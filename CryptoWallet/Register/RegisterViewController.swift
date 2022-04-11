//
//  RegisterViewController.swift
//  CryptoWallet
//
//  Created by SamLin on 2022/3/10.
//

import UIKit
import WebKit

class RegisterViewController: UIViewController, WKNavigationDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var termsWeb: WKWebView!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    var isScrollEnd: Bool = false
    var isChecked: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        termsWeb.navigationDelegate = self
        termsWeb.scrollView.delegate = self
        
        isScrollEnd = false
        isChecked = false
        
        checkBtn.setImage(UIImage(named: "check_disable")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), for: UIControl.State.normal)
        
        nextBtn.setBackgroundHorizontalGradient("555555", "363636", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: nextBtn.frame.height / 2)
        
        checkBtn.addTarget(self, action: #selector(checkBtnClick), for: UIControl.Event.touchDown)
        nextBtn.addTarget(self, action: #selector(nextBtnClick), for: UIControl.Event.touchUpInside)
        
        
        DispatchQueue.main.async {
            
            if let url = URL(string: "https://terms.line.me/line_tw_privacy_policy?lang=zh-Hant") {
                self.termsWeb.load(URLRequest(url: url))
            }
            
        }
    }
    
    func checkScrollEnd() {
        if let scroll = termsWeb?.scrollView {
            if scroll.bounds.height + scroll.contentOffset.y >= scroll.contentSize.height {
                isScrollEnd = true
                checkBtn.setImage(UIImage(named: "check_off")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), for: UIControl.State.normal)
            }
        }
    }
    
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        checkScrollEnd()
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.isDecelerating || scrollView.isDragging) && !termsWeb.isLoading && !isScrollEnd {
            checkScrollEnd()
        }
    }
    
    @objc func checkBtnClick() {
        if (isScrollEnd) {
            isChecked = !isChecked
            if (isChecked) {
                checkBtn.setImage(UIImage(named: "check_on")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), for: UIControl.State.normal)
                nextBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: nextBtn.frame.height / 2)
            } else {
                checkBtn.setImage(UIImage(named: "check_off")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), for: UIControl.State.normal)
                nextBtn.setBackgroundHorizontalGradient("555555", "363636", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: nextBtn.frame.height / 2)
            }
        }
    }
    
    @objc func nextBtnClick() {
        if (isChecked) {
            let register2ViewController = UIStoryboard(name: "Register2", bundle: nil).instantiateViewController(withIdentifier: "register2ViewController")
            self.navigationController?.pushViewController(register2ViewController, animated: true)
        }
    }
    
}
