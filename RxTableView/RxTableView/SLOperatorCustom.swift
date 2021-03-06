//
//  SLOperatorCustom.swift
//  RxTableView
//
//  Created by RY on 2018/6/22.
//  Copyright © 2018年 KK. All rights reserved.
//

import UIKit

postfix operator ~~
postfix func ~~(a: String?)            -> String            { return a == nil ? "" : a! }
postfix func ~~(a: Int?)               -> Int               { return a == nil ? 0 : a! }
postfix func ~~(a: Int8?)              -> Int8              { return a == nil ? 0 : a!}
postfix func ~~(a: Int16?)             -> Int16             { return a == nil ? 0 : a! }
postfix func ~~(a: Int32?)             -> Int32             { return a == nil ? 0 : a! }
postfix func ~~(a: Int64?)             -> Int64             { return a == nil ? 0 : a! }
postfix func ~~(a: UInt?)              -> UInt              { return a == nil ? 0 : a! }
postfix func ~~(a: Double?)            -> Double            { return a == nil ? 0 : a! }
postfix func ~~(a: Float?)             -> Float             { return a == nil ? 0 : a! }
postfix func ~~(a: CGFloat?)           -> CGFloat           { return a == nil ? 0 : a! }
postfix func ~~(a: [Any]?)             -> [Any]             { return a == nil ? [] : a! }
postfix func ~~(a: [String]?)          -> [String]          { return a == nil ? [] : a! }
postfix func ~~(a: [Int]?)             -> [Int]             { return a == nil ? [] : a! }
postfix func ~~(a: [String: Any]?)     -> [String: Any]     { return a == nil ? [:] : a! }
postfix func ~~(a: [String: String]?)  -> [String: String]  { return a == nil ? [:] : a! }

