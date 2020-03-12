//
//  ExtensionAlamofire.swift
//  Tasks
//
//  Created by Alexey on 26/05/2019.
//  Copyright © 2019 Alexey. All rights reserved.
//

import Alamofire
import Foundation
import RxSwift

extension Alamofire.DataRequest {
    func responseVoid() -> Completable {
        return Completable.create(subscribe: { [weak self] (completable) -> Disposable in
            self?.responseString { response in
                switch response.result {
                case let .success(data):
                    print("success responseString - \(data)")
                    completable(.completed)
                case let .failure(error):
                    completable(.error(error))
                }
            }
            return Disposables.create {
                self?.task?.cancel()
            }
        })
    }

    func responseArray<T: Codable>(with decoder: JSONDecoder) -> Single<[T]> {
        return Single.create { [weak self] single -> Disposable in
            self?.responseData { response in
                switch response.result {
                case let .success(data):
                    do {
                        let objects: [T] = try decoder.decode([T].self, from: data)
                        single(.success(objects))
                    } catch {
                        single(.error(error))
                    }
                case let .failure(error):
                    single(.error(error))
                }
            }
            return Disposables.create {
                self?.task?.cancel()
            }
        }
    }

    func responseObjectById<T: Codable>(with decoder: JSONDecoder) -> Single<T> {
        return Single.create { [weak self] single -> Disposable in
            self?.responseData { response in
                switch response.result {
                case let .success(data):
                    do {
                        let object: T = try decoder.decode(T.self, from: data)
                        single(.success(object))
                    } catch {
                        single(.error(error))
                    }
                case let .failure(error):
                    single(.error(error))
                }
            }
            return Disposables.create {
                self?.task?.cancel()
            }
        }
    }
}
