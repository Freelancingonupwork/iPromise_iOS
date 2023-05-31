//
//  Manager.swift
//  iPromise
//
//  Created by Apple on 15/03/23.
//

import Foundation

class NameManager : NSObject{
    
    //MARK: -  variable
    fileprivate unowned var controller: NameVC
    fileprivate unowned var model: NameModel

    
    //MARK: -  intializer
    init(controller:NameVC, model:NameModel) {
        self.controller = controller
        self.model = model
    }

}

