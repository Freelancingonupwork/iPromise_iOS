//
//  Manager.swift
//  iPromise
//
//  Created by Apple on 16/03/23.
//

import Foundation


class WebviewManager : NSObject{
    
    //MARK: -  variable
    fileprivate unowned var controller: WebviewVC
    fileprivate unowned var model: WebviewModel
    
    //MARK: -  intializer
    init(controller:WebviewVC, model:WebviewModel) {
        self.controller = controller
        self.model = model
    }
}
