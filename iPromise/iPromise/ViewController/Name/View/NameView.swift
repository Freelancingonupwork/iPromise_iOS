//
//  View.swift
//  iPromise
//
//  Created by Apple on 15/03/23.
//

import UIKit

class NameView : UIView{
    //MARK: - outlet
   
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnNotNow: UIButton!
    
    @IBOutlet weak var vwName: UIView!
    
    @IBOutlet weak var txtName: UITextField!
    
    //MARK: - variable
  
    
    //MARK: - setupUI
    func setupUI(delegate : NameManager){
        lblHeading.font = UIFont.customFont(font: .bold, size: 32)
        [ lblDescription].forEach { $0?.font = UIFont.customFont(font: .regular, size: 16) }

        vwName.setShadow()

        btnSave.setDarkButton()
        btnNotNow.setLightButton()
        if isGuest{
            btnNotNow.isHidden = false
        }

        txtName.attributedPlaceholder = txtName.setAttributeText(placeHolderString: "Your name")
        [txtName].forEach{
            $0.delegate = delegate as? any UITextFieldDelegate
            $0.font = UIFont.customFont(font: .regular, size: 16)
            $0.textColor = color.blackColor()
            $0.adjustsFontSizeToFitWidth = true
        }
    }
}
