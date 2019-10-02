//
//  UserSettingsRepository.swift
//  SwitchAssignment
//
//  Created by Thinh Vo on 2.10.2019.
//  Copyright © 2019 Thinh Vo. All rights reserved.
//

import Foundation
import RxSwift

protocol UserSettingsRepository {
    func load() -> Observable<UserSettings>
    @discardableResult func save(settings: UserSettings) -> Observable<Void>
}

///
/// RemoteUserSettingRepository which makes http request to fetch or update user settings
///
class RemoteUserSettingRepository: UserSettingsRepository {

    let apiClient: APIClient = API()

    func load() -> Observable<UserSettings> {
        let getRequest = UserSettingsRequest()
        return apiClient.load(getRequest)
    }

    func save(settings: UserSettings) -> Observable<Void> {
        let putRequest = UserSettingsUpdateRequest(settings: settings)
        return apiClient.load(putRequest).map { _ in }
    }
}

///
/// LocalUserSettingRepository which relies on UserDefaults to store and fetch user settings locally
///
class LocalUserSettingRepository: UserSettingsRepository {

    static let userSettingsKey: String = "userSettingsKey"

    var userDefault: UserDefaults = UserDefaults.standard

    // swiftlint:disable line_length
    func load() -> Observable<UserSettings> {
        return Observable.create { [weak self] observer -> Disposable in

            guard let strongSelf = self else { return Disposables.create() }

            let userSettings: UserSettings
            if let settings = strongSelf.userDefault.object(forKey: LocalUserSettingRepository.userSettingsKey) as? UserSettings {
                userSettings = settings
            } else {
                userSettings = UserSettings(state: false) // Default value
            }

            observer.onNext(userSettings)
            observer.onCompleted()

            return Disposables.create()
        }
    }

    func save(settings: UserSettings) -> Observable<Void> {
        return Observable.create { [weak self] observer in
            guard let strongSelf = self else {
                return Disposables.create()
            }

            strongSelf.userDefault.set(settings, forKey: LocalUserSettingRepository.userSettingsKey)
            observer.onNext(())
            observer.onCompleted()
            return Disposables.create()
        }
    }
}
