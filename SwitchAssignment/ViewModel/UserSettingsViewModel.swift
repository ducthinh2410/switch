//
//  UserSettingsViewModel.swift
//  SwitchAssignment
//
//  Created by Thinh Vo on 2.10.2019.
//  Copyright © 2019 Thinh Vo. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol UserSettingsModeling {
    var userSettings: Driver<Result<UserSettings, Error>> { get }
}

class UserSettingsViewModel: UserSettingsModeling {

    var userSettings: Driver<Result<UserSettings, Error>>

    let reload: AnyObserver<Void>

    private let disposeBag = DisposeBag()

    private let localSettingsRepository: UserSettingsRepository
    private let remoteSettingsRepository: UserSettingsRepository

    init(localUserSettingsRepository: UserSettingsRepository,
         remoteUserSettingsReopsitory: UserSettingsRepository,
         switchUpdate: Observable<Bool>) {

        localSettingsRepository = localUserSettingsRepository
        remoteSettingsRepository = remoteUserSettingsReopsitory

        reload = PublishSubject<Void>().asObserver()

        // Initialize userUserSettings driver
        let subject: ReplaySubject<Result<UserSettings, Error>> = ReplaySubject.create(bufferSize: 1)
        userSettings = subject.asDriver(onErrorJustReturn: .success(UserSettings(state: false)))

        // Load the settings either from local or from remote server
        let initialLocalOrRemoteLoad = Observable.merge(
            localSettingsRepository.load().share().take(1),
            remoteSettingsRepository.load().share().retry().take(1)
        ).take(1)

        // If initialLocalOrRemoteLoad is a local load then we still need to do an intial remote load
        let initialRemoteLoad = remoteSettingsRepository.load().share().skip(1)

        // Ignore the initial remote loading if user taps the switch or state changes
        let initialRemoteLoadUntilUpdate = initialRemoteLoad.takeUntil(switchUpdate.share())

        // Ignore the initial load if the user taps the switch or state changes
        let initialLocalOrRemoteLoadUntilUpdate = initialLocalOrRemoteLoad.takeUntil(switchUpdate.share())

        let updateSettings = switchUpdate.flatMap { state in
            return self.remoteSettingsRepository
                .save(settings: UserSettings(state: state)) // Save/Update the settings to remote server
                .map { UserSettings(state: state) } // Map Observable<Void> -> Observable<UserSettings>
                .do(onNext: { self.localSettingsRepository.save(settings: $0) }) // Cache the settings locally
        }

        Observable.merge(initialLocalOrRemoteLoadUntilUpdate,
                         initialRemoteLoadUntilUpdate,
                         updateSettings)
            .map { Result<UserSettings, Error>.success($0) }
            .catchError {
                return Observable.just(.failure($0))
            }
            .asDriver(onErrorJustReturn: .success(UserSettings(state: true)))
            .drive(subject)
            .disposed(by: disposeBag)
    }
}
