//
//  NoRecordView.swift
//  CryptoWallet
//
//  Created by paul.chen-mini on 2022/4/25.
//

import UIKit
import SnapKit

class NoRecordView: UIView {
    
    static let noRecordView = NoRecordView()
    
    let noRecordImage = UIImageView()
    let noRecordLabel = UILabel()
    
    
    func setCoverView(TV: UITableView) {
        self.frame = CGRect(x: 0, y: 0 , width: ScreenWidth, height: ScreenHeight)
        self.backgroundColor = .init(hex: "1C1C1C")
        
        noRecordImage.image = UIImage(named: "pic_emptybox")
        noRecordLabel.text = "no_record".localized
        noRecordLabel.textColor = .init(hex: "383838")
        noRecordLabel.font = UIFont.systemFont(ofSize: 15)
        noRecordLabel.textAlignment = .center
        self.addSubview(noRecordImage)
        self.addSubview(noRecordLabel)
        
        noRecordImage.snp.makeConstraints { make in
            make.centerX.equalTo(self.center.x)
            make.centerY.equalTo(self.center.y - 120)
            make.height.equalTo(150)
            make.width.equalTo(150)
        }
        
        noRecordLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.center.x)
            make.centerY.equalTo(self.center.y - 40)
        }
        
        TV.addSubview(self)
    }
    
    func hide() {
        self.isHidden = true
    }
    
    func show() {
        self.isHidden = false
    }
    
    
    
    

}
