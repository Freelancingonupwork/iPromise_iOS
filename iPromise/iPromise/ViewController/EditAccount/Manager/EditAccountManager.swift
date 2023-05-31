//
//  Manager.swift
//  iPromise
//
//  Created by Apple on 16/03/23.
//

import Foundation


class EditAccountManager : NSObject{
    
    //MARK: -  variable
    fileprivate unowned var controller: EditAccountVC
    fileprivate unowned var model: EditAccountModel
    
    //MARK: -  intializer
    init(controller:EditAccountVC, model:EditAccountModel) {
        self.controller = controller
        self.model = model
    }
}
