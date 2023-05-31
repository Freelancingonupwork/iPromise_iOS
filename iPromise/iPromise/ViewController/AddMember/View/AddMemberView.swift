//
//  View.swift
//  iPromise
//
//  Created by Apple on 21/03/23.
//

import UIKit

class AddMemberView : UIView{
    //MARK: - outlet
    @IBOutlet weak var vwSearch: UIView!
    @IBOutlet weak var vwBanner: UIView!
    
    @IBOutlet weak var txtSearch: UITextField!
    
    @IBOutlet weak var btnInviteContact: UIButton!
    
    @IBOutlet weak var tblMembers: UITableView!
    
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var vwBannerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btnInvite: UIButton!
    @IBOutlet weak var btnOther: UIButton!
    
    //MARK: - variable
    var oldMultiplier = 0.0
    var isHideByClick = false
    var isAddMember = false{
        didSet{
            setInactiveButton()
        }
    }
    
    //MARK: - setupUI
    func setupUI(delegate : AddMemberManager){
        vwBanner.makeCorner()
        vwSearch.setShadow(borderColor: .clear)
        
        oldMultiplier = vwBannerHeight.multiplier
        
        btnInviteContact.titleLabel?.font = UIFont.customFont(font: .medium, size: 22)
        btnInvite.setDisableButton()
        btnOther.setLightButton()
        
        txtSearch.returnKeyType = .search
        txtSearch.attributedPlaceholder = txtSearch.setAttributeText(placeHolderString: "Search")
        [txtSearch].forEach{
            $0.delegate = delegate as? any UITextFieldDelegate
            $0.font = UIFont.customFont(font: .regular, size: 16)
            $0.textColor = color.blackColor()
            $0.adjustsFontSizeToFitWidth = true
        }
        
        tblMembers.delegate = delegate
        tblMembers.dataSource = delegate
        registerCell()
        
    }
    
    
    func hideBanner(isHideByClick : Bool? = false){
        self.isHideByClick = !self.isHideByClick  ? ( isHideByClick ?? false ) : true
        vwBanner.isHidden = true
        vwBannerHeight.constant = 0
    }
    
    func showBanner(){
        if !isHideByClick{
            vwBanner.isHidden = false
            vwBannerHeight.constant = 140
        }
    }
    
    
    func setButtonActive(count : Int){
        btnInvite.setDarkButton()
        !isAddMember ? btnInvite.setTitle("Invite (\(count))", for: .normal) :  btnInvite.setTitle("Add (\(count))", for: .normal)
    }
    
    func setInactiveButton(){
        btnInvite.setDisableButton()
        !isAddMember ? btnInvite.setTitle("Invite (0)", for: .normal) :  btnInvite.setTitle("Add (0)", for: .normal)
    }
    
    //MARK: -  register cell
    func registerCell(){
        tblMembers.register(UINib(nibName: "AddMemberCell", bundle: nil), forCellReuseIdentifier: "AddMemberCell")
        tblMembers.reloadData()
        tblMembers.separatorStyle = .none
        tblMembers.isScrollEnabled = false
        tblMembers.rowHeight = UITableView.automaticDimension
        tblMembers.backgroundColor = .clear
        tblMembers.addObserver(self, forKeyPath: "contentSize", options: .new, context: .none)
        tblMembers.reloadData()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if (object as! UITableView) == self.tblMembers {
            if(keyPath == "contentSize"){
                if let newvalue = change?[.newKey]
                {
                    let newsize = newvalue as! CGSize
                    self.tableHeight.constant = newsize.height
                }
            }
        }
    }
    

}
