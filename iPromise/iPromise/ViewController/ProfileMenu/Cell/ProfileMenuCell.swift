//
//  ProfileMenuCell.swift
//  iPromise
//
//  Created by Apple on 20/03/23.
//

import UIKit

class ProfileMenuCell: UITableViewCell {

    //MARK: -  outlet
    
    @IBOutlet weak var imgMenu: UIImageView!
    
    @IBOutlet weak var lblMenuTitle: UILabel!
    @IBOutlet weak var lblVersion: UILabel!
    //MARK: -  lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    //MARK: -  setupui
    func setupUI(){
        
        
        lblMenuTitle.font = UIFont.customFont(font: .regular, size: 16)
        lblMenuTitle.font = UIFont.customFont(font: .regular, size: 14)
        
      
    }
    
}
