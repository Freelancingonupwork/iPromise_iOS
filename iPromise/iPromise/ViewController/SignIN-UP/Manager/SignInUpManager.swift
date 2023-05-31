//
//  SignInManager.swift
//  iPromise
//
//  Created by Apple on 14/03/23.
//

import Foundation


class SignInUpManager : NSObject{
    
    //MARK: -  variable
    fileprivate unowned var controller: SignInUpVC
    fileprivate unowned var model: SignInUpModel
    
    //MARK: -  intializer
    init(controller:SignInUpVC, model:SignInUpModel) {
        self.controller = controller
        self.model = model
    }
    
}
