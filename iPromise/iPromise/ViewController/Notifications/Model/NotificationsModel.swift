//
//  Model.swift
//  iPromise
//
//  Created by Apple on 16/03/23.
//

import SwiftyJSON

class NotificationsModel  {
    //MARK: - variable
    private unowned var controller : NotificationsVC
    var arrNotification = [JSON]()
    
    //MARK: -  initializer
    init(controller:NotificationsVC) {
        self.controller = controller
    }
    
}
