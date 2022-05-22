//
//  ArabicCollectionFlow.swift
//  iHospital
//
//  Created by Zaid Khaled on 6/19/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation
import MOLH

class ArabicCollectionFlow: UICollectionViewFlowLayout {
  override var flipsHorizontallyInOppositeLayoutDirection: Bool {
    scrollDirection = .horizontal
    return MOLHLanguage.currentAppleLanguage() == "ar"
  }
}
