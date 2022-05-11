//
//  InviteListVC.swift
//  NuWallet
//
//  Created by paul.chen-mini on 2022/4/28.
//

import UIKit


class InviteListVC: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var invitationsArr: [DataResponse]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "invitation_list".localized
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        getInvitations()
    }
    
    func getInvitations() {
        BN.getInvitations { statusCode, dataObj, err in
            if (statusCode == 200) {
                if let objArr = dataObj?.data {
                    self.invitationsArr = objArr
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    

}

extension InviteListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invitationsArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InviteListCell", for: indexPath) as! InviteListCell
        if let info = invitationsArr?[indexPath.row] {
            cell.mobileLabel.text = info.mobile
            cell.dateLabel.text = info.date
            return cell
        }else{
            return cell
        }
    }
    
    
}
