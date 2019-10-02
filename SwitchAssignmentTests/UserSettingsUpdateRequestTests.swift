//
//  UserSettingsUpdateRequestTests.swift
//  SwitchAssignmentTests
//
//  Created by Thinh Vo on 2.10.2019.
//  Copyright © 2019 Thinh Vo. All rights reserved.
//

import XCTest
import Foundation
@testable import SwitchAssignment

// swiftlint:disable force_try
class UserSettingsUpdateRequestTests: XCTestCase {

    var mockAPIClient: APIClient!

    var sut: UserSettingsUpdateRequest!

    override func setUp() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)
        let apiClient = MockAPIClient(urlSession: session)

        mockAPIClient = apiClient

        sut = UserSettingsUpdateRequest(settings: UserSettings(state: false))
    }

    override func tearDown() {}

    func testRequest_CorrectURL() {
        let url = try! sut.url(in: mockAPIClient).absoluteString
        XCTAssertEqual(url, "http://test.com")
    }

    func testRequest_CorrectURLHeaders() {
        let urlRequest = try! sut.urlRequest(in: mockAPIClient)
        XCTAssertNotNil(urlRequest.allHTTPHeaderFields)
        XCTAssertEqual(urlRequest.allHTTPHeaderFields, ["Content-Type": "application/json"])
    }

    func testRequest_BodyNotNil() {
        XCTAssertNotNil(sut.body)
    }
}
