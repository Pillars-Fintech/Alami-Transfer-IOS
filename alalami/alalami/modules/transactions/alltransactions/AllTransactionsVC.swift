//
//  AllTransactionsVC.swift
//  alalami
//
//  Created by Zaid Khaled on 9/27/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit

enum TransactionTabs {
    case sent
    case received
}
class AllTransactionsVC: BaseVC, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var btnBack: UIButton!
    
    //tabs
    var selectedTab : TransactionTabs = .sent
    
    @IBOutlet weak var viewSend: CardView!
    @IBOutlet weak var btnSend: MyUIButton!
    
    @IBOutlet weak var viewReceive: CardView!
    @IBOutlet weak var btnReceive: MyUIButton!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var sendFilter : TransactionsFilter?
    var receiveFilter : TransactionsFilter?
    
    var totalRows = 200
    var isloadingList : Bool = false
    
    var transactions = [TransactionDatum]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (isArabic()) {
            btnBack.setImage(UIImage(named: "ic_back_ar"), for: .normal)
        }
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 70.0
        
        tableView.delegate = self
        tableView.dataSource = self
        
        initSendFilter()
        initReceiveFilter()
        
        validateSelectedTab()
        
        loadSendTransactions()
        loadReceiveTransactions()
        
    }
    
    private func validateSelectedTab() {
        if (selectedTab == .sent) {
            viewSend.backgroundColor = UIColor.highlight_blue
            btnSend.setTitleColor(UIColor.white, for: .normal)
            viewReceive.backgroundColor = UIColor.white
            btnReceive.setTitleColor(UIColor.text_dark, for: .normal)
            
        }else {
            viewReceive.backgroundColor = UIColor.highlight_blue
            btnReceive.setTitleColor(UIColor.white, for: .normal)
            viewSend.backgroundColor = UIColor.white
            btnSend.setTitleColor(UIColor.text_dark, for: .normal)
            
        }
    }
    
    func initSendFilter() {
        sendFilter = TransactionsFilter()
        sendFilter?.PageNumber = 1
    }
    
    func initReceiveFilter() {
        receiveFilter = TransactionsFilter()
        receiveFilter?.PageNumber = 1
    }
    
    func loadSendTransactions() {
        self.showLoading()
        self.getApiManager().getAllTransactions(token: self.getAccessToken(), filter: self.sendFilter, tab : selectedTab) { (response) in
            self.hideLoading()
            if (response.success ?? false) {
                if (self.sendFilter?.PageNumber ?? 1 == 1) {
                    self.transactions.removeAll()
                }
                self.transactions.append(contentsOf: response.data ?? [TransactionDatum]())
                self.tableView.reloadData()

            }else {
                self.handleError(code: response.code, message: response.message)
            }
        }
    }
    
    func loadReceiveTransactions() {
        self.showLoading()
        self.getApiManager().getAllTransactions(token: self.getAccessToken(), filter: self.receiveFilter, tab : selectedTab) { (response) in
            self.hideLoading()
            if (response.success ?? false) {
                if (self.receiveFilter?.PageNumber ?? 1 == 1) {
                    self.transactions.removeAll()
                }
                self.transactions.append(contentsOf: response.data ?? [TransactionDatum]())
                self.tableView.reloadData()
            }else {
                self.handleError(code: response.code, message: response.message)
            }
        }
    }
    
    //tableview delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let transaction = self.transactions[indexPath.row]
        
        let cell: HomeTransactionCell = tableView.dequeueReusableCell(withIdentifier: "HomeTransactionCell", for: indexPath as IndexPath) as! HomeTransactionCell
        
        if (self.isArabic()) {
            cell.lblAmount.textAlignment = .left
            cell.lblStatus.textAlignment = .left
        }else {
            cell.lblAmount.textAlignment = .right
            cell.lblStatus.textAlignment = .right
        }
        
        if (selectedTab == .sent) {
            cell.lblName.text = "\(transaction.receiverFirstNameEn ?? "") \(transaction.receiverLastNameEn ?? "")"
            cell.ivType.image = UIImage(named: "ic_transaction_sent")
            
            cell.lblDateCountry.text = "\(self.getStringDateWithFormat(dateStr: transaction.insertDate ?? "", outputFormat: Constants.DATE_FORMATS.dd_mm_yyyy))"
            cell.lblAmount.text = "\(transaction.sendAmount ?? 0.0) \(transaction.sendAmountCurrency ?? "")"
            cell.lblStatus.text = transaction.remittanceStatusName ?? ""
            print("\(transaction.remittanceStatusName ?? "") : \(transaction.remittanceStatusID ?? 0)")
            
        }else {
            cell.lblName.text = transaction.senderFullName ?? ""
            cell.ivType.image = UIImage(named: "ic_transaction_received")
            
            cell.lblDateCountry.text = "\(self.getStringDateWithFormat(dateStr: transaction.insertDate ?? "", outputFormat: Constants.DATE_FORMATS.dd_mm_yyyy))"
            cell.lblAmount.text = "\(transaction.expectedAmount ?? 0.0) \(transaction.expectedAmountCurrency ?? "")"
            cell.lblStatus.text = transaction.remittanceStatusName ?? ""
            print("\(transaction.remittanceStatusName ?? "") : \(transaction.remittanceStatusID ?? 0)")
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc : TransactionDetailsVC = self.getStoryBoard(name: Constants.STORYBOARDS.transactions).instantiateViewController(withIdentifier: "TransactionDetailsVC") as! TransactionDetailsVC
        let transaction = self.transactions[indexPath.row]
        vc.transactionId = transaction.id ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //--------
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.transactions.count >= self.totalRows) {
            return
        }
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height) && !self.isloadingList){
            self.isloadingList = true
            self.loadMoreItemsForList()
        }
    }
    
    func loadMoreItemsForList() {
        if (selectedTab == .sent) {
            let currentPageNumber = self.sendFilter?.PageNumber ?? 1
            self.sendFilter?.PageNumber =  currentPageNumber + 1
            self.loadSendTransactions()
        }else {
            let currentPageNumber = self.receiveFilter?.PageNumber ?? 1
            self.receiveFilter?.PageNumber =  currentPageNumber + 1
            self.loadReceiveTransactions()
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func filterAction(_ sender: Any) {
        let vc : FilterVC = self.getStoryBoard(name: Constants.STORYBOARDS.transactions).instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
        if (selectedTab == .sent) {
            vc.filter = self.sendFilter
        }else {
            vc.filter = self.receiveFilter
        }
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func sendTabAction(_ sender: Any) {
        sendFilter?.PageNumber = 1
        selectedTab = .sent
        validateSelectedTab()
        loadSendTransactions()
    }
    
    @IBAction func receiveTabAction(_ sender: Any) {
        receiveFilter?.PageNumber = 1
        selectedTab = .received
        validateSelectedTab()
        loadReceiveTransactions()
    }
    
}

extension AllTransactionsVC : TransactionFilterDelegate {
    func onApply(filter: TransactionsFilter?) {
        if (self.selectedTab == .sent) {
            self.initSendFilter()
            self.sendFilter = filter
            self.loadSendTransactions()
        }else {
            self.initReceiveFilter()
            self.receiveFilter = filter
            self.loadReceiveTransactions()
        }
    }
    func onClear() {
        if (self.selectedTab == .sent) {
            self.initSendFilter()
            self.loadSendTransactions()
        }else {
            self.initReceiveFilter()
            self.loadReceiveTransactions()
        }
    }
}
