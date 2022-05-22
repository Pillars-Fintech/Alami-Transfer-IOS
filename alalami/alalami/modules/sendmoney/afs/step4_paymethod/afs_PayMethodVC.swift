//
//  afs_PayMethodVC.swift
//  alalami
//
//  Created by Zaid Khaled on 9/13/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit
import DropDown

class afs_PayMethodVC: BaseVC, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var btnBack: UIButton!
    
    //pay in method
    @IBOutlet weak var cvPayInMethod: CardView!
    @IBOutlet weak var fieldPayInMethod: MyUITextField!
    @IBOutlet weak var ivPayInMethod: UIImageView!
    var payInMethods = [PayInMethodDatum]()
    var methodsDropDown : DropDown?
    var selectedMethod : PayInMethodDatum?
    
    //sender address
    @IBOutlet weak var viewSenderAddress: UIView!
    
    @IBOutlet weak var cvSenderRegion: CardView!
    @IBOutlet weak var fieldSenderRegion: MyUITextField!
    
    @IBOutlet weak var cvSenderCity: CardView!
    @IBOutlet weak var fieldSenderCity: MyUITextField!
    
    @IBOutlet weak var cvSenderStreet: CardView!
    @IBOutlet weak var fieldSenderStreet: MyUITextField!
    
    @IBOutlet weak var cvSenderBuildingName: CardView!
    @IBOutlet weak var fieldSenderBuildingName: MyUITextField!
    
    @IBOutlet weak var cvSenderBuildingNumber: CardView!
    @IBOutlet weak var fieldSenderBuildingNumber: MyUITextField!
    
    @IBOutlet weak var cvSenderApartment: CardView!
    @IBOutlet weak var fieldSenderApartment: MyUITextField!
    
    @IBOutlet weak var cvSenderAddress: CardView!
    @IBOutlet weak var fieldSenderAddress: MyUITextField!
    
    //receiver address
    @IBOutlet weak var viewReceiverAddress: UIView!
    
    @IBOutlet weak var cvReceiverRegion: CardView!
    @IBOutlet weak var fieldReceiverRegion: MyUITextField!
    
    @IBOutlet weak var cvReceiverCity: CardView!
    @IBOutlet weak var fieldReceiverCity: MyUITextField!
    
    @IBOutlet weak var cvReceiverStreet: CardView!
    @IBOutlet weak var fieldReceiverStreet: MyUITextField!
    
    @IBOutlet weak var cvReceiverBuildingName: CardView!
    @IBOutlet weak var fieldReceiverBuildingName: MyUITextField!
    
    @IBOutlet weak var cvReceiverBuildingNumber: CardView!
    @IBOutlet weak var fieldReceiverBuildingNumber: MyUITextField!
    
    @IBOutlet weak var cvReceiverApartment: CardView!
    @IBOutlet weak var fieldReceiverApartment: MyUITextField!
    
    @IBOutlet weak var cvReceiverAddress: CardView!
    @IBOutlet weak var fieldReceiverAddress: MyUITextField!
    
    //branches
    @IBOutlet weak var viewBranches: UIView!
    @IBOutlet weak var viewBranchesHeight: NSLayoutConstraint!
    @IBOutlet weak var tableBranches: UITableView!
    var branches = [BranchDatum]()
    
    //wallet
    @IBOutlet weak var viewWallet: UIView!
    
    @IBOutlet weak var cvWalletProvider: CardView!
    @IBOutlet weak var fieldWalletProvider: MyUITextField!
    var walletProviders = [WalletProviderDatum]()
    var walletsDropDown : DropDown?
    var selectedWallet : WalletProviderDatum?
    
    @IBOutlet weak var cvWalletNumber: CardView!
    @IBOutlet weak var fieldWalletNumber: MyUITextField!
    
    
    //continue
    @IBOutlet weak var cvContinue: CardView!
    @IBOutlet weak var btnContinue: MyUIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (isArabic()) {
            btnBack.setImage(UIImage(named: "ic_back_ar"), for: .normal)
        }
        
        self.fieldSenderRegion.delegate = self
        self.fieldSenderCity.delegate = self
        self.fieldSenderStreet.delegate = self
        self.fieldSenderBuildingName.delegate = self
        self.fieldSenderBuildingNumber.delegate = self
        self.fieldSenderApartment.delegate = self
        self.fieldSenderAddress.delegate = self
        
        
        self.fieldReceiverRegion.delegate = self
        self.fieldReceiverCity.delegate = self
        self.fieldReceiverStreet.delegate = self
        self.fieldReceiverBuildingName.delegate = self
        self.fieldReceiverBuildingNumber.delegate = self
        self.fieldReceiverApartment.delegate = self
        self.fieldReceiverAddress.delegate = self
        
        self.fieldWalletNumber.delegate = self
        
        self.tableBranches.delegate = self
        self.tableBranches.dataSource = self
        
        self.validateFields()
        
        
    }
    
    
    func fillData() {
        if (App.shared.sendMoneyAFS == nil) {
            App.shared.sendMoneyAFS = SendMoneyAFSModel()
        }
        App.shared.sendMoneyAFS?.payInOption = self.selectedMethod
        
        App.shared.sendMoneyAFS?.senderRegion = self.fieldSenderRegion.text ?? ""
        App.shared.sendMoneyAFS?.senderCity = self.fieldSenderCity.text ?? ""
        App.shared.sendMoneyAFS?.senderStreet = self.fieldSenderStreet.text ?? ""
        App.shared.sendMoneyAFS?.senderBuildingName = self.fieldSenderBuildingName.text ?? ""
        App.shared.sendMoneyAFS?.senderBuildingNumber = self.fieldSenderBuildingNumber.text ?? ""
        App.shared.sendMoneyAFS?.senderApartment = self.fieldSenderApartment.text ?? ""
        App.shared.sendMoneyAFS?.senderAddress = self.fieldSenderAddress.text ?? ""
        
        App.shared.sendMoneyAFS?.ReceiverRegion = self.fieldReceiverRegion.text ?? ""
        App.shared.sendMoneyAFS?.ReceiverCity = self.fieldReceiverCity.text ?? ""
        App.shared.sendMoneyAFS?.ReceiverStreet = self.fieldReceiverStreet.text ?? ""
        App.shared.sendMoneyAFS?.ReceiverBuildingName = self.fieldReceiverBuildingName.text ?? ""
        App.shared.sendMoneyAFS?.ReceiverBuildingNumber = self.fieldReceiverBuildingNumber.text ?? ""
        App.shared.sendMoneyAFS?.ReceiverApartment = self.fieldReceiverApartment.text ?? ""
        App.shared.sendMoneyAFS?.ReceiverAddress = self.fieldReceiverAddress.text ?? ""
        
        App.shared.sendMoneyAFS?.walletProvider = self.selectedWallet
        App.shared.sendMoneyAFS?.walletNumber = self.fieldWalletNumber.text ?? ""
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectPayInMethod(_ sender: Any) {
        self.showLoading()
        self.getApiManager().getPayInMethods(token: self.getAccessToken()) { (response) in
            self.hideLoading()
            self.methodsDropDown = DropDown()
            self.methodsDropDown?.anchorView = self.cvPayInMethod
            var arr = [String]()
            self.payInMethods.removeAll()
            self.payInMethods.append(contentsOf: response.data ?? [PayInMethodDatum]())
            for item in self.payInMethods {
                arr.append(item.name ?? "")
            }
            self.methodsDropDown?.dataSource = arr
            
            self.methodsDropDown?.cellNib = UINib(nibName: "ImageDropDownCell", bundle: nil)
            
            self.methodsDropDown?.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
               guard let cell = cell as? ImageDropDownCell else { return }
                let url = URL(string: "\(Constants.IMAGE_URL)\(self.payInMethods[index].logo ?? "")")
                cell.ivLogo.kf.setImage(with: url, placeholder: UIImage(named: ""))
            }
            
            self.methodsDropDown?.show()
            
            self.methodsDropDown?.selectionAction = { [unowned self] (index: Int, item: String) in
                self.selectedMethod = self.payInMethods[index]
                self.fieldPayInMethod.text = self.selectedMethod?.name ?? ""
                let url = URL(string: "\(Constants.IMAGE_URL)\(self.payInMethods[index].logo ?? "")")
                self.ivPayInMethod.kf.setImage(with: url, placeholder: UIImage(named: ""))
                self.cvPayInMethod.backgroundColor = UIColor.card_color
                self.validateSelectedPayInMethod()
            }
        }
    }
    
    func validateSelectedPayInMethod() {
        let payInMethodCode = self.selectedMethod?.code ?? "01"
        switch payInMethodCode {
        case "01": // EFawaterkom
            self.eFawaterkomUI()
            break
        case "02": // in location
            self.inLocationUI()
            break
        case "03": // Door to door
            self.doorToDoorUI()
            break
        case "04": // collection cash in location
            self.doorToDoorUI()
            break
        case "05": // eWallet
            self.eWalletUI()
            break
        default:
            self.defaultUI()
            break
        }
        self.validateFields()
    }
    
    func validate() -> Bool {
        if (self.selectedMethod?.name?.count ?? 0 == 0) {
            self.showBanner(title: "alert".localized, message: "select_payin_method".localized, style: UIColor.INFO)
            self.cvPayInMethod.backgroundColor = UIColor.app_red
            return false
        }
        if (self.selectedMethod?.code == "03" || self.selectedMethod?.code == "04") { //door to door or colletion cash in location
            if (self.fieldSenderRegion.text?.count ?? 0 == 0) {
                self.showBanner(title: "alert".localized, message: "enter_sender_region".localized, style: UIColor.INFO)
                self.cvSenderRegion.backgroundColor = UIColor.app_red
                return false
            }
            if (!isPureText(text: fieldSenderRegion.text ?? "")) {
                self.showBanner(title: "alert".localized, message: "text_regex_region".localized, style: UIColor.INFO)
                self.cvSenderRegion.backgroundColor = UIColor.app_red
                return false
            }
            if (self.fieldSenderCity.text?.count ?? 0 == 0) {
                self.showBanner(title: "alert".localized, message: "enter_sender_city".localized, style: UIColor.INFO)
                self.cvSenderCity.backgroundColor = UIColor.app_red
                return false
            }
            if (!isPureText(text: fieldSenderCity.text ?? "")) {
                self.showBanner(title: "alert".localized, message: "text_regex_city".localized, style: UIColor.INFO)
                self.cvSenderCity.backgroundColor = UIColor.app_red
                return false
            }
            if (self.fieldSenderStreet.text?.count ?? 0 == 0) {
                self.showBanner(title: "alert".localized, message: "enter_sender_street".localized, style: UIColor.INFO)
                self.cvSenderStreet.backgroundColor = UIColor.app_red
                return false
            }
            if (!isPureText(text: fieldSenderStreet.text ?? "")) {
                self.showBanner(title: "alert".localized, message: "text_regex_street".localized, style: UIColor.INFO)
                self.cvSenderStreet.backgroundColor = UIColor.app_red
                return false
            }
            if (self.fieldSenderBuildingName.text?.count ?? 0 == 0) {
                self.showBanner(title: "alert".localized, message: "enter_sender_building_name".localized, style: UIColor.INFO)
                self.cvSenderBuildingName.backgroundColor = UIColor.app_red
                return false
            }
            if (!isPureText(text: fieldSenderBuildingName.text ?? "")) {
                self.showBanner(title: "alert".localized, message: "text_regex_building_name".localized, style: UIColor.INFO)
                self.cvSenderBuildingName.backgroundColor = UIColor.app_red
                return false
            }
            if (self.fieldSenderBuildingNumber.text?.count ?? 0 == 0) {
                self.showBanner(title: "alert".localized, message: "enter_sender_building_number".localized, style: UIColor.INFO)
                self.cvSenderBuildingNumber.backgroundColor = UIColor.app_red
                return false
            }
            if (!isPureText(text: fieldSenderBuildingNumber.text ?? "")) {
                self.showBanner(title: "alert".localized, message: "text_regex_building_number".localized, style: UIColor.INFO)
                self.cvSenderBuildingNumber.backgroundColor = UIColor.app_red
                return false
            }
            if (self.fieldSenderApartment.text?.count ?? 0 == 0) {
                self.showBanner(title: "alert".localized, message: "enter_sender_apartment".localized, style: UIColor.INFO)
                self.cvSenderApartment.backgroundColor = UIColor.app_red
                return false
            }
            if (!isPureText(text: fieldSenderApartment.text ?? "")) {
                self.showBanner(title: "alert".localized, message: "text_regex_apartment".localized, style: UIColor.INFO)
                self.cvSenderApartment.backgroundColor = UIColor.app_red
                return false
            }
            if (self.fieldSenderAddress.text?.count ?? 0 == 0) {
                self.showBanner(title: "alert".localized, message: "enter_sender_address".localized, style: UIColor.INFO)
                self.cvSenderAddress.backgroundColor = UIColor.app_red
                return false
            }
            if (!isPureText(text: fieldSenderAddress.text ?? "")) {
                self.showBanner(title: "alert".localized, message: "text_regex_address".localized, style: UIColor.INFO)
                self.cvSenderAddress.backgroundColor = UIColor.app_red
                return false
            }
            
//            if (self.fieldReceiverRegion.text?.count ?? 0 == 0) {
//                self.showBanner(title: "alert".localized, message: "enter_receiver_region".localized, style: UIColor.INFO)
//                self.cvReceiverRegion.backgroundColor = UIColor.app_red
//                return false
//            }
//            if (self.fieldReceiverCity.text?.count ?? 0 == 0) {
//                self.showBanner(title: "alert".localized, message: "enter_receiver_city".localized, style: UIColor.INFO)
//                self.cvReceiverCity.backgroundColor = UIColor.app_red
//                return false
//            }
//            if (self.fieldReceiverStreet.text?.count ?? 0 == 0) {
//                self.showBanner(title: "alert".localized, message: "enter_receiver_street".localized, style: UIColor.INFO)
//                self.cvReceiverStreet.backgroundColor = UIColor.app_red
//                return false
//            }
//            if (self.fieldReceiverBuildingName.text?.count ?? 0 == 0) {
//                self.showBanner(title: "alert".localized, message: "enter_receiver_building_name".localized, style: UIColor.INFO)
//                self.cvReceiverBuildingName.backgroundColor = UIColor.app_red
//                return false
//            }
//            if (self.fieldReceiverBuildingNumber.text?.count ?? 0 == 0) {
//                self.showBanner(title: "alert".localized, message: "enter_receiver_building_number".localized, style: UIColor.INFO)
//                self.cvReceiverRegion.backgroundColor = UIColor.app_red
//                return false
//            }
//            if (self.fieldReceiverApartment.text?.count ?? 0 == 0) {
//                self.showBanner(title: "alert".localized, message: "enter_receiver_apartment".localized, style: UIColor.INFO)
//                self.cvReceiverApartment.backgroundColor = UIColor.app_red
//                return false
//            }
//            if (self.fieldReceiverAddress.text?.count ?? 0 == 0) {
//                self.showBanner(title: "alert".localized, message: "enter_receiver_address".localized, style: UIColor.INFO)
//                self.cvReceiverAddress.backgroundColor = UIColor.app_red
//                return false
//            }
        }
        if (self.selectedMethod?.code == "05") { //eWallet
            if (self.selectedWallet?.name?.count ?? 0 == 0) {
                self.showBanner(title: "alert".localized, message: "select_wallet_provider".localized, style: UIColor.INFO)
                self.cvWalletProvider.backgroundColor = UIColor.app_red
                return false
            }
            if (self.fieldWalletNumber.text?.count ?? 0 == 0) {
                self.showBanner(title: "alert".localized, message: "enter_wallet_number".localized, style: UIColor.INFO)
                self.cvReceiverAddress.backgroundColor = UIColor.app_red
                return false
            }
            if (!isPureTextNumber(text: (self.fieldWalletNumber.text ?? "").replacedArabicDigitsWithEnglish)) {
                self.showBanner(title: "alert".localized, message: "enter_wallet_number".localized, style: UIColor.INFO)
                self.cvReceiverAddress.backgroundColor = UIColor.app_red
                return false
            }
        }
        
        return true
    }
    
    func validateFields() {
        if (selectedMethod?.name?.count ?? 0 == 0) {
            self.enableNext(flag: false)
            return
        }
        if (self.selectedMethod?.code == "03" || self.selectedMethod?.code == "04") { //door to door or colletion cash in location
            if (self.fieldSenderRegion.text?.count ?? 0 == 0) {
                self.enableNext(flag: false)
                return
            }
            if (self.fieldSenderCity.text?.count ?? 0 == 0) {
                self.enableNext(flag: false)
                return
            }
            if (self.fieldSenderStreet.text?.count ?? 0 == 0) {
                self.enableNext(flag: false)
                return
            }
            if (!isPureText(text: [fieldSenderRegion.text ?? "", fieldSenderCity.text ?? "", fieldSenderBuildingNumber.text ?? "", fieldSenderBuildingName.text ?? "", fieldSenderApartment.text ?? "", fieldSenderAddress.text ?? ""])) {
                self.enableNext(flag: false)
                return
            }
            if (self.fieldSenderBuildingName.text?.count ?? 0 == 0) {
                self.enableNext(flag: false)
                return
            }
            if (self.fieldSenderBuildingNumber.text?.count ?? 0 == 0) {
                self.enableNext(flag: false)
                return
            }
            if (self.fieldSenderApartment.text?.count ?? 0 == 0) {
                self.enableNext(flag: false)
                return
            }
            if (self.fieldSenderAddress.text?.count ?? 0 == 0) {
                self.enableNext(flag: false)
                return
            }
            
            
//            if (self.fieldReceiverRegion.text?.count ?? 0 == 0) {
//                self.enableNext(flag: false)
//                return
//            }
//            if (self.fieldReceiverCity.text?.count ?? 0 == 0) {
//                self.enableNext(flag: false)
//                return
//            }
//            if (self.fieldReceiverStreet.text?.count ?? 0 == 0) {
//                self.enableNext(flag: false)
//                return
//            }
//            if (self.fieldReceiverBuildingName.text?.count ?? 0 == 0) {
//                self.enableNext(flag: false)
//                return
//            }
//            if (self.fieldReceiverBuildingNumber.text?.count ?? 0 == 0) {
//                self.enableNext(flag: false)
//                return
//            }
//            if (self.fieldReceiverApartment.text?.count ?? 0 == 0) {
//                self.enableNext(flag: false)
//                return
//            }
//            if (self.fieldReceiverAddress.text?.count ?? 0 == 0) {
//                self.enableNext(flag: false)
//                return
//            }
        }
        
        if (self.selectedMethod?.code == "05") { //eWallet
            if (self.selectedWallet?.name?.count ?? 0 == 0) {
                self.enableNext(flag: false)
                return
            }
            if (self.fieldWalletNumber.text?.count ?? 0 == 0) {
                self.enableNext(flag: false)
                return
            }
            if (!self.isPureTextNumber(text: (self.fieldWalletNumber.text ?? "").replacedArabicDigitsWithEnglish)) {
                self.enableNext(flag: false)
                return
            }
        }
        self.enableNext(flag: true)
    }
    
    func inLocationUI() {
        self.viewSenderAddress.isHidden = true
        self.viewReceiverAddress.isHidden = true
        self.viewWallet.isHidden = true
        self.loadBranchesApi()
    }
    
    func loadBranchesApi() {
        self.showLoading()
        self.getApiManager().getBranches(token: self.getAccessToken()) { (response) in
            self.hideLoading()
            self.branches.removeAll()
           // self.branches.append(contentsOf: self.getDefaultBranches())
            self.branches.append(contentsOf: response.data ?? [BranchDatum]())
            if (self.branches.count > 0) {
                self.viewBranches.isHidden = false
                let itemsHeight = self.branches.count * 120
                self.viewBranchesHeight.constant = CGFloat(itemsHeight + 60)
                self.tableBranches.reloadData()
            }else {
                self.viewBranches.isHidden = true
            }
            
        }
    }
    
    func doorToDoorUI() {
        self.viewSenderAddress.isHidden = false
        self.viewReceiverAddress.isHidden = true
        self.viewBranches.isHidden = true
        self.viewWallet.isHidden = true
    }
    
    
    func eWalletUI() {
        self.fieldWalletNumber.text = ""
        self.fieldWalletProvider.text = ""
        self.selectedWallet = nil
        self.viewSenderAddress.isHidden = true
        self.viewReceiverAddress.isHidden = true
        self.viewBranches.isHidden = true
        self.viewWallet.isHidden = false
        self.validateFields()
    }
    
    func eFawaterkomUI() {
        self.viewSenderAddress.isHidden = true
        self.viewReceiverAddress.isHidden = true
        self.viewBranches.isHidden = true
        self.viewWallet.isHidden = true
    }
    func defaultUI() {
        self.viewSenderAddress.isHidden = true
        self.viewReceiverAddress.isHidden = true
        self.viewBranches.isHidden = true
        self.viewWallet.isHidden = true
    }
    
    //tableview delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.branches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let branch = self.branches[indexPath.row]
        
        let cell: PayInBranchCell = tableView.dequeueReusableCell(withIdentifier: "PayInBranchCell", for: indexPath as IndexPath) as! PayInBranchCell
        
        cell.lblTitle.text = branch.name ?? ""
        cell.lblAddress.text = branch.address ?? ""
        cell.lblPhone.text = branch.phone ?? ""
        cell.lblFax.text = branch.fax ?? ""
        
        cell.onNavigate = {
            self.startNavigation(longitude: Double(branch.longitude ?? "0.0") ?? 0.0, latitude: Double(branch.latitude ?? "0.0") ?? 0.0)
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    //--------
    
    @IBAction func selectWalletProvider(_ sender: Any) {
        self.showLoading()
        self.getApiManager().getWalletProviders(token: self.getAccessToken(), isInternal: true) { (response) in
            self.hideLoading()
            self.walletsDropDown = DropDown()
            self.walletsDropDown?.anchorView = self.cvWalletProvider
            var arr = [String]()
            self.walletProviders.removeAll()
            for apiProvider in response.data ?? [WalletProviderDatum]() {
                if (apiProvider.isAvailableSend ?? false) {
                    self.walletProviders.append(apiProvider)
                    arr.append(apiProvider.name ?? "")
                }
            }
            self.walletsDropDown?.dataSource = arr
            self.walletsDropDown?.show()
            
            self.walletsDropDown?.selectionAction = { [unowned self] (index: Int, item: String) in
                self.selectedWallet = self.walletProviders[index]
                self.fieldWalletProvider.text = self.selectedWallet?.name ?? ""
                self.cvWalletProvider.backgroundColor = UIColor.card_color
                self.validateFields()
            }
        }
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
    
    @IBAction func continueAction(_ sender: Any) {
        if(self.validate()) {
            self.fillData()
            self.loadPaymentDetails()
        }
    }
    
    
    func loadPaymentDetails() {
        self.showLoading()
        self.getApiManager().getAFSPaymentDetails(token: self.getAccessToken(), sendModel: App.shared.sendMoneyAFS) { (response) in
            self.hideLoading()
            
            if response.success == false {
                self.handleError(code: response.code, message: response.message ?? ["Something Wrong"])
            }else{
                self.pushVC(name: "afs_PaymentDetailsVC", sb: Constants.STORYBOARDS.afs)

            }
            
   
        }
    }
    
    //fields listeners
    @IBAction func fieldTextDidChange(_ sender: Any) {
        print("\(sender)")
        self.validateFields()
    }
    
    @IBAction func goToHome(_ sender: Any) {
        goHomeWithConfirmation()
    }
    
}


extension afs_PayMethodVC : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == self.fieldSenderRegion) {
            self.cvSenderRegion.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldSenderCity) {
            self.cvSenderCity.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldSenderStreet) {
            self.cvSenderStreet.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldSenderBuildingName) {
            self.cvSenderBuildingName.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldSenderBuildingNumber) {
            self.cvSenderBuildingNumber.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldSenderApartment) {
            self.cvSenderApartment.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldSenderAddress) {
            self.cvSenderAddress.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldReceiverRegion) {
            self.cvReceiverRegion.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldReceiverCity) {
            self.cvReceiverCity.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldReceiverStreet) {
            self.cvReceiverStreet.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldReceiverBuildingName) {
            self.cvReceiverBuildingName.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldReceiverBuildingNumber) {
            self.cvReceiverBuildingNumber.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldReceiverApartment) {
            self.cvReceiverApartment.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldReceiverAddress) {
            self.cvReceiverAddress.backgroundColor = UIColor.card_focused_color
        }else if (textField == self.fieldWalletNumber) {
            self.cvWalletNumber.backgroundColor = UIColor.card_focused_color
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == self.fieldSenderRegion) {
            self.cvSenderRegion.backgroundColor = UIColor.card_color
        }else if (textField == self.fieldSenderCity) {
            self.cvSenderCity.backgroundColor = UIColor.card_color
        }else if (textField == self.fieldSenderStreet) {
            self.cvSenderStreet.backgroundColor = UIColor.card_color
        }else if (textField == self.fieldSenderBuildingName) {
            self.cvSenderBuildingName.backgroundColor = UIColor.card_color
        }else if (textField == self.fieldSenderBuildingNumber) {
            self.cvSenderBuildingNumber.backgroundColor = UIColor.card_color
        }else if (textField == self.fieldSenderApartment) {
            self.cvSenderApartment.backgroundColor = UIColor.card_color
        }else if (textField == self.fieldSenderAddress) {
            self.cvSenderAddress.backgroundColor = UIColor.card_color
        }else if (textField == self.fieldReceiverRegion) {
            self.cvReceiverRegion.backgroundColor = UIColor.card_color
        }else if (textField == self.fieldReceiverCity) {
            self.cvReceiverCity.backgroundColor = UIColor.card_color
        }else if (textField == self.fieldReceiverStreet) {
            self.cvReceiverStreet.backgroundColor = UIColor.card_color
        }else if (textField == self.fieldReceiverBuildingName) {
            self.cvReceiverBuildingName.backgroundColor = UIColor.card_color
        }else if (textField == self.fieldReceiverBuildingNumber) {
            self.cvReceiverBuildingNumber.backgroundColor = UIColor.card_color
        }else if (textField == self.fieldReceiverApartment) {
            self.cvReceiverApartment.backgroundColor = UIColor.card_color
        }else if (textField == self.fieldReceiverAddress) {
            self.cvReceiverAddress.backgroundColor = UIColor.card_color
        }else if (textField == self.fieldWalletNumber) {
            self.cvWalletNumber.backgroundColor = UIColor.card_color
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == self.fieldSenderRegion) {
            self.fieldSenderCity.becomeFirstResponder()
        }else if (textField == self.fieldSenderCity) {
            self.fieldSenderStreet.becomeFirstResponder()
        }else if (textField == self.fieldSenderStreet) {
            self.fieldSenderBuildingName.becomeFirstResponder()
        }else if (textField == self.fieldSenderBuildingName) {
            self.fieldSenderBuildingNumber.becomeFirstResponder()
        }else if (textField == self.fieldSenderBuildingNumber) {
            self.fieldSenderApartment.becomeFirstResponder()
        }else if (textField == self.fieldSenderApartment) {
            self.fieldSenderAddress.becomeFirstResponder()
        }else if (textField == self.fieldSenderAddress) {
            self.fieldSenderAddress.resignFirstResponder()
        }
        
        else if (textField == self.fieldReceiverRegion) {
            self.fieldReceiverCity.becomeFirstResponder()
        }else if (textField == self.fieldReceiverCity) {
            self.fieldReceiverStreet.becomeFirstResponder()
        }else if (textField == self.fieldReceiverStreet) {
            self.fieldReceiverBuildingName.becomeFirstResponder()
        }else if (textField == self.fieldReceiverBuildingName) {
            self.fieldReceiverBuildingNumber.becomeFirstResponder()
        }else if (textField == self.fieldReceiverBuildingNumber) {
            self.fieldReceiverApartment.becomeFirstResponder()
        }else if (textField == self.fieldReceiverApartment) {
            self.fieldReceiverAddress.becomeFirstResponder()
        }else if (textField == self.fieldReceiverAddress) {
            self.fieldReceiverAddress.resignFirstResponder()
        }
        
        else if (textField == self.fieldWalletNumber) {
            self.fieldWalletNumber.resignFirstResponder()
        }
        return false
    }
}
