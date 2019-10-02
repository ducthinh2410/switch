//
//  Other.swift
//  SwitchAssignment
//
//  Created by Thinh Vo on 2.10.2019.
//  Copyright © 2019 Thinh Vo. All rights reserved.
//

import Foundation

typealias Parameters = [String: Any]

typealias HTTPHeaders = [String: String]

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
}

enum EncodingError: Error {
    case dataIsNotEncodable(_ : Any)
    case invalidURL(_: String)
}
