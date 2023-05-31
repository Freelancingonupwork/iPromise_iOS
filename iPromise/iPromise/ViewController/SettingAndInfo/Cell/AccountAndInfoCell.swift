//
//  AccountAndInfoCell.swift
//  iPromise
//
//  Created by Apple on 20/03/23.
//

import UIKit

class AccountAndInfoCell: UITableViewCell {
    //MARK: - outlet
    @IBOutlet weak var vwParent: UIView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var imgMenu: UIImageView!

    //MARK: - lifecyle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: -  setupUI
    func setupUI(){
        [vwParent].forEach { $0?.makeCorner() }
        
        [lblTitle].forEach{ $0?.font = UIFont.customFont(font: .medium, size: 17)}
    }
}
