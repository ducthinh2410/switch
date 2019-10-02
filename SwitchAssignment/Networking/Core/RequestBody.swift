//
//  RequestBody.swift
//  SwitchAssignment
//
//  Created by Thinh Vo on 2.10.2019.
//  Copyright © 2019 Thinh Vo. All rights reserved.
//

import Foundation

struct RequestBody {
    enum Encoding {
        case json // Can be more options such as: urlEncoded, formData...
    }

    let data: Any
    let encoding: Encoding

    var headers: HTTPHeaders? {
        switch encoding {
        case .json:
            return ["Content-Type": "application/json"]
        }
    }

    func encodedData() throws -> Data? {
        return try JSONSerialization.data(withJSONObject: data, options: [])
    }
}
