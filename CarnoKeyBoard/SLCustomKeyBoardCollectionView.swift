//
//  SLCustomKeyBoardCollectionView.swift
//  SLCustomKeyBoard
//
//  Created by X.T.X on 2018/3/14.
//  Copyright © 2018年 shiliukeji. All rights reserved.
//

import UIKit

class SLCustomKeyBoardCollectionView: UICollectionView {

    var complete: ((String) -> Void)?
    
    var dataArray = [String]() {
        didSet {
            reloadData()
        }
    }
    
    init() {
        super.init(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        backgroundColor = UIColor.clear
        delegate = self
        dataSource = self
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        bounces = false
        register(SLCustomKeyBoardCell.self, forCellWithReuseIdentifier: "cellid")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SLCustomKeyBoardCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellid", for: indexPath) as? SLCustomKeyBoardCell
        cell?.textLabel.text = dataArray[indexPath.row]
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width/CGFloat((dataArray.count + 8)/5), height: collectionView.bounds.height/5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        complete?(dataArray[indexPath.row])
    }
}
class SLCustomKeyBoardCell: UICollectionViewCell {
    
    let textLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textLabel.frame = bounds
        textLabel.backgroundColor = UIColor.white
        textLabel.textColor = UIColor.black
        textLabel.textAlignment = .center
        
        addSubview(textLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

