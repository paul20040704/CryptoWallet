//
//  WithdrawDetailVC.swift
//  NuWallet
//
//  Created by paul.chen-mini on 2022/5/9.
//

import UIKit

class WithdrawDetailVC: UIViewController {

    
    @IBOutlet weak var amountTF: UITextField!
    @IBOutlet weak var amountBtn: UIButton!
    
    
    @IBOutlet weak var typeTF: UITextField!
    @IBOutlet weak var selectBtn: UIButton!
    
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var scanBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    var isCanNext = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    func setUI() {
        self.navigationItem.title = "withdraw".localized
        
        amountTF.resetCustom(cornerRadius: 10, paddingLeft: 15, paddingRight: 15, placeholderText: "min".localized + "10  " + "Max".localized + "10000", placeholderColorHex: "393939")
        amountTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        typeTF.resetCustom(cornerRadius: 10, paddingLeft: 15, paddingRight: 15, placeholderText: "address_type_placeholder".localized, placeholderColorHex: "393939")
        selectBtn.addTarget(self, action: #selector(selectClick), for: .touchUpInside)
        
        addressTF.resetCustom(cornerRadius: 10, paddingLeft: 15, paddingRight: 15, placeholderText: "address_placeholder".localized , placeholderColorHex: "393939")
        addressTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        scanBtn.addTarget(self, action: #selector(scanClick), for: .touchUpInside)
        
        nextBtn.setBackgroundHorizontalGradient("555555", "363636", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: nextBtn.frame.height / 2)
        nextBtn.addTarget(self, action: #selector(nextClick), for: .touchUpInside)
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        judgeCanNext()
    }
    
    func judgeCanNext() {
        amountTF.judgeRemind()
        typeTF.judgeRemind()
        addressTF.judgeRemind()
        
        var isFilled = false
        if let amount = amountTF.text, let label = typeTF.text, let address = addressTF.text {
            if (amount.count > 0 && label.count > 0 && address.count > 0) {
                isFilled = true
            }
        }
        
        if (isFilled) {
            isCanNext = true
            nextBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: nextBtn.frame.height / 2)
        }else{
            isCanNext = false
            nextBtn.setBackgroundHorizontalGradient("555555", "363636", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: nextBtn.frame.height / 2)
        }
        
        
    }
    
    @objc func selectClick() {
        let types = ["ERC20","TRC20","SPL"]
        let selectVC = UIStoryboard(name: "SelectVC", bundle: nil).instantiateViewController(withIdentifier: "SelectVC") as! SelectVC
        selectVC.page = 7
        selectVC.selectArr = types
        selectVC.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        selectVC.delegate = self
        self.present(selectVC, animated: true, completion: nil)
    }
    
    @objc func scanClick() {
        let scanQrcodeVC = ScanQrcodeVC()
        scanQrcodeVC.delegate = self
        self.present(scanQrcodeVC, animated: true, completion: nil)
    }
    
    
    @objc func nextClick() {
        judgeCanNext()
    }
    

}
                     
extension WithdrawDetailVC: SelectDelegate, scanQrcodeDelegate {
    
    func updateOption(tag: Int, condition: String) {
        typeTF.text = condition
        judgeCanNext()
    }
    
    func getQrcodeStr(qrStr: String) {
        addressTF.text = qrStr
        judgeCanNext()
    }
    
            

}
                     
