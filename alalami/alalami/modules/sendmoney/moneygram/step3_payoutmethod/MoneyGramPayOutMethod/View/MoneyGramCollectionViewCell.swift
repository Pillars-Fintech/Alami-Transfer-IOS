//
//  MoneyGramCollectionViewCell.swift
//  alalami
//
//  Created by Osama Abu Hdba on 11/11/2021.
//  Copyright © 2021 technzone. All rights reserved.
//

import UIKit

class MoneyGramCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: MyUILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 20
        imageView.contentMode = .scaleAspectFit
    }
}
