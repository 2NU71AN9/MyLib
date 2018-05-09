//
//  API.swift
//  RxSwiftDemo
//
//  Created by X.T.X on 2017/6/9.
//  Copyright © 2017年 shiliukeji. All rights reserved.
//

import Foundation
import HandyJSON

/// 网络请求返回的数据
struct NetworkResponse: HandyJSON {
    var code: Int = 0
    var message: String?
    var data: Any?
}

/// 各code代表什么
public enum HttpStatus: Int {
    case success = 200 // 成功
    case logout = 208 // 登出
    case bizError
}

/// 是否是发布版本
public let isRelease: Bool = true
/// 发布域名
public let releaseUrl = ""
/// 测试域名
public let debugUrl = ""


