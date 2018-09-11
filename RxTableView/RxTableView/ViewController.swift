//
//  ViewController.swift
//  RxTableView
//
//  Created by RY on 2018/6/2.
//  Copyright © 2018年 KK. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class ViewController: UIViewController {

    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        tableView1()
        tableView2()
        
    }
    
    func tableView1() {
        
        let tableView = UITableView(frame: UIScreen.main.bounds, style: .plain)
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        let items = Observable.just(["AAA", "BBB", "CCC"])
        
        items.bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { (row, element, cell) in
            cell.selectionStyle = .none
            cell.textLabel?.text = "\(row)：\(element)"
            }.disposed(by: bag)
        
        //获取选中索引
        tableView.rx.itemSelected.subscribe(onNext: { (indexPath) in
            print("选中-\(indexPath)")
        }).disposed(by: bag)
        
        //获取选中数据(必须先绑定数据,否则会崩溃)
        tableView.rx.modelSelected(String.self).subscribe(onNext: { (str) in
            print(str)
        }).disposed(by: bag)
        
        //获取取消选中索引,也有获取取消选中数据, 每次点击会把当前点击设为选中,上次点击重置为非选中(可应用于单选)
        tableView.rx.itemDeselected.subscribe(onNext: { (indexPath) in
            print("取消选中-\(indexPath)")
        }).disposed(by: bag)
        
        //获取删除项的索引
        tableView.rx.itemDeleted.subscribe(onNext: { indexPath in
            print("删除项的indexPath为：\(indexPath)")
        }).disposed(by: bag)
        
        //获取删除项的内容
        tableView.rx.modelDeleted(String.self).subscribe(onNext: { str in
            print("删除项的的标题为：\(str)")
        }).disposed(by: bag)

    }
    
    func tableView2() {
        let tableView = UITableView(frame: UIScreen.main.bounds, style: .plain)
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let items = Observable.just([SectionModel(model: "123", items: ["AAA", "BBB", "CCC"])])
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, String>>(configureCell: { (ds, tv, ip, item) -> UITableViewCell in
            let cell = tv.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = "\(ip.row)：\(item)"
            return cell
        }, titleForHeaderInSection: { (ds, section) -> String? in
            return ds.sectionModels[section].model
        }, titleForFooterInSection: { (ds, section) -> String? in
            return "456"
        })
        
        items.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: bag)
    }
    
}
