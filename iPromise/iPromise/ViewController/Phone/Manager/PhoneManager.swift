//
//  PhoneManager.swift
//  iPromise
//
//  Created by Apple on 14/03/23.
//

import Foundation
import JNPhoneNumberView

class PhoneManager : NSObject{
    //MARK: -  variable
    fileprivate unowned var controller: PhoneVC
    fileprivate unowned var model: PhoneModel
 
    //MARK: -  intializer

    init(controller:PhoneVC, model:PhoneModel) {
        self.controller = controller
        self.model = model
    }

}
//MARK: - JN number view delegate
extension PhoneManager: JNPhoneNumberViewDelegate {
    
   
    func phoneNumberView(getPresenterViewControllerFor phoneNumberView: JNPhoneNumberView) -> UIViewController {
        return controller
    }
 
    func phoneNumberView(getCountryPickerAttributesFor phoneNumberView: JNPhoneNumberView) -> JNCountryPickerConfiguration {
        let configuration = JNCountryPickerConfiguration()
        configuration.pickerLanguage = .en
        configuration.tableCellInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        configuration.viewBackgroundColor = UIColor.white
        configuration.tableCellBackgroundColor = UIColor.white
        
        return configuration
    }
    
    func phoneNumberView(didChangeText nationalNumber: String, country: JNCountry, forPhoneNumberView phoneNumberView: JNPhoneNumberView) {
        controller.activeDeActiveContinueButton()
    }
  
    func phoneNumberView(didEndEditing nationalNumber: String, country: JNCountry, isValidPhoneNumber: Bool, forPhoneNumberView phoneNumberView: JNPhoneNumberView) {
            controller.activeDeActiveContinueButton()
    }
   
    func phoneNumberView(countryDidChanged country: JNCountry, isValidPhoneNumber: Bool, forPhoneNumberView phoneNumberView: JNPhoneNumberView) {
        controller.activeDeActiveContinueButton()
    }
    
}
