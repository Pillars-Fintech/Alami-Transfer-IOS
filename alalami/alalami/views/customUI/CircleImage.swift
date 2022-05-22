//
//  CircleImage.swift
//  ababk
//
//  Created by Zaid Khaled on 8/1/19.
//  Copyright © 2019 technzone. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CircleImage : UIImageView {
    override func layoutSubviews() {
        self.layer.cornerRadius = self.bounds.width / 2.0
    }
}
