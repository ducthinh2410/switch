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

    let reload: AnyObserver<Void> // Use to reload data on the go (app become active or after certain period)

    private let disposeBag: DisposeBag

    private let localSettingsRepository: UserSettingsRepository
    private let remoteSettingsRepository: UserSettingsRepository

    // swiftlint:disable function_body_length
    init(localUserSettingsRepository: UserSettingsRepository,
         remoteUserSettingsReopsitory: UserSettingsRepository,
         switchUpdate: Observable<Bool>) {
        let bag = DisposeBag()
        disposeBag = bag

        localSettingsRepository = localUserSettingsRepository
        remoteSettingsRepository = remoteUserSettingsReopsitory

        let reloadSubject = PublishSubject<Void>()
        reload = reloadSubject.asObserver()

        // Initialize userUserSettings driver
        let subject: ReplaySubject<Result<UserSettings, Error>> = ReplaySubject.create(bufferSize: 1)
        userSettings = subject.asDriver(onErrorJustReturn: .success(UserSettings(state: false)))

        // Load either from local or from remote server
        let localCache = localSettingsRepository.load().share().take(1)
        let firstLoad = remoteSettingsRepository.load().share().retry().take(1)

        let localCacheOrFirstLoad = localCache.takeUntil(firstLoad)

        // Refresh or reload the user settings
        let reload = reloadSubject.asObservable()
            .flatMapLatest { _ -> Observable<Result<UserSettings, Error>> in
                print("GET request")
                return remoteUserSettingsReopsitory
                    .load()
                    .map { Result<UserSettings, Error>.success($0) }
                    .catchError { error in Observable.just(.failure(error)) }
            }

        // Update to remote server whenever user taps the switch
        let remoteUpdate = switchUpdate
            .flatMapLatest { state -> Observable<UserSettings> in
                print("PUT request")
                return remoteUserSettingsReopsitory
                    .save(settings: UserSettings(state: state)) // Save/Update the settings to remote server
                    .map { UserSettings(state: state) } // Map Observable<Void> -> Observable<UserSettings>
                    .catchError { _ in Observable.just(UserSettings(state: !state)) }
            }

        // Ignore the initial cache/load if the user taps the switch
        let localCacheOrFirstLoadUntilFirstSwitch = localCacheOrFirstLoad.takeUntil(switchUpdate)

        // First setup includes either first cache or first load(remote)
        let firstSetupOrLastUpdate = Observable.merge(localCacheOrFirstLoadUntilFirstSwitch, remoteUpdate)
            .map { Result<UserSettings, Error>.success($0) }

        // Latest user settings result no matter
        // it comes from from a cache, first load, latest update or reload
        let latestSettingsResult = Observable.merge(firstSetupOrLastUpdate, reload).share()

        latestSettingsResult.asDriver(onErrorJustReturn: .success(UserSettings(state: true)))
            .drive(subject)
            .disposed(by: disposeBag)

        // Cache the newest settings
        latestSettingsResult.subscribe(onNext: { result in
            switch result {
            case let .success(settings):
                localUserSettingsRepository
                    .save(settings: settings)
                    .asObservable()
                    .subscribe { _ in
                        print("Cached!")
                    }
                .disposed(by: bag)
            default:
                break
            }
        })
        .disposed(by: disposeBag)
    }
}
