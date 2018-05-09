//
//  SLCitySelectorModel.swift
//  SLPlaceSelectorKeyBoard
//
//  Created by X.T.X on 2018/3/19.
//  Copyright © 2018年 shiliukeji. All rights reserved.
//

import UIKit

class SLCitySelectorModel: NSObject {
    
    var id: String = ""
    var name: String = ""
    var array: [SLCitySelectorModel] = []
    
    override init() {
        super.init()
    }
    
    init(json j: [String: Any]?) {
        
        guard let j = j else { return }
        
        id = j["id"] as? String ?? ""
        name = j["name"] as? String ?? ""
        
        if let arr = j[name] as? [[String : Any]] {
            for value in arr {
                let model = SLCitySelectorModel(json: value)
                array.append(model)
            }
        }
    }
}
