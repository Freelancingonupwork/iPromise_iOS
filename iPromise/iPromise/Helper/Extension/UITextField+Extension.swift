//
//  UITextField+Extension.swift
//  iPromise
//
//  Created by Apple on 14/03/23.
//

import UIKit


extension UITextField {
 
  
    func setAttributeText(  placeHolderString : String) -> NSAttributedString
    {
        let attributes = [
            NSAttributedString.Key.foregroundColor: color.grayColor() as Any ,
            NSAttributedString.Key.font : UIFont.customFont(font: .regular, size: 16)
        ] as [NSAttributedString.Key : Any]
        return NSAttributedString(string:placeHolderString, attributes:attributes)
    }
  
    
}
