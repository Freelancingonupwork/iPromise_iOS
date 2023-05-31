//
//  NotificationStatusCell.swift
//  iPromise
//
//  Created by Apple on 20/03/23.
//

import UIKit

class NotificationStatusCell: UITableViewCell {

    //MARK: -  outlet
    @IBOutlet weak var lblNotification: UILabel!
    
    @IBOutlet weak var vwParent: UIView!
    
    @IBOutlet weak var switchNotification: UISwitch!
    
    //MARK: - variable
    var buttonAction: ((UISwitch) -> Void)?
    
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
        
        vwParent.makeCorner()
        
        lblNotification.font = UIFont.customFont(font: .medium, size: 16)
        
        let bool = Utils.getUserDetail(.notification)
        switchNotification.isOn =  (bool == "true") ? true : false
        
    }
    
    @IBAction func swicthClicked(_ sender: UISwitch) {
        buttonAction?(sender)
    }
}
