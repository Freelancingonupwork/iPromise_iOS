//
//  AddMemberCell.swift
//  iPromise
//
//  Created by Apple on 22/03/23.
//

import UIKit

class AddMemberCell: UITableViewCell {
    
    //MARK: -  outlet

    @IBOutlet weak var btnCheckMark: UIButton!
    @IBOutlet weak var imgMember: UIImageView!
    @IBOutlet weak var imgCall: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPromises: UILabel!
    
    //MARK: -  variable
    var buttonAction: ((UIButton) -> Void)?
    
    //MARK: - life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: -  setupUI
    func setupUI(){
        imgMember.makeRound()
        lblName.font = UIFont.customFont(font: .medium, size: 16)
        lblPromises.font = UIFont.customFont(font: .regular, size: 14)
    }
    
    func setCheckedButton(){
        btnCheckMark.tintColor = color.primaryColor()
        btnCheckMark.isSelected = true
    }
    
    func setUncheckedButton(){
        btnCheckMark.tintColor = color.grayColor()
        btnCheckMark.isSelected = false
    }
    
    @IBAction func btnCheckClicked(_ sender: UIButton) {
        buttonAction?(sender)
    }
}
