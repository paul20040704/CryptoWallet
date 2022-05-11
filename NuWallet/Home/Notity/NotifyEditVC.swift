//
//  NotifyEditVC.swift
//  NuWallet
//
//  Created by paul.chen-mini on 2022/5/5.
//

import UIKit

class NotifyEditVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectAllBtn: UIButton!
    @IBOutlet weak var readBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setUI() {
        self.navigationItem.title = "Edit"
        selectAllBtn.setBackgroundImage(UIImage(named: "button_main_check1b"), for: .normal)
        selectAllBtn.setBackgroundImage(UIImage(named: "button_main_check2"), for: .selected)
        selectAllBtn.addTarget(self, action: #selector(allClick), for: .touchUpInside)
    }

    @objc func allClick() {
        selectAllBtn.isSelected = !(selectAllBtn.isSelected)
        tableView.reloadData()
    }

}

extension NotifyEditVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NotifyEditCell", for: indexPath) as? NotifyEditCell {
            if (selectAllBtn.isSelected) {
                cell.editBtn.isSelected = true
                return cell
            }else{
                cell.editBtn.isSelected = false
                return cell
            }
        } else {
            return UITableViewCell()
        }
    }
    
    
}
