//
//  HistoryVC.swift
//  CryptoWallet
//
//  Created by paul.chen-mini on 2022/4/25.
//

import UIKit
import PKHUD

class HistoryVC: UIViewController {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    var type = 0 // 0 Deposit 1 Withdraw 2 Swap
    
    @IBOutlet weak var tableView: UITableView!
    
    var historyViewModel = HistoryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "history".localized
        self.navigationItem.backButtonTitle = ""
        setUI()
        initTV()
        initVM()
        
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
    
    func initVM() {
        HUD.show(.systemActivity, onView: self.view)
        historyViewModel.reloadHistory = {
            HUD.hide()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        historyViewModel.getHistory()
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
            if historyViewModel.deposits.count > 0 {
                NoRecordView.noRecordView.hide()
            }else{
                NoRecordView.noRecordView.show()
            }
            return historyViewModel.deposits.count
        case 1:
            if historyViewModel.withdraws.count > 0 {
                NoRecordView.noRecordView.hide()
            }else{
                NoRecordView.noRecordView.show()
            }
            return historyViewModel.withdraws.count
        case 2:
            if historyViewModel.swaps.count > 0 {
                NoRecordView.noRecordView.hide()
            }else{
                NoRecordView.noRecordView.show()
            }
            return historyViewModel.swaps.count
        default:
            NoRecordView.noRecordView.show()
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch type {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryCell
            let vms = historyViewModel.deposits
            cell.setup(model: vms[indexPath.row])
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryCell
            let vms = historyViewModel.withdraws
            cell.setup(model: vms[indexPath.row])
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwapHistoryCell", for: indexPath) as! SwapHistoryCell
            cell.setup(model: historyViewModel.swaps[indexPath.row])
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch type {
        case 2:
            let swapHistoryDetailVC = UIStoryboard(name: "SwapHistoryDetailVC", bundle: nil).instantiateViewController(withIdentifier: "SwapHistoryDetailVC") as! SwapHistoryDetailVC
            swapHistoryDetailVC.swapDetail = historyViewModel.swaps[indexPath.row]
            self.navigationController?.show(swapHistoryDetailVC, sender: nil)
        default:
            if let cell = tableView.cellForRow(at: indexPath) as? HistoryCell {
                if cell.isBtmTransaction {
                    let btmHistoryDetailVC = UIStoryboard(name: "BtmHistoryDetailVC", bundle: nil).instantiateViewController(withIdentifier: "BtmHistoryDetailVC") as! BtmHistoryDetailVC
                    btmHistoryDetailVC.type = type
                    btmHistoryDetailVC.transactionId = cell.transactionId
                    self.navigationController?.show(btmHistoryDetailVC, sender: nil)
                }else{
                    let historyDetailVC = UIStoryboard(name: "HistoryDetailVC", bundle: nil).instantiateViewController(withIdentifier: "HistoryDetailVC") as! HistoryDetailVC
                    historyDetailVC.type = type
                    historyDetailVC.transactionId = cell.transactionId
                    self.navigationController?.show(historyDetailVC, sender: nil)
                }
            }
        }
    }
    
    
}
