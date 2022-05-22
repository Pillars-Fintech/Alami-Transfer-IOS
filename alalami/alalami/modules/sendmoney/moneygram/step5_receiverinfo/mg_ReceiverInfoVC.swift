//
//  mg_ReceiverInfoVC.swift
//  alalami
//
//  Created by Zaid Khaled on 9/9/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit

protocol ValidateDynamicProtocol {
    func validateFieldsTriggered()
}
class mg_ReceiverInfoVC: BaseVC, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    //action
    @IBOutlet weak var cvContinue: CardView!
    @IBOutlet weak var btnContinue: MyUIButton!
    
    //beneficiaries
    @IBOutlet weak var collectionBeneficiaries: UICollectionView!
    @IBOutlet weak var btnClearBeneficiary: UIButton!
    var beneficiaries = [MGBeneficiaryDatum]()
    
    
    var cells = [UITableViewCell]()
    var dynamicFields = [DynamicFieldDatum]()
    
    var dynamicFieldsResponse = [DynamicFieldsResponse]()
    
    //countries
    var countries = [MGCountryDatum]()
    
    var beneFirsName = ""
    var beneSecondName = ""
    var beneThirdName = ""
    var beneLastName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (isArabic()) {
            btnBack.setImage(UIImage(named: "ic_back_ar"), for: .normal)
        }
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 95.0
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.collectionBeneficiaries.delegate = self
        self.collectionBeneficiaries.dataSource = self
        
        self.loadCountries()
        loadBeneficiaries()
        
    }
    
    
    
    
    func loadBeneficiaries(){
        getApiManager().getMGBeneficiaries(token: getAccessToken(), countryId: App.shared.sendMoneyMG?.destinationCountry?.countryId ?? "") { (response) in
            self.beneficiaries.removeAll()
            self.beneficiaries.append(contentsOf: response.data ?? [MGBeneficiaryDatum]())
            let filterdArray = self.beneficiaries.removeDuplicates()
            self.beneficiaries = filterdArray
            self.collectionBeneficiaries.reloadData()
            
            
           
//            print("success \(response.success)")
//            print("message \(response.message)")
//            print("code \(response.code)")
//            print("data \(response.data)")

        }
    }
    
    
    
    
    //collectionview delegates
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.beneficiaries.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : ReceiverBeneficiaryCell = self.collectionBeneficiaries.dequeueReusableCell(withReuseIdentifier:"ReceiverBeneficiaryCell", for: indexPath) as! ReceiverBeneficiaryCell
        
        let item = self.beneficiaries[indexPath.row]
        
        var shortName = ""
        let firstChar = item.firstNameEn?.prefix(1)
        let secondChar = item.lastNameEn?.prefix(1)
        shortName = "\(firstChar ?? "")\(secondChar ?? "")"
        cell.lblShortName.text = shortName.uppercased()
        
        if (item.isChecked ?? false) {
            cell.bgColor.backgroundColor = UIColor.highlight_blue
            cell.lblShortName.textColor = UIColor.white
        }else {
            cell.bgColor.backgroundColor = UIColor.white
            cell.lblShortName.textColor = UIColor.highlight_blue
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50.0, height: 50.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentCheck = self.beneficiaries[indexPath.row].isChecked ?? false
        for bene in beneficiaries {
            bene.isChecked = false
        }
        beneficiaries[indexPath.row].isChecked = !currentCheck
        collectionBeneficiaries.reloadData()
        loadDynamicFields()
        if (beneficiaries[indexPath.row].isChecked ?? false) {
            self.showAlert(title: "\(beneficiaries[indexPath.row].firstNameEn ?? "") \(beneficiaries[indexPath.row].lastNameEn ?? "")", message: "\(beneficiaries[indexPath.row].mobile ?? "")\n\("confirm_receiver_name".localized)")
        }
    }
    
    func loadCountries() {
        self.showLoading()
        self.getApiManager().getMGCountries(token: self.getAccessToken()) { (response) in
            self.hideLoading()
            self.countries.removeAll()
            self.countries.append(contentsOf: response.data ?? [MGCountryDatum]())
            self.loadDynamicFields()
        }
    }
    
    func unique<S : Sequence, T : Hashable>(source: S) -> [T] where S.Iterator.Element == T {
        var buffer = [T]()
        var added = Set<T>()
        for elem in source {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
    
    func loadDynamicFields() {
        self.showLoading()
        self.getApiManager().getDynamicFields(token: self.getAccessToken(), beneficiaryId: getSelectedBeneficiaryId(), sendModel: App.shared.sendMoneyMG) { (response) in
            

            
//           print("response.message\( response.message)")
//            print("response.code\( response.code)")
//            print("response.success\( response.success)")

            
            let message = response.message ?? ["Somthing Wrong"]
            print("response.message\(message)")

            
            if response.success == false{
            self.handleError(code : response.code ?? "", message : response.message ?? ["Somthing Wrong"])

            }else{
                
                self.hideLoading()
                self.dynamicFields.removeAll()
                self.dynamicFields.append(contentsOf: response.data?.fields ?? [DynamicFieldDatum]())
                //bene data
                self.beneFirsName = response.data?.firstName ?? ""
                self.beneSecondName = response.data?.secondName ?? ""
                self.beneThirdName = response.data?.thirdName ?? ""
                self.beneLastName = response.data?.lastName ?? ""
                self.setUpCells()
            }

        }
    }
    
    private func getSelectedBeneficiaryId() -> String {
        var id = ""
        for bene in self.beneficiaries {
            if (bene.isChecked ?? false) {
                id = bene.beneficiaryID ?? ""
            }
        }
        return id
    }
    
    func addStaticCells() {
        var field = DynamicFieldDatum(fieldsForProductEnumDetails: nil, xmlTag: "", visibility: "", label: "first_name".localized, displayOrder: "", category: "", datumDynamic: false, max: "", min: "", dataType: Constants.DYNAMIC_FIELDS.first_name, enumerated: false, defaultValue: "", validationRegEx: "", arrayName: "", arrayLength: "", isMand: true)
        
        field.isMand = true
        
        
        var cell: DynamicStringCell = self.tableView.dequeueReusableCell(withIdentifier: "DynamicStringCell") as! DynamicStringCell
        cell.lblTitle.text = "first_name".localized
        
        if (isArabic()) {
            cell.lblTitle.textAlignment = .right
        }else{
            cell.lblTitle.textAlignment = .left

        }
        
        cell.field = field
        cell.delegate = self
        cell.setup(field: field)
        cell.fieldContent.placeholder = "first_name_ph".localized
        if (isArabic()) {
            cell.fieldContent.textAlignment = .right
        }else{
            cell.fieldContent.textAlignment = .left

        }
        cell.fieldContent.text = beneFirsName
        self.cells.append(cell)
        
        
        field = DynamicFieldDatum(fieldsForProductEnumDetails: nil, xmlTag: "", visibility: "", label: "second_name".localized, displayOrder: "", category: "", datumDynamic: false, max: "", min: "", dataType: Constants.DYNAMIC_FIELDS.second_name, enumerated: false, defaultValue: "", validationRegEx: "", arrayName: "", arrayLength: "", isMand: false)
        cell = self.tableView.dequeueReusableCell(withIdentifier: "DynamicStringCell") as! DynamicStringCell
        cell.lblTitle.text = "second_name".localized
        
        if (isArabic()) {
            cell.lblTitle.textAlignment = .right
        }else{
            cell.lblTitle.textAlignment = .left

        }
        
        cell.field = field
        cell.delegate = self
        cell.setup(field: field)
        cell.fieldContent.placeholder = "second_name_ph".localized
        cell.fieldContent.text = beneSecondName
        self.cells.append(cell)
        
        
        field = DynamicFieldDatum(fieldsForProductEnumDetails: nil, xmlTag: "", visibility: "", label: "third_name".localized, displayOrder: "", category: "", datumDynamic: false, max: "", min: "", dataType: Constants.DYNAMIC_FIELDS.third_name, enumerated: false, defaultValue: "", validationRegEx: "", arrayName: "", arrayLength: "", isMand: false)
        cell = self.tableView.dequeueReusableCell(withIdentifier: "DynamicStringCell") as! DynamicStringCell
        cell.lblTitle.text = "third_name".localized
        
        if (isArabic()) {
            cell.lblTitle.textAlignment = .right
        }else{
            cell.lblTitle.textAlignment = .left

        }
        cell.field = field
        cell.delegate = self
        cell.setup(field: field)
        cell.fieldContent.placeholder = "third_name_ph".localized
        cell.fieldContent.text = beneThirdName
        self.cells.append(cell)
        
        
        field = DynamicFieldDatum(fieldsForProductEnumDetails: nil, xmlTag: "", visibility: "", label: "last_name".localized, displayOrder: "", category: "", datumDynamic: false, max: "", min: "", dataType: Constants.DYNAMIC_FIELDS.last_name, enumerated: false, defaultValue: "", validationRegEx: "", arrayName: "", arrayLength: "", isMand: true)
        field.isMand = true
        cell = self.tableView.dequeueReusableCell(withIdentifier: "DynamicStringCell") as! DynamicStringCell
        cell.lblTitle.text = "last_name".localized
        
        if (isArabic()) {
            cell.lblTitle.textAlignment = .right
        }else{
            cell.lblTitle.textAlignment = .left

        }
        
        cell.field = field
        cell.delegate = self
        cell.setup(field: field)
        cell.fieldContent.placeholder = "last_name_ph".localized
        cell.fieldContent.text = beneLastName
        self.cells.append(cell)
        
        self.validateFields()
    }
    
    func setUpCells() {
        //add static cells first
        self.cells.removeAll()
        self.addStaticCells()
        //add cells by type
        for field in self.dynamicFields {
            if (field.fieldsForProductEnumDetails?.count ?? 0 > 0) {
                let cell: DynamicDropDownCell = self.tableView.dequeueReusableCell(withIdentifier: "DynamicDropDownCell") as! DynamicDropDownCell
                cell.field = field
                cell.delegate = self
                cell.setup(field: field)
                self.cells.append(cell)
            }else {
                switch field.dataType ?? "" {
                case Constants.DYNAMIC_FIELDS.dropdown:
                    let cell: DynamicDropDownCell = self.tableView.dequeueReusableCell(withIdentifier: "DynamicDropDownCell") as! DynamicDropDownCell
                    cell.field = field
                    cell.delegate = self
                    cell.setup(field: field)
                    self.cells.append(cell)
                    break
                case Constants.DYNAMIC_FIELDS.countrycode:
                    let cell: DynamicCountryCell = self.tableView.dequeueReusableCell(withIdentifier: "DynamicCountryCell") as! DynamicCountryCell
                    cell.field = field
                    cell.delegate = self
                    cell.setup(field: field, countries : self.countries)
                    self.cells.append(cell)
                    break
                case Constants.DYNAMIC_FIELDS.string:
                    let cell: DynamicStringCell = self.tableView.dequeueReusableCell(withIdentifier: "DynamicStringCell") as! DynamicStringCell
                    cell.field = field
                    cell.delegate = self
                    cell.setup(field: field)
                    self.cells.append(cell)
                    break
                case Constants.DYNAMIC_FIELDS.decimal:
                    let cell: DynamicDecimalCell = self.tableView.dequeueReusableCell(withIdentifier: "DynamicDecimalCell") as! DynamicDecimalCell
                    cell.field = field
                    cell.delegate = self
                    cell.setup(field: field)
                    self.cells.append(cell)
                    break
                case Constants.DYNAMIC_FIELDS.datetime:
                    let cell: DynamicDateTimeCell = self.tableView.dequeueReusableCell(withIdentifier: "DynamicDateTimeCell") as! DynamicDateTimeCell
                    cell.field = field
                    cell.delegate = self
                    cell.setup(field: field)
                    self.cells.append(cell)
                    break
                case Constants.DYNAMIC_FIELDS.boolean:
                    let cell: DynamicBooleanCell = self.tableView.dequeueReusableCell(withIdentifier: "DynamicBooleanCell") as! DynamicBooleanCell
                    cell.field = field
                    cell.setup(field: field)
                    self.cells.append(cell)
                    break
                default:
                    //
                    break
                }
            }
        }
        self.validateFields()
        self.tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dynamicCell = self.cells[indexPath.row]
        
        
        
        return dynamicCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95.0
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueAction(_ sender: Any) {
        if (self.validate()) {
            self.fillData()
            self.pushVC(name: "mg_PaymentDetailsVC", sb: Constants.STORYBOARDS.money_gram)
        }
    }
    
    func validate() -> Bool {
        for cell in self.cells {
            if let dynamicCell = cell as? DynamicStringCell {
                let isMand = dynamicCell.field?.isMand ?? false
                let fieldContentStr = (dynamicCell.fieldContent.text ?? "").trim()
                let dataType = dynamicCell.field?.dataType ?? ""
                
                if (isMand && fieldContentStr.count == 0) {
                    dynamicCell.cvField.backgroundColor = UIColor.app_red
                    self.showBanner(title: "alert".localized, message: "\(dynamicCell.field?.label ?? "") \("is_required".localized)", style: UIColor.INFO)
                    return false
                }
                
                if (dataType == Constants.DYNAMIC_FIELDS.first_name || dataType == Constants.DYNAMIC_FIELDS.second_name || dataType == Constants.DYNAMIC_FIELDS.third_name || dataType == Constants.DYNAMIC_FIELDS.last_name) {
                    if (!self.isPureText(text: fieldContentStr)) {
                        dynamicCell.cvField.backgroundColor = UIColor.app_red
                        self.showBanner(title: "alert".localized, message: "\(dynamicCell.field?.label ?? "") \("must_not_contain_special_chars".localized)", style: UIColor.INFO)
                        return false
                    }
                }else {
                    if (!self.isPureText(text: fieldContentStr)) {
                        dynamicCell.cvField.backgroundColor = UIColor.app_red
                        self.showBanner(title: "alert".localized, message: "\(dynamicCell.field?.label ?? "") \("must_not_contain_special_chars".localized)", style: UIColor.INFO)
                        return false
                    }
                    if (isMand && dynamicCell.field?.validationRegEx?.count ?? 0 > 0) {
                        if (NSPredicate(format: "SELF MATCHES %@", dynamicCell.field?.validationRegEx ?? "").evaluate(with: fieldContentStr) == false) {
                            self.showBanner(title: "alert".localized, message: "\(dynamicCell.field?.label ?? "") \("does_not_match_format".localized)", style: UIColor.INFO)
                            return false
                        }
                    }
                }
                
            }else if let dynamicCell = cell as? DynamicDecimalCell {
                let isMand = dynamicCell.field?.isMand ?? false
                let fieldContentStr = (dynamicCell.fieldContent.text ?? "").trim()
                if (!self.isPureTextNumber(text: fieldContentStr)) {
                    self.showBanner(title: "alert".localized, message: "\(dynamicCell.field?.label ?? "") \("must_not_contain_special_chars".localized)", style: UIColor.INFO)
                    return false
                }
                
                if (isMand && fieldContentStr.count == 0) {
                    self.showBanner(title: "alert".localized, message: "\(dynamicCell.field?.label ?? "") \("is_required".localized)", style: UIColor.INFO)
                    return false
                }
                if (isMand && dynamicCell.field?.validationRegEx?.count ?? 0 > 0) {
                    if (NSPredicate(format: "SELF MATCHES %@", dynamicCell.field?.validationRegEx ?? "").evaluate(with: fieldContentStr) == false) {
                        self.showBanner(title: "alert".localized, message: "\(dynamicCell.field?.label ?? "") \("does_not_match_format".localized)", style: UIColor.INFO)
                        return false
                    }
                }
            }else if let dynamicCell = cell as? DynamicDropDownCell {
                let isMand = dynamicCell.field?.isMand ?? false
                let fieldContentStr = (dynamicCell.fieldContent.text ?? "").trim()
                if (isMand && fieldContentStr.count == 0) {
                    self.showBanner(title: "alert".localized, message: "\(dynamicCell.field?.label ?? "") \("is_required".localized)", style: UIColor.INFO)
                    return false
                }
            }else if let dynamicCell = cell as? DynamicCountryCell {
                let isMand = dynamicCell.field?.isMand ?? false
                let fieldContentStr = (dynamicCell.fieldContent.text ?? "").trim()
                if (isMand && fieldContentStr.count == 0) {
                    self.showBanner(title: "alert".localized, message: "\(dynamicCell.field?.label ?? "") \("is_required".localized)", style: UIColor.INFO)
                    return false
                }
            }
        }
        return true
    }
    
    func validateFields() {
        for cell in self.cells {
            if let dynamicCell = cell as? DynamicStringCell {
                let isMand = dynamicCell.field?.isMand ?? false
                let fieldContentStr = (dynamicCell.fieldContent.text ?? "").trim()
                let dataType = dynamicCell.field?.dataType ?? ""
                
                if (isMand && fieldContentStr.count == 0) {
                    self.enableNext(flag: false)
                    return
                }
                
                if (dataType == Constants.DYNAMIC_FIELDS.first_name || dataType == Constants.DYNAMIC_FIELDS.second_name || dataType == Constants.DYNAMIC_FIELDS.third_name || dataType == Constants.DYNAMIC_FIELDS.last_name) {
                    if (!self.isPureText(text: fieldContentStr)) {
                        self.enableNext(flag: false)
                        return
                    }
                }else {
                    if (!self.isPureText(text: fieldContentStr)) {
                        self.enableNext(flag: false)
                        return
                    }
                    if (isMand && dynamicCell.field?.validationRegEx?.count ?? 0 > 0) {
                        if (NSPredicate(format: "SELF MATCHES %@", dynamicCell.field?.validationRegEx ?? "").evaluate(with: fieldContentStr) == false) {
                            self.enableNext(flag: false)
                            return
                        }
                    }
                }
                
            }else if let dynamicCell = cell as? DynamicDecimalCell {
                let isMand = dynamicCell.field?.isMand ?? false
                let fieldContentStr = (dynamicCell.fieldContent.text ?? "").trim()
                if (!self.isPureTextNumber(text: fieldContentStr)) {
                    self.enableNext(flag: false)
                    return
                }
                
                if (isMand && fieldContentStr.count == 0) {
                    self.enableNext(flag: false)
                    return
                }
                if (isMand && dynamicCell.field?.validationRegEx?.count ?? 0 > 0) {
                    if (NSPredicate(format: "SELF MATCHES %@", dynamicCell.field?.validationRegEx ?? "").evaluate(with: fieldContentStr) == false) {
                        self.enableNext(flag: false)
                        return
                    }
                }
            }else if let dynamicCell = cell as? DynamicDropDownCell {
                let isMand = dynamicCell.field?.isMand ?? false
                let fieldContentStr = (dynamicCell.fieldContent.text ?? "").trim()
                if (isMand && fieldContentStr.count == 0) {
                    self.enableNext(flag: false)
                    return
                }
            }else if let dynamicCell = cell as? DynamicCountryCell {
                let isMand = dynamicCell.field?.isMand ?? false
                let fieldContentStr = (dynamicCell.fieldContent.text ?? "").trim()
                if (isMand && fieldContentStr.count == 0) {
                    self.enableNext(flag: false)
                    return
                }
            }
        }
        self.enableNext(flag: true)
        return
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
    
    @IBAction func goBackHome(_ sender: Any) {
        goHomeWithConfirmation()
    }
    
    //fill data
    func fillData() {
        var dynamicFields = [DynamicFieldDatum]()
        for cell in self.cells {
            if let dynamicCell = cell as? DynamicDropDownCell {
                let field = dynamicCell.field
                field?.value = dynamicCell.selectedItem?.value ?? ""
                dynamicFields.append(field!)
            }else if let dynamicCell = cell as? DynamicCountryCell {
                let field = dynamicCell.field
                field?.value = dynamicCell.selectedCountry?.countryCode ?? ""
                dynamicFields.append(field!)
            }else if let dynamicCell = cell as? DynamicStringCell {
                if (dynamicCell.field?.dataType ?? "" == Constants.DYNAMIC_FIELDS.first_name) {
                    App.shared.sendMoneyMG?.receiverFirstName = (dynamicCell.fieldContent.text ?? "").trim()
                }else if (dynamicCell.field?.dataType ?? "" == Constants.DYNAMIC_FIELDS.second_name) {
                    App.shared.sendMoneyMG?.receiverSecondName = (dynamicCell.fieldContent.text ?? "").trim()
                }else if (dynamicCell.field?.dataType ?? "" == Constants.DYNAMIC_FIELDS.third_name) {
                    App.shared.sendMoneyMG?.receiverThirdName = (dynamicCell.fieldContent.text ?? "").trim()
                }else if (dynamicCell.field?.dataType ?? "" == Constants.DYNAMIC_FIELDS.last_name) {
                    App.shared.sendMoneyMG?.receiverLastName = (dynamicCell.fieldContent.text ?? "").trim()
                }else {
                    let field = dynamicCell.field
                    field?.value = (dynamicCell.fieldContent.text ?? "").trim()
                    dynamicFields.append(field!)
                }
            }else if let dynamicCell = cell as? DynamicDecimalCell {
                let field = dynamicCell.field
                field?.value = (dynamicCell.fieldContent.text ?? "").trim()
                dynamicFields.append(field!)
            }else if let dynamicCell = cell as? DynamicDateTimeCell {
                let field = dynamicCell.field
                let date = (dynamicCell.fieldContent.text ?? "").trim().replacedArabicDigitsWithEnglish
                let dateForApi = self.getStringDateWithFormat(dateStr: date, outputFormat: Constants.DATE_FORMATS.api_date)
                field?.value = dateForApi
                dynamicFields.append(field!)
            }else if let dynamicCell = cell as? DynamicBooleanCell {
                let field = dynamicCell.field
                if (dynamicCell.selectedValue) {
                    field?.value = "true"
                }else {
                    field?.value = "false"
                }
                dynamicFields.append(field!)
            }
        }
        App.shared.sendMoneyMG?.dynamicFields = dynamicFields
    }
    
    @IBAction func clearBeneficiaryAction(_ sender: Any) {
        for bene in beneficiaries {
            bene.isChecked = false
        }
        collectionBeneficiaries.reloadData()
        loadDynamicFields()
    }
}

extension mg_ReceiverInfoVC : ValidateDynamicProtocol {
    func validateFieldsTriggered() {
        validateFields()
    }
}

extension Array {

    func filterDuplicates(includeElement: (_ lhs:Element, _ rhs:Element) -> Bool) -> [Element]{
        var results = [Element]()

        forEach { (element) in
            let existingElements = results.filter {
                return includeElement(element, $0)
            }
            if existingElements.count == 0 {
                results.append(element)
            }
        }

        return results
    }
}

extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()

        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }

        return result
    }
}
