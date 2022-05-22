//
//  afs_ReceiverInfoVC.swift
//  alalami
//
//  Created by Zaid Khaled on 9/13/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit

class afs_ReceiverInfoVC: BaseVC, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblBeneficiariesCount: MyUILabel!
    
    //search
    @IBOutlet weak var cvSearch: CardView!
    @IBOutlet weak var fieldSearch: MyUITextField!
    
    @IBOutlet weak var tableView: UITableView!
    var items = [BeneficiaryDatum]()
    
    //emptyView
    @IBOutlet weak var viewEmpty: UIView!
    
    //action
    @IBOutlet weak var cvContinue: CardView!
    @IBOutlet weak var btnContinue: MyUIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (isArabic()) {
            btnBack.setImage(UIImage(named: "ic_back_ar"), for: .normal)
        }
        
        self.fieldSearch.delegate = self
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.loadBeneficiaries()
    }
    
    
    func loadBeneficiaries() {
        self.viewEmpty.isHidden = true
        self.tableView.isHidden = true
        self.showLoading()
        self.getApiManager().getBeneficiaries(token: self.getAccessToken()) { (response) in
            self.hideLoading()
            
            
            if response.success == false {
                self.handleError(code: response.code, message: response.message ?? ["Something Wrong"])

            }else{
                self.items.removeAll()
                self.items.append(contentsOf: response.data ?? [BeneficiaryDatum]())
                self.reloadTableData()

            }
            

        }
    }
    
    //tableview delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = self.items[indexPath.row]
        
        let cell: BeneficiaryCell = tableView.dequeueReusableCell(withIdentifier: "BeneficiaryCell", for: indexPath as IndexPath) as! BeneficiaryCell
        
        cell.lblName.text = "\(item.firstNameEn ?? "") \(item.lastNameEn ?? "")"
        cell.lblPhone.text = item.mobile ?? ""
        
        var shortName = ""
        let firstChar = item.firstNameEn?.prefix(1)
        let secondChar = item.lastNameEn?.prefix(1)
        shortName = "\(firstChar ?? "")\(secondChar ?? "")"
        cell.lblShortName.text = shortName.uppercased()
        
        if (item.isChecked ?? false) {
            cell.ivChecked.isHidden = false
        }else {
            cell.ivChecked.isHidden = true
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCheck = self.items[indexPath.row].isChecked ?? false
        for beneficiary in self.items {
            beneficiary.isChecked = false
        }
        self.items[indexPath.row].isChecked = !(currentCheck)
        self.tableView.reloadData()
        self.validateFields()
    }
    
    func validate() -> Bool {
        let selectedBeneficiary = self.items.filter { (bene) -> Bool in
            bene.isChecked ?? false == true
        }
        if (selectedBeneficiary.count == 0) {
            return false
        }
        return true
    }
    
    func validateFields() {
        let selectedBeneficiary = self.items.filter { (bene) -> Bool in
            bene.isChecked ?? false == true
        }
        if (selectedBeneficiary.count == 0) {
            self.enableNext(flag: false)
            return
        }
        self.enableNext(flag: true)
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
    
    //--------
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addNewBeneficiaryAction(_ sender: Any) {
        let vc : AddNewBenefeciaryVC = self.getStoryBoard(name: Constants.STORYBOARDS.afs).instantiateViewController(withIdentifier: "AddNewBenefeciaryVC") as! AddNewBenefeciaryVC
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func fillData() {
        let selectedBeneficiary = self.items.filter { (bene) -> Bool in
            bene.isChecked ?? false == true
        }
        App.shared.sendMoneyAFS?.selectedBeneficiary = selectedBeneficiary[0]
    }
    
    @IBAction func continueAction(_ sender: Any) {
        if (self.validate()) {
            self.fillData()
            self.pushVC(name: "afs_PayMethodVC", sb: Constants.STORYBOARDS.afs)
        }
    }
    
    func reloadTableData() {
        if (self.items.count > 0) {
            self.viewEmpty.isHidden = true
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }else {
            self.viewEmpty.isHidden = false
            self.tableView.isHidden = true
        }
    }
    
    @IBAction func goToHome(_ sender: Any) {
        goHomeWithConfirmation()
    }
    
}

extension afs_ReceiverInfoVC : AddBeneficiaryDelegate {
    func didAddBeneficiary(beneficiary: BeneficiaryDatum) {
        for bene in self.items {
            bene.isChecked = false
        }
        beneficiary.isChecked = true
        self.items.insert(beneficiary, at: 0)
        self.reloadTableData()
        self.enableNext(flag: true)
    }
}

extension afs_ReceiverInfoVC : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == self.fieldSearch) {
            self.cvSearch.backgroundColor = UIColor.card_focused_color
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == self.fieldSearch) {
            self.cvSearch.backgroundColor = UIColor.card_color
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == self.fieldSearch) {
            self.fieldSearch.resignFirstResponder()
        }
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if textField == self.fieldSearch {
            let maxLength = 30
            let currentString: NSString = textField.text as NSString? ?? ""
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            if (newString.length >= 1) {
                let arr = self.items.filter {
                    ($0.firstNameEn?.lowercased().contains(newString.lowercased) ?? false) || ($0.lastNameEn?.lowercased().contains(newString.lowercased) ?? false)
                }
                self.items.removeAll()
                self.items.append(contentsOf: arr)
                self.tableView.reloadData()
            }else {
                self.loadBeneficiaries()
            }
            return newString.length <= maxLength
        }
        
        return false
    }
    
}
