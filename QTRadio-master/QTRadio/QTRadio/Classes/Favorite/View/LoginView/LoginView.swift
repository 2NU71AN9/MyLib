//
//  LoginView.swift
//  QTRadio
//
//  Created by Enrica on 2017/11/2.
//  Copyright © 2017年 Enrica. All rights reserved.
//
// 主要是用来管理收藏模块最顶部立即登录按钮和标题的

import UIKit

class LoginView: UIView {
    
    // MARK: - 私有属性
    
    /// 保存父控制器
    fileprivate var parentVc: UIViewController

    // MARK: - 懒加载属性
    
    /// 加载一张白色的背景图片
    fileprivate lazy var whiteImage: WhiteImage = {
        
        let whiteImage = WhiteImage(frame: self.bounds)
        return whiteImage
    }()
    
    /// 标题控件
    fileprivate lazy var titleLabel: UILabel = {
        
        let label = UILabel()
        label.text = "登录后收藏内容永久保存云端"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13)
        label.sizeToFit()
        return label
    }()
    
    /// 登录按钮
    fileprivate lazy var loginBtn: UIButton = {
        
        // 创建拥有背景图片的圆角按钮
        let btn = UIButton(imageName: "icon_input_record_indicator_cancel", title: "立即登录")
        
        // 监听按钮的点击
        btn.addTarget(self, action: #selector(loginBtnClick), for: .touchUpInside)
        
        return btn
    }()
    
    /// 底部分隔条
    fileprivate lazy var seperateBar: UIView = {
        
        let bar = UIView()
        bar.backgroundColor = UIColor(r: 249, g: 249, b: 249)
        return bar
    }()
    
    // MARK: - 构造函数
    init(frame: CGRect, parentVc: UIViewController) {
        
        // 初始化私有出行
        self.parentVc = parentVc
        
        super.init(frame: frame)
        
        
        // 统一设置UI界面
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



// MARK: - 设置UI界面
extension LoginView {
    
    // 统一设置UI界面
    fileprivate func setupUI() {
        
        // 统一添加子控件
        addSubviews()
    }
    
    /// 统一添加子控件
    private func addSubviews() {
        
        // 添加白色的背景图片
        addSubview(whiteImage)
        
        // 添加标题控件
        addSubview(titleLabel)
        
        // 添加登录按钮
        addSubview(loginBtn)
        
        // 添加底部分隔条
        addSubview(seperateBar)
    }
    
    /// 重新布局子控件
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 布局whiteImage的位置
        whiteImage.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.bottom.equalTo(self)
        }
        
        // 布局标题的位置
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(50)
            make.centerX.equalTo(self)
        }
        
        // 布局按钮的位置
        loginBtn.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.left.equalTo(self).offset(80)
            make.right.equalTo(self).offset(-80)
            make.height.equalTo(44)
            make.centerX.equalTo(self)
        }
        
        // 布局底部分隔条的位置
        seperateBar.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.height.equalTo(10)
            make.bottom.equalTo(self)
        }
    }
}



// MARK: - 监听按钮的点击
extension LoginView {
    
    /// 监听登录按钮的点击
    @objc fileprivate func loginBtnClick() {
        
        let vc = LoginViewController()
        vc.view.backgroundColor = .white
        parentVc.present(vc, animated: true, completion: nil)
    }
}
