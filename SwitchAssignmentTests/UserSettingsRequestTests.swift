//
//  UserSettingsRequestTests.swift
//  SwitchAssignmentTests
//
//  Created by Thinh Vo on 2.10.2019.
//  Copyright © 2019 Thinh Vo. All rights reserved.
//

import XCTest
import Foundation
@testable import SwitchAssignment

// swiftlint:disable force_try
class UserSettingsRequestTests: XCTestCase {

    var mockAPIClient: APIClient!

    var sut: UserSettingsRequest!

    override func setUp() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)
        let apiClient = MockAPIClient(urlSession: session)
        apiClient.headers = ["Test": "Test"]

        mockAPIClient = apiClient

        sut = UserSettingsRequest()
    }

    override func tearDown() {}

    func testRequest_CorrectURL() {
        let url = try! sut.url(in: mockAPIClient)
        XCTAssertEqual(url.absoluteString,
                       "http://test.com",
                       "The request does not have endpoint part and it must be the same as the base url")
    }

    func testRequest_CorrectHeaders() {
        let urlRequest = try! sut.urlRequest(in: mockAPIClient)
        let headers = urlRequest.allHTTPHeaderFields
        XCTAssertNotNil(headers)
        XCTAssertEqual(headers, ["Test": "Test"])
    }
}
