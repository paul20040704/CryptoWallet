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
    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var closeBtn: UIButton!
    
    var qrcodeImage = UIImageView()
    var currentBright = 0.5
    
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
    
    func showMe(qrStr: String, coin: String, key: String) {
        
        self.currentBright = UIScreen.main.brightness
        UIScreen.main.brightness = 1.0
        
        coinLabel.text = "\(coin) (\(key))"
        qrcodeImage = UIImageView.init(frame: CGRect(x: alertView.frame.width / 2 - 80, y: 125, width: 160, height: 160))
        qrcodeImage.image = createQrcode(str: qrStr)
        alertView.addSubview(qrcodeImage)
        
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.addSubview(parentView)
    }
    
    func createQrcode(str: String) -> UIImage? {
        let strData = str.data(using: .utf8, allowLossyConversion: false)
        let qrFilter = CIFilter(name: "CIQRCodeGenerator")
        qrFilter?.setValue(strData, forKey: "inputMessage")
        qrFilter?.setValue("H", forKey: "inputCorrectionLevel")
        if let qrCIImage = qrFilter?.outputImage {
            let scaleX = qrcodeImage.frame.size.width / qrCIImage.extent.size.width
            let scaleY = qrcodeImage.frame.size.height / qrCIImage.extent.size.height
            let transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
            let output = qrCIImage.transformed(by: transform)
            return UIImage(ciImage: output)
        }
        return nil
    }
    
    @objc func closeClick () {
        UIScreen.main.brightness = currentBright
        parentView.removeFromSuperview()
    }

}
