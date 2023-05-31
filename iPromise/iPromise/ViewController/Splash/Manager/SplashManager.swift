//
//  SplashManager.swift
//  iPromise
//
//  Created by Apple on 14/03/23.
//

import Foundation

class SplashManager : NSObject{
    
    //MARK: -  variable
    fileprivate unowned var controller: SplashVC
    fileprivate unowned var model: SplashModel
    
    //MARK: -  intializer
    init(controller:SplashVC, model:SplashModel) {
        self.controller = controller
        self.model = model
    }
    
}
