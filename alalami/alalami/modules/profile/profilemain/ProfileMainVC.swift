//
//  ProfileMainVC.swift
//  alalami
//
//  Created by Zaid Khaled on 10/1/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit

class ProfileMainVC: BaseVC {

    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var lblFullName: UILabel!
    
    @IBOutlet weak var ivCard: UIImageView!
    
    @IBOutlet weak var CardName: UILabel!
    
    @IBOutlet weak var cardDate: UILabel!
    
    @IBOutlet weak var cardNubmer: UILabel!
    
    //indicators
    @IBOutlet weak var ivIndicator1: UIImageView!
    @IBOutlet weak var ivIndicator2: UIImageView!
    @IBOutlet weak var ivIndicator3: UIImageView!
    @IBOutlet weak var ivIndicator4: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblFullName.textAlignment = .natural

        
        if (isArabic()) {
            btnBack.setImage(UIImage(named: "ic_back_ar"), for: .normal)
            ivIndicator1.image = UIImage(named: "ic_indicator_ar")
            ivIndicator2.image = UIImage(named: "ic_indicator_ar")
            ivIndicator3.image = UIImage(named: "ic_indicator_ar")
            ivIndicator4.image = UIImage(named: "ic_indicator_ar")
                    
        }
        
        if(isArabic()){
            lblFullName.textAlignment = .right
        }else{
            
            lblFullName.textAlignment = .left

        }
        
        lblFullName.text = getUserFullName()
        CardName.text = getUserFullName()
        
        naturalText()

        
        ivCard.clipsToBounds = false
        ivCard.layer.shadowColor = UIColor.black.cgColor
        ivCard.layer.shadowOpacity = 0.1
        ivCard.layer.shadowOffset = CGSize.zero
        ivCard.layer.shadowRadius = 1
    }
   
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func personalInformationAction(_ sender: Any) {
        self.pushVC(name: "PersonalInformationVC", sb: Constants.STORYBOARDS.profile)
    }
    
    @IBAction func identificationDetailsAction(_ sender: Any) {
        self.pushVC(name: "IdentificationDetailsVC", sb: Constants.STORYBOARDS.profile)
    }
    
    @IBAction func contactInformationAction(_ sender: Any) {
        self.pushVC(name: "ContactInformationVC", sb: Constants.STORYBOARDS.profile)
    }
    
    @IBAction func changePasswordAction(_ sender: Any) {
        self.pushVC(name: "ChangePasswordVC", sb: Constants.STORYBOARDS.more)
    }
    
    @IBAction func orderCardAction(_ sender: Any) {
        self.showBanner(title: "alert".localized, message: "coming_soon".localized, style: UIColor.SUCCESS)
        
//        06-5504545
    }
    
    func naturalText(){
        CardName.textAlignment = .natural
        cardNubmer.textAlignment = .natural
        cardDate.textAlignment = .natural

    }
    
}
