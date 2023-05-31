//
//  File.swift
//  iPromise
//
//  Created by Apple on 21/03/23.
//


import SwiftyJSON


class PromiseCategoryModel  {
    //MARK: - variable
    private unowned var controller : PromiseCategoryVC
    var arrCategory = [JSON]()
    
    //MARK: -  initializer
    init(controller:PromiseCategoryVC) {
        self.controller = controller
    }
    
}
