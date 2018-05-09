//
//  SLTools.swift
//  MRA
//
//  Created by X.T.X on 2017/12/12.
//  Copyright © 2017年 shiliukeji. All rights reserved.
//

import UIKit
import pop
import SnapKit
import Alamofire
import Then
import MapKit

class SLTools {

    static let callView = UIWebView()
    /// 拨打电话
    ///
    /// - Parameter number: 电话号码
    static func callWithNumber(_ number: String?) {
        guard let number = number,
            let url = URL(string: "tel:\(number)"),
            let cur_vc = cur_visible_vc else { return }
        callView.loadRequest(URLRequest(url: url))
        cur_vc.view.addSubview(callView)
    }
    
    /// 其他设备登录,用户需登出
    static func userLogout() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: UserSignOutNotification), object: nil)
    }
    
    /// 弹出1个按钮的提示框
    static func showSingleAlert(text: String, actionTitle: String, action: (() -> Void)?) {
        let slertView = SLAlertView(text: text, firstTitle: actionTitle, secondTitle: nil, firstAction: action, secondAction: nil)
        UIApplication.shared.keyWindow?.addSubview(slertView)
    }
    
    /// 弹出2个按钮的提示框
    static func showChoiceAlert(text: String, firstTitle: String, secondTitle: String, firstAction: (() -> Void)?, secondAction: (() -> Void)?) {
        let slertView = SLAlertView(text: text, firstTitle: firstTitle, secondTitle: secondTitle, firstAction: firstAction, secondAction: secondAction)
        UIApplication.shared.keyWindow?.addSubview(slertView)
    }
    
    /// 跳转地图导航
    static func startNavigationInAppleMap(_ location: SLShopLocationModel?) {
        guard let location = location,
            let appleLocation = SLLocationTransform(latitude: location.Latitude, andLongitude: location.longitude).transformFromBDToGD() as? SLLocationTransform else { return }
        let coordinate = CLLocationCoordinate2D(latitude: appleLocation.latitude, longitude: appleLocation.longitude)
        let coordinateMark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        let curLocation = MKMapItem.forCurrentLocation()
        let toLocation = MKMapItem(placemark: coordinateMark)
        MKMapItem.openMaps(with: [curLocation, toLocation], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
    
    /// 获取本机IP
    static func getIPAddress() -> String? {
        var addresses = [String]()
        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while (ptr != nil) {
                let flags = Int32(ptr!.pointee.ifa_flags)
                var addr = ptr!.pointee.ifa_addr.pointee
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                            if let address = String(validatingUTF8:hostname) {
                                addresses.append(address)
                            }
                        }
                    }
                }
                ptr = ptr!.pointee.ifa_next
            }
            freeifaddrs(ifaddr)
        }
        return addresses.first
    }
    
    /// 去App Store进行评价
    static func evaluationInAppStore() {
        let urlString = "itms-apps://itunes.apple.com/app/id\(appid)"
        let url = URL(string: urlString)
        UIApplication.shared.openURL(url!)
    }
    
    /// 获取缓存
    static func access2Cache() -> String {
        return String(format: "%.2fM", SLFileManager.forderSizeAtPath(NSHomeDirectory()))
    }
    
    /// 删除缓存
    ///
    /// - Parameter competion: 完成闭包
    static func cleanCache(competion:() -> Void) {
        SLFileManager.deleteFolder(path: NSHomeDirectory() + "/Documents")
        SLFileManager.deleteFolder(path: NSHomeDirectory() + "/Library")
        SLFileManager.deleteFolder(path: NSHomeDirectory() + "/tmp")
        competion()
    }
}

// MARK: - 提示器
extension SLTools {

    private static var tipView = TipView()
    /// 弹出动画
    private static var showAnim: POPSpringAnimation = {
        let anmi: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerScaleY)
        anmi.fromValue = 0
        anmi.toValue = 1
        anmi.springBounciness = 13
        anmi.springSpeed = 20
        return anmi
    }()
    
    /// 弹回动画
    private static var hideAnim: POPSpringAnimation = {
        let anmi: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerScaleY)
        anmi.toValue = 0
        anmi.springBounciness = 0
        return anmi
    }()
    
    /// 弹出提示
    ///
    /// - Parameters:
    ///   - text: 提示内容
    ///   - completion: 提示框消失时要做的事
    static func showTips(_ text: String?, completion: (() -> Void)? = nil) {
        guard let text = text,
            text.sl_length > 0,
            let cur_vc = cur_visible_vc else { return }
        
        if cur_vc.view.subviews.contains(tipView) || cur_vc.navigationController?.view.subviews.contains(tipView) ?? false {
            return
        }
        cur_vc.navigationController != nil
            ? cur_vc.navigationController?.view.addSubview(tipView)
            : cur_vc.view.addSubview(tipView)
        
        tipView.tipContent = text
        tipView.layer.pop_add(showAnim, forKey: nil)

        /// 弹回动画
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + (completion == nil ? 2.2 : 1)) {
            tipView.layer.pop_add(hideAnim, forKey: nil)
            completion?()
            hideAnim.completionBlock = {_,_ in
                tipView.removeFromSuperview()
            }
        }
    }
}

class TipView: UIView {
    
    var tipContent: String? {
        didSet {
            guard let tipContent = tipContent else { return }
            textLabel.text = tipContent
            textLabel.adjustsFontSizeToFitWidth = true
        }
    }
    
    private let iconImageView = UIImageView().then{
        $0.image = UIImage(named:"tipIcon")
    }
    
    private let textLabel = UILabel().then{
        $0.numberOfLines = 0
        $0.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
    
    init() {
        super.init(frame: CGRect(x: 0, y: -statusBarHeight - 44, width: SCREEN_WIDTH, height: (statusBarHeight + 44) * 2))

        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        layer.shadowColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 0.2
    
        addSubview(iconImageView)
        addSubview(textLabel)
        
        iconImageView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-5)
            make.size.equalTo(20)
        }
        textLabel.snp.makeConstraints { (make) in
            make.leftMargin.equalTo(iconImageView.snp.right).offset(15)
            make.right.equalToSuperview().offset(-15)
            make.bottom.lessThanOrEqualToSuperview().offset(-5)
            make.height.lessThanOrEqualTo(35)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// 网络检测
class SLNetworkStatusManager {
    
    var networkStatus: NetworkReachabilityManager.NetworkReachabilityStatus = .unknown
    var manager: NetworkReachabilityManager?
    
    static let shared: SLNetworkStatusManager = {
        let shared = SLNetworkStatusManager()
        shared.manager = NetworkReachabilityManager(host: "www.baidu.com")
        return shared
    }()
    private init() {}
    
    /// 开始监测
    func start() {
        manager?.listener = { [weak self] status in
            self?.networkStatus = status
        }
        manager?.startListening()
    }
    
    func checkNetworkStatus() {
        switch networkStatus {
        case .notReachable:
            print("当前网络=====> 无网络连接")
            SLTools.showTips("无网络连接,请检查手机设置")
        case .unknown:
            print("当前网络=====> 未知网络")
        case .reachable(.ethernetOrWiFi):
            print("当前网络=====> 以太网或WIFI")
        case .reachable(.wwan):
            print("当前网络=====> 蜂窝移动网络")
        }
    }
}

class SLFileManager {
    /// 获取路径下的所有文件大小
    ///
    /// - Parameter folderPath: 路径
    /// - Returns: 文件大小
    static func forderSizeAtPath(_ folderPath:String) -> Double {
        let manage = FileManager.default
        if !manage.fileExists(atPath: folderPath) {
            return 0
        }
        let childFilePath = manage.subpaths(atPath: folderPath)
        var fileSize:Double = 0
        for path in childFilePath! {
            let fileAbsoluePath = folderPath+"/"+path
            fileSize += returnFileSize(path: fileAbsoluePath)
        }
        return fileSize
    }
    
    /// 获取单个文件大小
    ///
    /// - Parameter path: 路径
    /// - Returns: 文件大小
    static func returnFileSize(path:String) -> Double {
        let manager = FileManager.default
        var fileSize:Double = 0
        do {
            let attr = try manager.attributesOfItem(atPath: path)
            fileSize = Double(attr[FileAttributeKey.size] as! UInt64)
            let dict = attr as NSDictionary
            fileSize = Double(dict.fileSize())
        } catch {
            dump(error)
        }
        return fileSize/1024/1024
    }
    
    
    /// 删除路径下的所有文件
    ///
    /// - Parameter path: 路径
    static func deleteFolder(path: String) {
        let manage = FileManager.default
        if !manage.fileExists(atPath: path) {
        }
        let childFilePath = manage.subpaths(atPath: path)
        for path_1 in childFilePath! {
            let fileAbsoluePath = path+"/"+path_1
            deleteFile(path: fileAbsoluePath)
        }
    }
    
    /// 删除单个文件
    ///
    /// - Parameter path: 路径
    static func deleteFile(path: String) {
        let manage = FileManager.default
        do {
            try manage.removeItem(atPath: path)
        } catch {
        }
    }
}

import RxSwift
class SLAlertView: UIView {
    
    private let alertView = UIView().then {
        $0.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    private let titleImageView = UIImageView().then {
        $0.image = UIImage(named: "balloon")
    }
    private let infoLabel = UILabel().then {
        $0.textAlignment = .center
        $0.numberOfLines = 2
        $0.font = UIFont.systemFont(ofSize: 19)
    }
    private let firstBtn = UIButton().then {
        $0.backgroundColor = sl_theme.SLAlmostColor
    }
    private let secondBtn = UIButton().then {
        $0.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
    }
    
    private let bag = DisposeBag()
    
    private var single = true
    
    init(text: String, firstTitle: String, secondTitle: String?, firstAction: (() -> Void)?, secondAction: (() -> Void)?) {
        super.init(frame: SCREEN_BOUNS)
        backgroundColor = #colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 0.3134364298)
        
        addSubview(alertView)
        addSubview(titleImageView)
        alertView.addSubview(infoLabel)
        alertView.addSubview(firstBtn)
        if secondTitle != nil {
            single = false
            alertView.addSubview(secondBtn)
        }
        
        infoLabel.text = text
        firstBtn.setTitle(firstTitle, for: .normal)
        secondBtn.setTitle(secondTitle, for: .normal)
        
        firstBtn.rx.tap.subscribe(onNext: { [weak self] (_) in
            self?.removeFromSuperview()
            firstAction?()
        }).disposed(by: bag)
        secondBtn.rx.tap.subscribe(onNext: { [weak self] (_) in
            self?.removeFromSuperview()
            secondAction?()
        }).disposed(by: bag)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        newSuperview?.endEditing(true)
        let bgAnmi = POPSpringAnimation(propertyNamed: kPOPViewAlpha)
        bgAnmi?.springSpeed = 18
        bgAnmi?.fromValue = 0
        pop_add(bgAnmi, forKey: nil)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        alertView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH * 0.8)
            make.height.equalTo(SCREEN_WIDTH * 0.5)
        }
        titleImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(alertView.snp.top)
            make.size.equalTo(CGSize(width: 120, height: 120))
        }
        firstBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(50)
            if single {
                make.width.equalToSuperview()
            }else{
                make.right.equalTo(alertView.snp.centerX)
            }
        }
        if !single {
            secondBtn.snp.makeConstraints { (make) in
                make.right.equalToSuperview()
                make.bottom.equalToSuperview()
                make.height.equalTo(50)
                make.left.equalTo(firstBtn.snp.right)
            }
        }
        infoLabel.snp.makeConstraints { (make) in
            make.width.equalToSuperview().offset(-30)
            make.centerX.equalToSuperview()
            make.top.equalTo(40)
            make.bottom.equalTo(firstBtn.snp.top)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
