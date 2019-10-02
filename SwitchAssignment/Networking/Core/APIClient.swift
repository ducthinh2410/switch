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
    var session: URLSession { get }

    func load<R: APIRequest>(_ request: R) -> Observable<R.ResponseDataType>
}

extension APIClient {
    func load<R: APIRequest>(_ request: R) -> Observable<R.ResponseDataType> {
        do {
            let urlRequest = try request.urlRequest(in: self)
            return session.rx.data(request: urlRequest).map { data in
                return try request.parseResponse(data)
            }
        } catch {
            return Observable<R.ResponseDataType>.error(error)
        }
    }
}
