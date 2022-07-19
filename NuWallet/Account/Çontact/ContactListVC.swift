//
//  ContactListVC.swift
//  NuWallet
//
//  Created by paul.chen-mini on 2022/5/13.
//

import UIKit
import PKHUD
import SupportSDK
import ZendeskCoreSDK

class ContactListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contactBtn: UIButton!
    
    var requests = [ZDKRequest]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        
        tableView.delegate = self
        tableView.dataSource = self
        setZendesk()
        HUD.show(.systemActivity, onView: self.tableView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getAllRequest()
    }
    
    func setUI() {
        self.navigationItem.backButtonTitle = ""
        contactBtn.addTarget(self, action: #selector(contactClick), for: .touchUpInside)
    }
    
    func getAllRequest() {
        ZDKRequestProvider().getAllRequests { zdkRequestsWithCommentingAgents, error in
            HUD.hide()
            if let zdkRequestsWithCommentingAgents = zdkRequestsWithCommentingAgents {
                self.requests = zdkRequestsWithCommentingAgents.requests
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    
    
    func setZendesk() {
        Zendesk.initialize(appId: "abe894f8b6b1e41b1ea9c1c69999fbe984834f28cd954ab6", clientId: "mobile_sdk_client_0b34ffd27549caa04666", zendeskUrl: "https://numiner.zendesk.com")
        Support.initialize(withZendesk: Zendesk.instance)
    
        if let data = UD.data(forKey: "token"), let token = try? PDecoder.decode(TokenResponse.self, from: data){

            let id = US.decodeTokenId(token: token.token)
            let identity = Identity.createJwt(token: id)
            Zendesk.instance?.setIdentity(identity)
        }
    
    }
    
    @objc func contactClick() {
        let contactVC = UIStoryboard(name: "Contact", bundle: nil).instantiateViewController(withIdentifier: "ContactVC") as! ContactVC
        self.navigationController?.show(contactVC, sender: nil)
    }

    

}

extension ContactListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactListCell", for: indexPath) as! ContactListCell
        let request = requests[indexPath.row]
        cell.titleLabel.text = request.subject ?? ""
        let date = request.updateAt
        cell.timeLabel.text = US.dateToStringMS(date: date)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let request = requests[indexPath.row]
        
        let chatVC = UIStoryboard(name: "Contact", bundle: nil).instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        chatVC.userId = String(request.requesterId.intValue)
        chatVC.requestId = request.requestId
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    
}
