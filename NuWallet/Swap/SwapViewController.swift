//
//  SwapViewController.swift
//  CryptoWallet
//
//  Created by SamLin on 2022/3/15.
//

import UIKit
import PKHUD

class SwapViewController: UIViewController {

    @IBOutlet weak var historyBtn: UIButton!
    @IBOutlet weak var selectFromBtn: UIButton!
    @IBOutlet weak var fromImage: UIImageView!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var fromTF: UITextField!
    @IBOutlet weak var fromCoinLabel: UILabel!
    @IBOutlet var percentBtns: [UIButton]!
    
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var selectToBtn: UIButton!
    @IBOutlet weak var toImage: UIImageView!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var toCoinLabel: UILabel!
    
    @IBOutlet weak var swapBtn: UIButton!
    @IBOutlet weak var swapLabel: UILabel!
    
    var iTabBarController: TabBarController?
    var swapViewModel = SwapViewModel()
    
    var fromCoin: String = "" {
        didSet {
            self.fromCoinLabel.text = fromCoin
            self.fromImage.image = UIImage(named: "coin_\(fromCoin.lowercased())")
            self.min = swapViewModel.swapListMin[fromCoin] ?? 0
            self.fromDecimal = swapViewModel.swapDecimal[fromCoin] ?? 0
        }
    }
    
    var toCoin: String = "" {
        didSet {
            self.toCoinLabel.text = toCoin
            self.toImage.image = UIImage(named: "coin_\(toCoin.lowercased())")
        }
    }
    
    var min: Double = 0 {
        didSet {
            self.minLabel.text = ": " + String(min)
        }
    }
    //餘額
    var balance: Double = 0.0 {
        didSet {
            self.balanceLabel.text = String(balance)
        }
    }
    
    // 要交換金額
    var fromBalance: Double = 0.0
    
    var fromDecimal = 0 //支援小數點
    var rate = 0.0
    
    var isCanNext = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iTabBarController?.iTabBarMainViewController?.navigationItem.title = "Swap"
        NotificationCenter.default.addObserver(self, selector: #selector(setFromCoin), name: NSNotification.Name(rawValue: "setFromCoin"), object: nil)
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initVM()
        judgeCanNext()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("viewWillDisappear")
        fromCoin = ""
        //fromTF.text = "0"
        //self.balanceLabel.text = "0"
        balance = 0
        fromBalance = 0
        fromTF.text = "0"
        toLabel.text = "0"
        toCoin = ""
        min = 0
        
    }
    
    
    func setUI() {
        historyBtn.addTarget(self, action: #selector(goHistory), for: .touchUpInside)
        
        fromTF.keyboardType = .decimalPad
        fromTF.delegate = self
        fromTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        selectFromBtn.addTarget(self, action: #selector(selectFrom), for: .touchUpInside)
        
        selectToBtn.addTarget(self, action: #selector(selectFrom), for: .touchUpInside)
        
        for btn in  percentBtns {
            btn.addTarget(self, action: #selector(percentClick(_:)), for: .touchUpInside)
        }
        
        swapBtn.setBackgroundHorizontalGradient("555555", "363636", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: swapBtn.frame.height / 2)
        swapBtn.addTarget(self, action: #selector(swap), for: .touchUpInside)
    }
    
    func initVM() {
        swapViewModel.swapReload = {
            DispatchQueue.main.async { [self] in
                if self.fromCoin == "" {
                    self.fromCoin = swapViewModel.swapList[0]
                    self.balance = swapViewModel.swapDefaultDic[fromCoin] ?? 0
                    //self.balanceLabel.text = String(balance)
                    
                }else{
                    //從wallet頁面進來
                    let coin = self.fromCoin
                    self.fromCoin = coin
                    
                }
                if let coinArr = swapViewModel.swapModelDic[fromCoin] {
                    self.toCoin = coinArr[0]
                    self.getSwapRate()
                }
            }
        }
        swapViewModel.getSwapModel()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
    
        judgeCanNext()
    }
    
    func judgeCanNext() {
        self.fromBalance = Double(fromTF.text ?? "") ?? 0
        if (self.fromBalance > balance) {
            fromTF.borderWidth = 1
            fromTF.borderColor = .red
        }else{
            fromTF.borderWidth = 0
        }
        
        swapToCoin()
        
        if (balance >= fromBalance && fromBalance > min && fromCoin != "" && toCoin != "") {
            isCanNext = true
            swapBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: swapBtn.frame.height / 2)
        }else{
            isCanNext = false
            swapBtn.setBackgroundHorizontalGradient("555555", "363636", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: swapBtn.frame.height / 2)
        }
    }
    
    @objc func setFromCoin(notification: Notification) {
        guard let userInfo = notification.userInfo, let fromCoin = userInfo["fromCoin"] as? String, let balance = userInfo["balance"] as? String else{return}
        self.fromCoin = fromCoin
        //self.fromImage.image = UIImage(named: "coin_\(fromCoin.lowercased())")
        //self.fromBalance = Double(balance) ?? 0
        self.balance = Double(balance) ?? 0
        //self.balanceLabel.text = balance
        //self.fromTF.text = balance
        //self.fromCoinLabel.text = fromCoin
    }
    
    @objc func goHistory() {
        let historyVC = UIStoryboard(name: "History", bundle: nil).instantiateViewController(withIdentifier: "HistoryVC") as! HistoryVC
        historyVC.type = 2
        self.navigationController?.show(historyVC, sender: nil)
    }
    
    @objc func selectFrom(_ button: UIButton) {
        if swapViewModel.swapList.count > 0 {
            let depositVC = UIStoryboard(name: "Deposit", bundle: nil).instantiateViewController(withIdentifier: "DepositVC") as! DepositVC
            depositVC.type = 2
            depositVC.kind = button.tag
            depositVC.swapList = swapViewModel.swapList
            depositVC.swapFullCoinDic = swapViewModel.fullCoinDic
            depositVC.swapWallectDic = swapViewModel.swapWalletDic
            depositVC.swapToList = swapViewModel.swapModelDic[fromCoin] ?? [""]
            depositVC.delegate = self
            self.present(depositVC, animated: true)
        }
    }
    
    @objc func percentClick(_ button: UIButton) {
        switch button.tag {
        case 0:
            self.fromBalance = (balance / 4).ceiling(toDecimal: fromDecimal)
            self.fromTF.text = String(self.fromBalance)
        case 1:
            self.fromBalance = (balance / 2).ceiling(toDecimal: fromDecimal)
            self.fromTF.text = String(self.fromBalance)
        case 2:
            self.fromBalance = (balance * 3 / 4).ceiling(toDecimal: fromDecimal)
            self.fromTF.text = String(self.fromBalance)
        case 3:
            self.fromBalance = balance.floor(toDecimal: fromDecimal)
            self.fromTF.text = String(self.fromBalance)
        default:
            break
        }
        swapToCoin()
        judgeCanNext()
    }
    
    func getSwapRate() {
        if (fromCoin != "" && toCoin != "") {
            HUD.show(.systemActivity, onView: self.view)
            BN.getSwapRate(fromCoin: fromCoin, toCoin: toCoin) { statusCode, dataObj, err in
                HUD.hide()
                if (statusCode == 200) {
                    self.rate = dataObj?.rate ?? 0
                    self.swapToCoin()
                    self.judgeCanNext()
                }
            }
        }
    }
    
    func swapToCoin() {
        if (fromCoin != "" && toCoin != "" && rate != 0.0) {
            let toCoinBalance = self.fromBalance * rate
            self.toLabel.text = toCoinBalance.toString()
        }
    }
    
    @objc func swap() {
        if isCanNext {
            HUD.show(.systemActivity)
            BN.getMember { statusCode, dataObj, err in
                HUD.hide()
                if (statusCode == 200) {
                    let setted = dataObj?.wasTransactionPasswordSetted ?? false
                    //let setted = false
                    if !(setted) {
                        FailGoView.failGoView.showMe(type: 2, status: 0, vc: self)
                    }else{
                        HUD.show(.systemActivity)
                        BN.postSwapOrder(fromCoinId: self.fromCoin, toCoinId: self.toCoin, quantity: self.fromTF.text ?? "0") { statusCode, dataObj, err in
                            HUD.hide()
                            if (statusCode == 200) {
                                let swapConfirmVC = UIStoryboard(name: "Swap", bundle: nil).instantiateViewController(withIdentifier: "SwapConfirmVC") as! SwapConfirmVC
                                swapConfirmVC.swapVC = self
                                swapConfirmVC.fromCoin = dataObj?.fromCoinId ?? ""
                                swapConfirmVC.fromAmount = dataObj?.payQuantity?.toString() ?? "0"
                                swapConfirmVC.toCoin = dataObj?.toCoinId ?? ""
                                swapConfirmVC.toAmount = dataObj?.purchaseQuantity?.toString() ?? "0"
                                swapConfirmVC.transactionId = dataObj?.transactionId ?? ""
                                swapConfirmVC.confrimExpiredAt = dataObj?.confirmExpiredAt ?? ""
                                swapConfirmVC.completeExpiredAt = dataObj?.completeExpiredAt ?? ""
                                swapConfirmVC.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
                                self.present(swapConfirmVC, animated: true)
                            }else{
                                FailView.failView.showMe(error: err?.exception ?? "network_fail".localized)
                            }
                        }
                    }
                }
            }
        }
        
    }

}


extension SwapViewController: CoinSelectDelegate {
    func coinSelect(type: Int, balanceStr: String, coin: String) {
        if (type == 0) {
            self.fromCoin = coin
            self.balance = Double(balanceStr) ?? 0
            //self.balanceLabel.text = balanceStr
            self.fromBalance = self.balance.floor(toDecimal: swapViewModel.swapDecimal[coin] ?? 8)
            self.fromTF.text = String(self.fromBalance)
           
        }else{
            self.toCoin = coin
            
        }
        getSwapRate()
    }
    
}

extension SwapViewController: UITextFieldDelegate {
    
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
                if flag > fromDecimal {
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
