//
//  PromiseCell.swift
//  iPromise
//
//  Created by Apple on 16/03/23.
//

import UIKit

class PromiseCell:  UITableViewCell {
    
    //MARK: -  outlet
    
    @IBOutlet weak var vwParent: UIView!
    @IBOutlet weak var vwMembers: UIView!
    @IBOutlet weak var vwMember1: UIView!
    @IBOutlet weak var vwMember2: UIView!
    @IBOutlet weak var vwMember3: UIView!
    @IBOutlet weak var vwMember4: UIView!
    
    @IBOutlet weak var imgPromise: UIImageView!
    @IBOutlet weak var imgMember1: UIImageView!
    @IBOutlet weak var imgMember2: UIImageView!
    @IBOutlet weak var imgMember3: UIImageView!
    @IBOutlet weak var imgMember4: UIImageView!

 
    @IBOutlet weak var lblPromiseTitle: UILabel!
    @IBOutlet weak var lblCreated: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblMoreMember: UILabel!
    
    @IBOutlet weak var stackviewDate: UIStackView!
    
    @IBOutlet weak var vwPromiseStatus: UIView!
    @IBOutlet weak var vwPromiseColor: UIView!
    @IBOutlet weak var btnPromiseStatus: UIButton!
    
    //MARK: -  lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    

    //MARK: -  setupui
    func setupUI(){
      
        lblPromiseTitle.font = UIFont.customFont(font: .medium, size: 16)
        [lblCreated,lblDate].forEach { $0?.font = UIFont.customFont(font: .regular, size: 14) }
        lblMoreMember.font = UIFont.customFont(font: .medium, size: 14)
        
        [vwMember1,vwMember2,vwMember3,vwMember4].forEach{ $0?.makeRound()}
        [imgMember1,imgMember2,imgMember3,imgMember4].forEach{ $0?.makeRound()}
        vwParent.setShadow(borderColor: .clear)
        
        btnPromiseStatus.titleLabel?.font = UIFont.customFont(font: .regular, size: 16)
        
        //imgPromise.layer.cornerRadius = 10
    }
    
    func setFailPromise(){
        vwPromiseStatus.isHidden = false
        stackviewDate.isHidden = true
        
        vwPromiseColor.backgroundColor = color.redColor()?.withAlphaComponent(0.5)
        btnPromiseStatus.setTitle(" Archived", for: .normal)
        btnPromiseStatus.setTitleColor(color.redColor(), for: .normal)
        btnPromiseStatus.tintColor = color.redColor()
        if #available(iOS 13.0, *) {
            btnPromiseStatus.setImage(UIImage(systemName: "multiply.circle"), for: .normal)
        } else {
            // Fallback on earlier versions
        }
    }
    
    @available(iOS 13.0, *)
    func setCompletedPromise(){
        vwPromiseStatus.isHidden = false
        stackviewDate.isHidden = true
        
        vwPromiseColor.backgroundColor = color.greenColor()?.withAlphaComponent(0.5)
        btnPromiseStatus.setTitle(" Completed", for: .normal)
        btnPromiseStatus.setTitleColor(color.greenColor(), for: .normal)
        btnPromiseStatus.tintColor = color.greenColor()
        btnPromiseStatus.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
    }
    
    func setINProgressPromise(){
        vwPromiseStatus.isHidden = false
        stackviewDate.isHidden = true
        
        vwPromiseColor.backgroundColor = color.primaryColor()?.withAlphaComponent(0.5)
        btnPromiseStatus.setTitle(" In progress", for: .normal)
        btnPromiseStatus.setTitleColor(color.primaryColor(), for: .normal)
        btnPromiseStatus.tintColor = color.primaryColor()
        if #available(iOS 13.0, *) {
            btnPromiseStatus.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        } else {
            // Fallback on earlier versions
        }
    }
    
    func setInvitedPromise(){
        vwPromiseStatus.isHidden = false
        stackviewDate.isHidden = true
        
        vwPromiseColor.backgroundColor = color.grayColor()?.withAlphaComponent(0.5)
        btnPromiseStatus.setTitle(" Invited", for: .normal)
        btnPromiseStatus.setTitleColor(color.grayColor(), for: .normal)
        btnPromiseStatus.tintColor = color.grayColor()
        if #available(iOS 13.0, *) {
            btnPromiseStatus.setImage(UIImage(systemName: "person.badge.plus"), for: .normal)
        } else {
            // Fallback on earlier versions
        }
    }
    
    func setMemberView(){
        vwPromiseStatus.isHidden = true
        stackviewDate.isHidden = false
        vwMembers.isHidden = false
    }
    
    func setNoMemberView(){
        vwPromiseStatus.isHidden = true
        stackviewDate.isHidden = false
        vwMembers.isHidden = true
    }
}
