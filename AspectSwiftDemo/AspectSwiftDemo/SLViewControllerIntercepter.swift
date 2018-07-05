//
//  SLViewControllerIntercepter.swift
//  AspectSwiftDemo
//
//  Created by RY on 2018/7/5.
//  Copyright © 2018年 SL. All rights reserved.
//

import Foundation
import UIKit
import Aspects

class SLViewControllerIntercepter: NSObject {
    static let shared = SLViewControllerIntercepter()
    private override init() {
        super.init()

        loadViewIntercepter()
        viewDidLoadIntercepter()
        viewWillAppearIntercepter()
    }
    
    /// 拦截loadView
    private func loadViewIntercepter() {
        let block: @convention(block) (Any?) -> Void = { [weak self] info in
            let aspectInfo = info as! AspectInfo
            let controller = aspectInfo.instance() as! UIViewController
            self?.loadView(controller)
        }
        do {
            try UIViewController.aspect_hook(NSSelectorFromString("loadView"), with: [], usingBlock: unsafeBitCast(block, to: AnyObject.self))
        }catch{
            print(error)
        }
    }
    
    /// 拦截viewDidLoad
    private func viewDidLoadIntercepter() {
        let block: @convention(block) (Any?) -> Void = { [weak self] info in
            let aspectInfo = info as! AspectInfo
            let controller = aspectInfo.instance() as! UIViewController
            self?.viewDidLoad(controller)
        }
        do {
            try UIViewController.aspect_hook(NSSelectorFromString("viewDidLoad"), with: [], usingBlock: unsafeBitCast(block, to: AnyObject.self))
        }catch{
            print(error)
        }
    }
    
    /// 拦截viewWillAppear
    private func viewWillAppearIntercepter() {
        let block: @convention(block) (Any?) -> Void = { [weak self] info in
            let aspectInfo = info as! AspectInfo
            let controller = aspectInfo.instance() as! UIViewController
            self?.viewWillAppear(controller)
        }
        do {
            try UIViewController.aspect_hook(NSSelectorFromString("viewWillAppear:"), with: [], usingBlock: unsafeBitCast(block, to: AnyObject.self))
        }catch{
            print(error)
        }
    }
    
    private func loadView(_ Controller: UIViewController) {
        print("拦截loadView")
        
    }
    
    private func viewDidLoad(_ Controller: UIViewController) {
        print("拦截viewDidLoad")

    }
    
    private func viewWillAppear(_ Controller: UIViewController) {
        print("拦截viewWillAppear")

    }
}
