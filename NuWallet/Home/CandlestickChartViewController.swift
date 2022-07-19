//
//  CandlestickChartViewController.swift
//  CryptoWallet
//
//  Created by SamLin on 2022/3/17.
//

import UIKit
import WebKit
import PKHUD

class CandlestickChartViewController: UIViewController, WKNavigationDelegate, UIScrollViewDelegate {

    var iTabBarNavigationController: TabBarNavigationController?
    
    @IBOutlet weak var coinImage: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var usdLabel: UILabel!
    
    
    @IBOutlet weak var m1Btn: UIButton!
    @IBOutlet weak var m5Btn: UIButton!
    @IBOutlet weak var m30Btn: UIButton!
    @IBOutlet weak var h1Btn: UIButton!
    @IBOutlet weak var d1Btn: UIButton!
    @IBOutlet weak var w1Btn: UIButton!
    @IBOutlet weak var chartWeb: WKWebView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomBackgroundImageView: UIImageView!
    @IBOutlet weak var swapBtn: UIButton!
    @IBOutlet weak var depositBtn: UIButton!
    @IBOutlet weak var withdrawBtn: UIButton!
    
    var symbol = "BTC"
    //var fullName = "BTC"
    var balance = "0"
    var tradeEnabled = false
    var depositEnabled = false
    var withdrawalEnabled = false
//    var price = "0"
//    var percent = 0.0
    
    var cryptoVM = CryptoViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HUD.flash(.systemActivity, delay: 0.5)
        
        if let nc = self.navigationController as? TabBarNavigationController {
            iTabBarNavigationController = nc
        }
        
        chartWeb.navigationDelegate = self
        chartWeb.scrollView.delegate = self
        chartWeb.scrollView.isScrollEnabled = false
        
        DispatchQueue.main.async {
            
            self.htmlString = self.htmlString.replacingOccurrences(of: "1920", with: "\(Int(self.chartWeb.frame.size.height))")
            if (self.symbol == "USDT") {
                self.htmlString = self.htmlString.replacingOccurrences(of: "BTCUSDT", with: "USDTUSD")
                self.htmlString = self.htmlString.replacingOccurrences(of: "BINANCE", with: "COINBASE")
            }else{
                self.htmlString = self.htmlString.replacingOccurrences(of: "BTCUSDT", with: self.symbol + "USDT")
            }
            self.chartWeb.loadHTMLString(self.htmlString, baseURL: nil)
            
        }
        initVM()
        setUI()
    }
    
    deinit {
        print("deinit")
    }
    
    func initVM() {
        cryptoVM.reloadCrypto = { [weak self] in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.navigationItem.title = "\(self.symbol) / USDT"
                self.coinImage.image = UIImage(named: "coin_\(self.symbol.lowercased())")
                let double = Double(self.cryptoVM.priceDic[self.symbol] ?? "0") ?? 0
                self.priceLabel.text = double.round()
                
                self.percentLabel.text = String(format: "%.2f", self.cryptoVM.percentDic[self.symbol] ?? 0)
                self.percentLabel.textColor()
                
                self.balanceLabel.text = self.balance + " " + self.symbol
                let balance = Double(self.balance)
                let usePrice = double * (balance ?? 0)
                self.usdLabel.text = "$ " + usePrice.round()
            }
        }
        cryptoVM.getCyypto()
    }
    
    func setUI() {
        self.navigationItem.backButtonTitle = ""
        
        m1Btn.addTarget(self, action: #selector(m1BtnClick), for: UIControl.Event.touchUpInside)
        m5Btn.addTarget(self, action: #selector(m5BtnClick), for: UIControl.Event.touchUpInside)
        m30Btn.addTarget(self, action: #selector(m30BtnClick), for: UIControl.Event.touchUpInside)
        h1Btn.addTarget(self, action: #selector(h1BtnClick), for: UIControl.Event.touchUpInside)
        d1Btn.addTarget(self, action: #selector(d1BtnClick), for: UIControl.Event.touchUpInside)
        w1Btn.addTarget(self, action: #selector(w1BtnClick), for: UIControl.Event.touchUpInside)
        resetBtnStatus(index: 4)
        
        DispatchQueue.main.async {
            self.bottomBackgroundImageView.backgroundColor = UIColor.clear
            self.bottomBackgroundImageView.image = getVerticalGradientImage(width: self.bottomBackgroundImageView.frame.size.width, height: self.bottomBackgroundImageView.frame.size.height, startColorHex: "343434", endColorHex: "141414", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: 12)
        }
        
        
        swapBtn.addTarget(self, action: #selector(swapBtnClick(_:)), for: UIControl.Event.touchUpInside)
        
        depositBtn.addTarget(self, action: #selector(depositBtnClick(_:)), for: UIControl.Event.touchUpInside)
        
        withdrawBtn.addTarget(self, action: #selector(withdrawBtnClick(_:)), for: UIControl.Event.touchUpInside)
        
        if !(tradeEnabled) {
            swapBtn.isHidden = true
        }
        if !(depositEnabled) {
            depositBtn.isHidden = true
        }
        if !(withdrawalEnabled) {
            withdrawBtn.isHidden = true
        }
        
    }
    
    @objc func m1BtnClick() {
        resetBtnStatus(index: 0)
        let str = htmlString.replacingOccurrences(of: "\"interval\": \"D\",", with: "\"interval\": \"1\",")
        self.chartWeb.loadHTMLString(str, baseURL: nil)
    }
    
    @objc func m5BtnClick() {
        resetBtnStatus(index: 1)
        let str = htmlString.replacingOccurrences(of: "\"interval\": \"D\",", with: "\"interval\": \"5\",")
        self.chartWeb.loadHTMLString(str, baseURL: nil)
    }
    
    @objc func m30BtnClick() {
        resetBtnStatus(index: 2)
        let str = htmlString.replacingOccurrences(of: "\"interval\": \"D\",", with: "\"interval\": \"30\",")
        self.chartWeb.loadHTMLString(str, baseURL: nil)
    }
    
    @objc func h1BtnClick() {
        resetBtnStatus(index: 3)
        let str = htmlString.replacingOccurrences(of: "\"interval\": \"D\",", with: "\"interval\": \"60\",")
        self.chartWeb.loadHTMLString(str, baseURL: nil)
    }
    
    @objc func d1BtnClick() {
        resetBtnStatus(index: 4)
        //muHtmlStr = muHtmlStr.replacingOccurrences(of: "1920", with: "\(Int(self.chartWeb.frame.size.height - 16))")
        self.chartWeb.loadHTMLString(htmlString, baseURL: nil)
    }
    
    @objc func w1BtnClick() {
        resetBtnStatus(index: 5)
        let str = htmlString.replacingOccurrences(of: "\"interval\": \"D\",", with: "\"interval\": \"W\",")
        self.chartWeb.loadHTMLString(str, baseURL: nil)
    }
    
    func resetBtnStatus(index: Int) {
        if (index == 0) {
            m1Btn.setBackgroundHorizontalGradient("ffffff", "d8d8d8", "222222", paddingLeftRight: 5, paddingTopBottom: 12, borderWidth: nil, borderColorHex: nil, cornerRadius: 12)
            m1Btn.setTitleColor(UIColor.black, for: UIControl.State.normal)
        } else {
            m1Btn.setBackgroundColor("ffffff00", "ffffff88", paddingLeftRight: 5, paddingTopBottom: 12, borderWidth: 2, borderColorHex: "ffffff88", cornerRadius: 12)
            m1Btn.setTitleColor(UIColor.init(hex: "ffffff88"), for: UIControl.State.normal)
        }
        if (index == 1) {
            m5Btn.setBackgroundHorizontalGradient("ffffff", "d8d8d8", "222222", paddingLeftRight: 5, paddingTopBottom: 12, borderWidth: nil, borderColorHex: nil, cornerRadius: 12)
            m5Btn.setTitleColor(UIColor.black, for: UIControl.State.normal)
        } else {
            m5Btn.setBackgroundColor("ffffff00", "ffffff88", paddingLeftRight: 5, paddingTopBottom: 12, borderWidth: 2, borderColorHex: "ffffff88", cornerRadius: 12)
            m5Btn.setTitleColor(UIColor.init(hex: "ffffff88"), for: UIControl.State.normal)
        }
        if (index == 2) {
            m30Btn.setBackgroundHorizontalGradient("ffffff", "d8d8d8", "222222", paddingLeftRight: 5, paddingTopBottom: 12, borderWidth: nil, borderColorHex: nil, cornerRadius: 12)
            m30Btn.setTitleColor(UIColor.black, for: UIControl.State.normal)
        } else {
            m30Btn.setBackgroundColor("ffffff00", "ffffff88", paddingLeftRight: 5, paddingTopBottom: 12, borderWidth: 2, borderColorHex: "ffffff88", cornerRadius: 12)
            m30Btn.setTitleColor(UIColor.init(hex: "ffffff88"), for: UIControl.State.normal)
        }
        if (index == 3) {
            h1Btn.setBackgroundHorizontalGradient("ffffff", "d8d8d8", "222222", paddingLeftRight: 5, paddingTopBottom: 12, borderWidth: nil, borderColorHex: nil, cornerRadius: 12)
            h1Btn.setTitleColor(UIColor.black, for: UIControl.State.normal)
        } else {
            h1Btn.setBackgroundColor("ffffff00", "ffffff88", paddingLeftRight: 5, paddingTopBottom: 12, borderWidth: 2, borderColorHex: "ffffff88", cornerRadius: 12)
            h1Btn.setTitleColor(UIColor.init(hex: "ffffff88"), for: UIControl.State.normal)
        }
        if (index == 4) {
            d1Btn.setBackgroundHorizontalGradient("ffffff", "d8d8d8", "222222", paddingLeftRight: 5, paddingTopBottom: 12, borderWidth: nil, borderColorHex: nil, cornerRadius: 12)
            d1Btn.setTitleColor(UIColor.black, for: UIControl.State.normal)
        } else {
            d1Btn.setBackgroundColor("ffffff00", "ffffff88", paddingLeftRight: 5, paddingTopBottom: 12, borderWidth: 2, borderColorHex: "ffffff88", cornerRadius: 12)
            d1Btn.setTitleColor(UIColor.init(hex: "ffffff88"), for: UIControl.State.normal)
        }
        if (index == 5) {
            w1Btn.setBackgroundHorizontalGradient("ffffff", "d8d8d8", "222222", paddingLeftRight: 5, paddingTopBottom: 12, borderWidth: nil, borderColorHex: nil, cornerRadius: 12)
            w1Btn.setTitleColor(UIColor.black, for: UIControl.State.normal)
        } else {
            w1Btn.setBackgroundColor("ffffff00", "ffffff88", paddingLeftRight: 5, paddingTopBottom: 12, borderWidth: 2, borderColorHex: "ffffff88", cornerRadius: 12)
            w1Btn.setTitleColor(UIColor.init(hex: "ffffff88"), for: UIControl.State.normal)
        }
    }
    
    @objc func swapBtnClick(_ btn: UIButton) {
        
        if let arr = self.navigationController?.viewControllers[0] as? TabBarMainViewController {
            self.navigationController?.popToViewController(arr, animated: true)
            arr.iTabBarController?.selectedIndex = 3
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "setFromCoin"), object: nil, userInfo: ["fromCoin":symbol, "balance":balance])
//        let homeVC = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "homeViewController")
//        homeVC.tabBarController?.selectedIndex = 3
        
        
        
    }
    
    @objc func depositBtnClick(_ btn: UIButton) {
        if depositEnabled {
            let depositDetailVC = UIStoryboard(name: "Deposit", bundle: nil).instantiateViewController(withIdentifier: "DepositDetailVC") as! DepositDetailVC
            depositDetailVC.coin = symbol
            self.navigationController?.show(depositDetailVC, sender: nil)
        }else{
            let alertC = US.showAlert(title: "greet".localized, message: "not_support_deposit".localized)
            self.present(alertC, animated: true, completion: nil)
        }
        
    }
    
    @objc func withdrawBtnClick(_ btn: UIButton) {
        if withdrawalEnabled {
            HUD.show(.systemActivity, onView: self.view)
            BN.getMember { statusCode, dataObj, err in
                HUD.hide()
                if (statusCode == 200) {
                    let enable = dataObj?.withdrawalEnabled ?? false
                    //let enable = false
                    let level = dataObj?.memberLevel ?? 1
                    //let level = 2
                    let kycStatus = dataObj?.memberKycStatus ?? 0
                    
                    let setted = dataObj?.wasTransactionPasswordSetted ?? false
                    //let setted = false
                    if level != 2{
                        FailGoView.failGoView.showMe(type: 0, status: kycStatus, vc: self)
                    }
                    else if !(enable) {
                        FailGoView.failGoView.showMe(type: 1, status: 0, vc: self)
                    }
                    else if !(setted) {
                        FailGoView.failGoView.showMe(type: 2, status: 0, vc: self)
                    }
                    else {
                        let withdrawDetailVC = UIStoryboard(name: "Deposit", bundle: nil).instantiateViewController(withIdentifier: "WithdrawDetailVC") as! WithdrawDetailVC
                        withdrawDetailVC.coin = self.symbol
                        withdrawDetailVC.fullName = self.cryptoVM.fullDic[self.symbol] ?? ""
                        self.navigationController?.show(withdrawDetailVC, sender: nil)
                    }
                }
            }
        }else{
            FailGoView.failGoView.showMe(type: 3, status: 0, vc: self)
        }
        
    }
    
    
    var htmlString = """
    <!DOCTYPE html>
    <html>
        <body style="background-color: #1c1c1c;">
            <meta name="viewport" content="width=device-width, initial-scale=1" >
            <div class="tradingview-widget-container">
              <div id="tradingview_fa611"></div>
              <div class="tradingview-widget-copyright"><a href="https://tw.tradingview.com/symbols/BTCUSDT/?exchange=BINANCE" rel="noopener" target="_blank"><span class="blue-text">BTCUSDT圖表</span></a>由TradingView提供</div>
              <script type="text/javascript" src="https://s3.tradingview.com/tv.js"></script>
              <script type="text/javascript">
              new TradingView.widget(
              {
              "width": "100%",
              "height": 1920,
              "symbol": "BINANCE:BTCUSDT",
              "interval": "D",
              "timezone": "Etc/UTC",
              "theme": "dark",
              "style": "1",
              "locale": "zh_TW",
              "toolbar_bg": "#f1f3f6",
              "enable_publishing": false,
              "hide_top_toolbar": true,
              "hide_legend": true,
              "save_image": false,
              "container_id": "tradingview_fa611"
            }
              );
              </script>
            </div>
        </body>
    </html>
    """


}
