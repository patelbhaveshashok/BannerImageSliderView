//
//  ShimmerImageView.swift
//  BannerImageSlider
//
//  Created by Bhavesh Patel on 07/04/21.
//

import UIKit

class ShimmerImageView: UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension UIView {
    
    func configureShimmerAndShow() {
        backgroundColor = UIColor(red:245/255, green:245/255, blue:245/255, alpha:1)
        startShimmering()
    }
    
    func startShimmering() {
        let lightColor = UIColor(white: 0, alpha: 0.1).cgColor
        let darkColor = UIColor.black.cgColor

        let effectgGadient = CAGradientLayer()
        effectgGadient.colors = [darkColor, lightColor, darkColor]
        effectgGadient.frame = CGRect(x: -bounds.size.width, y: 0, width: 3 * bounds.size.width, height: bounds.size.height)

        effectgGadient.startPoint = CGPoint(x: 0.0, y: 0.5)
        effectgGadient.endPoint   = CGPoint(x: 1.0, y: 0.525)
        effectgGadient.locations  = [0.4, 0.5, 0.6]

        layer.mask = effectgGadient

        let basicAnimation: CABasicAnimation = CABasicAnimation.init(keyPath: "locations")
        basicAnimation.fromValue = [0.0, 0.1, 0.2]
        basicAnimation.toValue   = [0.8, 0.9, 1.0]

        basicAnimation.duration = 1.5
        basicAnimation.repeatCount = Float.greatestFiniteMagnitude
        basicAnimation.isRemovedOnCompletion = false

        effectgGadient.add(basicAnimation, forKey: "shimmer")
    }
    func stopShimmering() {
        backgroundColor = .white
        layer.mask = nil
    }
}
