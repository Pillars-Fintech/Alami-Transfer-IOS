//
//  HomeActionCell.swift
//  alalami
//
//  Created by Zaid Khaled on 10/26/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit

class HomeActionCell: UICollectionViewCell {
    
    @IBOutlet weak var cvContent: CardView!
    
    @IBOutlet weak var ivLogo: UIImageView!
    
    @IBOutlet weak var lblTitle: MyUILabel!
    
    
    override var isHighlighted: Bool{
        didSet{
            if isHighlighted{
                self.cvContent.backgroundColor = UIColor.app_red
                self.ivLogo.setImageColor(color: UIColor.white)
                self.lblTitle.textColor = UIColor.white
            }else{
                self.cvContent.backgroundColor = UIColor.white
                self.ivLogo.setImageColor(color: UIColor.text_dark)
                self.lblTitle.textColor = UIColor.text_dark
            }
        }
    }
    
}
