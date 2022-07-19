//
//  ScannerBackgroundView.swift
//  NuWallet
//
//  Created by paul.chen-mini on 2022/6/8.
//

import UIKit

class ScannerBackgroundView: UIView {
    
    
    //屏幕扫描区域视图
    let barcodeView = UIView(frame: CGRect(x: UIScreen.main.bounds.size.width * 0.2, y: UIScreen.main.bounds.size.height * 0.35, width: UIScreen.main.bounds.size.width * 0.6, height: UIScreen.main.bounds.size.width * 0.6))
    //扫描线
    let scanLine = UIImageView()
    
    var scanning : String!
    var timer = Timer()
    
    var scanQrcodeVC: ScanQrcodeVC?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        barcodeView.layer.borderWidth = 1.0
        barcodeView.layer.borderColor = UIColor.white.cgColor
        self.addSubview(barcodeView)
        
        //设置扫描线
        scanLine.frame = CGRect(x: 0, y: 0, width: barcodeView.frame.size.width, height: 5)
        scanLine.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7)
        //scanLine.image = UIImage(named: "QRCodeScanLine")
        
        //添加扫描线图层
        barcodeView.addSubview(scanLine)
        
        self.createBackGroundView()
        
        self.addObserver(self, forKeyPath: "scanning", options: .new, context: nil)
        
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(moveScannerLayer(_:)), userInfo: nil, repeats: true)
        
    }
    
    func  createBackGroundView() {
        let topView = UIView(frame: CGRect(x: 0, y: 0,  width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height * 0.35))
        let bottomView = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.width * 0.6 + UIScreen.main.bounds.size.height * 0.35, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height * 0.65 - UIScreen.main.bounds.size.width * 0.6))
        
        let leftView = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height * 0.35, width: UIScreen.main.bounds.size.width * 0.2, height: UIScreen.main.bounds.size.width * 0.6))
        let rightView = UIView(frame: CGRect(x: UIScreen.main.bounds.size.width * 0.8, y: UIScreen.main.bounds.size.height * 0.35, width: UIScreen.main.bounds.size.width * 0.2, height: UIScreen.main.bounds.size.width * 0.6))
        
        topView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        bottomView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        leftView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        rightView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        
        let label = UILabel(frame: CGRect(x: ScreenWidth / 2 - 75, y: 100, width: 150, height: 30))
        label.text = "scan_qrcode".localized
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        topView.addSubview(label)
        
        let cancelBtn = UIButton(frame: CGRect(x: ScreenWidth - 50 , y: 50, width: 30, height: 30))
        cancelBtn.setImage(UIImage(named: "cancel"), for: .normal)
        cancelBtn.addTarget(self, action: #selector(close), for: .touchUpInside)
        topView.addSubview(cancelBtn)
        
        self.addSubview(topView)
        self.addSubview(bottomView)
        self.addSubview(leftView)
        self.addSubview(rightView)
    }
    
    @objc func close() {
        scanQrcodeVC?.dismiss(animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if scanning == "start" {
            timer.fire()
        }else{
            timer.invalidate()
        }
    }
    
    
    //让扫描线滚动
   @objc func moveScannerLayer(_ timer : Timer) {
        scanLine.frame = CGRect(x: 0, y: 0, width: self.barcodeView.frame.size.width, height: 5);
        UIView.animate(withDuration: 2) {
            self.scanLine.frame = CGRect(x: self.scanLine.frame.origin.x, y: self.scanLine.frame.origin.y + self.barcodeView.frame.size.height - 5, width: self.scanLine.frame.size.width, height: self.scanLine.frame.size.height);
            
        }
        
    }
}

