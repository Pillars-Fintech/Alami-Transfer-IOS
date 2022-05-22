//
//  SelectCountryVC.swift
//  alalami
//
//  Created by Zaid Khaled on 8/31/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit

protocol CountryDelegate  {
    func didSelectCountry(country : CountryDatum)
}
class SelectCountryVC: BaseVC, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    //search
    @IBOutlet weak var cvSearch: CardView!
    @IBOutlet weak var fieldSearch: MyUITextField!
    
    var isFilter: Bool = false
    
    var onlyJordan: Bool?
    
    var items = [CountryDatum]()
    var filteredItems = [CountryDatum]()
    
    var delegate : CountryDelegate?
    
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
        self.showLoading()
        self.getApiManager().getCountries { (response) in
            self.hideLoading()
            
            
            if  response.success == false {
                
                self.handleError(code: response.code, message: response.message ?? ["Somthing Wrong"])
                
            }else{

                
                self.items.removeAll()
                self.filteredItems.removeAll()
                if (self.onlyJordan ?? false) {
                    let responseArr = response.data ?? [CountryDatum]()
                    self.items.append(contentsOf: responseArr.filter({ (countryDatum) -> Bool in
                        ((countryDatum.name?.lowercased().contains(find: "jordan") ?? false) || (countryDatum.name?.lowercased().contains(find: "اردن") ?? false))
                    }))
                    self.filteredItems.append(contentsOf: responseArr.filter({ (countryDatum) -> Bool in
                        ((countryDatum.name?.lowercased().contains(find: "jordan") ?? false) || (countryDatum.name?.lowercased().contains(find: "اردن") ?? false))
                    }))
                }else {
                    self.filteredItems.append(contentsOf: response.data ?? [CountryDatum]())
                    self.items.append(contentsOf: response.data ?? [CountryDatum]())
                }
                self.tableView.reloadData()
                
//                self.handleError(code: response.code, message: response.message ?? ["Somthing Wrong"])

            }
            
            

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
        
        
        
        if (self.isFilter)  {
            let item = self.filteredItems[indexPath.row]
            
            let cell: CountryCell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath as IndexPath) as! CountryCell
            
            cell.lblTitle.text = item.name ?? ""
            
            if(isArabic()){
                cell.lblTitle.textAlignment = .right

            }else{
                cell.lblTitle.textAlignment = .left

            }
            
            if (self.isArabic()) {
                cell.ivIndicator.image = UIImage(named: "ic_indicator_ar")

            }else {
                cell.ivIndicator.image = UIImage(named: "ic_indicator")


            }
            
            let url = URL(string: "\(Constants.IMAGE_URL)\(item.flag ??  "")")
            cell.ivFlag.kf.setImage(with: url, placeholder: UIImage(named: ""))
            
            return cell
        }else {
            let item = self.items[indexPath.row]
            
            
            
            let cell: CountryCell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath as IndexPath) as! CountryCell
            
            
            if(isArabic()){
                cell.lblTitle.textAlignment = .right

            }else{
                cell.lblTitle.textAlignment = .left

            }
            
            
            cell.lblTitle.text = item.name ?? ""
            if (self.isArabic()) {
                cell.ivIndicator.image = UIImage(named: "ic_indicator_ar")

            }else {
                cell.ivIndicator.image = UIImage(named: "ic_indicator")
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

extension SelectCountryVC : UITextFieldDelegate {
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
                    ($0.name?.lowercased().contains(newString.lowercased) ?? false)
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
