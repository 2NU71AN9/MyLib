//
//  SLRefreshHeader.swift
//  SLRefreshView
//
//  Created by X.T.X on 2018/3/8.
//  Copyright © 2018年 shiliukeji. All rights reserved.
//

import UIKit
import MJRefresh

class SLRefreshHeader: MJRefreshGifHeader {
    override func prepare() {
        super.prepare()
        setImages([UIImage(named: "refreshIdle") as Any], for: .idle)
        setImages([UIImage(named: "refreshing") as Any], for: .pulling)
        setImages([UIImage(named: "refreshing") as Any], for: .refreshing)
        stateLabel.isHidden = true
        lastUpdatedTimeLabel.isHidden = true
    }
}
class SLRefreshFooter: MJRefreshBackGifFooter {
    override func prepare() {
        super.prepare()
        setImages([UIImage(named: "refreshIdle") as Any], for: .idle)
        setImages([UIImage(named: "refreshing") as Any], for: .pulling)
        setImages([UIImage(named: "refreshing") as Any], for: .refreshing)
        stateLabel.isHidden = true
    }
}
