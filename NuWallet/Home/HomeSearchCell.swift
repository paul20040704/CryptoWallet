//
//  HomeSearchCell.swift
//  CryptoWallet
//
//  Created by paul.chen-mini on 2022/4/22.
//

import UIKit

class HomeSearchCell: UITableViewCell {

    @IBOutlet weak var sortBtn: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var iHomeTableView: HomeTableView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        sortBtn.addTarget(self, action: #selector(sortClick), for: .touchUpInside)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        searchBar.delegate = iHomeTableView?.iHomeViewController
        // Configure the view for the selected state
    }

    @objc func sortClick() {
        let selectVC = UIStoryboard(name: "SelectVC", bundle: nil).instantiateViewController(withIdentifier: "SelectVC") as! SelectVC
        selectVC.tag = tag
        selectVC.page = 4
        selectVC.selectArr = ["coin_sort_1".localized,"coin_sort_2".localized,"coin_sort_3".localized,"coin_sort_4".localized]
        selectVC.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        selectVC.delegate = iHomeTableView?.iHomeViewController
        iHomeTableView?.iHomeViewController?.present(selectVC, animated: true, completion: nil)
    }
    
}

