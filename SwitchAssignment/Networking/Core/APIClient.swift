//
//  APIClient.swift
//  SwitchAssignment
//
//  Created by Thinh Vo on 2.10.2019.
//  Copyright © 2019 Thinh Vo. All rights reserved.
//

import Foundation
import RxSwift

protocol APIClient {
    var baseUrl: URL { get }
    var headers: HTTPHeaders { get }
    var cachePolicy: URLRequest.CachePolicy { get }
    var timeout: TimeInterval { get }

    func load<R: APIRequest>(_ request: R) -> Observable<R.ResponseDataType>
}
