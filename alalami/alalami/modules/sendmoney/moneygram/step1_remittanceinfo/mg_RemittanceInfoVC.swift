//
//  mg_RemittanceInfoVC.swift
//  alalami
//
//  Created by Zaid Khaled on 9/7/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit
import DropDown
import Kingfisher
import EMAlertController


class mg_RemittanceInfoVC: BaseVC {
    
    @IBOutlet weak var lRemittance: MyUILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var showview: UIView!
    @IBOutlet weak var alartLabel: UILabel!
    
    //destination country
    @IBOutlet weak var fieldDestinationCountry: MyUITextField!
    @IBOutlet weak var cvDestinationCountry: CardView!
    @IBOutlet weak var ivDestinationCountry: UIImageView!
    var selectedDestinationCountry : MGCountryDatum?
    
    //fee type
    @IBOutlet weak var fieldFeeType: MyUITextField!
    @IBOutlet weak var cvFeeType: CardView!
    @IBOutlet weak var feeTypeButton: UIButton!
    @IBOutlet weak var feeTypeImageView: UIImageView!
    var feeTypes = ["exclude_fee".localized, "include_fee".localized]
    
    var feeDropDown : DropDown?
    var selectedFee : String?
    var selectedFeeValue : Int?
    
    var selectedTransactionTypeValue : Bool?
    

    //amount
    @IBOutlet weak var lblAmountTitle: MyUILabel!
    @IBOutlet weak var AmountToReciveLabel: MyUILabel!
    @IBOutlet weak var fieldAmount: MyUITextField!
    @IBOutlet weak var fieldRecive: MyUITextField!
    @IBOutlet weak var cvAmount: CardView!
    var amountCurrencyDropDown : DropDown?
    var amountTypes = ["JOD".localized, "USD".localized]
    var selectedCurrency: String?
    @IBOutlet weak var or: MyUILabel!
    
    //promotion code
    @IBOutlet weak var fieldPromotionCode: MyUITextField!
    @IBOutlet weak var cvPromotionCode: CardView!
    
    //continue
    @IBOutlet weak var cvContinue: CardView!
    @IBOutlet weak var btnContinue: MyUIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alartLabel.textAlignment = .natural

        
        if (isArabic()) {
            btnBack.setImage(UIImage(named: "ic_back_ar"), for: .normal)
        }
        
        if (isArabic()) {
            alartLabel.textAlignment = .right
        }else{
            alartLabel.textAlignment = .left

        }
        
        
        self.fieldAmount.delegate = self
        self.fieldRecive.delegate = self
        
        self.fieldAmount.keyboardType = .decimalPad
        
        self.fieldAmount.layer.borderWidth = 1
        self.fieldAmount.layer.borderColor = UIColor.clear.cgColor
        self.fieldAmount.layer.cornerRadius = 7

        self.fieldRecive.layer.borderWidth = 1
        self.fieldRecive.layer.borderColor = UIColor.clear.cgColor
        self.fieldRecive.layer.cornerRadius = 7
        
        self.fieldPromotionCode.delegate = self
        self.feeTypeImageView.tintColor = .black
        self.fieldAmount.maxLength = 10
        self.fieldRecive.maxLength = 10
        

        selectDefaultTransactionType()
        
        
        //fieldAmount && fieldRecive
        fieldAmount.placeholder = "Send Money".localized
        fieldRecive.placeholder = "Received of payment".localized
        or.text = "OR".localized
        alartLabel.text = "Please enter the amount in Jordanian Dinar or foreign currency".localized
        
        
        self.enableNext(flag: false)
    }
    
    private func selectDefaultTransactionType() {
//        self.selectedTransactionType = self.transactionTypes[0]
//        self.selectedTransactionTypeValue = true
//        self.fieldTransactionType.text = self.selectedTransactionType ?? ""
        
        
        lblAmountTitle.text = "amount_by_jod".localized
        AmountToReciveLabel.text = "Amount In Country".localized
    }
    
    
    //sent // 
    
    func fillData() {
        if (App.shared.sendMoneyMG == nil) {
            App.shared.sendMoneyMG = SendMoneyMGModel()
        }
        App.shared.sendMoneyMG?.destinationCountry = self.selectedDestinationCountry
        App.shared.sendMoneyMG?.feeType = selectedFeeValue
        let amountText = (self.fieldAmount.text ?? "").trim().replacedArabicDigitsWithEnglish
        let reciveText = (self.fieldRecive.text ?? "").trim().replacedArabicDigitsWithEnglish
        App.shared.sendMoneyMG?.amount = selectedTransactionTypeValue ?? true ?  Double(amountText) : Double(reciveText)
        App.shared.sendMoneyMG?.promotionCode = self.fieldPromotionCode.text ?? ""
       
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectDestinationCountry(_ sender: Any) {
        let vc : SelectMGCountryVC = self.getStoryBoard(name: Constants.STORYBOARDS.money_gram).instantiateViewController(withIdentifier: "SelectMGCountryVC")
            as! SelectMGCountryVC
        vc.delegate = self
        vc.showSendCountries = true
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func selectFeeType(_ sender: Any) {
        self.feeDropDown = DropDown()
        self.feeDropDown?.anchorView = self.cvFeeType
        
        self.feeDropDown?.dataSource = self.feeTypes
        self.feeDropDown?.show()
        
        self.feeDropDown?.selectionAction = { [unowned self] (index: Int, item: String) in
            self.selectedFee = self.feeTypes[index]
            if (index == 0) {
                self.selectedFeeValue = 1
            }else {
                self.selectedFeeValue = 2
            }
            self.fieldFeeType.text = self.selectedFee ?? ""
            self.cvFeeType.backgroundColor = UIColor.card_color
            self.validateFields()
        }
    }
    
    @IBAction func continueAction(_ sender: Any) {
        if (self.validate()) {
            self.fillData()
            let vc : mg_PayInMethodVC = self.getStoryBoard(name: Constants.STORYBOARDS.money_gram).instantiateViewController(withIdentifier: "mg_PayInMethodVC") as! mg_PayInMethodVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //fields listeners
    @IBAction func amountChanged(_ sender: MyUITextField) {
        fieldRecive.text = ""
        self.validateFields()
    
    }
    
    



    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text, let r = Range(range, in: oldText) else {
            return true
        }

        let newText = oldText.replacingCharacters(in: r, with: string)
        let isNumeric = newText.isEmpty || (Double(newText) != nil)
        let numberOfDots = newText.components(separatedBy: ".").count - 1

        let numberOfDecimalDigits: Int
        if let dotIndex = newText.index(of: ".") {
            numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
        } else {
            numberOfDecimalDigits = 0
        }

        return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 3
    }
    

    
    
    @IBAction func reciveChanged(_ sender: MyUITextField) {
        fieldAmount.text = ""
        validateFields()
   

    }
    
    
    
    

    
    
    
    
    @IBAction func promotionCodeChanged(_ sender: Any) {
        self.validateFields()
    }
    
    func validate() -> Bool {
        let amount = (self.fieldAmount.text ?? "").trim().replacedArabicDigitsWithEnglish
        let recive = (self.fieldRecive.text ?? "").trim().replacedArabicDigitsWithEnglish
        //  let promocode = (self.fieldPromotionCode.text ?? "").trim()
        
        if (self.selectedDestinationCountry?.countryName?.count ?? 0 == 0) {
            self.showBanner(title: "alert".localized, message: "select_destination_country".localized, style: UIColor.INFO)
            self.cvDestinationCountry.backgroundColor = UIColor.app_red
            return false
        }
        
        
        
        if (self.selectedFeeValue ?? 0 == 0) {
            self.showBanner(title: "alert".localized, message: "select_fee_type".localized, style: UIColor.INFO)
            self.cvFeeType.backgroundColor = UIColor.app_red
            return false
        }
        
        
        
        
        
        if selectedTransactionTypeValue == true {
        if (amount.count == 0) {
            self.showBanner(title: "alert".localized, message: "enter_amount".localized, style: UIColor.INFO)
            self.cvAmount.backgroundColor = UIColor.app_red
            return false

        }
        
        let doubleAmount = Double(amount)
        if (doubleAmount == 0) {
            self.showBanner(title: "alert".localized, message: "enter_amount".localized, style: UIColor.INFO)
            self.cvAmount.backgroundColor = UIColor.app_red
            return false
        }
        }else {
            if (recive.count == 0) {
                self.showBanner(title: "alert".localized, message: "enter_amount".localized, style: UIColor.INFO)
                self.cvAmount.backgroundColor = UIColor.app_red
                return false
            }
            
            let doublerecive = Double(recive)
            if (doublerecive == 0) {
                self.showBanner(title: "alert".localized, message: "enter_amount".localized, style: UIColor.INFO)
                self.cvAmount.backgroundColor = UIColor.app_red
                return false
            }
        }
        return true
    }
    
    func validateFields() {
        let amount = (self.fieldAmount.text ?? "").trim().replacedArabicDigitsWithEnglish
        let recive = (self.fieldRecive.text ?? "").trim().replacedArabicDigitsWithEnglish
        //  let promocode = (self.fieldPromotionCode.text ?? "").trim()
        
        if (self.selectedFeeValue ?? 0 == 0) {
            self.enableNext(flag: false)
            return
        }
        
        if (self.selectedDestinationCountry?.countryName?.count ?? 0 == 0) {
            self.enableNext(flag: false)
            return
        }
        
        if (amount.count == 0 && recive.isEmpty) {
            self.enableNext(flag: false)
            return
        }
        
        let doubleAmount = Double(amount)
        let doubleRecive = Double(recive)
        if (doubleAmount == 0 && doubleRecive == 0) {
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
    
    @IBAction func goBackHome(_ sender: Any) {
        goHomeWithConfirmation()
    }
    
    @IBAction func questionMarkButton(_ sender: Any) {
    
        //dev
//        let alert = UIAlertController(title: "!", message: "Enter the amount you need to send by JOD \n \n OR \n \n The amount you need to receive by destination country currency".localized, preferredStyle: UIAlertController.Style.alert)
//              alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//              self.present(alert, animated: true, completion: nil)


        let alert = EMAlertController(title: "", message: "Enter the amount you need to send by JOD \n \n OR \n \n The amount you need to receive by destination country currency".localized)
        let confirm = EMAlertAction(title: "OK".localized, style: .normal) {
        // Perform Action

        }
        alert.addAction(confirm)

        let icon = UIImage(named: "alert")

        alert.iconImage = icon
//        alert.titleText = "Sample Title"
        alert.messageColor = UIColor.black
        alert.cornerRadius = 20
        // Default corner radius = 5
        // Default color = UIColor.black
        present(alert, animated: true, completion: nil)



    }
    
}

extension mg_RemittanceInfoVC : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == self.fieldAmount) {
            self.fieldAmount.layer.borderColor = UIColor.card_focused_color.cgColor
            self.fieldRecive.layer.borderColor = UIColor.clear.cgColor
            self.selectedTransactionTypeValue = true
            App.shared.sendMoneyMG?.isSend = true
//            self.fieldRecive.text = ""
            self.fieldFeeType.text = ""
            self.feeTypeButton.isEnabled = true
            self.selectedFeeValue = 0
            self.feeTypeImageView.tintColor = .black
            validateFields()
        }else if (textField == self.fieldPromotionCode) {
            self.cvPromotionCode.backgroundColor = UIColor.card_focused_color
        }
        
        if (textField == self.fieldRecive) {
            self.fieldAmount.layer.borderColor = UIColor.clear.cgColor
            self.fieldRecive.layer.borderColor = UIColor.card_focused_color.cgColor
//            self.fieldAmount.text = ""
            self.fieldFeeType.text = self.feeTypes[0]
            self.selectedFee = self.feeTypes[0]
            self.selectedFeeValue = 1
            self.fieldFeeType.isEnabled = false
            self.feeTypeButton.isEnabled = false
            self.feeTypeImageView.tintColor = .gray
            self.selectedTransactionTypeValue = false
            App.shared.sendMoneyMG?.isSend = false
            
            validateFields()
        }else {
            self.fieldAmount.isEnabled = true

        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == self.fieldAmount) {
            self.cvAmount.backgroundColor = UIColor.card_color
        }else if (textField == self.fieldPromotionCode) {
            self.cvPromotionCode.backgroundColor = UIColor.card_color
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == self.fieldAmount) {
            self.fieldPromotionCode.becomeFirstResponder()
        }else if (textField == self.fieldPromotionCode) {
            self.fieldPromotionCode.resignFirstResponder()
        }
        return false
    }
}

extension mg_RemittanceInfoVC : MGCountryDelegate {
    func didSelectCountry(country: MGCountryDatum) {
        self.selectedDestinationCountry = country
        self.fieldDestinationCountry.text = country.countryName ?? ""
        let url = URL(string: "\(Constants.IMAGE_URL)\(country.flag ?? "")")
        ivDestinationCountry.kf.setImage(with: url, placeholder: UIImage(named: ""))
        self.cvDestinationCountry.backgroundColor = UIColor.card_color
//        self.AmountToReciveLabel.text = "Amount In  \(country.countryName ?? "")".localized
        self.AmountToReciveLabel.text = "Amount In".localized + " " + "\(country.countryName ?? "")"

        self.validateFields()
    }
}
