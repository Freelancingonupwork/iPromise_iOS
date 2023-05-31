//
//  View.swift
//  iPromise
//
//  Created by Apple on 16/03/23.
//
import UIKit
import MaterialComponents.MaterialTextControls_OutlinedTextFields


class EditAccountView : UIView{
    
    //MARK: - outlet
    
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var vwProfile: UIView!
    
    @IBOutlet weak var txtName: MDCOutlinedTextField!
    @IBOutlet weak var txtNumber: MDCOutlinedTextField!
    
    @IBOutlet weak var btnDeleteAccount: UIButton!
    
    //MARK: - variable
    
    
    //MARK: - setupUI
    func setupUI(delegate : EditAccountManager){
       
        setupData()
        
        imgProfile.makeRound()
        
        vwProfile.layer.cornerRadius = 30
        vwProfile.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]

        btnDeleteAccount.titleLabel?.font = UIFont.customFont(font: .bold, size: 16)
        
        txtName.label.text = "Name"
        txtName.placeholder = "Name"
        txtNumber.label.text = "Phone Number"
        txtNumber.placeholder = "Phone Number"
        
        
        [txtName,txtNumber].forEach{
            $0?.setOutlineColor(color.primaryColor()!, for: .editing)
            $0?.setOutlineColor(color.grayColor()!, for: .normal)
            $0?.setFloatingLabelColor(color.primaryColor()!, for: .editing)
            $0?.setFloatingLabelColor(color.grayColor()!, for: .normal)
            $0?.setNormalLabelColor(color.grayColor()!, for: .normal)
            $0?.font = UIFont.customFont(font: .regular, size: 16)
        }
    }
    
    func setupData(){
        let name = Utils.getUserDetail(.name)
        let number = Utils.getUserDetail(.phoneNumber)
        let image = Utils.getUserDetail(.avatar)
        
        txtName.text = name
        txtNumber.text = number
        imgProfile.setImageFromUrl(url: image)
    }
}
