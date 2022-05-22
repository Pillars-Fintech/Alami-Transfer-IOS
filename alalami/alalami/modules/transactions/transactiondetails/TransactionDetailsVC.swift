//
//  TransactionDetailsVC.swift
//  alalami
//
//  Created by Zaid Khaled on 9/30/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit
import Sheeeeeeeeet

class TransactionDetailsVC: BaseVC, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var btnBack: UIButton!
    
    //tabs
    @IBOutlet weak var btnTab1: MyUIButton!
    @IBOutlet weak var viewTab1: CardView!
    
    @IBOutlet weak var btnTab2: MyUIButton!
    @IBOutlet weak var viewTab2: CardView!
    
    var selectedTab = 1
    
    //view card
    @IBOutlet weak var viewCard: CardView!
    @IBOutlet weak var lblCardTitle: MyUILabel!
    @IBOutlet weak var lblCardNumber: MyUILabel!
    @IBOutlet weak var lblCardDate: MyUILabel!
    
    //rejection reasons
    var reasons = [RejectionReasonDatum]()
    
    //table
    @IBOutlet weak var tableView: UITableView!
    
    
    //actions
    @IBOutlet weak var stackActions: UIStackView!
    @IBOutlet weak var stackActionsHeight: NSLayoutConstraint!
    
    @IBOutlet weak var viewCancel: CardView!
    @IBOutlet weak var viewAmend: CardView!

    //50
    
    
    var transactionId : String?
    var remittanceData : RemDetailsClass?
    
    var itemsTab1 = [DetialsTab]()
    var itemsTab2 = [DetialsTab]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (isArabic()) {
            btnBack.setImage(UIImage(named: "ic_back_ar"), for: .normal)
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        loadRemittanceApi()
        
    }
    
    private func loadRemittanceApi() {
        self.showLoading()
        getApiManager().getRemittanceById(token: getAccessToken(), remId: self.transactionId ?? "") { (response) in
            self.hideLoading()
            
            
            if response.success == false{
                
                self.handleError(code: response.code, message: response.message ?? ["Something Wrong"])
            }else{
                
                let data = response.data
                self.remittanceData = data
                
                //handle actions
                let canCancel = data?.CanBeCancel ?? false
                let canAmend = data?.CanBeAmended ?? false
                
                if (canCancel == false && canAmend == false) {
                    self.showActions(show: false)
                }else {
                    self.showActions(show: true)
                }
                
                self.viewCancel.isHidden = !canCancel
                self.viewAmend.isHidden = !canAmend
                
                
                //handle tabs
                self.btnTab1.setTitle(data?.tapTitel1 ?? "", for: .normal)
                self.btnTab2.setTitle(data?.tapTitel2 ?? "", for: .normal)
                
                //list items
                self.itemsTab1.append(contentsOf: data?.detialsTab1 ?? [DetialsTab]())
                self.itemsTab2.append(contentsOf: data?.detialsTab2 ?? [DetialsTab]())
                
                //handle inner cards
                self.tab1UI()
                

            }
            

            
        }
    }
    
    //tableview delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (selectedTab == 1) {
            return self.itemsTab1.count
        }else {
            return self.itemsTab2.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: TransactionDetailCell = tableView.dequeueReusableCell(withIdentifier: "TransactionDetailCell", for: indexPath as IndexPath) as! TransactionDetailCell
        
        if (selectedTab == 1) {
            let detail = self.itemsTab1[indexPath.row]
            cell.lblTitle.text = detail.caption ?? ""
            cell.lblValue.text = detail.value ?? ""
            
            if let iconUrl = URL(string: "\(Constants.IMAGE_URL)\(detail.icon ?? "")") {
                cell.ivLogo.isHidden = false
                cell.ivLogo.kf.setImage(with: iconUrl)
            }else {
                cell.ivLogo.isHidden = true
            }
        }else {
            let detail = self.itemsTab2[indexPath.row]
            cell.lblTitle.text = detail.caption ?? ""
            cell.lblValue.text = detail.value ?? ""
            
            if let iconUrl = URL(string: "\(Constants.IMAGE_URL)\(detail.icon ?? "")") {
                cell.ivLogo.isHidden = false
                cell.ivLogo.kf.setImage(with: iconUrl)
            }else {
                cell.ivLogo.isHidden = true
            }
        }
        
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func takeScreenshotAction(_ sender: Any) {
        let _ = self.takeScreenshot()
    }
    
    
    func tab1UI() {
        self.selectedTab = 1
        self.btnTab1.setTitleColor(UIColor.text_dark, for: .normal)
        self.btnTab2.setTitleColor(UIColor.text_gray, for: .normal)
        self.viewTab1.isHidden = false
        self.viewTab2.isHidden = true
        
        self.viewCard.isHidden = false
        self.lblCardTitle.text = self.remittanceData?.cardTitel1 ?? ""
        self.lblCardNumber.text = self.remittanceData?.remittanceNumber ?? ""
        self.lblCardDate.text = self.getStringDateWithFormat(dateStr: self.remittanceData?.transactionDate ?? "", outputFormat: Constants.DATE_FORMATS.EEEE_MMM_d_yyyy)
        
        tableView.reloadData()
    }
    
    func tab2UI() {
        self.selectedTab = 2
        self.btnTab2.setTitleColor(UIColor.text_dark, for: .normal)
        self.btnTab1.setTitleColor(UIColor.text_gray, for: .normal)
        self.viewTab2.isHidden = false
        self.viewTab1.isHidden = true
        
        self.viewCard.isHidden = false
        self.lblCardTitle.text = self.remittanceData?.cardTitel2 ?? ""
        self.lblCardNumber.text = self.remittanceData?.remittanceNumber ?? ""
        self.lblCardDate.text = self.getStringDateWithFormat(dateStr: self.remittanceData?.transactionDate ?? "", outputFormat: Constants.DATE_FORMATS.EEEE_MMM_d_yyyy)
        
        tableView.reloadData()
    }
    
    @IBAction func tab1Action(_ sender: Any) {
        self.tab1UI()
    }
    
    @IBAction func tab2Action(_ sender: Any) {
        self.tab2UI()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.showAlert(title: "alert".localized, message: "confirm_cancel_remittance".localized, actionTitle: "yes".localized, cancelTitle: "no".localized, actionHandler: {
            self.loadRejectionReasonsApi()
        })
    }
    
    private func showRejectionReasonsSheet() {
        var items = [MenuItem]()
        for reason in self.reasons {
            var title = reason.caption ?? ""
            if (title.count == 0) {
                title = "---"
            }
            let item = MenuItem(title: title, value: reason.value ?? "", image: UIImage(named: "ic_indicator"))
            items.append(item)
        }
        let menu = Menu(title: "select_rejection_reason".localized, items: items)
        
        let sheet = menu.toActionSheet { (ActionSheet, item) in
            if let value = item.value as? String {
                let reasons = self.reasons.filter { (loc) -> Bool in
                    loc.value == value
                }
                if(reasons.count > 0) {
                    self.cancelApi(reasonId: reasons[0].value ?? "")
                }
            }
        }
        
        sheet.present(in: self, from: self.view)
    }
    
    func loadRejectionReasonsApi() {
        var isSend = false
        if (self.remittanceData?.isSend ?? false) {
            isSend = true
        }
        self.showLoading()
        getApiManager().getRejectionReasons(token: getAccessToken(), remittanceId: self.transactionId ?? "", isSend: isSend, isCancel: true) { (response) in
            self.hideLoading()
            self.reasons.removeAll()
            self.reasons.append(contentsOf: response.data ?? [RejectionReasonDatum]())
            self.showRejectionReasonsSheet()
        }
    }
    
    func cancelApi(reasonId : String) {
        var isSend = false
        if (self.remittanceData?.isSend ?? false) {
            isSend = true
        }
        self.showLoading()
        self.getApiManager().cancelRequest(token: getAccessToken(), remittanceId: self.transactionId ?? "", reasonId: reasonId, isSend: isSend) { (response) in
            self.hideLoading()
            if (response.success ?? false) {
                var message = ""
                for item in response.data ?? [AddBeneDatum]() {
                    message = "\(message).\n\(item.caption ?? "") : \(item.value ?? "")"
                }
                self.showSuccessAlert(message: message)
            }else {
                self.handleError(code: response.code, message: response.message)
            }
        }
    }
    
    func showSuccessAlert(message : String) {
        showAlert(title: "alert".localized, message: message, buttonText: "ok".localized) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func requestAmendment(_ sender: Any) {
        loadTransactionDetails(id: self.transactionId ?? "")
    }
    
    func openAmendRequestScreen(transaction : TransactionDatum?) {
        let vc : AmendmentVC = self.getStoryBoard(name: Constants.STORYBOARDS.transactions).instantiateViewController(withIdentifier: "AmendmentVC") as! AmendmentVC
        vc.delegate = self
        vc.transaction = transaction
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func loadTransactionDetails(id : String) {
        self.showLoading()
        getApiManager().getTransactionDetails(token: getAccessToken(), transactionId: id) { (response) in
            self.hideLoading()
            if (response.success ?? false) {
                self.openAmendRequestScreen(transaction: response.data)
            }else {
                self.handleError(code: response.code, message: response.message)
            }
        }
    }
    
    func showActions(show : Bool) {
        if (show) {
            self.stackActions.isHidden = false
            self.stackActionsHeight.constant = 50.0
        }else {
            self.stackActions.isHidden = true
            self.stackActionsHeight.constant = 0
        }
    }
}

extension TransactionDetailsVC : AmendmentDelegate {
    func didAmendRequest() {
        //do anything after amendment request
    }
}
