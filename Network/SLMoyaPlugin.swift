//
//  SLMoyaPlugin.swift
//  RxSwiftDemo
//
//  Created by X.T.X on 2017/6/10.
//  Copyright © 2017年 shiliukeji. All rights reserved.
//

import Foundation
import Moya
import Result
import SVProgressHUD
import SwiftyJSON

/// Moya插件: 网络请求时显示loading...
internal final class SLShowState: PluginType {

    func willSend(_ request: RequestType, target: TargetType) {
        
        guard let target = target as? APIService else { return }
        /// 判断是否需要显示
        target.showStats ? SVProgressHUD.show() : ()
        SVProgressHUD.setDefaultMaskType(.clear)
    }
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        /// 0.2s后消失
        SVProgressHUD.dismiss(withDelay: 0.2)
    }
}

/// Moya插件: 控制台打印请求的参数和服务器返回的json数据
internal final class SLPrintParameterAndJson: PluginType {
    
    func willSend(_ request: RequestType, target: TargetType) {
        #if DEBUG
            print("""
                
                
                
                >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                
                请求参数=====> \(target)
                
                """)
        #endif
    }
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        
        #if DEBUG
            switch result {
            case .success(let response):
                do {
                    let jsonObiect = try response.mapJSON()
                    print("""
                        
                        返回数据=====> \(JSON(jsonObiect))
                        
                        <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                        <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                        <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                        <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                        
                        
                        
                        """)
                } catch {
                }
            default:
                break
            }
        #endif
    }
}
// MARK: - Moya插件: 检查网络状态, 未完成
internal final class SLCheckService: PluginType {
    
    func willSend(_ request: RequestType, target: TargetType) {
        SLNetworkStatusManager.shared.checkNetworkStatus()
    }
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
    }
}
