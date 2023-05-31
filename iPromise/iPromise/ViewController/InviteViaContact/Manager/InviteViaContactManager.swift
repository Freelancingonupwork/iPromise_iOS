//
//  Manager.swift
//  iPromise
//
//  Created by Apple on 16/03/23.
//

import Foundation


class InviteViaContactManager : NSObject{
    //MARK: -  variable
    fileprivate unowned var controller: InviteViaContactVC
    fileprivate unowned var model: InviteViaContactModel
    
    //MARK: -  intializer
    init(controller:InviteViaContactVC, model:InviteViaContactModel) {
        self.controller = controller
        self.model = model
    }
}
