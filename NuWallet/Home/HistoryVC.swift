//
//  HistoryVC.swift
//  CryptoWallet
//
//  Created by paul.chen-mini on 2022/4/25.
//

import UIKit

class HistoryVC: UIViewController {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    var type = 0 // 0 Deposit 1 Withdraw 2 Swap
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "history".localized
        self.navigationItem.backButtonTitle = ""
        setUI()
        initTV()
        
    }
    
    func setUI() {
        segmentControl.setTitle("deposit".localized, forSegmentAt: 0)
        segmentControl.setTitle("withdraw".localized, forSegmentAt: 1)
        segmentControl.setTitle("swap".localized, forSegmentAt: 2)
        segmentControl.setTitleTextAttributes([.foregroundColor: UIColor.white ], for: .normal)
        segmentControl.setTitleTextAttributes([.foregroundColor: UIColor.white ], for: .selected)
        segmentControl.selectedSegmentIndex = type
        segmentControl.addTarget(self, action: #selector(segmentChange(_:)), for: .valueChanged)
        
        self.tableView.tableFooterView = UIView()
    }

    func initTV() {
        let nib = UINib(nibName: "HistoryCell", bundle: nil)
        let nib1 = UINib(nibName: "SwapHistoryCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "HistoryCell")
        tableView.register(nib1, forCellReuseIdentifier: "SwapHistoryCell")
        tableView.delegate = self
        tableView.dataSource = self
        NoRecordView.noRecordView.setCoverView(TV: self.tableView)
        
    }

    @objc func segmentChange(_ sender: UISegmentedControl) {
        type = sender.selectedSegmentIndex
        tableView.reloadData()
    }
    
}

extension HistoryVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch type {
        case 0:
            return 2
        case 1:
            return 1
        default:
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch type {
        case 0:
            NoRecordView.noRecordView.hide()
            let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath)
            return cell
        case 1:
            NoRecordView.noRecordView.show()
            let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath)
            return cell
        default:
            NoRecordView.noRecordView.hide()
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwapHistoryCell", for: indexPath)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch type {
        case 2:
            let swapHistoryDetailVC = UIStoryboard(name: "SwapHistoryDetailVC", bundle: nil).instantiateViewController(withIdentifier: "SwapHistoryDetailVC") as! SwapHistoryDetailVC
            self.navigationController?.show(swapHistoryDetailVC, sender: nil)
        default:
            let historyDetailVC = UIStoryboard(name: "HistoryDetailVC", bundle: nil).instantiateViewController(withIdentifier: "HistoryDetailVC") as! HistoryDetailVC
            historyDetailVC.type = type
            self.navigationController?.show(historyDetailVC, sender: nil)
        }
    }
    
    
}
