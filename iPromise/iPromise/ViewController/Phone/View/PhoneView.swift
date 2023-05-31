//
//  PhoneView.swift
//  iPromise
//
//  Created by Apple on 14/03/23.
//

import UIKit
import JNPhoneNumberView

class PhoneView : UIView{
    //MARK: - outlet
   
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var vwPhoneParent: UIView!
    @IBOutlet weak var vwPhone: JNPhoneNumberView!
    
    @IBOutlet weak var btnContinue: UIButton!
    
    @IBOutlet weak var lblBottomText: UILabel!
    
    @IBOutlet weak var btnClear: UIButton!
    //MARK: - variable
    
    let strBottomText = "By clicking Continue you agree to the \nTerms of Use  and Privacy Policy"
    
    //MARK: - setupUI
    func setupUI(delegate : PhoneManager){
        lblHeading.font = UIFont.customFont(font: .bold, size: 32)

        [ lblDescription].forEach { $0?.font = UIFont.customFont(font: .regular, size: 16) }
        lblBottomText.font = UIFont.customFont(font: .regular, size: 16)

        vwPhoneParent.setShadow()
        customPrivacyTermsUI()
        btnContinue.setDisableButton()
        btnClear.makeRound()
        

        vwPhone.delegate = delegate
        vwPhone.setDefaultCountryCode("US")
        vwPhone.setViewConfiguration(self.getConfigration())
        vwPhone.tintColor = color.blackColor()

        if promiseByDeepLink.phoneNumber != "" && promiseByDeepLink.promiseId != "nil"{
            vwPhone.setPhoneNumber(promiseByDeepLink.phoneNumber)
            vwPhone.isValidPhoneNumber() ? btnContinue.setDarkButton() : btnContinue.setDisableButton()
        }
    }
    
    
    func customPrivacyTermsUI()
    {
        lblBottomText.text = strBottomText
        lblBottomText.isUserInteractionEnabled = true
        lblBottomText.highlightWords(phrases:  ["Privacy Policy","Terms of Use"], withColor: color.primaryColor(), withFont: UIFont.customFont(font: .medium, size: 16))
    }
    
    //MARK: - phonenumber view configuration
    func getConfigration() -> JNPhoneNumberViewConfiguration {
        let configrartion = JNPhoneNumberViewConfiguration()
        configrartion.phoneNumberTitleColor = color.blackColor() ?? .black
        configrartion.countryDialCodeTitleColor = color.blackColor() ?? .black
        configrartion.phoneNumberTitleFont = UIFont.customFont(font: .regular, size: 16)
        let attributes = [
            NSAttributedString.Key.foregroundColor: color.grayColor() as Any ,
            NSAttributedString.Key.font : UIFont.customFont(font: .regular, size: 16)
        ] as [NSAttributedString.Key : Any]
        configrartion.phoneNumberAttributedPlaceHolder = NSAttributedString(string:"Phone number", attributes:attributes)
        configrartion.countryDialCodeTitleFont = UIFont.customFont(font: .regular, size: 16)
        
        return configrartion
    }
    
   
}

