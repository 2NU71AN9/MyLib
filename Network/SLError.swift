//
//  SLError.swift
//  RxSwiftDemo
//
//  Created by X.T.X on 2017/6/10.
//  Copyright © 2017年 shiliukeji. All rights reserved.
//

import Foundation

public enum SLError: Swift.Error {
    case SLNoRepresentor //
    case SLNotSuccessfulHTTP //请求失败
    case SLNoData //无返回数据
    case SLOperationFailure(resultCode: Int?, resultMsg: String?) //操作失败
    case SLLogout //登出
    case SLToObjFailed //数据解析失败
    case SLFailed // 失败
}

// MARK: - 输出error详细信息
extension SLError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .SLToObjFailed:
            return "数据解析失败"
        case .SLNoRepresentor:
            return "NoRepresentor."
        case .SLNotSuccessfulHTTP:
            return "请求失败"
        case .SLNoData:
            return "无返回数据"
        case .SLOperationFailure(resultCode: let resultCode, resultMsg: let resultMsg):
            guard let resultCode = resultCode,
                let resultMsg = resultMsg else {
                    return "操作失败"
            }
            SLTools.showTips(resultMsg)
            return "#################---错误码:" + resultCode.sl_ToString + ", 错误信息:" + resultMsg + "---#################"
        case .SLLogout:
            SLTools.userLogout()
            return "其他设备登录,需登出"
        case .SLFailed:
            return "失败"
        }
    }
}
