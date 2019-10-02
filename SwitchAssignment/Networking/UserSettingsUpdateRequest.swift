//
//  UserSettingsUpdateRequest.swift
//  SwitchAssignment
//
//  Created by Thinh Vo on 2.10.2019.
//  Copyright © 2019 Thinh Vo. All rights reserved.
//

import Foundation

struct UserSettingsUpdateRequest: APIRequest {

    typealias ResponseDataType = UserSettings

    let method: HTTPMethod = .put

    let settings: UserSettings

    var body: RequestBody? {
        return RequestBody(data: ["state": settings.state], encoding: .json)
    }
}
