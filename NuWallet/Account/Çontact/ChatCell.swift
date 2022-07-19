//
//  ChatCell.swift
//  NuWallet
//
//  Created by paul.chen-mini on 2022/6/6.
//

import UIKit
import AVKit

class ChatCell: UITableViewCell {
    
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet var imageViews: [UIImageView]!
    @IBOutlet weak var timeLabel: UILabel!
    
    var videoDic = Dictionary<Int, String>()
    var chatVC: ChatVC?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        for imageView in imageViews {
            imageView.isHidden = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setImageTap(tag: Int) {
        let imageTap = UITapGestureRecognizer.init(target: self, action: #selector(showScrollImage(_:)))
        imageTap.view?.tag = tag
        if let image = imageViews.first(where: { $0.tag == tag}) {
            image.addGestureRecognizer(imageTap)
        }
    }

    func setVideoTap(tag: Int, videoStr: String) {
        let videoTap = UITapGestureRecognizer.init(target: self, action: #selector(showVideo(_:)))
        videoTap.view?.tag = tag
        self.videoDic[tag] = videoStr
        if let image = imageViews.first(where: { $0.tag == tag}) {
            image.addGestureRecognizer(videoTap)
        }
    }
    
    @objc func showScrollImage(_ gesture: UITapGestureRecognizer) {
        let scrollImageVC = ScrollImageVC()
        if let image = imageViews.first(where: { $0.tag == gesture.view?.tag}) {
            scrollImageVC.cachedImage = image.image ?? UIImage(named: "icon_toolbar_contact")!
            chatVC?.present(scrollImageVC, animated: true, completion: nil)
        }
    }

    @objc func showVideo(_ gesture: UITapGestureRecognizer) {
        let tag = gesture.view?.tag
        let videoStr = videoDic[tag ?? 0]
        let playerVC = AVPlayerViewController()
        // 0.获取远程视频url
        let remoteURL = URL(string: videoStr ?? "")
        let player = AVPlayer(url: remoteURL!)
        playerVC.player = player
        chatVC?.present(playerVC, animated: true) {
            playerVC.player?.play()
        }
       
    }

}
