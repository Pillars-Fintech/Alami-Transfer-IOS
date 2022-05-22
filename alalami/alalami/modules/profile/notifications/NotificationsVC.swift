//
//  NotificationsVC.swift
//  alalami
//
//  Created by Zaid Khaled on 10/28/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit

class NotificationsVC: BaseVC, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lblScreenTitle: MyUILabel!
    
    var type : Int?
    var screenTitle : String?
    
    var items = [NotificationDatum]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (isArabic()) {
            btnBack.setImage(UIImage(named: "ic_back_ar"), for: .normal)
        }
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100.0
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setScreenTitle()
        
        loadNotificationsApi()
        
    }
    
    private func loadNotificationsApi() {
        self.showLoading()
        getApiManager().getNotifications(token: getAccessToken()) { (response) in
            self.hideLoading()
            
            if response.success == false {
                self.handleError(code: response.code, message: response.message ?? ["Something Wrong"])
                
            }else{
                let apiItems = response.data ?? [NotificationDatum]()
                let filteredItems = apiItems.filter { (item) -> Bool in
                    item.notifactionType ?? 0 == self.type ?? 0
                }
                self.items.removeAll()
                self.items.append(contentsOf: filteredItems)
                self.tableView.reloadData()
                

            }
            
   
        }
    }
    
    
    private func setScreenTitle() {
        switch type {
        case Constants.NOTIFICATION_TYPES.send:
            lblScreenTitle.text = "send_notifications".localized
            break
        case Constants.NOTIFICATION_TYPES.receive:
            lblScreenTitle.text = "receive_notifications".localized
            break
        case Constants.NOTIFICATION_TYPES.profile:
            lblScreenTitle.text = "profile_notifications".localized
            break
        case Constants.NOTIFICATION_TYPES.general:
            lblScreenTitle.text = "general_notifications".localized
            break
        default:
            lblScreenTitle.text = "notifications".localized
            break
        }
    }
    
    //tableview delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = self.items[indexPath.row]
        
        let cell: NotificationCell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath as IndexPath) as! NotificationCell
        
        if (self.isArabic()) {
            cell.lblTitle.text = item.titleAr ?? ""
            cell.lblDesc.text = item.descriptionAr ?? ""
        }else {
            cell.lblTitle.text = item.titleEn ?? ""
            cell.lblDesc.text = item.descriptionEn ?? ""
        }
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.items[indexPath.row]
        switch  item.notifactionType {
        case Constants.NOTIFICATION_TYPES.send:
            if (item.sourceId?.count ?? 0 > 0) {
                loadTransactionDetails(id: item.sourceId ?? "")
            }
            break
        case Constants.NOTIFICATION_TYPES.receive:
            if (item.sourceId?.count ?? 0 > 0) {
                loadTransactionDetails(id: item.sourceId ?? "")
            }
            break
        default:
            break
        }
    }
    
    private func loadTransactionDetails(id : String) {
        self.openRemittanceDetails(transactionId: id)
    }
    
    private func openRemittanceDetails(transactionId : String) {
        let vc : TransactionDetailsVC = self.getStoryBoard(name: Constants.STORYBOARDS.transactions).instantiateViewController(withIdentifier: "TransactionDetailsVC") as! TransactionDetailsVC
        vc.transactionId = transactionId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
