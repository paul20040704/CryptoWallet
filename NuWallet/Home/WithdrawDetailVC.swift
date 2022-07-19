//
//  WithdrawDetailVC.swift
//  NuWallet
//
//  Created by paul.chen-mini on 2022/5/9.
//

import UIKit
import PKHUD
import AVFoundation

class WithdrawDetailVC: UIViewController {

    @IBOutlet weak var supportLabel: UILabel!
    @IBOutlet weak var amountTF: UITextField!
    @IBOutlet weak var amountBtn: UIButton!
    
    @IBOutlet weak var amountImage: UIImageView!
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    
    @IBOutlet weak var typeTF: UITextField!
    @IBOutlet weak var selectBtn: UIButton!
    
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var scanBtn: UIButton!
    
    @IBOutlet weak var addressImage: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var memoView: UIView!
    @IBOutlet weak var memoTF: UITextField!
    
    @IBOutlet weak var feeLabel: PaddingLabel!
    @IBOutlet weak var expectLabel: PaddingLabel!
    @IBOutlet weak var nextBtn: UIButton!
    
    var isCanNext = false
    var coin = "USDT"
    var fullName = ""
    
    var balance = 0.0
    var twoFactorEnable = false
    var twoFactorType = 0
    
    var withdrawDic = Dictionary<String, Any>() //出金資訊
    
    var networkInfo: NetworkResponse?
    var networkDic = Dictionary<String, NetworkResponse>()
    var networkKey = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getWithdrawal()
        setUI()
    }
    
    deinit {
        print("deinit")
    }

    func setUI() {
        self.navigationItem.title = "withdraw".localized
        self.navigationItem.backButtonTitle = ""
        
        amountImage.image = UIImage(named: "coin_\(coin.lowercased())")
        amountLabel.text = "\(coin) " + "amount".localized
        
        amountTF.resetCustom(cornerRadius: 10, paddingLeft: 15, paddingRight: 15, placeholderText: "min".localized + "10  " + "Max".localized + "10000", placeholderColorHex: "393939")
        amountTF.keyboardType = .decimalPad
        amountTF.delegate = self
        amountTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        amountBtn.addTarget(self, action: #selector(maxClick), for: .touchUpInside)
        
        typeTF.resetCustom(cornerRadius: 10, paddingLeft: 15, paddingRight: 15, placeholderText: "address_type_placeholder".localized, placeholderColorHex: "393939")
        selectBtn.addTarget(self, action: #selector(selectClick), for: .touchUpInside)
        
        addressImage.image = UIImage(named: "coin_\(coin.lowercased())")
        addressLabel.text = fullName + " \("generate_address_paragraph_two".localized) (\(coin))"
        
        addressTF.resetCustom(cornerRadius: 10, paddingLeft: 15, paddingRight: 15, placeholderText: "address_placeholder".localized , placeholderColorHex: "393939")
        addressTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        scanBtn.addTarget(self, action: #selector(scanClick), for: .touchUpInside)
        
        memoTF.resetCustom(cornerRadius: 10, paddingLeft: 15, paddingRight: 15, placeholderText: "memo_placeholder".localized , placeholderColorHex: "393939")
        
        nextBtn.setBackgroundHorizontalGradient("555555", "363636", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: nextBtn.frame.height / 2)
        nextBtn.addTarget(self, action: #selector(nextClick), for: .touchUpInside)
        
    }
    
    func getWithdrawal() {
        HUD.show(.systemActivity)
        BN.getAssetWithdrawal(coinId: coin) { statusCode, dataObj, error in
            HUD.hide()
            if (statusCode == 200) {
                self.balance = Double(dataObj?.balance ?? 0)
                //self.balance = 100
                self.twoFactorEnable = dataObj?.twoFactorAuthEnabled ?? false
                self.twoFactorType = dataObj?.twoFactorAuthType ?? 0
                if let networks = dataObj?.networks {
                    for network in networks {
                        self.networkDic[network.networkId ?? ""] = network
                    }
                    self.networkKey = Array(self.networkDic.keys.sorted(by: <))
                    self.setParameter(id: "")
                }
            }else{
                FailView.failView.showMe(error: error?.exception ?? "network_fail".localized)
            }
        }
    }
    
    func setParameter(id: String) {
        var networkId = ""
        if id == "" {
            networkId = networkKey[0]
        }else{
            networkId = id
        }
        var supportStr = ""
        for key in networkKey {
            supportStr = supportStr + " . \(key)"
        }
        supportLabel.text = supportStr
        networkInfo = networkDic[networkId]
        typeTF.text = networkInfo?.networkId
        amountTF.placeholder = "amount_placeholder_one".localized + "\(networkInfo?.minWithdrawalQuantity ?? 0) " + "max".localized + "\(balance)"
        minLabel.text = "min".localized + " : \(networkInfo?.minWithdrawalQuantity ?? 0)"
        balanceLabel.text = "available_balance".localized + " : \(self.balance) \(coin)"
        feeLabel.text = "\(networkInfo?.fee ?? 0) " + coin
        expectLabel.text = "0 " + coin
        
        let includeMemo = networkInfo?.includeMemo ?? false
        //let includeMemo = true
        if includeMemo {
            memoView.isHidden = false
        }else{
            memoView.isHidden = true
        }
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        judgeCanNext()
        
    }
    
    func judgeCanNext() {
        amountTF.judgeRemind()
        typeTF.judgeRemind()
        addressTF.judgeRemind()
        
        var addressValidate = false
        if (validateAddress(address: addressTF.text ?? "", addressRegex: networkInfo?.addressRegex ?? "")) {
            addressTF.borderWidth = 0
            addressValidate = true
        }else{
            addressTF.borderWidth = 1
            addressTF.borderColor = .red
        }
        
        var amountValidate = false
        let amount = Double(amountTF.text ?? "0") ?? 0.0
        let fee = networkInfo?.fee ?? 0.0
        if (amount > fee) && (amount <= balance) && (amount >= networkInfo?.minWithdrawalQuantity ?? 0) {
            amountTF.borderWidth = 0
            amountValidate = true
            let expect = (amount - fee).rounding(toDecimal: networkInfo?.decimalPlaces ?? 8)
            expectLabel.text = String(expect) + " \(coin)"
        }else{
            amountTF.borderWidth = 1
            amountTF.borderColor = .red
            expectLabel.text = "0 \(coin)"
        }
        
        var isFilled = false
        if let amount = amountTF.text, let label = typeTF.text, let address = addressTF.text {
            if (amount.count > 0 && label.count > 0 && address.count > 0) {
                isFilled = true
            }
        }
        
        if (isFilled && addressValidate && amountValidate) {
            isCanNext = true
            nextBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: nextBtn.frame.height / 2)
        }else{
            isCanNext = false
            nextBtn.setBackgroundHorizontalGradient("555555", "363636", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: nextBtn.frame.height / 2)
        }
    }
    
    @objc func selectClick() {
        let types = networkKey
        let selectVC = UIStoryboard(name: "SelectVC", bundle: nil).instantiateViewController(withIdentifier: "SelectVC") as! SelectVC
        selectVC.page = 7
        selectVC.selectArr = types
        selectVC.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        selectVC.delegate = self
        self.present(selectVC, animated: true, completion: nil)
    }
    
    @objc func maxClick() {
        amountTF.text = String(balance.floor(toDecimal: networkInfo?.decimalPlaces ?? 8))
        judgeCanNext()
    }
    
    @objc func scanClick() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
                case .notDetermined:
                    AVCaptureDevice.requestAccess(for: .video) { success in
                        guard success == true else{return}
                        DispatchQueue.main.async {
                            let scanQrcodeVC = ScanQrcodeVC()
                            scanQrcodeVC.delegate = self
                            self.present(scanQrcodeVC, animated: true, completion: nil)
                        }
                    }
                case .denied, .restricted:
                    let alertVC = UIAlertController(title: "相機開啟失敗", message: "相機服務未啟用", preferredStyle: .alert)
                    let action = UIAlertAction(title: "去設定", style: .destructive) {(_) in
                        guard let settingUrl = URL(string: UIApplication.openSettingsURLString) else {return}
                        
                        if UIApplication.shared.canOpenURL(settingUrl) {
                            UIApplication.shared.open(settingUrl)
                        }
                    }
                    alertVC.addAction(action)
                    let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                    alertVC.addAction(cancel)
                    self.present(alertVC, animated: true, completion: nil)
                    
                case .authorized:
                    let scanQrcodeVC = ScanQrcodeVC()
                    scanQrcodeVC.delegate = self
                    self.present(scanQrcodeVC, animated: true, completion: nil)
                default:
                    break
                }
    }
    
    
    @objc func nextClick() {
        judgeCanNext()
        if isCanNext {
            withdrawDic["coinId"] = coin
            withdrawDic["networkId"] = networkInfo?.networkId ?? ""
            withdrawDic["quantity"] = Double(amountTF.text ?? "0")
            withdrawDic["address"] = addressTF.text ?? ""
            withdrawDic["memo"] = memoTF.text ?? ""
            let withdrawPwVC = UIStoryboard(name: "Deposit", bundle: nil).instantiateViewController(withIdentifier: "WithdrawPwVC") as! WithdrawPwVC
            withdrawPwVC.withdrawDic = self.withdrawDic
            withdrawPwVC.twoFactorEnable = self.twoFactorEnable
            withdrawPwVC.twoFactorType = self.twoFactorType
            self.navigationController?.show(withdrawPwVC, sender: nil)
        }
    }
    
    
}
                     
extension WithdrawDetailVC: SelectDelegate, scanQrcodeDelegate {
    
    func updateOption(tag: Int, condition: String) {
        typeTF.text = condition
        amountTF.text = ""
        addressTF.text = ""
        setParameter(id: condition)
        judgeCanNext()
    }
    
    func getQrcodeStr(qrStr: String) {
        addressTF.text = ""
        addressTF.text = qrStr
        judgeCanNext()
    }
    
}

extension WithdrawDetailVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var futureStr = textField.text
        futureStr?.append(string)
        if futureStr == nil {
            futureStr = ""
        }
        var flag = -1
        var pointIndex = 0
        var isSeePoint = false
        
        for i in 0..<futureStr!.count + 1 {
            let subStr1 = (futureStr! as NSString).substring(to: i)
            if subStr1.contains(".") {
                if isSeePoint == false {
                    if i == 1 && string == "." {
                        return false
                    }
                    pointIndex = i
                    isSeePoint = true
                }else{
                    if string == "." {
                        return false
                    }
                }
                flag += 1
                if flag > networkInfo?.decimalPlaces ?? 5 {
                    if range.location < pointIndex {
                        return true
                    }
                    return false
                }
            }
        }
        return true
    }
    
}
                     
