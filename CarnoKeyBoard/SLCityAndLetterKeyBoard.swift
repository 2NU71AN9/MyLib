//
//  SLCityAndLetterKeyBoard.swift
//  SLCustomKeyBoard
//
//  Created by X.T.X on 2018/3/14.
//  Copyright © 2018年 shiliukeji. All rights reserved.
//

import UIKit

/// bottom高度
public let bottomHeight:CGFloat = UIScreen.main.bounds.height == 812 ? 34 : 0

class SLCityAndLetterKeyBoard: UIView {

    var cityComplete: ((String) -> Void)?
    var letterComplete: ((String) -> Void)?
    /// 设置键盘翻到第几页 0-1
    var curIndex: CGFloat = 0 {
        didSet {
            scrollView.setContentOffset(CGPoint(x: scrollView.bounds.width * curIndex, y: 0), animated: true)
        }
    }
    
    //获取城市数据
    private lazy var cityDic:[String: String] = {
        let path = Bundle.main.path(forResource: "CityShorthand", ofType: "plist")
        let dic = NSDictionary(contentsOfFile: path!)
        return dic as! [String : String]
    }()
    // 字母
    private lazy var letterArray = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    private lazy var scrollView: UIScrollView = {
        let scro = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 216))
        scro.contentSize = CGSize(width: scro.frame.width * 2, height: scro.frame.height)
        scro.isPagingEnabled = true
        scro.backgroundColor = UIColor.clear
        scro.showsVerticalScrollIndicator = false
        scro.showsHorizontalScrollIndicator = false
        scro.bounces = false
        return scro
    }()
    
    private lazy var page: UIPageControl = {
        let page = UIPageControl()
        page.currentPage = 0
        page.numberOfPages = 2
        return page
    }()
    
    private lazy var leftCollectView = SLCustomKeyBoardCollectionView()
    private lazy var rightCollectView = SLCustomKeyBoardCollectionView()
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 236 + bottomHeight))
        backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        
        addSubview(scrollView)
        scrollView.delegate = self
        
        scrollView.addSubview(leftCollectView)
        scrollView.addSubview(rightCollectView)
        leftCollectView.frame = CGRect(x: 0, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
        leftCollectView.complete = { [weak self] str in
            self?.cityComplete?(str)
            self?.scrollView.setContentOffset(CGPoint(x: (self?.scrollView.bounds.width)!, y: 0), animated: true)
        }
        rightCollectView.frame = CGRect(x: scrollView.bounds.width, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
        rightCollectView.complete = { [weak self] str in
            self?.letterComplete?(str)
        }
        
        addSubview(page)
        page.frame = CGRect(x: 0, y: scrollView.frame.maxY, width: frame.width, height: 20)
        
        leftCollectView.dataArray = Array(cityDic.values)
        rightCollectView.dataArray = letterArray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SLCityAndLetterKeyBoard: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        page.currentPage = Int((scrollView.contentOffset.x + scrollView.bounds.width/2) / scrollView.bounds.width)
    }
}
