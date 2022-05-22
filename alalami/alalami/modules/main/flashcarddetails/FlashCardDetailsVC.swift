//
//  FlashCardDetailsVC.swift
//  alalami
//
//  Created by Zaid Khaled on 9/7/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit
import ImageTransition

class FlashCardDetailsVC: BaseVC {

    
    @IBOutlet weak var btnBack: UIButton!
    
    //content
    @IBOutlet weak var ivLogo: UIImageView!
    @IBOutlet weak var lblTitle: MyUILabel!
    @IBOutlet weak var tvContent: MyUITextView!
    
    //action
    @IBOutlet weak var cvAction: CardView!
    @IBOutlet weak var btnAction: MyUIButton!
    
    var flashCard : FlashCardDatum?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if (isArabic()) {
            btnBack.setImage(UIImage(named: "ic_back_ar"), for: .normal)
        }
        
        self.lblTitle.text = flashCard?.title ?? ""
        self.tvContent.text = flashCard?.datumDescription ?? ""
        
        let url = URL(string: "\(Constants.IMAGE_URL)\(flashCard?.innerImage ??  "")")
        self.ivLogo.kf.setImage(with: url, placeholder: UIImage(named: "flashcard_placeholder"))
        
    }

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionClick(_ sender: Any) {
        
    }
}
extension FlashCardDetailsVC: ImageTransitionable {
    var imageViewForTransition: UIImageView? {
        return self.ivLogo
    }
}
