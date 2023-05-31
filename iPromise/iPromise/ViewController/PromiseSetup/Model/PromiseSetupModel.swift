//
//  File.swift
//  iPromise
//
//  Created by Apple on 21/03/23.
//

import SwiftyJSON
import Foundation



class PromiseSetupModel  {
    //MARK: - variable
    private unowned var controller : PromiseSetupVC
    var arrMember = [JSON]()
    
    //MARK: -  initializer
    init(controller:PromiseSetupVC) {
        self.controller = controller
        getUser()
    }
    
    func getUser(){
        guard let data = Utils.getDataFromLocal(.userData) as? Data else { return  }
        let userDetail = JSON(data)
        arrMember.append(userDetail)
    }
    
}
