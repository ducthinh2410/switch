//
//  RequestBodyTests.swift
//  SwitchAssignmentTests
//
//  Created by Thinh Vo on 2.10.2019.
//  Copyright © 2019 Thinh Vo. All rights reserved.
//

import XCTest
@testable import SwitchAssignment

class RequestBodyTests: XCTestCase {

    var sut: RequestBody!

    override func setUp() {}

    override func tearDown() {}

    func testJSONRequestBody_CorrectHeaders() {
        sut = RequestBody(data: ["state": false], encoding: .json)
        XCTAssertNotNil(sut.headers)
        XCTAssertEqual(sut.headers, ["Content-Type": "application/json"])
    }

    func testJSONRequestBody_ValidEncodedData() {
        sut = RequestBody(data: ["state": false], encoding: .json)
        do {
            let encodedData = try sut.encodedData()
            XCTAssertNotNil(encodedData)
        } catch {
            XCTFail("There must not be an error when encode a valid dictionary!")
        }
    }
}
