//
//  ContactVC.swift
//  NuWallet
//
//  Created by paul.chen-mini on 2022/5/5.
//

import UIKit
import SupportSDK
import PKHUD
import PhotosUI

class ContactVC: UIViewController {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var typeLabel: PaddingLabel!
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var descriptionTV: UITextView!
    @IBOutlet weak var fileLabel: UILabel!
    @IBOutlet var selectLabels: [UILabel]!
    @IBOutlet weak var uploadBtn: UIButton!
    @IBOutlet weak var sendBtn: UIButton!
    
    var isCanNext = false
    
    var pickKeys = Array<String>()
    var imageKeys = Array<String>()
    var videoKeys = Array<String>()
    //var pickImages = Dictionary<String, UIImage>()
    //var pickVideo = Dictionary<String, URL>()
    var pickData = Dictionary<String, Data>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    

    func setUI() {
        self.navigationItem.title = "question_new".localized
        
        emailTF.resetCustom(cornerRadius: 10, paddingLeft: 15, paddingRight: 15, placeholderText: "email_placeholder".localized, placeholderColorHex: "393939")
        emailTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        selectBtn.setBackgroundVerticalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: nil)
        selectBtn.addTarget(self, action: #selector(selectBtnClick(_:)), for: .touchUpInside)
        
        titleTF.resetCustom(cornerRadius: 10, paddingLeft: 15, paddingRight: 15, placeholderText: "title_placeholder".localized, placeholderColorHex: "393939")
        titleTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        descriptionTV.placeholder = "content_placeholder".localized
        
        uploadBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: self.uploadBtn.frame.height / 2)
        uploadBtn.addTarget(self, action: #selector(uploadBtnClick(_:)), for: UIControl.Event.touchUpInside)
        
        sendBtn.setBackgroundHorizontalGradient("555555", "363636", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: self.sendBtn.frame.height / 2)
        sendBtn.addTarget(self, action: #selector(nextBtnClick), for: UIControl.Event.touchUpInside)
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        judgeCanNext()
    }
    
    func judgeCanNext() {
        
        titleTF.judgeRemind()
        
        var isTitleFilled = false
        if let title = self.titleTF.text {
            if (title.count > 0) {
                isTitleFilled = true
            }
        }
        
        if (isTitleFilled) {
            isCanNext = true
            self.sendBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: self.sendBtn.frame.height / 2)
        } else {
            isCanNext = false
            self.sendBtn.setBackgroundHorizontalGradient("555555", "363636", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: self.sendBtn.frame.height / 2)
        }
    }

    @objc func selectBtnClick(_ btn: UIButton) {
        
    }

    @objc func uploadBtnClick(_ btn: UIButton) {
        var configuration = PHPickerConfiguration()
        configuration.filter = .any(of: [.images, .videos])
        configuration.selectionLimit = 5
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    @objc func nextBtnClick() {
        judgeCanNext()
        if isCanNext {
            createRequest()
        }
    }
    
    // Zendesk Send Message
    func createRequest() {
        HUD.show(.systemActivity, onView: self.view)
        bulidCreateRequest(callback: { request in
            ZDKRequestProvider().createRequest(request)  { request, error in
                HUD.hide()
                if request != nil {
                    let FinishVC = UIStoryboard(name: "FinishVC", bundle: nil).instantiateViewController(withIdentifier: "FinishVC") as! FinishVC
                    FinishVC.contactVC = self
                    FinishVC.tag = 12
                    FinishVC.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
                    self.present(FinishVC, animated: true, completion: nil)
                    print("Success to send request")
                }
                if error != nil {
                    FailView.failView.showMe(error: error?.localizedDescription ?? "Failed to send")
                    print("Error : Failed to send request.")
                }
            }
        })
    }
    
    func bulidCreateRequest(callback: @escaping (ZDKCreateRequest) -> Void) {
        let request = ZDKCreateRequest()
        request.subject = titleTF.text ?? "no title"
        let description = descriptionTV.text ?? ""
        if description.count < 1 {
            request.requestDescription =  "#123"
        }else{
            request.requestDescription = description
        }
        uploadAttachment { (attachments) in
            for attachment in attachments {
                request.attachments.append(attachment)
            }
            callback(request)
        }
    }
    
    func uploadAttachment(callback: @escaping ([ZDKUploadResponse]) -> Void) {
        let group: DispatchGroup = DispatchGroup()
        var zdkUploadResponse = [ZDKUploadResponse]()
        for key in imageKeys {
            let queue = DispatchQueue(label: key, attributes: .concurrent)
            group.enter()
            queue.async {
                let attachment = self.pickData[key]
                ZDKUploadProvider().uploadAttachment(attachment, withFilename: key, andContentType: "image/jpeg") { response, error in
                    if let response = response {
                        zdkUploadResponse.append(response)
                    }
                    group.leave()
                }
            }
        }
        for key in videoKeys {
            let queue = DispatchQueue(label: key, attributes: .concurrent)
            group.enter()
            queue.async {
                let attachment = self.pickData[key]
                ZDKUploadProvider().uploadAttachment(attachment, withFilename: key, andContentType: "video/mp4") { response, error in
                    if let response = response {
                        zdkUploadResponse.append(response)
                    }
                    group.leave()
                }
            }
        }
        group.notify(queue: .main) {
            callback(zdkUploadResponse)
        }
    }
    
}


extension ContactVC: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        for result in results {
            
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    
                    let count = self.pickKeys.count
                    if count < 5 {
                        let fileName = result.itemProvider.suggestedName ?? "IMG_0000"
                        guard let image = image as? UIImage else {return}
                        let scaleImage = image.resizeImage()
                        if let imageData = scaleImage.fixOrientation().jpegData(compressionQuality: 1) {
                            if US.dataSizeOver(data: imageData) {
                                DispatchQueue.main.async {
                                    let alertVC = US.showAlert(title: "greet".localized, message: "over_file_max_size".localized)
                                    self.present(alertVC, animated: true)
                                }
                            }else{
                                DispatchQueue.main.async {
                                    self.fileLabel.isHidden = true
                                    let label = self.selectLabels[count]
                                    label.isHidden = false
                                    label.text = fileName + ".jpeg"
                                }
                                self.pickKeys.append(fileName)
                                self.imageKeys.append(fileName)
                                self.pickData[fileName] = imageData
                            }
                        }
                    }
                }
            }else{
                DispatchQueue.main.async {
                    HUD.show(.systemActivity)
                }
                result.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { url, error in
                    DispatchQueue.main.async {
                        HUD.hide()
                    }
                    if let error = error {
                        print(error)
                        return
                    }
                    
                    let count = self.pickKeys.count
                    if count < 5 {
                        guard let url = url else {return}
                        let fileName = result.itemProvider.suggestedName ?? "viede"
                        
                        let videoName = "\(Int(Date().timeIntervalSince1970)).\(url.pathExtension)"
                        let newUrl = URL(fileURLWithPath: NSTemporaryDirectory() + videoName)
                        try? FileManager.default.copyItem(at: url, to: newUrl)
                        
                        let data = try? Data(contentsOf: url)
                        if let videoData = data {
                            if US.dataSizeOver(data: videoData) {
                                DispatchQueue.main.async {
                                    let alertVC = US.showAlert(title: "greet".localized, message: "over_file_max_size".localized)
                                    self.present(alertVC, animated: true)
                                }
                            }else{
                                DispatchQueue.main.async {
                                    self.fileLabel.isHidden = true
                                    let label = self.selectLabels[count]
                                    label.isHidden = false
                                    label.text = fileName + ".mp4"
                                }
                                self.pickKeys.append(fileName)
                                self.videoKeys.append(fileName)
                                self.pickData[fileName] = videoData
                            }
                        }
                    }
                }
            }
        }
    }
    
    
}
