//
//  ScanQrcodeVC.swift
//  NuWallet
//
//  Created by paul.chen-mini on 2022/4/28.
//

import UIKit
import AVFoundation

protocol scanQrcodeDelegate {
    func getQrcodeStr(qrStr: String)
}

class ScanQrcodeVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate{
    
    // 用來管理擷取活動和協調輸入及輸出數據流的對象。
    var captureSession: AVCaptureSession?
    // 核心動畫層，可以在擷取視頻時顯示視頻。
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
    var delegate: scanQrcodeDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        configurationScanner()
        // Do any additional setup after loading the view.
    }
    
    func setUI() {
        let label = UILabel(frame: CGRect(x: ScreenWidth / 2 - 75, y: 100, width: 150, height: 30))
        label.text = "scan_qrcode".localized
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        self.view.addSubview(label)
        self.view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7)
    }
    
    func configurationScanner() {
    
        let captureDevice = AVCaptureDevice.default(for: .video)
        var input: AnyObject! = nil
        var error: NSError?
        do{
            guard let device = captureDevice else {return}
            
            input = try AVCaptureDeviceInput(device: device)
            
            captureSession = AVCaptureSession()
            captureSession?.addInput(input as! AVCaptureInput)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity = .resizeAspectFill
            videoPreviewLayer?.bounds.size = CGSize(width: 300,height: 300)
            videoPreviewLayer?.frame.origin = CGPoint(x: ScreenWidth / 2 - 150, y: ScreenHeight / 2 - 150)
            view.layer.addSublayer(videoPreviewLayer!)
            
            captureSession?.startRunning()
            settingScannerFrame()
            
        }
        catch{
            print(error.localizedDescription)
            return
        }
        
        
    }
    
    
    func settingScannerFrame() {
        qrCodeFrameView = UIView()
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubviewToFront(qrCodeFrameView)
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if metadataObjects.isEmpty {
            qrCodeFrameView?.frame = .zero
            return
        }
        
        if let metadataObj = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
            if metadataObj.type == .qr {
                let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
                qrCodeFrameView?.frame = barCodeObject!.bounds
                if let value = metadataObj.stringValue {
                    print(value)
                    captureSession?.stopRunning()
                    self.delegate?.getQrcodeStr(qrStr: value)
                    self.dismiss(animated: true)
                }
            }
        }

    }
    
    

}
