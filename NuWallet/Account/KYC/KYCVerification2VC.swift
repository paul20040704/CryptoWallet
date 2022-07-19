//
//  KYCVerification2VC.swift
//  CryptoWallet
//
//  Created by paul.chen-mini on 2022/4/18.
//

import UIKit

class KYCVerification2VC: UIViewController, SelectDelegate {

    @IBOutlet var selectBtns: [UIButton]!
    @IBOutlet var selectTFs: [UITextField]!
    @IBOutlet weak var nextBtn: UIButton!
    
    var kycOptionsResponse: KYCOptionsResponse?
    var employmentStatusDic = Dictionary<Int, String>()
    var industryDic = Dictionary<Int, String>()
    var totalIncomeDic = Dictionary<Int, String>()
    var sourceFundsDic = Dictionary<Int, String>()
    
    var kycDic = Dictionary<String, Any>() //最後送出的資訊
    var isCanNext = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "account_verification".localized
        self.navigationItem.backButtonTitle = ""
        setUI()
        setDic()
    }
    

    func setUI() {
        for btn in selectBtns {
            btn.setBackgroundVerticalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: nil)
            btn.addTarget(self, action: #selector(selectBtnClick(btn:)), for: .touchUpInside)
        }
        
        for tf in selectTFs {
            switch tf.tag {
            case 0:
                tf.resetCustom(cornerRadius: 10, paddingLeft: 15, paddingRight: 15, placeholderText: "employment_status_placeholder".localized, placeholderColorHex: "393939")
            case 1:
                tf.resetCustom(cornerRadius: 10, paddingLeft: 15, paddingRight: 15, placeholderText: "industry_placeholder".localized, placeholderColorHex: "393939")
            case 2:
                tf.resetCustom(cornerRadius: 10, paddingLeft: 15, paddingRight: 15, placeholderText: "total_annual_income_placeholder".localized, placeholderColorHex: "393939")
            case 3:
                tf.resetCustom(cornerRadius: 10, paddingLeft: 15, paddingRight: 15, placeholderText: "source_of_funds_placeholder".localized, placeholderColorHex: "393939")
            default:
                break
            }
        }

        
        nextBtn.setBackgroundHorizontalGradient("555555", "363636", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: self.nextBtn.frame.height / 2)
        nextBtn.addTarget(self, action: #selector(nextBtnClick), for: UIControl.Event.touchUpInside)
        
    }
    
    func setDic() {
        
        if let data = kycOptionsResponse {
            for employmentStatus in data.employmentStatus {
                self.employmentStatusDic[employmentStatus.key ?? 0] = employmentStatus.value
            }
            for industry in data.industry {
                self.industryDic[industry.key ?? 0] = industry.value
            }
            for totalAnnualIncome in data.totalAnnualIncome {
                self.totalIncomeDic[totalAnnualIncome.key ?? 0] = totalAnnualIncome.value
            }
            for sourceOfFunds in data.sourceOfFunds {
                self.sourceFundsDic[sourceOfFunds.key ?? 0] = sourceOfFunds.value
            }
            self.employmentStatusDic.removeValue(forKey: 0)
            self.industryDic.removeValue(forKey: 0)
            self.totalIncomeDic.removeValue(forKey: 0)
            self.sourceFundsDic.removeValue(forKey: 0)
        }
    }
    
    @objc func selectBtnClick(btn: UIButton) {
        switch btn.tag {
        case 0:
            showSelectView(tag: 0,arr: US.sortDicValue(dic: employmentStatusDic))
        case 1:
            showSelectView(tag: 1,arr: US.sortDicValue(dic: industryDic))
        case 2:
            showSelectView(tag: 2,arr: US.sortDicValue(dic: totalIncomeDic))
        default:
            showSelectView(tag: 3,arr: US.sortDicValue(dic: sourceFundsDic))
        }
    }
    
    func showSelectView(tag: Int,arr: Array<String>) {
        let selectVC = UIStoryboard(name: "SelectVC", bundle: nil).instantiateViewController(withIdentifier: "SelectVC") as! SelectVC
        selectVC.tag = tag
        selectVC.page = 2
        selectVC.selectArr = arr
        selectVC.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        selectVC.delegate = self
        self.present(selectVC, animated: true, completion: nil)
    }
    
    func judgeCanNext() {
        for tf in selectTFs {
            if (tf.tag != 0) {
                tf.judgeRemind()
            }
        }
        
        var isTFSelect = true
        for tf in selectTFs {
            if (tf.text!.count < 1 && tf.tag != 0) {
                isTFSelect = false
                break
            }
        }
        if (isTFSelect) {
            isCanNext = true
            self.nextBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: self.nextBtn.frame.height / 2)
        } else {
            isCanNext = false
            self.nextBtn.setBackgroundHorizontalGradient("555555", "363636", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: self.nextBtn.frame.height / 2)
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
            kycDic["employmentStatus"] = US.dicFindKey(value: condition,dic: employmentStatusDic) as! Int
        case 1:
            kycDic["industry"] = US.dicFindKey(value: condition,dic: industryDic) as! Int
        case 2:
            kycDic["totalAnnualIncome"] = US.dicFindKey(value: condition,dic: totalIncomeDic) as! Int
        default:
            kycDic["sourceOfFunds"] = US.dicFindKey(value: condition,dic: sourceFundsDic) as! Int
        }
        judgeCanNext()
    }
    
    @objc func nextBtnClick() {
        judgeCanNext()
        if isCanNext {
            let KYCVerification3VC = UIStoryboard(name: "KYC", bundle: nil).instantiateViewController(withIdentifier: "KYCVerification3VC") as! KYCVerification3VC
            self.navigationController?.show(KYCVerification3VC, sender: nil)
            KYCVerification3VC.kycOptionsResponse = self.kycOptionsResponse
            KYCVerification3VC.kycDic = self.kycDic
        }
        
    }
    
    
    
    
    
}
