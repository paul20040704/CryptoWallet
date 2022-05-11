//
//  CandlestickChartViewController.swift
//  CryptoWallet
//
//  Created by SamLin on 2022/3/17.
//

import UIKit
import WebKit

class CandlestickChartViewController: UIViewController, WKNavigationDelegate, UIScrollViewDelegate {

    var iTabBarNavigationController: TabBarNavigationController?
    
    @IBOutlet weak var coinImage: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    
    
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
    var price = "0"
    var percent = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let nc = self.navigationController as? TabBarNavigationController {
            iTabBarNavigationController = nc
        }
        
        chartWeb.navigationDelegate = self
        chartWeb.scrollView.delegate = self
        chartWeb.scrollView.isScrollEnabled = false
        
        DispatchQueue.main.async {
            
            self.htmlString = self.htmlString.replacingOccurrences(of: "1920", with: "\(Int(self.chartWeb.frame.size.height - 30))")
            self.htmlString = self.htmlString.replacingOccurrences(of: "BTCUSDT", with: self.symbol + "USDT")
            self.chartWeb.loadHTMLString(self.htmlString, baseURL: nil)
            
        }
    
        setUI()
    }
    
    func setUI() {
        self.navigationItem.title = "\(symbol) / USDT"
        coinImage.image = UIImage(named: "coin_\(symbol.lowercased())")
        priceLabel.text = price
        percentLabel.text = String(format: "%.2f", percent)
        percentLabel.textColor()
        
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
        
        swapBtn.setBackgroundHorizontalGradient("ffffff", "d8d8d8", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: swapBtn.frame.height / 2)
        swapBtn.addTarget(self, action: #selector(swapBtnClick(_:)), for: UIControl.Event.touchUpInside)
        
        depositBtn.setBackgroundHorizontalGradient("ffffff", "d8d8d8", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: depositBtn.frame.height / 2)
        depositBtn.addTarget(self, action: #selector(depositBtnClick(_:)), for: UIControl.Event.touchUpInside)
        
        withdrawBtn.setBackgroundHorizontalGradient("ffffff", "d8d8d8", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: withdrawBtn.frame.height / 2)
        withdrawBtn.addTarget(self, action: #selector(depositBtnClick(_:)), for: UIControl.Event.touchUpInside)
        
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
        print("swapBtnClick")
    }
    
    @objc func depositBtnClick(_ btn: UIButton) {
        print("depositBtnClick")
    }
    
    @objc func withdrawBtnClick(_ btn: UIButton) {
        print("withdrawBtnClick")
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
