//
//  SignInUpView.swift
//  iPromise
//
//  Created by Apple on 14/03/23.
//

import UIKit

class SignInUpView : UIView{
    
    //MARK: - outlet
    @IBOutlet weak var scrollview : UIScrollView!
    
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblSubHeading: UILabel!
    
    @IBOutlet weak var stackview: UIStackView!
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btncontinueAsGuest: UIButton!
    
    //MARK: - variable
    
    
    //MARK: - setupUI
    func SetupUI(delegate : SignInUpManager){
        
        lblHeading.font = UIFont.customFont(font: .bold, size: 32)
        lblSubHeading.font = UIFont.customFont(font: .regular, size: 16)
        
        btnLogin.setLightButton(BGcolor: color.whiteColor())
        btncontinueAsGuest.setDarkButton(BGcolor: .clear)
        
        if promiseByDeepLink.promiseId != "" && promiseByDeepLink.phoneNumber != "" {
            btnLogin.setTitle("Accept", for: .normal)
            btncontinueAsGuest.setTitle("Deny", for: .normal)
        }

    }
}
