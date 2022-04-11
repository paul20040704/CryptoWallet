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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let nc = self.navigationController as? TabBarNavigationController {
            iTabBarNavigationController = nc
        }
        
        self.navigationItem.title = "BTC / USD"
        
        m1Btn.addTarget(self, action: #selector(m1BtnClick), for: UIControl.Event.touchUpInside)
        m5Btn.addTarget(self, action: #selector(m5BtnClick), for: UIControl.Event.touchUpInside)
        m30Btn.addTarget(self, action: #selector(m30BtnClick), for: UIControl.Event.touchUpInside)
        h1Btn.addTarget(self, action: #selector(h1BtnClick), for: UIControl.Event.touchUpInside)
        d1Btn.addTarget(self, action: #selector(d1BtnClick), for: UIControl.Event.touchUpInside)
        w1Btn.addTarget(self, action: #selector(w1BtnClick), for: UIControl.Event.touchUpInside)
        resetBtnStatus(index: 4)
        
        chartWeb.navigationDelegate = self
        chartWeb.scrollView.delegate = self
        chartWeb.scrollView.isScrollEnabled = false
        
        DispatchQueue.main.async {
            
            let str = self.htmlString.replacingOccurrences(of: "1920", with: "\(Int(self.chartWeb.frame.size.height - 16))")
            self.chartWeb.loadHTMLString(str, baseURL: nil)
            
        }
        
        
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
        var str = self.htmlString.replacingOccurrences(of: "1920", with: "\(Int(self.chartWeb.frame.size.height - 16))")
        str = str.replacingOccurrences(of: "\"interval\": \"D\",", with: "\"interval\": \"1\",")
        self.chartWeb.loadHTMLString(str, baseURL: nil)
    }
    
    @objc func m5BtnClick() {
        resetBtnStatus(index: 1)
        var str = self.htmlString.replacingOccurrences(of: "1920", with: "\(Int(self.chartWeb.frame.size.height - 16))")
        str = str.replacingOccurrences(of: "\"interval\": \"D\",", with: "\"interval\": \"5\",")
        self.chartWeb.loadHTMLString(str, baseURL: nil)
    }
    
    @objc func m30BtnClick() {
        resetBtnStatus(index: 2)
        var str = self.htmlString.replacingOccurrences(of: "1920", with: "\(Int(self.chartWeb.frame.size.height - 16))")
        str = str.replacingOccurrences(of: "\"interval\": \"D\",", with: "\"interval\": \"30\",")
        self.chartWeb.loadHTMLString(str, baseURL: nil)
    }
    
    @objc func h1BtnClick() {
        resetBtnStatus(index: 3)
        var str = self.htmlString.replacingOccurrences(of: "1920", with: "\(Int(self.chartWeb.frame.size.height - 16))")
        str = str.replacingOccurrences(of: "\"interval\": \"D\",", with: "\"interval\": \"60\",")
        self.chartWeb.loadHTMLString(str, baseURL: nil)
    }
    
    @objc func d1BtnClick() {
        resetBtnStatus(index: 4)
        let str = self.htmlString.replacingOccurrences(of: "1920", with: "\(Int(self.chartWeb.frame.size.height - 16))")
        self.chartWeb.loadHTMLString(str, baseURL: nil)
    }
    
    @objc func w1BtnClick() {
        resetBtnStatus(index: 5)
        var str = self.htmlString.replacingOccurrences(of: "1920", with: "\(Int(self.chartWeb.frame.size.height - 16))")
        str = str.replacingOccurrences(of: "\"interval\": \"D\",", with: "\"interval\": \"W\",")
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
    
    
    let htmlString = """
    <!DOCTYPE html>
    <html>
        <body style="background-color: #1c1c1c;">
            <meta name="viewport" content="width=device-width, initial-scale=1" >
            <div class="tradingview-widget-container" style="background-color: #1c1c1c;">
                <div id="tradingview_661d1" style="background-color: #1c1c1c;"></div>
                <div class="tradingview-widget-copyright"><a href="https://tw.tradingview.com/symbols/NASDAQ-AAPL/" rel="noopener" target="_blank"><span class="blue-text">AAPL圖表</span></a>由TradingView提供</div>
                <script type="text/javascript" src="https://s3.tradingview.com/tv.js"></script>
                <script type="text/javascript">
      new TradingView.widget(
      {
      "width": "100%",
      "height": 1920,
      "symbol": "NASDAQ:AAPL",
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
      "container_id": "tradingview_661d1"
    }
      );
      </script>
            </div>
        </body>
    </html>
    """

}
