//
//  SLObservable+Extension.swift
//  RxSwiftDemo
//
//  Created by X.T.X on 2017/6/10.
//  Copyright © 2017年 shiliukeji. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON
import HandyJSON

extension Observable {
    
    /// 输出错误
    ///
    func showError() -> Observable<Element> {
        return self.do(onError: { (error) in
            print("\(error.localizedDescription)")
        })
    }
    
    /// json -> 模型或模型数组
    ///
    /// - Parameter type: 模型类
    /// - Returns: 模型或模型数组
    func mapResponseToObj<T: HandyJSON>(type: T.Type, failure: @escaping (Error) -> Void) -> Observable<Any> {
        return map { response in
            
            guard let response = NetworkResponse.deserialize(from: response as? [String: Any]) else {
                failure(SLError.SLNoRepresentor)
                throw SLError.SLNoRepresentor
            }
            
            if response.code == HttpStatus.success.rawValue {
                /// 成功
                if response.data is [String: Any] {
                    /// 如果是字典
                    guard let model = T.deserialize(from: response.data as? [String: Any]) else {
                        failure(SLError.SLToObjFailed)
                        throw SLError.SLToObjFailed
                    }
                    return model
                    
                } else if response.data is [[String: Any]] {
                    /// 如果是数组
                    guard let models = [T].deserialize(from: response.data as? [[String: Any]]) else {
                        failure(SLError.SLToObjFailed)
                        throw SLError.SLToObjFailed
                    }
                    return models
                    
                } else {
                    failure(SLError.SLNoData)
                    throw SLError.SLNoData
                }
            } else if response.code == HttpStatus.logout.rawValue {
                /// 登出
                failure(SLError.SLLogout)
                throw SLError.SLLogout
            } else {
                /// 直接输出错误
                failure(SLError.SLOperationFailure(resultCode: response.code, resultMsg: response.message))
                throw SLError.SLOperationFailure(resultCode: response.code, resultMsg: response.message)
            }
        }.showError()
    }
    
    /// 网络请求判断是否成功, 不转模型
    ///
    /// - Returns: (是否成功, 返回的数据)
    func isSuccessful(failure: @escaping (Error) -> Void) -> Observable<(Bool, [String: Any]?)> {
        return self.flatMap { (response) -> Observable<(Bool, [String: Any]?)>  in
            Observable.just(response)
                .map { (response) -> (Bool, [String: Any]?) in
                    
                    guard let response = NetworkResponse.deserialize(from: response as? [String: Any]) else {
                        failure(SLError.SLNoRepresentor)
                        throw SLError.SLNoRepresentor
                    }

                    if response.code == HttpStatus.success.rawValue {
                        /// 成功
                        return (true, response.data as? [String : Any])
                    } else if response.code == HttpStatus.logout.rawValue {
                        /// 登出
                        failure(SLError.SLLogout)
                        throw SLError.SLLogout
                    } else {
                        /// 直接输出错误
                        failure(SLError.SLOperationFailure(resultCode: response.code, resultMsg: response.message))
                        throw SLError.SLOperationFailure(resultCode: response.code, resultMsg: response.message)
                    }
                }.catchError { (error) -> Observable<(Bool, [String: Any]?)> in
                    print("\(error.localizedDescription)")
                    return .just((false, nil))
            }
        }
    }
}
