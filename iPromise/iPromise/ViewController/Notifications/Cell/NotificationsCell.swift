//
//  NotificationsCell.swift
//  iPromise
//
//  Created by Apple on 17/03/23.
//

import UIKit

class NotificationsCell: UITableViewCell {

    //MARK: -  outlet
    @IBOutlet weak var lblNotification: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var imgNotification: UIImageView!
    
    @IBOutlet weak var vwAction: UIView!
    
    @IBOutlet weak var btnNegative: UIButton!
    @IBOutlet weak var btnPositive: UIButton!
    
    @IBOutlet weak var vwActionHeight: NSLayoutConstraint!
    
    //MARK: -  variable
    var leftButtonAction: ((UIButton) -> Void)?
    var rightButtonAction: ((UIButton) -> Void)?
    
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
        
        [btnNegative,btnPositive].forEach{
            $0?.makeRound()
            $0?.titleLabel?.font = UIFont.customFont(font: .bold, size: 16)
        }
        
        imgNotification.makeRound()
        
        lblNotification.font = UIFont.customFont(font: .regular, size: 16)
        lblTime.font = UIFont.customFont(font: .regular, size: 14)
    }
    
    func showButtonUI(){
        [btnNegative,btnPositive].forEach{
            $0?.makeRound()
            $0?.titleLabel?.font = UIFont.customFont(font: .bold, size: 16)
        }
        vwAction.isHidden = false
        vwActionHeight.constant = 60
    }
    func hideButtonUI(){
        [btnNegative,btnPositive].forEach{
            $0?.makeRound()
            $0?.titleLabel?.font = UIFont.customFont(font: .bold, size: 16)
        }

        vwAction.isHidden = true
        vwActionHeight.constant = 0
    }
    //MARK: - button click
    
    @IBAction func btnLeftClicked(_ sender: UIButton) {
        leftButtonAction?(sender)
    }
    @IBAction func btnRightClicked(_ sender: UIButton) {
        rightButtonAction?(sender)
    }
}
