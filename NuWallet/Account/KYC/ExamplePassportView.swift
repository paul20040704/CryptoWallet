//
//  ExamplePassportView.swift
//  CryptoWallet
//
//  Created by paul.chen-mini on 2022/4/19.
//

import UIKit

class ExamplePassportView: UIView {
    static let examplePassportView = ExamplePassportView()
    
    @IBOutlet var parentView: UIView!
    
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var confirmBtn: UIButton!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        Bundle.main.loadNibNamed("ExamplePassportView", owner: self)
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
        
        confirmBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: confirmBtn.frame.height / 2)
        confirmBtn.addTarget(self, action: #selector(confirmClick), for: UIControl.Event.touchUpInside)
        
        
    }
    
    func showMe() {
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.addSubview(parentView)
    }
    
    @objc func confirmClick () {
        parentView.removeFromSuperview()
    }

}
