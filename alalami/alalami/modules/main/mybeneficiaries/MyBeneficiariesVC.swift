//
//  MyBeneficiariesVC.swift
//  alalami
//
//  Created by Zaid Khaled on 10/27/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit

class MyBeneficiariesVC: BaseVC, UITableViewDelegate, UITableViewDataSource  {
    
    //shortname
    @IBOutlet weak var lblShortName: MyUILabel!
    
    @IBOutlet weak var lblBeneficiariesCount: MyUILabel!
    
    //notifications
    @IBOutlet weak var cvCount: CardView!
    @IBOutlet weak var lblCount: UILabel!
    
    //search
    @IBOutlet weak var cvSearch: CardView!
    @IBOutlet weak var fieldSearch: MyUITextField!
    
    @IBOutlet weak var tableView: UITableView!
    var items = [MyBeneficiaryDatum]()
    
    //emptyView
    @IBOutlet weak var viewEmpty: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fieldSearch.delegate = self
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        
        self.loadBeneficiaries()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshNotifications), name: NSNotification.Name(rawValue: "notificationsCountShouldRefresh"), object: nil)
    }
    
    @objc private func refreshNotifications() {
        validateNotificationsCount()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.lblShortName.text = getUserShortName()
        validateNotificationsCount()
    }
    
    func validateNotificationsCount() {
        let count = UserDefaults.standard.value(forKey: Constants.DEFAULT_KEYS.NOTIFICATION_COUNT) as? Int ?? 0
        if (count > 0) {
            self.cvCount.isHidden = false
            self.lblCount.text = "\(count)"
        }else {
            self.cvCount.isHidden = true
        }
    }
    
    func loadBeneficiaries() {
        self.viewEmpty.isHidden = true
        self.tableView.isHidden = true
        self.showLoading()
        self.getApiManager().getMyBeneficiaries(token: self.getAccessToken()) { (response) in
            self.hideLoading()
            self.items.removeAll()
            self.items.append(contentsOf: response.data ?? [MyBeneficiaryDatum]())
            self.lblBeneficiariesCount.text = "\(self.items.count) \("active_members".localized)"
            self.reloadTableData()
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
        
        cell.ivChecked.isHidden = true
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    @IBAction func addNewBeneficiaryAction(_ sender: Any) {
        let vc : AddNewMyBeneficiaryVC = self.getStoryBoard(name: Constants.STORYBOARDS.main).instantiateViewController(withIdentifier: "AddNewMyBeneficiaryVC") as! AddNewMyBeneficiaryVC
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
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
    
    @IBAction func profileAction(_ sender: Any) {
        self.openProfileScreen()
    }
    
    
    @IBAction func notificationsAction(_ sender: Any) {
        self.openNotificationsScreen()
    }
    
}

extension MyBeneficiariesVC : AddNewMyBeneficiaryDelegate {
    func didAdd() {
        self.loadBeneficiaries()
    }
}

extension MyBeneficiariesVC : UITextFieldDelegate {
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


