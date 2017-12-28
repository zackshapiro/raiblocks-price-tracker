//
//  UIColor+Extension.swift
//  Rai
//
//  Created by Zack Shapiro on 12/4/17.
//  Copyright © 2017 Zack Shapiro. All rights reserved.
//

import UIKit


extension UIColor {

    class func from(rgb: UInt32) -> UIColor {
        return UIColor(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    class func from(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0)
    }

    func lighterColor(percent: Double) -> UIColor {
        return colorWithBrightnessFactor(factor: CGFloat(1 + percent))
    }

    func darkerColor(percent: Double) -> UIColor {
        return colorWithBrightnessFactor(factor: CGFloat(1 - percent))
    }

    private func colorWithBrightnessFactor(factor: CGFloat) -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: hue, saturation: saturation, brightness: brightness * factor, alpha: alpha)
        } else {
            return self
        }
    }

}

