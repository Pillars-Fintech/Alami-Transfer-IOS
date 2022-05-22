//
//  MailDetailsVC.swift
//  alalami
//
//  Created by Zaid Khaled on 10/1/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit

class MailDetailsVC: BaseVC {
    
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var lblSubject: MyUILabel!
    @IBOutlet weak var lblDate: MyUILabel!
    
    @IBOutlet weak var tvBody: MyUITextView!
    
    var mail : MailDatum?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (isArabic()) {
            btnBack.setImage(UIImage(named: "ic_back_ar"), for: .normal)
        }
        
        self.lblSubject.text = self.mail?.emailSubject ?? ""
        self.lblDate.text = self.getStringDateWithFormat(dateStr: self.mail?.sendDate ?? "", outputFormat: Constants.DATE_FORMATS.dd_mm_yyyy_hh_mm_a)
        self.tvBody.setHTMLFromString(htmlText: self.mail?.body ?? "")
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
