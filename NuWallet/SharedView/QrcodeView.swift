//
//  QrcodeView.swift
//  NuWallet
//
//  Created by paul.chen-mini on 2022/5/9.
//

import UIKit

class QrcodeView: UIView {
    static let qrcodeView = QrcodeView()
    
    @IBOutlet var parentView: UIView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var closeBtn: UIButton!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        Bundle.main.loadNibNamed("QrcodeView", owner: self)
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
        
        closeBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: closeBtn.frame.height / 2)
        closeBtn.addTarget(self, action: #selector(closeClick), for: UIControl.Event.touchUpInside)
        
        
    }
    
    func showMe() {
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.addSubview(parentView)
    }
    
    @objc func closeClick () {
        parentView.removeFromSuperview()
    }

}
