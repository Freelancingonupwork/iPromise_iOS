//
//  InviteCell.swift
//  iPromise
//
//  Created by Apple on 23/03/23.
//

import UIKit

class InviteCell: UITableViewCell {
    
    //MARK: -  outlet
    @IBOutlet weak var btnCheckBox: UIButton!
    @IBOutlet weak var btnRemove: UIButton!
    
    @IBOutlet weak var lblName: UILabel!
    
    //MARK: -  variable
    var buttonCheckAction : ((UIButton) -> Void)?
    var buttonRemoveAction : ((UIButton) -> Void)?
    
    //MARK: -  life cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - setup UI
    func setupUI(){
        lblName.font = UIFont.customFont(font: .regular, size: 16)
        
        btnRemove.makeRound()
    }
    
    func setCheckedButton(){
        btnCheckBox.tintColor = color.primaryColor()
        btnCheckBox.isSelected = true
    }
    
    func setUncheckedButton(){
        btnCheckBox.tintColor = color.grayColor()
        btnCheckBox.isSelected = false
    }
    
    //MARK: -  button clicks
    
    
    @IBAction func btnCheckBoxClick(_ sender: UIButton) {
        buttonCheckAction?(sender)
    }
    
    @IBAction func btnRemoveClicked(_ sender: UIButton) {
        buttonRemoveAction?(sender)
    }
    
}
