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
        case json
    }

    let data: Any
    let encoding: Encoding

    var headers: HTTPHeaders? {
        return nil
    }

    // TODO: Implement this
    func encodedData() throws -> Data? {
        return nil
    }
}
