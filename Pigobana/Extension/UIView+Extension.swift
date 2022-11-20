//
//  UIView+Extension.swift
//  Pigobana
//
//  Created by Saba Khitaridze on 26.09.22.
//

import UIKit

extension UIView {
    
    func setGradient(maskLayer: CAGradientLayer, forPlayer player: Int) {
        self.layer.cornerRadius = 30
        self.layer.maskedCorners = player == 1 ? [.topLeft, .topRight] : [.bottomLeft, .bottomRight]
        maskLayer.frame = self.bounds
        maskLayer.colors = player == 1 ? [ColorKey.clear, ColorKey.black] : [ColorKey.black, ColorKey.clear]
        maskLayer.locations = player == 1 ? [0, 0.3] : [0.7, 1]
        self.layer.mask = maskLayer
    }
    
    func setCurvedFrame() {
        self.layer.cornerRadius = 9
        self.layer.borderColor = ColorKey.white
        self.layer.borderWidth = (self.frame.width) / 30
    }
    
    func removeCurvedFrame() {
        self.backgroundColor = nil
        self.layer.cornerRadius = 0
        self.layer.borderColor = ColorKey.clear
        self.layer.borderWidth = 0
    }
}
