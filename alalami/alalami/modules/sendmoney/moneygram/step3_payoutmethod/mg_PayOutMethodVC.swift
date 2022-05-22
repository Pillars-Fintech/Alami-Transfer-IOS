//
//  mg_PayOutMethodVC.swift
//  alalami
//
//  Created by Zaid Khaled on 9/8/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit

class mg_PayOutMethodVC: BaseVC, UITableViewDelegate, UITableViewDataSource{
    
    
    
    
    
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var payreceved: MyUILabel!
    
    //action
    @IBOutlet weak var cvContinue: CardView!
    @IBOutlet weak var btnContinue: MyUIButton!
    
    
    var serviceOptions = [MoneyGramServiceOptionsDatum]()
    
    var sendModel : SendMoneyMGModel?
    
    
    var isSelected = -1
    var isCoolaspe = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        payreceved.text = "Pay Out Method".localized
        
        if (isArabic()) {
            btnBack.setImage(UIImage(named: "ic_back_ar"), for: .normal)
        }
        
        
        if (isArabic()) {
            payreceved.textAlignment = .right
            
        }else{
            payreceved.textAlignment = .left

        }
        
        

        
        
        self.tableView.estimatedRowHeight = CGFloat(240.0)
        self.tableView.rowHeight = UITableView.automaticDimension
        
        
        self.sendModel = App.shared.sendMoneyMG
        print(self.sendModel!)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.enableNext(flag: false)
        
        

        self.loadServiceOptions()
    }
    
    func loadServiceOptions() {
        self.showLoading()
        self.getApiManager().getMoneyGramServiceOptions(token: self.getAccessToken(), sendModel: App.shared.sendMoneyMG, AmountIncludingFee: self.sendModel?.amount ?? 0.0, ReceiveCountry: self.sendModel?.destinationCountry?.countryCode ?? "", payOptionId: App.shared.sendMoneyMG?.payInOption?.payMethodsResponseID ?? 0, promocode: App.shared.sendMoneyMG?.promotionCode ?? "", isSend: self.sendModel?.isSend ?? false) { (response) in
            self.hideLoading()
            if (response.success ?? false) {
                self.serviceOptions.removeAll()
                self.serviceOptions.append(contentsOf: response.data ?? [MoneyGramServiceOptionsDatum]())
                self.tableView.reloadData()
            }else {
                self.handleError(code : response.code ?? "", message : response.message)

//                self.navigationController?.popViewController(animated: true)

                
            }
            
        }
    }
    
    //tableview delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.serviceOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let serviceOption = self.serviceOptions[indexPath.row]
        
        let cell: PayOutServiceOptionCell = tableView.dequeueReusableCell(withIdentifier: "PayOutServiceOptionCell", for: indexPath as IndexPath) as! PayOutServiceOptionCell
        
        cell.setup(items: serviceOption.responseLists ?? [ResponseList]())
        
        if (serviceOption.isChecked ?? false) {
            cell.bgContainer.backgroundColor = UIColor.white
            cell.bgColor.backgroundColor = UIColor.highlight_blue
            cell.ivChecked.image = UIImage(named: "ic_option_checked")
        }else {
            cell.bgContainer.backgroundColor = UIColor.disabled
            cell.bgColor.backgroundColor = UIColor.disabled
            cell.ivChecked.image = UIImage(named: "ic_option_unchecked")
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let serviceOption = self.serviceOptions[indexPath.row]
//        let height = (serviceOption.responseLists?.count ?? 0) * 35
//        return CGFloat(height + 65)
        
        
        
                 if self.isSelected == indexPath.row && self.isCoolaspe == true{
                     return  CGFloat(420.0)
        
        
                 }else{
                     return CGFloat(140.0)
        
                 }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCheck = self.serviceOptions[indexPath.row].isChecked ?? false
        for serviceOption in self.serviceOptions {
            serviceOption.isChecked = false
        }
        self.serviceOptions[indexPath.row].isChecked = !(currentCheck)
        self.tableView.reloadData()
        self.validateFields()
        
        
        
        
        if self.isSelected == indexPath.row{
            
            
            if self.isCoolaspe == false{
                self.isCoolaspe = true
            }else{
                self.isCoolaspe = false
            }
            
            
            
            
        }else{
            self.isCoolaspe = true
        }


        isSelected = indexPath.row
        
        
        
    }
    
    //--------
    
    func validate() -> Bool {
        let selectedOption = self.serviceOptions.filter { (option) -> Bool in
            option.isChecked ?? false == true
        }
        if (selectedOption.count == 0) {
            self.showBanner(title: "alert".localized, message: "select_payout_option".localized, style: UIColor.INFO)
            return false
        }
        return true
    }
    
    
    func validateFields() {
        let selectedOption = self.serviceOptions.filter { (option) -> Bool in
            option.isChecked ?? false == true
        }
        if (selectedOption.count == 0) {
            self.enableNext(flag: false)
            return
        }
        self.enableNext(flag: true)
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueAction(_ sender: Any) {
        if (self.validate()) {
            self.fillData()
            self.pushVC(name: "mg_RemittanceDetailsVC", sb: Constants.STORYBOARDS.money_gram)
        }
    }
    
    @IBAction func goBackHome(_ sender: Any) {
        goHomeWithConfirmation()
    }
    
    func fillData() {
        if (App.shared.sendMoneyMG == nil) {
            App.shared.sendMoneyMG = SendMoneyMGModel()
        }
        let selectedOption = self.serviceOptions.filter { (option) -> Bool in
            option.isChecked ?? false == true
        }
        App.shared.sendMoneyMG?.selectedServiceOption = selectedOption[0]
    }
    
    func enableNext(flag : Bool) {
        if (flag) {
            self.cvContinue.backgroundColor = UIColor.enabled
            self.btnContinue.setTitleColor(UIColor.enabled_text, for: .normal)
            btnContinue.isEnabled = true
        }else {
            self.cvContinue.backgroundColor = UIColor.disabled
            self.btnContinue.setTitleColor(UIColor.disabled_text, for: .normal)
            if (Constants.SHOULD_DISABLE_BUTTON) {
                btnContinue.isEnabled = false
            }
        }
    }
}
