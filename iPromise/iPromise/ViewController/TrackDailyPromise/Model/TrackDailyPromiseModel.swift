//
//  Model.swift
//  iPromise
//
//  Created by Apple on 16/03/23.
//

import SwiftyJSON

class TrackDailyPromiseModel  {
    
//    MARK: - variable
    private unowned var controller : TrackDailyPromiseVC
    var arrPromises = [JSON]()
    
    //MARK: -  initializer
    init(controller:TrackDailyPromiseVC) {
        self.controller = controller
    }
    
}
