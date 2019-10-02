//
//  APIRequest+Decodable.swift
//  SwitchAssignment
//
//  Created by Thinh Vo on 2.10.2019.
//  Copyright © 2019 Thinh Vo. All rights reserved.
//

import Foundation

extension APIRequest where ResponseDataType: Decodable {
    func parseResponse(_ data: Data) throws -> ResponseDataType {
        return try JSONDecoder().decode(ResponseDataType.self, from: data)
    }
}
