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
    
    var unreadKey = Array<Int>()
    var selectKey = Array<Int>()
    var notifyViewModel = NotifyViewModel()
    
    var isAllSelect = false
    
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
        
        readBtn.setBackgroundHorizontalGradient("1F892B", "11681B", "222222", paddingLeftRight: nil, paddingTopBottom: nil, borderWidth: nil, borderColorHex: nil, cornerRadius: self.readBtn.frame.height / 2)
        readBtn.addTarget(self, action: #selector(read), for: .touchUpInside)
    }

    @objc func allClick() {
        if !(selectAllBtn.isSelected) {
            isAllSelect = true
            selectKey = unreadKey
            selectAllBtn.isSelected = !(selectAllBtn.isSelected)
        }else{
            isAllSelect = false
            selectKey.removeAll()
            selectAllBtn.isSelected = !(selectAllBtn.isSelected)
        }
        tableView.reloadData()
    }
    
    @objc func read() {
        if selectKey.count > 0 {
            if let readArray = UD.object(forKey: "boardRead") as? Array<Int> {
                let newRead = readArray + selectKey
                UD.set(newRead, forKey: "boardRead")
            }
            let arr = self.navigationController?.viewControllers
            self.navigationController?.popToViewController(arr![1], animated: false)
        }
    }

}

extension NotifyEditVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return unreadKey.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NotifyEditCell", for: indexPath) as? NotifyEditCell {
            cell.updateSelect = { id, type in
                if type == 0 {
                    self.selectKey.append(id)
                }else{
                    self.selectKey = self.selectKey.filter{$0 != id}
                }
            }
            cell.selectKey = self.selectKey
            cell.setup(vm: notifyViewModel.notifyList[unreadKey[indexPath.row]] ?? BoardModel(id: 0, title: "", article: "", postOn: ""))
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    
}
