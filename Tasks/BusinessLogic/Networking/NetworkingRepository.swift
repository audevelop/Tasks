//
//  NetworkingRepository.swift
//  Tasks
//
//  Created by Alexey on 02/10/2018.
//  Copyright © 2018 Alexey. All rights reserved.
//

import Alamofire
import Foundation
import PromiseKit

public protocol RequestConvertible {
    associatedtype Result: Codable
    var base: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var params: Parameters { get }
    var encoding: ParameterEncoding { get }
}

public protocol NetworkPepository {
    func object<T: RequestConvertible>(_ request: T) -> Promise<T.Result>
    func data<T: RequestConvertible>(_ request: T) -> Promise<Data>
}

public class NetworkPepositoryImp {
    private let sessionManager: SessionManager
    private let decoder: JSONDecoder

    public init(
        sessionManager: SessionManager,
        decoder: JSONDecoder
    ) {
        self.sessionManager = sessionManager
        self.decoder = decoder
    }

    private func createUrlRequest<T: RequestConvertible>(_ request: T) throws -> URLRequest {
        let url = request.base.appendingPathComponent(request.path)
        let urlRequest = try URLRequest(url: url, method: request.method)
        return try request.encoding.encode(urlRequest, with: request.params)
    }
}

extension NetworkPepositoryImp: NetworkPepository {
    public func object<T: RequestConvertible>(_ request: T) -> Promise<T.Result> {
        return firstly {
            try Promise.value(createUrlRequest(request))
        }.then { urlRequest in
            self.sessionManager
                .request(urlRequest)
                .validate()
                .responseDecodable(
                    T.Result.self,
                    queue: nil,
                    decoder: self.decoder
                )
        }
    }

    public func data<T: RequestConvertible>(_ request: T) -> Promise<Data> {
        return firstly {
            try Promise.value(createUrlRequest(request))
        }.then { urlRequest in
            self.sessionManager
                .request(urlRequest)
                .validate()
                .responseData(queue: nil)
        }
        .then { (arg: (data: Data, response: PMKAlamofireDataResponse)) in
            Promise.value(arg.data)
        }
    }
}
