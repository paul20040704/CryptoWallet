//
//  FailView.swift
//  CryptoWallet
//
//  Created by paul.chen-mini on 2022/4/13.
//

import UIKit

class FailView: UIView {
    static let failView = FailView()

    @IBOutlet var parentView: UIView!
    @IBOutlet weak var alertView: UIView!

    @IBOutlet weak var errorTextView: UITextView!
    @IBOutlet weak var retryBtn: UIButton!
    @IBOutlet weak var FAQBtn: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        Bundle.main.loadNibNamed("FailView", owner: self)
        commitInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commitInit() {
        parentView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        parentView.autoresizingMask = [.flexibleHeight , .flexibleWidth]
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = alertView.bounds
        gradientLayer.colors = [UIColor(hex: "#1E361A")?.cgColor, UIColor(hex: "#071505")?.cgColor]
        alertView.layer.insertSublayer(gradientLayer, at: 0)
        
        retryBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: retryBtn.frame.height / 2)
        retryBtn.addTarget(self, action: #selector(retryClick), for: UIControl.Event.touchUpInside)
        
        FAQBtn.addTarget(self, action: #selector(faqClick), for: .touchUpInside)
    }
    
    func showMe(error: String) {
        
        errorTextView.text = error
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.addSubview(parentView)
    }
    
    @objc func retryClick() {
        parentView.removeFromSuperview()
    }
    
    @objc func faqClick() {
        openUrlStr(urlStr: "https://numiner.zendesk.com/hc/en-001/sections/5319628035097-Common")
        parentView.removeFromSuperview()
    }
    
}
