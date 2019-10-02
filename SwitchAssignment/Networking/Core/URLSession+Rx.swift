//
//  URLSession+Rx.swift
//  SwitchAssignment
//
//  Created by Thinh Vo on 2.10.2019.
//  Copyright © 2019 Thinh Vo. All rights reserved.
//

import Foundation
import RxSwift

enum RxURLSessionError: Error {
    case unknown
    case invalidResponse(response: URLResponse)
    case error(reesponse: HTTPURLResponse, data: Data?)
}

extension Reactive where Base: URLSession {

    func response(request: URLRequest) -> Observable<(HTTPURLResponse, Data)> {
        return Observable.create { (observer) -> Disposable in
            let task = self.base.dataTask(with: request) { (data, response, error) in

                guard let response = response, let data = data else {
                    observer.onError(error ?? RxURLSessionError.unknown)
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    observer.onError(error ?? RxURLSessionError.invalidResponse(response: response))
                    return
                }

                observer.onNext((httpResponse, data))
            }

            task.resume()

            return Disposables.create { task.cancel() }
        }
    }

    func data(request: URLRequest) -> Observable<Data> {
        return response(request: request).map { (response, data) -> Data in
            guard 200..<300 ~= response.statusCode else {
                throw RxURLSessionError.error(reesponse: response, data: data)
            }

            return data
        }
    }
}
