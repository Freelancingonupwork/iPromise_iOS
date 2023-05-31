//
//  Manager.swift
//  iPromise
//
//  Created by Apple on 16/03/23.
//

import Foundation


class CompletePopupManager : NSObject{
    
    //MARK: -  variable
    fileprivate unowned var controller: CompletePopupVC
    fileprivate unowned var model: CompletePopupModel
    
    //MARK: -  intializer
    init(controller:CompletePopupVC, model:CompletePopupModel) {
        self.controller = controller
        self.model = model
    }
}
