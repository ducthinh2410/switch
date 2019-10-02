//
//  API.swift
//  SwitchAssignment
//
//  Created by Thinh Vo on 2.10.2019.
//  Copyright © 2019 Thinh Vo. All rights reserved.
//

import Foundation

final class API: APIClient {

    var session: URLSession = URLSession.shared

    var baseUrl: URL = URL(string: "http://localhost:3000")!

    var headers: HTTPHeaders = [:]

    var cachePolicy: URLRequest.CachePolicy = URLRequest.CachePolicy.useProtocolCachePolicy

    var timeout: TimeInterval = 15.0
}
