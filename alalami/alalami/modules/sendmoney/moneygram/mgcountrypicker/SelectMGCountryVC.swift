//
//  SelectMGCountryVC.swift
//  alalami
//
//  Created by Zaid Khaled on 9/24/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit

protocol MGCountryDelegate  {
    func didSelectCountry(country : MGCountryDatum)
}
class SelectMGCountryVC: BaseVC, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    //search
    @IBOutlet weak var cvSearch: CardView!
    @IBOutlet weak var fieldSearch: MyUITextField!
    
    var items = [MGCountryDatum]()
    var filteredItems = [MGCountryDatum]()
    
    var showSendCountries : Bool?
    
    var delegate : MGCountryDelegate?
    
    var isFilter: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fieldSearch.delegate = self
        
        self.tableView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadCountries()
    }
    
    func loadCountries() {
        if (self.showSendCountries ?? false) {
            self.showLoading()
            self.getApiManager().getMGSendCountries(token: self.getAccessToken()) { (response) in
                self.hideLoading()
                
                
                if response.success == false{
                    
                    print("response.message \(response.message)")
                    self.handleError(code: response.code, message: response.message)
                }else{
                    self.items.removeAll()
                    self.filteredItems.removeAll()
                    self.items.append(contentsOf: response.data ?? [MGCountryDatum]())
                    self.filteredItems.append(contentsOf: response.data ?? [MGCountryDatum]())
                    self.tableView.reloadData()
                }

                

            }
        }else {
            
            self.showLoading()
            self.getApiManager().getMGCountries(token: self.getAccessToken()) { (response) in
             self.hideLoading()
                
                if response.success == false{
                    print("response.message \(response.message)")
                    self.handleError(code: response.code, message: response.message)
                }else{
                    self.items.removeAll()
                    self.filteredItems.removeAll()
                    self.items.append(contentsOf: response.data ?? [MGCountryDatum]())
                    self.filteredItems.append(contentsOf: response.data ?? [MGCountryDatum]())
                    self.tableView.reloadData()
                }
        
                


            }
            
//
//            print("response.message \(response.message)")
//            self.handleError(code: response.code, message: response.message)
        }
    }
    
    //tableview delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (isFilter) {
            return self.filteredItems.count
        }else {
            return self.items.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (isFilter) {
            let item = self.filteredItems[indexPath.row]
            
            let cell: CountryCell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath as IndexPath) as! CountryCell
            
            cell.lblTitle.text = item.countryName ?? ""
            if (self.isArabic()) {
                cell.ivIndicator.image = UIImage(named: "ic_indicator_ar")
                cell.lblTitle.textAlignment = .right
            }else {
                cell.ivIndicator.image = UIImage(named: "ic_indicator")
                cell.lblTitle.textAlignment = .left

            }
            
            let url = URL(string: "\(Constants.IMAGE_URL)\(item.flag ??  "")")
            cell.ivFlag.kf.setImage(with: url, placeholder: UIImage(named: ""))
            
            return cell
        }else {
            let item = self.items[indexPath.row]
            
            let cell: CountryCell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath as IndexPath) as! CountryCell
            
            cell.lblTitle.text = item.countryName ?? ""
            if (self.isArabic()) {
                cell.ivIndicator.image = UIImage(named: "ic_indicator_ar")
                cell.lblTitle.textAlignment = .right

            }else {
                cell.ivIndicator.image = UIImage(named: "ic_indicator")
                cell.lblTitle.textAlignment = .left

            }
            
            let url = URL(string: "\(Constants.IMAGE_URL)\(item.flag ??  "")")
            cell.ivFlag.kf.setImage(with: url, placeholder: UIImage(named: ""))
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (isFilter) {
            let item = self.filteredItems[indexPath.row]
            self.delegate?.didSelectCountry(country: item)
            self.dismiss(animated: true, completion: nil)
        }else {
            let item = self.items[indexPath.row]
            self.delegate?.didSelectCountry(country: item)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension SelectMGCountryVC : UITextFieldDelegate {
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
                self.isFilter = true
                let arr = self.items.filter {
                    ($0.countryName?.lowercased().contains(newString.lowercased) ?? false)
                }
                self.filteredItems.removeAll()
                self.filteredItems.append(contentsOf: arr)
                self.tableView.reloadData()
            }else {
                self.isFilter = false
                self.loadCountries()
            }
            return newString.length <= maxLength
        }
        
        return false
    }
    
    
}

