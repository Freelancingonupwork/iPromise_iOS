//
//  ViewController.swift
//  iPromise
//
//  Created by Apple on 13/03/23.
//

import UIKit
import RswiftResources


class ViewController: UIViewController {
    
    lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.type = .axial
        gradient.colors = [
            UIColor.hexToColor(hex: "#52C6E0").cgColor,
            UIColor.hexToColor(hex: "#4CBCFB").cgColor,
            UIColor.hexToColor(hex: "#4C8EFB").cgColor,
            UIColor.hexToColor(hex: "#5187FB").cgColor,
            UIColor.hexToColor(hex: "#4E84F9").cgColor,
            UIColor.hexToColor(hex: "#5BA9F1").cgColor,
            UIColor.hexToColor(hex: "#7DFDDC").withAlphaComponent(0.4).cgColor,
            UIColor.hexToColor(hex: "#58FDF3").cgColor,
        ]
        gradient.locations = [0, 0.1,0.2,0.3,0.4, 0.5]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        
        return gradient
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
       
        gradient.frame = view.bounds
        view.layer.addSublayer(gradient)
    }
    

    
}


extension UIColor {
   class func hexToColor (hex:String) -> UIColor {
       var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

       if (cString.hasPrefix("#")) {
           cString.remove(at: cString.startIndex)
       }

       if ((cString.count) != 6) {
           return UIColor.gray
       }

       var rgbValue:UInt64 = 0
       Scanner(string: cString).scanHexInt64(&rgbValue)

       return UIColor(
           red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
           green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
           blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
           alpha: CGFloat(1.0)
       )
   }
}
