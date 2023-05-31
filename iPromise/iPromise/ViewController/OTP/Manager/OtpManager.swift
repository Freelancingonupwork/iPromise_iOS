//
//  OtpManager.swift
//  iPromise
//
//  Created by Apple on 15/03/23.
//

import Foundation

class OtpManager : NSObject{
    
    //MARK: -  variable
    fileprivate unowned var controller: OtpVC
    fileprivate unowned var model: OtpModel
    
    //MARK: -  intializer
    init(controller:OtpVC, model:OtpModel) {
        self.controller = controller
        self.model = model
    }

}

//MARK: -  otpview delegate
extension OtpManager: OTPDelegate {
    
    func didChangeValidity(isValid: Bool) {
        controller.setVeriryActiveDeactive(bool : isValid)
    }
    
}

