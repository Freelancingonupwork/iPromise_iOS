//
//  Model.swift
//  iPromise
//
//  Created by Apple on 16/03/23.
//

import SwiftyJSON

class PromisePopupModel  {
    //MARK: - variable
    private unowned var controller : PromisePopupVC
    var arrPromises = [JSON]() 
    
    //MARK: -  initializer
    init(controller:PromisePopupVC) {
        self.controller = controller
    }
    
}
