//
//  KYCVerificationVC.swift
//  CryptoWallet
//
//  Created by paul.chen-mini on 2022/4/15.
//

import UIKit

class KYCVerificationVC: UIViewController, SelectDelegate, dateDelegate{

    @IBOutlet var selectBtns: [UIButton]!
    @IBOutlet var selectTFs: [UITextField]!
    @IBOutlet weak var idNumberTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var birthdayLabel: PaddingLabel!
    @IBOutlet weak var nextBtn: UIButton!
    
    var kycOptionsResponse: KYCOptionsResponse?
    var nationalityDic = Dictionary<String, String>()
    var countryResidenceDic = Dictionary<String, String>()
    var gernderDic = Dictionary<Int, String>()
    
    var kycDic = Dictionary<String, Any>() //最後送出的資訊
    var isCanNext = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "account_verification".localized
        self.navigationItem.backButtonTitle = ""
        downloadKycOptions()
        setUI()
    }
    
    func setUI() {
        
        for btn in selectBtns {
            btn.setBackgroundVerticalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: nil)
            btn.addTarget(self, action: #selector(selectBtnClick(btn:)), for: .touchUpInside)
        }
        
        for tf in selectTFs {
            switch tf.tag {
            case 0:
                tf.resetCustom(cornerRadius: 10, paddingLeft: 15, paddingRight: 15, placeholderText: "nationality_placeholder".localized, placeholderColorHex: "393939")
            case 1:
                tf.resetCustom(cornerRadius: 10, paddingLeft: 15, paddingRight: 15, placeholderText: "residential_address_placeholder".localized, placeholderColorHex: "393939")
            case 2:
                tf.resetCustom(cornerRadius: 10, paddingLeft: 15, paddingRight: 15, placeholderText: "gender_placeholder".localized, placeholderColorHex: "393939")
            default:
                break
            }
        }

        
        idNumberTF.resetCustom(cornerRadius: 10, paddingLeft: 15, paddingRight: 15, placeholderText: "passport_idcard_number_placeholder".localized, placeholderColorHex: "393939")
        idNumberTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        addressTF.resetCustom(cornerRadius: 10, paddingLeft: 15, paddingRight: 15, placeholderText: "residential_address_placeholder".localized, placeholderColorHex: "393939")
        addressTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        firstNameTF.resetCustom(cornerRadius: 10, paddingLeft: 15, paddingRight: 15, placeholderText: "first_name_placeholder".localized, placeholderColorHex: "393939")
        firstNameTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        lastNameTF.resetCustom(cornerRadius: 10, paddingLeft: 15, paddingRight: 15, placeholderText: "last_name_placeholder".localized, placeholderColorHex: "393939")
        lastNameTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        birthdayLabel.text = US.dateToString(date: Date())
        
        nextBtn.setBackgroundHorizontalGradient("555555", "363636", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: self.nextBtn.frame.height / 2)
        nextBtn.addTarget(self, action: #selector(nextBtnClick), for: UIControl.Event.touchUpInside)
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        judgeCanNext()
    }

    
    func downloadKycOptions() {
        getKycOptions { statusCode, datdObj, err in
            if (statusCode == 200) {
                if let data = datdObj {
                    self.kycOptionsResponse = datdObj
                    
                    for nationality in data.nationality {
                        self.nationalityDic[nationality.key ?? ""] = nationality.value
                    }
                    for countryResidence in data.countryOfResidence {
                        self.countryResidenceDic[countryResidence.key ?? ""] = countryResidence.value
                    }
                    for genderValue in data.gender {
                        self.gernderDic[genderValue.key ?? 0] = genderValue.value
                    }
                    self.gernderDic.removeValue(forKey: 0)
                }
            }
        }
    }
    

    @objc func selectBtnClick(btn: UIButton) {
        switch btn.tag {
        case 0:
            showSelectView(tag: 0,arr: Array(nationalityDic.values.map{ $0 }).sorted(by: <))
        case 1:
            showSelectView(tag: 1,arr: Array(countryResidenceDic.values.map{ $0 }).sorted(by: <))
        case 2:
            showSelectView(tag: 2,arr: US.sortDicValue(dic: gernderDic))
        default:
            let selectDateVC = UIStoryboard(name: "SelectDateVC", bundle: nil).instantiateViewController(withIdentifier: "SelectDateVC") as! SelectDateVC
            selectDateVC.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            selectDateVC.delegate = self
            self.present(selectDateVC, animated: true, completion: nil)
        }
    }
    
    func showSelectView(tag: Int,arr: Array<String>) {
        let selectVC = UIStoryboard(name: "SelectVC", bundle: nil).instantiateViewController(withIdentifier: "SelectVC") as! SelectVC
        selectVC.tag = tag
        selectVC.page = 1
        selectVC.selectArr = arr
        selectVC.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        selectVC.delegate = self
        self.present(selectVC, animated: true, completion: nil)
    }
    
    func judgeCanNext() {
        
        for tf in selectTFs {
            tf.judgeRemind()
        }
        idNumberTF.judgeRemind()
        addressTF.judgeRemind()
        firstNameTF.judgeRemind()
        lastNameTF.judgeRemind()
        
        var isLabelSelect = true
        if (birthdayLabel.text!.count) < 1 {
            isLabelSelect = false
        }
        for tf in selectTFs {
            if (tf.text!.count < 1) {
                isLabelSelect = false
                break
            }
        }
        
        var isTextFieldFilled = false
        if (idNumberTF.text!.count > 0 && addressTF.text!.count > 0 && firstNameTF.text!.count > 0 && lastNameTF.text!.count > 0) {
            isTextFieldFilled = true
        }
        
        if (isLabelSelect && isTextFieldFilled) {
            isCanNext = true
            self.nextBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: self.nextBtn.frame.height / 2)
        } else {
            isCanNext = false
            self.nextBtn.setBackgroundHorizontalGradient("555555", "363636", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: self.nextBtn.frame.height / 2)
        }
    }
    
    @objc func nextBtnClick() {
        judgeCanNext()
        if isCanNext {
            kycDic["number"] = idNumberTF.text ?? ""
            kycDic["residentialAddress"] = addressTF.text ?? ""
            kycDic["firstName"] = firstNameTF.text ?? ""
            kycDic["lastName"] = lastNameTF.text ?? ""
            kycDic["birthday"] = birthdayLabel.text ?? ""
            
            let KYCVerification2VC = UIStoryboard(name: "KYC", bundle: nil).instantiateViewController(withIdentifier: "KYCVerification2VC") as! KYCVerification2VC
            self.navigationController?.show(KYCVerification2VC, sender: nil)
            KYCVerification2VC.kycOptionsResponse = self.kycOptionsResponse
            KYCVerification2VC.kycDic = self.kycDic
        }
        
    }
    
    //Delegate
    func updateOption(tag: Int, condition: String) {
        for tf in selectTFs {
            if (tf.tag == tag) {
                tf.text = condition
            }
        }
        switch tag {
        case 0:
            kycDic["nationalityId"] = US.dicFindKey(value: condition,dic: nationalityDic) as! String
        case 1:
            kycDic["countryOfResidenceId"] = US.dicFindKey(value: condition,dic: countryResidenceDic) as! String
        case 2:
            kycDic["gender"] = US.dicFindKey(value: condition,dic: gernderDic) as! Int
        default:
            break
        }
        judgeCanNext()
    }
    
    func updateDate(dateStr: String) {
        self.birthdayLabel.text = dateStr
    }
    
    
}
