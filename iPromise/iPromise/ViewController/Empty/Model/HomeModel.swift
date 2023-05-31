//
//  Model.swift
//  iPromise
//
//  Created by Apple on 15/03/23.
//

import SwiftyJSON

class HomeModel  {
    //MARK: - variable
    private unowned var controller : HomeVC
    var arrPromise = [JSON]()
    
    //MARK: -  initializer
    init(controller:HomeVC) {
        self.controller = controller
    }
    
}
