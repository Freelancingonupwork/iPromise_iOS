//
//  UIView+Extension.swift
//  iPromise
//
//  Created by Apple on 14/03/23.
//

import UIKit

extension UIView {
    
    func setShadow(borderColor : UIColor? = color.grayColor(),corner : CGFloat? = 15){
        self.clipsToBounds = true
        self.backgroundColor = color.whiteColor()
        self.layer.cornerRadius = corner ?? 15
        self.layer.borderColor = borderColor?.cgColor ?? color.grayColor()?.cgColor
        self.layer.borderWidth = 1
        
        self.layer.shadowColor = color.blackColor()?.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 5
    }
    
    func makeCorner(corner : CGFloat? = 25){
        self.clipsToBounds = true
        self.layer.cornerRadius = corner ?? 25
    }
    
    func makeRound(){
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.size.height/2
    }

    
    func setTopCorner(radius : CGFloat){
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    func setBottomCorner(radius : CGFloat){
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
}
