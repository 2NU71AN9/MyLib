//
//  SLCitySelectorView.swift
//  SLCitySelector
//
//  Created by X.T.X on 2018/3/7.
//  Copyright © 2018年 shiliukeji. All rights reserved.
//

import UIKit
import RxSwift

class SLCitySelectorView: UITableView {

    /// 选择的城市
    var selectCity: ((String) -> Void)? {
        didSet {
            hotCityView.selectCity = selectCity
        }
    }
    
    //获取城市数据
    var cityDic:[String:[String]] = [:]
    //热门城市
    var hotCities:[String] = [] {
        didSet {
           hotCityView.cityArray = hotCities
        }
    }
    //标题数组
    var titleArray:[String] = []
    
    let hotCityView = SLHotCityCollectionView()
    
    let bag = DisposeBag()
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        backgroundColor = backColor
        delegate = self
        dataSource = self
        //索引
        sectionIndexColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
        sectionIndexBackgroundColor = backColor
    }
}
//MARK:- 城市列表的 代理方法  tableView
extension SLCitySelectorView: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return titleArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0, 1:
            return 1
        default:
            let key = titleArray[section]
            return cityDic[key]?.count ?? 1
        }
    }
    
    // MARK: 创建cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 1:
            var cell = tableView.dequeueReusableCell(withIdentifier: "hotCellid")
            if cell == nil {
                cell = UITableViewCell(style: .value1, reuseIdentifier: "hotCellid")
                cell?.selectionStyle = .none
                cell?.backgroundColor = backColor
                cell?.addSubview(hotCityView)
            }
            return cell ?? UITableViewCell()
        default:
            var cell = tableView.dequeueReusableCell(withIdentifier: "cellid")
            if cell == nil {
                cell = UITableViewCell(style: .value1, reuseIdentifier: "cellid")
                cell?.selectionStyle = .none
                cell?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
            if indexPath.section == 0 {
                weak var weakCell = cell
                SLLocationManager.shared.status.asObservable().subscribe(onNext: { (status) in
                    weakCell?.textLabel?.text = status == 0 ? "定位中..." : status == 2 ? "定位失败" : SLLocationManager.shared.location?.addressDetail.city
                }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: bag)
                
            }else {
                let key = titleArray[indexPath.section]
                cell?.textLabel?.text = cityDic[key]?[indexPath.row]
            }
            return cell ?? UITableViewCell()
        }
    }
    // MARK: 点击cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section > 1 {
            let key = titleArray[indexPath.section]
            if let city = cityDic[key]?[indexPath.row] {
                selectCity?(city)
            }
        } else if indexPath.section == 0 {
            if SLLocationManager.shared.status.value == 1 {
                selectCity?((SLLocationManager.shared.location?.addressDetail.city)!)
            }
        }
    }
    
    // MARK: 右边索引
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return titleArray
    }
    
    // MARK: section头视图
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = backColor
        let title = UILabel(frame: CGRect(x: 20, y: 0, width: 200, height: 40))
        var titleArr = titleArray
        titleArr[0] = "定位城市"
        titleArr[1] = "热门城市"
        title.text = titleArr[section]
        title.textColor = UIColor.darkGray
        view.addSubview(title)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    // MARK: row高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            let row = (hotCities.count + 2) / 3
            return 50 * CGFloat(row) + 10
        }else{
            return 42
        }
    }
}
