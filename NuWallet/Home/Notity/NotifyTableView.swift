//
//  NotifyTableView.swift
//  CryptoWallet
//
//  Created by SamLin on 2022/3/17.
//

import UIKit

class NotifyTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    
    var iNotifyViewController: NotifyViewController?
    
    override func awakeFromNib() {
        self.dataSource = self
        self.delegate = self
        self.contentInset = UIEdgeInsets.init(top: 15, left: 0, bottom: 15, right: 0)
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 14
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "notifyTableViewCell", for: indexPath) as? NotifyTableViewCell {
            
            cell.iNotifyTableView = self
            
            return cell
        } else {
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let notifyDetailViewController = UIStoryboard(name: "NotifyDetail", bundle: nil).instantiateViewController(withIdentifier: "notifyDetailViewController")
        iNotifyViewController?.iTabBarNavigationController?.pushViewController(notifyDetailViewController, animated: true)
        
    }
    
    

}
