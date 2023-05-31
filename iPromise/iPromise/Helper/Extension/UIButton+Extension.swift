//
//  UIButton+Extension.swift
//  iPromise
//
//  Created by Apple on 14/03/23.
//

import UIKit

extension UIButton{
    func setDarkButton(BGcolor : UIColor? = color.primaryColor(), font : UIFont? = UIFont.customFont(font: .bold, size: 16)){
        self.layer.cornerRadius = 16
        self.backgroundColor = BGcolor ?? color.primaryColor()
        self.titleLabel?.font = font ?? UIFont.customFont(font: .bold, size: 16)
        self.setTitleColor(color.whiteColor(), for: .normal)
        self.isUserInteractionEnabled = true
    }
    
    func setLightButton(BGcolor : UIColor? = .clear, font : UIFont? = UIFont.customFont(font: .bold, size: 16), titleColor : UIColor? = color.primaryColor()){
        self.layer.cornerRadius = 16
        self.backgroundColor = BGcolor
        self.titleLabel?.font = font ?? UIFont.customFont(font: .bold, size: 16)
        self.setTitleColor(titleColor, for: .normal)
    }
    
    func setDisableButton(){
        self.layer.cornerRadius = 16
        self.backgroundColor = color.grayColor()
        self.titleLabel?.font = UIFont.customFont(font: .bold, size: 16)
        self.setTitleColor(.darkGray, for: .normal)
        self.isUserInteractionEnabled = false
    }
    
    func setBorderButton(borderColor : UIColor? = color.grayColor(), textColor : UIColor? = color.blackColor(), cornerRadius : CGFloat){
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = 1
        self.layer.borderColor = borderColor?.cgColor //color.grayColor()?.cgColor
        self.titleLabel?.font = UIFont.customFont(font: .bold, size: 16)
        self.setTitleColor(textColor, for: .normal)
        self.backgroundColor = .clear
    }
    
    func setGradientFontColor(){
        let image = R.image.gradientBackground()
        image?.resizableImage(withCapInsets: .zero, resizingMode: .tile)
        self.setTitleColor(UIColor(patternImage: R.image.gradientBackground()!), for: .normal)
       
    }
    func setGradientBackground(){
        self.backgroundColor = UIColor(patternImage: R.image.gradientBackground()!)
        self.layer.masksToBounds = true
        self.setTitleColor(.white, for: .normal)
    }
    
    func setRightSideImage(){
        self.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        self.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        self.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)

    }
}
