//
//  File.swift
//  iPromise
//
//  Created by Apple on 21/03/23.
//

import SwiftyJSON

class FilterModel  {
    //MARK: - variable
    private unowned var controller : FilterVC
    var arrStatusItems = [String]()
    var arrCategory = [JSON]()
    var arrSubCategory = [JSON]()
    
    //MARK: -  initializer
    init(controller:FilterVC) {
        self.controller = controller
    }

}
