//
//  SLOperator.swift
//  RxTableView
//
//  Created by RY on 2018/6/21.
//  Copyright © 2018年 KK. All rights reserved.
//

import UIKit

extension String {
    // 重载运算符
    static func + (left: String, right: String) -> String {
        return "fa"
    }
}

// 重载运算符
func - (left: String, right: String) -> Bool {
    return false
}

// 自定义运算符, 必须写在全局域
infix operator **
func ** (left: String, right: String) -> Bool {
    return true
}

class SLOperator: NSObject {

    func a() {
        _ = "1" ** "2"
        
        let d = "1" + "2"
        
        let v = "" - ""
        
        
        var ss: String?
        let aaa = ss~~
        
        var i: Int?
        var ii = i~~
    }
    
    
}

