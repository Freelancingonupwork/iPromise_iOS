//
//  View.swift
//  iPromise
//
//  Created by Apple on 16/03/23.
//
import UIKit


class InviteViaContactView : UIView{
    //MARK: -  outlet
    
    @IBOutlet weak var btnSMS: UIButton!
    @IBOutlet weak var btnOther: UIButton!
    
    @IBOutlet weak var lblContacr: UILabel!
    
    
    //MARK: - variable
  
    
    //MARK: - setupUI
    func setupUI(delegate : InviteViaContactManager){
    
        btnSMS.setDarkButton()
        btnOther.setLightButton()
      
        lblContacr.font = UIFont.customFont(font: .bold, size: 18)
        
    }
}
