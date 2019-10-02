//
//  MockAPIClient.swift
//  SwitchAssignmentTests
//
//  Created by Thinh Vo on 2.10.2019.
//  Copyright © 2019 Thinh Vo. All rights reserved.
//

import Foundation
@testable import SwitchAssignment

class MockAPIClient: APIClient {

    var baseUrl: URL = URL(string: "http://test.com")!

    var headers: HTTPHeaders = [:]

    var cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy

    var timeout: TimeInterval = 1.0

    var session: URLSession

    init(urlSession: URLSession) {
        session = urlSession
    }
}
