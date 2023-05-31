//
//  File.swift
//  iPromise
//
//  Created by Apple on 21/03/23.
//

import SwiftyJSON

class PromiseDetailModel  {
    //MARK: - variable
    private unowned var controller : PromiseDetailVC
    var arrMembers = [JSON]()
    var arrMaker = [JSON]()
    
    //MARK: -  initializer
    init(controller:PromiseDetailVC) {
        self.controller = controller
    }
    
}
