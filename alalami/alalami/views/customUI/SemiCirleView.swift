//
//  SemiCirleView.swift
//  EasyCar
//
//  Created by Zaid Khaled on 3/20/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit

@IBDesignable
class SemiCirleView: UIView {

    var semiCirleLayer: CAShapeLayer!

    override func layoutSubviews() {
        super.layoutSubviews()

        if semiCirleLayer == nil {
            let arcCenter = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
            let circleRadius = bounds.size.width / 2
            let circlePath = UIBezierPath(arcCenter: arcCenter, radius: circleRadius, startAngle: CGFloat.pi * 2, endAngle: CGFloat.pi, clockwise: true)

            semiCirleLayer = CAShapeLayer()
            semiCirleLayer.path = circlePath.cgPath
            layer.addSublayer(semiCirleLayer)

            // Make the view color transparent
            backgroundColor = UIColor.clear
        }
    }
}
