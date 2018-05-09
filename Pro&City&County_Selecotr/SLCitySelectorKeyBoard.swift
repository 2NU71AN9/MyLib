//
//  SLCitySelectorKeyBoard.swift
//  SLPlaceSelectorKeyBoard
//
//  Created by X.T.X on 2018/3/19.
//  Copyright © 2018年 shiliukeji. All rights reserved.
//

import UIKit

class SLCitySelectorKeyBoard: UIView {

    var complete: ((SLCitySelectorModel?, SLCitySelectorModel?, SLCitySelectorModel?) -> Void)?
    
    var curPro: SLCitySelectorModel?
    var curCity: SLCitySelectorModel?
    var curCounty: SLCitySelectorModel? {
        didSet {
            complete?(curPro, curCity, curCounty)
        }
    }
    
    private let picker = UIPickerView()
    
    //获取城市数据
    lazy var modelArray: [SLCitySelectorModel?] = {
        let path = Bundle.main.path(forResource: "Province&City&District", ofType: "plist")
        let dic = NSDictionary(contentsOfFile: path!) as! [String: Any]
        return Array(dic.values).map { (SLCitySelectorModel(json: $0 as? [String : Any])) }.sorted{ $0.id < $1.id }
    }()
    
    init(complete: @escaping (SLCitySelectorModel?, SLCitySelectorModel?, SLCitySelectorModel?) -> Void) {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 216 + bottomHeight))
        backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        self.complete = complete
        addSubview(picker)
        picker.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height - bottomHeight)
        picker.delegate = self
        picker.dataSource = self
        
        curPro = modelArray.first as? SLCitySelectorModel
        curCity = curPro?.array.first
        curCounty = curCity?.array.first
        
        complete(curPro, curCity, curCounty)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SLCitySelectorKeyBoard: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return modelArray.count
        case 1:
            return curPro?.array.count ?? 0
        case 2:
            return curCity?.array.count ?? 0
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return modelArray[row]?.name
        case 1:
            return curPro?.array[row].name
        case 2:
            return curCity?.array[row].name
        default:
            return ""
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            curPro = modelArray[row]
            if curPro?.array.count ?? 0 > 0 {
                curCity = curPro?.array.first
            } else {
                curCity = nil
            }
            curCounty = curCity?.array.first
            pickerView.reloadComponent(1)
            pickerView.reloadComponent(2)
            pickerView.selectRow(0, inComponent: 1, animated: true)
            pickerView.selectRow(0, inComponent: 2, animated: true)
        case 1:
            if curPro?.array.count ?? 0 > row {
                curCity = curPro?.array[row]
            } else {
                curCity = nil
            }
            if curCity?.array.count ?? 0 > 0 {
                curCounty = curCity?.array.first
            }
            pickerView.reloadComponent(2)
            pickerView.selectRow(0, inComponent: 2, animated: true)
        case 2:
            curCounty = curCity?.array[row]
        default:
            break
        }
    }
    
}
