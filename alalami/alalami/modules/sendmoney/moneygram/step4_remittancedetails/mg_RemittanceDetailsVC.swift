//
//  mg_RemittanceDetailsVC.swift
//  alalami
//
//  Created by Zaid Khaled on 9/8/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit
import DropDown

class mg_RemittanceDetailsVC: BaseVC, UINavigationControllerDelegate {
    @IBOutlet weak var lSupporting: MyUILabel!
    
    @IBOutlet weak var btnBack: UIButton!
    
    //purpose
    @IBOutlet weak var cvPurpose: CardView!
    @IBOutlet weak var fieldPurpose: MyUITextField!
    var purposes = [MGReasonOfTransferDatum]()
    var purposesDropDown : DropDown?
    var selectedPurpose : MGReasonOfTransferDatum?
    
    //relationship
    @IBOutlet weak var cvRelationship: CardView!
    @IBOutlet weak var fieldRelationship: MyUITextField!
    var relationships = [MGRelationToReceiverDatum]()
    var relationsDropDown : DropDown?
    var selectedRelation : MGRelationToReceiverDatum?
    
    //source of fund
    @IBOutlet weak var cvSourceOfFund: CardView!
    @IBOutlet weak var fieldSourceOfFund: MyUITextField!
    var sources = [MGSourceOfFundsDatum]()
    var sourcesDropDown : DropDown?
    var selectedSource : MGSourceOfFundsDatum?
    
    
    //document
    @IBOutlet weak var ivDocument: CorneredImage!
    var documentImage : UIImage?
    
    //image picker
    var imagePicker: UIImagePickerController!
    enum ImageSource {
        case photoLibrary
        case camera
    }
    func selectImageFrom(_ source: ImageSource) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        switch source {
        case .camera:
            imagePicker.sourceType = .camera
        case .photoLibrary:
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    //action
    @IBOutlet weak var cvContinue: CardView!
    @IBOutlet weak var btnContinue: MyUIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (isArabic()) {
            btnBack.setImage(UIImage(named: "ic_back_ar"), for: .normal)
        }
        
        if (isArabic()) {
            lSupporting.textAlignment = .right
        }else{
            lSupporting.textAlignment = .left

        }
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    private func showWarningMessage() {
        var message = App.shared.config?.moneyGramSettings?.fraudWarningEn ?? ""
        if (self.isArabic()) {
            message = App.shared.config?.moneyGramSettings?.fraudWarningAr ?? ""
        }
        
        showAlert(title: "warning".localized, message: message, buttonText: "ok".localized) {
            self.fillData()
            self.pushVC(name: "mg_ReceiverInfoVC", sb: Constants.STORYBOARDS.money_gram)
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectPurposeAction(_ sender: Any) {
        self.showLoading()
        self.getApiManager().getMGReasonsOfTransfer(token: self.getAccessToken()) { (response) in
            self.hideLoading()
            self.purposesDropDown = DropDown()
            self.purposesDropDown?.anchorView = self.cvPurpose
            var arr = [String]()
            self.purposes.removeAll()
            self.purposes.append(contentsOf: response.data ?? [MGReasonOfTransferDatum]())
            for item in self.purposes {
                arr.append(item.reasonOfTransferName ?? "")
            }
            self.purposesDropDown?.dataSource = arr
            self.purposesDropDown?.show()
            
            self.purposesDropDown?.selectionAction = { [unowned self] (index: Int, item: String) in
                self.selectedPurpose = self.purposes[index]
                self.fieldPurpose.text = self.selectedPurpose?.reasonOfTransferName ?? ""
                self.cvPurpose.backgroundColor = UIColor.card_color
                self.validateFields()
            }
        }
    }
    
    @IBAction func selectRelationshipAction(_ sender: Any) {
        self.showLoading()
        self.getApiManager().getMGRelationToReceiver(token: self.getAccessToken()) { (response) in
            self.hideLoading()
            self.relationsDropDown = DropDown()
            self.relationsDropDown?.anchorView = self.cvRelationship
            var arr = [String]()
            self.relationships.removeAll()
            self.relationships.append(contentsOf: response.data ?? [MGRelationToReceiverDatum]())
            for item in self.relationships {
                arr.append(item.relationshipsName ?? "")
            }
            self.relationsDropDown?.dataSource = arr
            self.relationsDropDown?.show()
            
            self.relationsDropDown?.selectionAction = { [unowned self] (index: Int, item: String) in
                self.selectedRelation = self.relationships[index]
                self.fieldRelationship.text = self.selectedRelation?.relationshipsName ?? ""
                self.cvRelationship.backgroundColor = UIColor.card_color
                self.validateFields()
            }
        }
    }
    
    @IBAction func selectSourceOfFundAction(_ sender: Any) {
        self.showLoading()
        self.getApiManager().getMGSourceOfFunds(token: self.getAccessToken()) { (response) in
            self.hideLoading()
            self.sourcesDropDown = DropDown()
            self.sourcesDropDown?.anchorView = self.cvSourceOfFund
            var arr = [String]()
            self.sources.removeAll()
            self.sources.append(contentsOf: response.data ?? [MGSourceOfFundsDatum]())
            for item in self.sources {
                arr.append(item.sourceOfFundName ?? "")
            }
            self.sourcesDropDown?.dataSource = arr
            self.sourcesDropDown?.show()
            
            self.sourcesDropDown?.selectionAction = { [unowned self] (index: Int, item: String) in
                self.selectedSource = self.sources[index]
                self.fieldSourceOfFund.text = self.selectedSource?.sourceOfFundName ?? ""
                self.cvSourceOfFund.backgroundColor = UIColor.card_color
                self.validateFields()
            }
        }
    }
    
    func validate() -> Bool {
        if (self.selectedPurpose?.reasonOfTransferName?.count ?? 0 == 0) {
            self.showBanner(title: "alert".localized, message: "select_reason_of_transfer".localized, style: UIColor.INFO)
            cvPurpose.backgroundColor = UIColor.app_red
            return false
        }
        if (self.selectedRelation?.relationshipsName?.count ?? 0 == 0) {
            self.showBanner(title: "alert".localized, message: "select_relationship_to_receiver".localized, style: UIColor.INFO)
            cvRelationship.backgroundColor = UIColor.app_red
            return false
        }
        if (self.selectedSource?.sourceOfFundName?.count ?? 0 == 0) {
            self.showBanner(title: "alert".localized, message: "select_source_of_fund".localized, style: UIColor.INFO)
            cvSourceOfFund.backgroundColor = UIColor.app_red
            return false
        }
        return true
    }
    
    func validateFields() {
        if (self.selectedPurpose?.reasonOfTransferName?.count ?? 0 == 0) {
            self.enableNext(flag: false)
            return
        }
        if (self.selectedRelation?.relationshipsName?.count ?? 0 == 0) {
            self.enableNext(flag: false)
            return
        }
        if (self.selectedSource?.sourceOfFundName?.count ?? 0 == 0) {
            self.enableNext(flag: false)
            return
        }
        self.enableNext(flag: true)
    }
    
    
    func showImagePickerAlert() {
        self.showAlertWithCancel(title: "add_image_pic_title".localized, message: "add_image_pic_message".localized, actionTitle: "camera".localized, cancelTitle: "gallery".localized, actionHandler: {
            //camera
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                self.selectImageFrom(.photoLibrary)
                return
            }
            self.selectImageFrom(.camera)
        }) {
            //gallery
            self.imagePicker =  UIImagePickerController()
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func selectDocumentAction(_ sender: Any) {
        self.showImagePickerAlert()
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
    
    @IBAction func continueAction(_ sender: Any) {
        if (self.validate()) {
            showWarningMessage()
        }
    }
    
    func fillData() {
        if (App.shared.sendMoneyMG == nil) {
            App.shared.sendMoneyMG = SendMoneyMGModel()
        }
        App.shared.sendMoneyMG?.selectedReasonOfTransfer = self.selectedPurpose
        App.shared.sendMoneyMG?.selectedRelationship = self.selectedRelation
        App.shared.sendMoneyMG?.selectedSourceOfFund = self.selectedSource
        App.shared.sendMoneyMG?.supportDocument = self.documentImage
    }
    
}

extension mg_RemittanceDetailsVC: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not found!")
            return
        }
        self.documentImage = selectedImage
        self.ivDocument.image = selectedImage
        self.validateFields()
    }
}
