//
//  MyUIButton.swift
//  rzq
//
//  Created by Zaid najjar on 3/31/19.
//  Copyright © 2019 technzone. All rights reserved.
//

import Foundation
import UIKit
import MOLH

@IBDesignable
class MyUIButton : UIButton {
    @IBInspectable var font_type: String = "15,1" {
        didSet {
            let result = font_type.split(separator: ",")
            let strSize = String(result[0])
            let fontSize: CGFloat = CGFloat((strSize as NSString).doubleValue)
            let fontType = String(result[1])
            if (MOLHLanguage.currentAppleLanguage() == "ar") {
                switch fontType {
                case "1"://light
                    self.titleLabel?.font = UIFont(name: "\(Constants.ARABIC_LIGHT)", size: (fontSize))
                    break
                case "2"://regular
                    self.titleLabel?.font = UIFont(name: "\(Constants.ARABIC_REGULAR)", size: (fontSize))
                    break
                case "3"://medium
                    self.titleLabel?.font = UIFont(name: "\(Constants.ARABIC_MEDIUM)", size: (fontSize))
                    break
                case "4"://semibold
                    self.titleLabel?.font = UIFont(name: "\(Constants.ARABIC_SEMIBOLD)", size: (fontSize))
                    break
                case "5"://bold
                    self.titleLabel?.font = UIFont(name: "\(Constants.ARABIC_BOLD)", size: (fontSize))
                    break
                default:
                    self.titleLabel?.font = UIFont(name: "\(Constants.ARABIC_REGULAR)", size: (fontSize))
                    break
                }
            }else {
                switch fontType {
                case "1"://light
                    self.titleLabel?.font = UIFont(name: "\(Constants.ENGLISH_LIGHT)", size: (fontSize))
                    break
                case "2"://regular
                    self.titleLabel?.font = UIFont(name: "\(Constants.ENGLISH_REGULAR)", size: (fontSize))
                    break
                case "3"://medium
                    self.titleLabel?.font = UIFont(name: "\(Constants.ENGLISH_MEDIUM)", size: (fontSize))
                    break
                case "4"://semibold
                    self.titleLabel?.font = UIFont(name: "\(Constants.ENGLISH_SEMIBOLD)", size: (fontSize))
                    break
                case "5"://bold
                    self.titleLabel?.font = UIFont(name: "\(Constants.ENGLISH_BOLD)", size: (fontSize))
                    break
                default:
                    self.titleLabel?.font = UIFont(name: "\(Constants.ENGLISH_REGULAR)", size: (fontSize))
                    break
                }
            }
            
        }
    }
}
