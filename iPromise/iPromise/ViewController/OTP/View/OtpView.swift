//
//  OtpView.swift
//  iPromise
//
//  Created by Apple on 15/03/23.
//

import UIKit


class OtpView : UIView{
    //MARK: - outlet
   
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblBottomText: UILabel!

    @IBOutlet weak var lblInvalideOtp: UILabel!
    
    @IBOutlet weak var vwOTP: OTPStackView!
    
    @IBOutlet weak var btnVerify: UIButton!
    //MARK: - variable
    
    let strBottomText = "Didn't receive a message? Send again"
    var strNumberText = "Please enter the verification code we sent to your phone number +998 97 742 02 33"
    var phoneNumber = "" {
        didSet{
            strNumberText = "Please enter the verification code we sent to your phone number \(phoneNumber)"
            customBottomLabel()
        }
    }
    
    
    //MARK: - setupUI
    func setupUI(delegate : OtpManager){
        lblHeading.font = UIFont.customFont(font: .bold, size: 32)

        [lblBottomText, lblDescription].forEach { $0?.font = UIFont.customFont(font: .regular, size: 16) }
        lblInvalideOtp.font = UIFont.customFont(font: .medium, size: 16)
      
        customBottomLabel()
        btnVerify.setDisableButton()
        
        vwOTP.delegate = delegate
    }

    func customBottomLabel()
    {
        lblBottomText.text = strBottomText
        lblBottomText.isUserInteractionEnabled = true
        lblBottomText.highlightWords(phrases:  ["Send again"], withColor: color.primaryColor(), withFont: UIFont.customFont(font: .medium, size: 16))
        
        lblDescription.text = strNumberText
        lblDescription.highlightWords(phrases:  [phoneNumber], withColor: color.blackColor(), withFont: nil)
    }
    
    func showInvalidOtp(){
        lblInvalideOtp.isHidden = false
        vwOTP.setAllFieldColor(color: color.redColor()!)
    }
    
}


