//
//  SLLocationManager.swift
//  SLBaiDuMap
//
//  Created by X.T.X on 2018/3/6.
//  Copyright © 2018年 shiliukeji. All rights reserved.
//

import UIKit
import RxSwift

class SLLocationManager: NSObject {

    // 鉴权相关,启动引擎
    private let bmkManager = BMKMapManager()
    // 定位相关
    private let service = BMKLocationService()
    // 地理反编码相关,一定要用懒加载
    private var searcher: BMKGeoCodeSearch?
    
    // 当前定位的位置信息
    var location: BMKReverseGeoCodeResult?
    let locationChanged = ReplaySubject<BMKReverseGeoCodeResult>.create(bufferSize: 1)
    let bag = DisposeBag()
    
    // 定位状态
    let status = Variable(0) // 0:正在定位 1: 定位成功 2:定位失败
    
    static let shared = SLLocationManager()
    private override init() {}
}

// MARK: - 鉴权
extension SLLocationManager: BMKGeneralDelegate {
    func start(_ key: String) {
        if !bmkManager.start(key, generalDelegate: self) {
            print("百度地图鉴权失败")
            status.value = 2
        }
    }
}

// MARK: - 定位
extension SLLocationManager: BMKLocationServiceDelegate {
    /// 开启定位
    func startLocation() {
        service.delegate = self
        service.startUserLocationService()
    }
    
    /// 位置发生变化
    func didUpdate(_ userLocation: BMKUserLocation!) {
        print(userLocation.location.coordinate.latitude)
        print(userLocation.location.coordinate.longitude)
        
        location2Address(coordinate: userLocation.location.coordinate)
        
        // 定位成功后关闭定位
        service.stopUserLocationService()
    }
}

// MARK: - 反地理编码
extension SLLocationManager: BMKGeoCodeSearchDelegate {
    /// 反地理编码
    func location2Address(coordinate: CLLocationCoordinate2D) {
        //初始化检索对象
        searcher = BMKGeoCodeSearch()
        searcher?.delegate = self
        let reverseOption = BMKReverseGeoCodeOption()
        reverseOption.reverseGeoPoint = coordinate
        let flag = searcher?.reverseGeoCode(reverseOption)
        if !(flag ?? false) {
            print("反geo检索发送失败")
            status.value = 2
        }
    }
    
    /// 反地理编码结果代理
    func onGetReverseGeoCodeResult(_ searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        if (error == BMK_SEARCH_NO_ERROR) {
            print("返回正常")
            searcher?.delegate = nil
            location = result
            locationChanged.onNext(result)
            status.value = 1
            print(result.address)
        } else{
            print("反地理编码失败")
            status.value = 2
        }
    }
}
