//
//  CorneredImage.swift
//  RunnersPay
//
//  Created by Zaid Khaled on 1/24/20.
//  Copyright © 2020 Technzone. All rights reserved.
//

import UIKit

@IBDesignable
class CorneredImage: UIImageView {
    
    @IBInspectable var cornerRadius: CGFloat = 8
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
    }
    
}
