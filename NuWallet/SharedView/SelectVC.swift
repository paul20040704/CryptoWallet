//
//  SelectVC.swift
//  CryptoWallet
//
//  Created by Fanglin Hsu on 2022/4/16.
//

import UIKit

protocol SelectDelegate {
    func updateOption(tag: Int,condition: String)
}

class SelectVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    var selectArr = [""]
    var tag = 0
    var page = 1
    var delegate: SelectDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        self.modalPresentationStyle = .custom
        setUI()
        calculateHeight()
    }
    
    func setUI() {
        switch page {
        case 1:
            switch tag {
            case 0:
                titleLabel.text = "nationality_placeholder".localized
            case 1:
                titleLabel.text = "residence_placeholder".localized
            case 2:
                titleLabel.text = "gender_placeholder".localized
            default:
                break
            }
        case 2:
            switch tag {
            case 0:
                titleLabel.text = "employment_status_placeholder".localized
            case 1:
                titleLabel.text = "industry_placeholder".localized
            case 2:
                titleLabel.text = "total_annual_income_placeholder".localized
            case 3:
                titleLabel.text = "source_of_funds_placeholder".localized
            default:
                break
            }
        case 3:
            titleLabel.text = "type_of_certificate".localized
        case 4:
            titleLabel.text = "Choose coin’s sort options"
        case 5:
            titleLabel.text = "language_choose".localized
        case 6:
            titleLabel.text = "Choose your area code"
        case 7:
            titleLabel.text = "address_type_placeholder".localized
        default:
            break
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFromSv))
        bgView.addGestureRecognizer(tap)
    }
    
    func calculateHeight() {
        let count = selectArr.count
        if count > 6 {
            tableViewHeight.constant = CGFloat(450)
        }else{
            tableViewHeight.constant = CGFloat(70 + (count * 60))
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectCell", for: indexPath) as! SelectCell
        cell.selectLabel.text = selectArr[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (page == 6){
            tag = indexPath.row
        }
        self.delegate?.updateOption(tag: tag, condition: selectArr[indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissFromSv(){
        self.dismiss(animated: true, completion: nil)
    }
    
}

