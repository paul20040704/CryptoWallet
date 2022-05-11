//
//  SelectDateVC.swift
//  CryptoWallet
//
//  Created by paul.chen-mini on 2022/4/18.
//

import UIKit

protocol dateDelegate {
    func updateDate(dateStr: String)
}

class SelectDateVC: UIViewController {

    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    var delegate: dateDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.modalPresentationStyle = .custom
        setUI()
    }
    
    func setUI() {
        datePicker.setValue(UIColor.white, forKey: "textColor")
        confirmBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: self.confirmBtn.frame.height / 2)
        confirmBtn.addTarget(self, action: #selector(confirmClick), for: .touchUpInside)
    }
    
    @IBAction func cancelClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func confirmClick() {
        self.delegate?.updateDate(dateStr: US.dateToString(date: datePicker.date))
        self.dismiss(animated: true, completion: nil)
    }
  

}
