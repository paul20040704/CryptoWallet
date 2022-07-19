//
//  RejectView.swift
//  NuWallet
//
//  Created by paul.chen-mini on 2022/4/29.
//

import UIKit

class RejectView: UIView {
    static let rejectView = RejectView()
    
    @IBOutlet var parentView: UIView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var noBtn: UIButton!
    @IBOutlet weak var yesBtn: UIButton!
    
    var sellingVC: SellingOrderVC?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        Bundle.main.loadNibNamed("RejectView", owner: self)
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
        
        noBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: noBtn.frame.height / 2)
        noBtn.addTarget(self, action: #selector(noClick), for: UIControl.Event.touchUpInside)
        
        yesBtn.addTarget(self, action: #selector(yesClick), for: UIControl.Event.touchUpInside)
        
        
    }
    
    func showMe() {
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.addSubview(parentView)
    }
    
    @objc func noClick () {
        parentView.removeFromSuperview()
    }
    
    @objc func yesClick () {
        parentView.removeFromSuperview()
        let FinishVC = UIStoryboard(name: "FinishVC", bundle: nil).instantiateViewController(withIdentifier: "FinishVC") as! FinishVC
        FinishVC.sellingOrderVC = sellingVC
        FinishVC.tag = 8
        FinishVC.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        sellingVC!.present(FinishVC, animated: true, completion: nil)
    }
    
    
    
}
