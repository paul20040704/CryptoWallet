//
//  HomeTableViewCellTitle.swift
//  CryptoWallet
//
//  Created by SamLin on 2022/3/16.
//

import UIKit

class HomeTableViewCellTitle: UITableViewCell {
    
    var iHomeTableView: HomeTableView?

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var cellTitleLabel: UILabel!
    @IBOutlet weak var cellBalanceVisibleBtn: UIButton!
    @IBOutlet weak var cellBalanceTextField: UITextField!
    @IBOutlet weak var cellDepositBtn: UIButton!
    @IBOutlet weak var cellWithdrawBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellBalanceTextField.isSecureTextEntry = true
        cellBalanceVisibleBtn.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        cellBalanceVisibleBtn.setImage(UIImage(named: "icon_eye_close"), for: UIControl.State.normal)
        cellBalanceVisibleBtn.addTarget(self, action: #selector(balanceVisibleBtnClick(_:)), for: UIControl.Event.touchUpInside)
        
        cellDepositBtn.setBackgroundHorizontalGradient("ffffff", "d8d8d8", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: cellDepositBtn.frame.height / 2)
        cellDepositBtn.addTarget(self, action: #selector(depositBtnClick(_:)), for: UIControl.Event.touchUpInside)
        
        cellWithdrawBtn.setBackgroundHorizontalGradient("ffffff", "d8d8d8", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: cellWithdrawBtn.frame.height / 2)
        cellWithdrawBtn.addTarget(self, action: #selector(withdrawBtnClick(_:)), for: UIControl.Event.touchUpInside)
        
    }

    @objc func balanceVisibleBtnClick(_ btn: UIButton) {
        cellBalanceTextField.isSecureTextEntry = !cellBalanceTextField.isSecureTextEntry
        if (cellBalanceTextField.isSecureTextEntry) {
            cellBalanceVisibleBtn.setImage(UIImage(named: "icon_eye_close"), for: UIControl.State.normal)
        } else {
            cellBalanceVisibleBtn.setImage(UIImage(named: "icon_eye_open"), for: UIControl.State.normal)
        }
    }
    
    @objc func depositBtnClick(_ btn: UIButton) {
        print("depositBtnClick")
        let depositVC = UIStoryboard(name: "Deposit", bundle: nil).instantiateViewController(withIdentifier: "DepositVC") as! DepositVC
        depositVC.type = 0
        iHomeTableView?.iHomeViewController?.navigationController?.show(depositVC, sender: nil)
        
    }
    
    @objc func withdrawBtnClick(_ btn: UIButton) {
        print("withdrawBtnClick")
        let depositVC = UIStoryboard(name: "Deposit", bundle: nil).instantiateViewController(withIdentifier: "DepositVC") as! DepositVC
        depositVC.type = 1
        iHomeTableView?.iHomeViewController?.navigationController?.show(depositVC, sender: nil)
    }
    
}
