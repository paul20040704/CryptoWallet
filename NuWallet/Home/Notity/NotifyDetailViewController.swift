//
//  NotifyDetailViewController.swift
//  CryptoWallet
//
//  Created by SamLin on 2022/3/17.
//

import UIKit
import WebKit

class NotifyDetailViewController: UIViewController {

    var iTabBarNavigationController: TabBarNavigationController?
    
    @IBOutlet weak var detailTitleLabel: UILabel!
    @IBOutlet weak var detailTimeLabel: UILabel!
    @IBOutlet weak var detailWebView: WKWebView!
    
    
    var id = 0
    var boardModel: BoardModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let nc = self.navigationController as? TabBarNavigationController {
            iTabBarNavigationController = nc
        }
        self.navigationItem.title = "Message Detail"
        
        read()
        setUI()
    }
    
    func read() {
        if let readList = UD.object(forKey: "boardRead") as? Array<Int> {
            var newLsit = readList
            if !(newLsit.contains(boardModel?.id ?? 0)) {
                newLsit.append(boardModel?.id ?? 0)
                UD.set(newLsit, forKey: "boardRead")
            }
        }
    }
    
    func setUI() {
        detailTitleLabel.text = boardModel?.title
        detailTimeLabel.text = US.isoDateToString(iso: boardModel?.postOn ?? "")
        
        let headerString = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>" + (boardModel?.article ?? "")
        
        detailWebView.loadHTMLString(headerString, baseURL: nil)
    }
    

}
