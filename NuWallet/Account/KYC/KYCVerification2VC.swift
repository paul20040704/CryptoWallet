//
//  KYCVerification2VC.swift
//  CryptoWallet
//
//  Created by paul.chen-mini on 2022/4/18.
//

import UIKit

class KYCVerification2VC: UIViewController, SelectDelegate {

    @IBOutlet var selectBtns: [UIButton]!
    @IBOutlet var selectLabels: [PaddingLabel]!
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
        for label in selectLabels {
            if (label.tag != 0) {
                label.judgeRemind()
            }
        }
        
        var isLabelSelect = true
        for label in selectLabels {
            if (label.text!.count < 1 && label.tag != 0) {
                isLabelSelect = false
                break
            }
        }
        if (isLabelSelect) {
            isCanNext = true
            self.nextBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: self.nextBtn.frame.height / 2)
        } else {
            isCanNext = false
            self.nextBtn.setBackgroundHorizontalGradient("555555", "363636", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: self.nextBtn.frame.height / 2)
        }
    }
    
    
    //Delegate
    func updateOption(tag: Int, condition: String) {
        for label in selectLabels {
            if (label.tag == tag) {
                label.text = condition
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
