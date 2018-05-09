//
//  SLWechatManager.swift
//  XiaocaoPlusNew
//
//  Created by X.T.X on 2018/4/3.
//  Copyright © 2018年 shiliukeji. All rights reserved.
//

import UIKit
import SVProgressHUD

class SLWechatManager: NSObject {
    
    static let shared = SLWechatManager()
    private override init() {}
    /// 注册
    func regist() {
        WXApi.registerApp(wechatKey)
    }
    
    /// 发起支付
    func wechatPay(_ model: SLWeChatPayModel?) {
        guard let model = model else { return }
        let req = PayReq()
        req.partnerId = model.mch_id
        req.prepayId = model.prepay_id
        req.nonceStr = model.nonce_str
        req.timeStamp = UInt32(model.timestamp) ?? 0
        req.package = "Sign=WXPay"
        req.sign = model.sign
        WXApi.send(req)
    }
    
    /// 支付成功
    func wechatPaySuccess() {
        SVProgressHUD.show(UIImage(named: "paySuccess")!, status: "支付成功")
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.dismiss(withDelay: 2)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: PaySuccessNotification), object: nil)
        }
    }
    
    /// 支付失败
    func wechatPayFailure() {
        SVProgressHUD.show(UIImage(named: "payFailure")!, status: "支付失败,请重新支付")
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.dismiss(withDelay: 2)
    }
}

extension SLWechatManager: WXApiDelegate {
    func onResp(_ resp: BaseResp!) {
        if resp.isKind(of: PayResp.self) {
            switch resp.errCode {
            case 0:
                wechatPaySuccess()
            default:
                wechatPayFailure()
            }
        }
    }
}
