//
//  APIRequest.swift
//  SwitchAssignment
//
//  Created by Thinh Vo on 2.10.2019.
//  Copyright © 2019 Thinh Vo. All rights reserved.
//

import Foundation

protocol APIRequest {

    associatedtype ResponseDataType

    var method: HTTPMethod { get }
    var endpoint: String { get }
    var queryParams: Parameters? { get }
    var pathParams: Parameters? { get }
    var headers: HTTPHeaders? { get }
    var body: RequestBody? { get }
    var cachePolicy: URLRequest.CachePolicy? { get set }
    var timeout: TimeInterval? { get }

    func headers(in service: APIClient) -> HTTPHeaders
    func url(in service: APIClient) throws -> URL
    func urlRequest(in service: APIClient) throws -> URLRequest

    func parseResponse(_ data: Data) -> ResponseDataType
}

///
/// APIRequest's default implementation
///
extension APIRequest {
    var method: HTTPMethod {
        return .get
    }

    var endpoint: String {
        return ""
    }

    var queryParams: Parameters? {
        return nil
    }

    var pathParams: Parameters? {
        return nil
    }

    var headers: Parameters? {
        return nil
    }

    var body: RequestBody? {
        return nil
    }

    var cachePolicy: URLRequest.CachePolicy? {
        return nil
    }

    func headers(in service: APIClient) -> HTTPHeaders {
        var newHeaders = service.headers
        headers?.forEach({key, value in newHeaders[key] = value})
        return newHeaders
    }

    func url(in service: APIClient) throws -> URL {

        // Obmit the path parameters and query parameters for simplicity purpose
        let baseURLString = service.baseUrl.absoluteString.appending(endpoint)

        // TODO: Double check this error type
        guard let url = URL(string: baseURLString) else {
            throw EncodingError.dataIsNotEncodable(baseURLString)
        }

        return url
    }

    func urlRequest(in service: APIClient) throws -> URLRequest {
        let requestURL = try url(in: service)
        let cachePolicy = self.cachePolicy ?? service.cachePolicy
        let timeout = self.timeout ?? service.timeout

        var urlRequest = URLRequest(url: requestURL, cachePolicy: cachePolicy, timeoutInterval: timeout)
        urlRequest.httpMethod = self.method.rawValue

        if let bodyData = try body?.encodedData() {
            urlRequest.httpBody = bodyData
        }

        var headers = self.headers(in: service)

        if let extraHeaders = body?.headers {
            for (key, value) in extraHeaders {
                headers[key] = value
            }
        }

        for (key, value) in headers {
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }

        return urlRequest
    }
}
