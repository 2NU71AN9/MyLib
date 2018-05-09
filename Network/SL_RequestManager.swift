//
//  SL_RequestManager.swift
//  MRA
//
//  Created by X.T.X on 2017/8/7.
//  Copyright © 2017年 shiliukeji. All rights reserved.
//

import UIKit
import RxSwift
import HandyJSON
import Moya

open class SL_RequestManager {
    
    /// 设置请求头
//    let myEndpointClosure = { (target: APIService) -> Endpoint<APIService> in
//        let url = target.baseURL.appendingPathComponent(target.path).absoluteString
//        let endpoint = Endpoint<APIService>(
//            url: url,
//            sampleResponseClosure: { .networkResponse(200, target.sampleData) },
//            method: target.method,
//            task: target.task,
//            httpHeaderFields: target.headers
//        )
//        return endpoint.adding(newHTTPHeaderFields: target.headers!)
//    }

    /// 请求工具
    var apiProvider = MoyaProvider<APIService>()
    
    static let shared: SL_RequestManager = {
        let shared = SL_RequestManager()
        shared.apiProvider = MoyaProvider<APIService>(plugins: [SLShowState(), SLPrintParameterAndJson(), SLCheckService()])
        return shared
    }()
    private init() {}
}

extension SL_RequestManager {
    
    /// 网络请求
    ///
    /// - Parameters:
    ///   - parameter: 参数
    ///   - modelType: 模型类
    ///   - bag:
    ///   - success: 成功闭包
    ///   - failure: 失败闭包
    public func request<T: HandyJSON>(_ parameter: APIService, modelType: T.Type, bag: DisposeBag, success: @escaping (Any?) -> Void, failure: @escaping (Error?) -> Void) {
        
        apiProvider.request(parameter) { (response) in
            switch response {
            case let .success(result):
                guard let json = try? result.mapJSON() else {
                    failure(nil)
                    print(">>>>>>>>>>>>>>数据反序列化失败<<<<<<<<<<<<<<<")
                    return
                }
                
                let obs = Observable<Any>.create{ (observer) -> Disposable in
                    observer.onNext(json)
                    observer.onCompleted()
                    return Disposables.create()
                }

                // 需要转模型
                obs.mapResponseToObj(type: modelType) { failure($0) }
                    .subscribe(onNext: { (model) in
                        success(model)
                    }).disposed(by: bag)
                
            case let .failure(error):
                failure(error)
            }
        }
    }
    
    /// 网络请求,不需要转模型
    ///
    /// - Parameters:
    ///   - parameter: 参数
    ///   - bag:
    ///   - success: 成功闭包
    ///   - failure: 失败闭包
    public func requestNoModel(_ parameter: APIService, bag: DisposeBag, success: @escaping (Any?) -> Void, failure: @escaping (Error?) -> Void) {
        
        apiProvider.request(parameter) { (response) in
            switch response {
            case let .success(result):
                guard let json = try? result.mapJSON() else {
                    failure(nil)
                    print(">>>>>>>>>>>>>>数据反序列化失败<<<<<<<<<<<<<<<")
                    return
                }
                let obs = Observable<Any>.create{ (observer) -> Disposable in
                    observer.onNext(json)
                    observer.onCompleted()
                    return Disposables.create()
                }
                
                // 不需要转模型
                obs.isSuccessful { failure($0) }
                    .subscribe { (event) in
                        switch event {
                        case let .next(isSuccess, data):
                            isSuccess ? success(data) : failure(SLError.SLFailed)
                        case let .error(error):
                            failure(error)
                        case .completed:
                            break
                        }
                    }.disposed(by: bag)
                
            case let .failure(error):
                print(error)
                failure(error)
            }
        }
    }
    
    /// 网络请求,获取原始数据
    ///
    /// - Parameters:
    ///   - parameter: 参数
    ///   - success: 成功闭包
    ///   - failure: 失败闭包
    func requestOriginalData(_ parameter: APIService, success: @escaping (Any?) -> Void, failure: @escaping (Error?) -> Void) {
        apiProvider.request(parameter) { (response) in
            switch response {
            case let .success(result):
                guard let json = try? result.mapJSON() else {
                    failure(nil)
                    print(">>>>>>>>>>>>>>数据反序列化失败<<<<<<<<<<<<<<<")
                    return
                }
                success(json)
            case let .failure(error):
                print(error)
                failure(error)
            }
        }
    }
}
