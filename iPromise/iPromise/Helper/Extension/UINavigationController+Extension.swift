//
//  UINavigationController+Extension.swift
//  iPromise
//
//  Created by Apple on 15/03/23.
//

import UIKit


extension UINavigationController{
    
    open override func viewDidLoad() {
        setNavigationBar()
    }
    
    func setNavigationBar(foreGroundColor : UIColor? = color.blackColor() ){
        if #available(iOS 13.0, *) {
            let titleFont = UIFont.customFont(font: .bold, size: 22)
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: foreGroundColor ?? color.blackColor() ?? .black, NSAttributedString.Key.font: titleFont]
            navBarAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: foreGroundColor ?? color.blackColor() ?? .black, NSAttributedString.Key.font: titleFont]
            navBarAppearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: foreGroundColor ?? color.grayColor]
            navBarAppearance.doneButtonAppearance.normal.titleTextAttributes = [.foregroundColor: foreGroundColor ?? color.grayColor]
            navBarAppearance.shadowColor = .clear
            navBarAppearance.backgroundColor = .clear
            navigationBar.standardAppearance = navBarAppearance
            navigationBar.scrollEdgeAppearance = navBarAppearance
            navigationBar.compactAppearance = navBarAppearance
        } else {
            
        }
        
        navigationBar.tintColor = color.grayColor()
        navigationBar.isTranslucent = true
        navigationBar.prefersLargeTitles = false
    }
}

