//
//  File.swift
//  iPromise
//
//  Created by Apple on 21/03/23.
//


import SwiftyJSON


class PromiseSubCategoryModel  {
    
    //MARK: - variable
    private unowned var controller : PromiseSubCategoryVC
    var arrSubCategory = [JSON]()
    
    //MARK: -  initializer
    init(controller:PromiseSubCategoryVC) {
        self.controller = controller
    }
//    
}
