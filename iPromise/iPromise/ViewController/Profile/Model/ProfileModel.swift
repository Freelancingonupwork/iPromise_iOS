//
//  Model.swift
//  iPromise
//
//  Created by Apple on 16/03/23.
//

import SwiftyJSON

class ProfileModel  {
    //MARK: - variable
    private unowned var controller : ProfileVC
    var arrPromise = [JSON]()
    
    
    //MARK: -  initializer
    init(controller:ProfileVC) {
        self.controller = controller
    }
    
}
