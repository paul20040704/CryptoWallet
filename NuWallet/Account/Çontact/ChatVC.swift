//
//  ChatVC.swift
//  NuWallet
//
//  Created by paul.chen-mini on 2022/6/6.
//

import UIKit
import PKHUD
import SupportSDK
import AVKit
import Kingfisher
import PhotosUI

class ChatVC: UIViewController, UITextViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var commentTV: UITextView!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var inputTextViewHeightConstraint: NSLayoutConstraint!
    
    var comments = [ZDKCommentWithUser]()
    var requestId = ""
    var userId = ""
    var videoDic = Dictionary<Int, String>()
    
    var playerVC: AVPlayerViewController?
    
    var isScrollBottom = false // 是否滑動到最下方
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "detail".localized
        
        comments = comments.reversed()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        commentTV.delegate = self
        // Do any additional setup after loading the view.
        addBtn.addTarget(self, action: #selector(add), for: .touchUpInside)
        sendBtn.addTarget(self, action: #selector(send), for: .touchUpInside)
        
        
        getCommentsWithRequestId()
    }
    

    func getCommentsWithRequestId() {
        ZDKRequestProvider().getCommentsWithRequestId(requestId) { zdkCommentWithUserArray, error in
            if let comments = zdkCommentWithUserArray{
               
                self.comments = comments.reversed()
                self.isScrollBottom = false
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func add() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .any(of: [.images, .videos])
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    @objc func send() {
        let text = commentTV.text ?? ""
        if text.count > 0 {
            HUD.show(.systemActivity)
            ZDKRequestProvider().addComment(text, forRequestId: requestId, attachments: nil) { zdkComment, error in
                HUD.hide()
                self.commentTV.text = ""
                self.inputTextViewHeightConstraint.constant = 35
                if let error = error {
                    print("Send \(error)")
                }else{
                    self.getCommentsWithRequestId()
                }
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        var height: CGFloat = 90
        if textView.contentSize.height < 90 {
            if textView.contentSize.height > 35 {
                height = textView.contentSize.height
            }else{
                height = 35
            }
        }
        
        if self.inputTextViewHeightConstraint.constant != height {
            self.inputTextViewHeightConstraint.constant = height
            textView.scrollRangeToVisible(NSRange(location: 0, length: 0))
        }
    }
    
}


extension ChatVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        let textCell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TextCell
        cell.chatVC = self
        let comment = comments[indexPath.row]
        if userId == String(comment.comment.authorId.intValue) {
            if let files = comment.comment.attachments {
                if comment.comment.body == "#123" {
                    cell.bodyLabel.text = ""
                }else{
                    cell.bodyLabel.text = comment.comment.body
                }
                let date = comment.comment.createdAt ?? Date()
                cell.timeLabel.text = US.dateToStringMS(date: date)
                
                let count = files.count
                for i in 0...count - 1 {
                    if let imageView = cell.imageViews.filter{ $0.tag == i}.first {
                        if files[i].contentType == "image/jpeg" {
                            let url = URL(string: files[i].contentURLString)
                            imageView.kf.indicatorType = .activity
                            imageView.kf.setImage(with: url)
                            imageView.isHidden = false
                            imageView.isUserInteractionEnabled = true
                            cell.setImageTap(tag: i)
                        }else{
                            imageView.image = UIImage(named: "icon_toolbar_contact")
                            imageView.isHidden = false
                            imageView.isUserInteractionEnabled = true
                            cell.setVideoTap(tag: i, videoStr: files[i].contentURLString)
                        }
                    }
                }
                return cell
            }else{
                if comment.comment.body == "#123" {
                    textCell.bodyLabel.text = ""
                }else{
                    textCell.bodyLabel.text = comment.comment.body
                }
                let date = comment.comment.createdAt ?? Date()
                textCell.timeLabel.text = US.dateToStringMS(date: date)
            }
            return textCell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell", for: indexPath) as! AnswerCell
            cell.bodyLabel.text = comment.comment.body
            let date = comment.comment.createdAt ?? Date()
            cell.timeLabel.text = US.dateToStringMS(date: date)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isScrollBottom == false {
            self.tableView.scrollToRow(at: IndexPath(row: self.comments.count - 1, section: 0), at: .none, animated: false)
            if (indexPath.row == self.comments.count - 1) {
                self.isScrollBottom = true
            }
        }
    }

}


extension ChatVC: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        HUD.show(.systemActivity, onView: self.view)
        
        if results.count > 0 {
            let result = results[0]
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    let fileName = result.itemProvider.suggestedName ?? "IMG_0000"
                    if let image = image as? UIImage {
                        let scaleImage = image.resizeImage()
                        if let attachment = scaleImage.fixOrientation().jpegData(compressionQuality: 1) {
                            if US.dataSizeOver(data: attachment) {
                                DispatchQueue.main.async {
                                    HUD.hide()
                                    let alertVC = US.showAlert(title: "greet".localized, message: "over_file_max_size".localized)
                                    self.present(alertVC, animated: true)
                                }
                            }else{
                                ZDKUploadProvider().uploadAttachment(attachment, withFilename: fileName, andContentType: "image/jpeg") { response, error in
                                    if let response = response {
                                        ZDKRequestProvider().addComment("#123", forRequestId: self.requestId, attachments: [response]) { zdkComment, error in
                                            DispatchQueue.main.async {
                                                HUD.hide()
                                            }
                                            if let error = error {
                                                print("Send \(error)")
                                            }else{
                                                self.getCommentsWithRequestId()
                                            }
                                        }
                                    }else{
                                        DispatchQueue.main.async {
                                            HUD.hide()
                                        }
                                    }
                                }
                            }
                        }else{
                            DispatchQueue.main.async {
                                HUD.hide()
                            }
                        }
                    }else{
                        DispatchQueue.main.async {
                            HUD.hide()
                        }
                    }
                }
            }else{
                result.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { url, error in
                    if let url = url {
                        let fileName = result.itemProvider.suggestedName ?? "viede"
                        let videoName = "\(Int(Date().timeIntervalSince1970)).\(url.pathExtension)"
                        let newUrl = URL(fileURLWithPath: NSTemporaryDirectory() + videoName)
                        try? FileManager.default.copyItem(at: url, to: newUrl)
                        let data = try? Data(contentsOf: newUrl)
                        
                        if let attachment = data {
                            if US.dataSizeOver(data: attachment) {
                                DispatchQueue.main.async {
                                    HUD.hide()
                                    let alertVC = US.showAlert(title: "greet".localized, message: "over_file_max_size".localized)
                                    self.present(alertVC, animated: true)
                                }
                            }else{
                                ZDKUploadProvider().uploadAttachment(attachment, withFilename: fileName, andContentType: "video/mp4") { response, error in
                                    if let response = response {
                                        ZDKRequestProvider().addComment("#123", forRequestId: self.requestId, attachments: [response]) { zdkComment, error in
                                            DispatchQueue.main.async {
                                                HUD.hide()
                                            }
                                            if let error = error {
                                                print("Send \(error)")
                                            }else{
                                                self.getCommentsWithRequestId()
                                            }
                                        }
                                    }else{
                                        DispatchQueue.main.async {
                                            HUD.hide()
                                        }
                                    }
                                }
                            }
                        }else{
                            DispatchQueue.main.async {
                                HUD.hide()
                            }
                        }
                    }else{
                        DispatchQueue.main.async {
                            HUD.hide()
                        }
                    }
                }
            }
        }else{
            HUD.hide()
        }
    }
    
    
}
