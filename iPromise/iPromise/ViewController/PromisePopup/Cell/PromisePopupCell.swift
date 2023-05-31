//
//  PromisePopupCell.swift
//  iPromise
//
//  Created by Apple on 30/03/23.
//

import UIKit

class PromisePopupCell: UITableViewCell {
    //MARK: -  outlet
    @IBOutlet weak var lblPromise: UILabel!
    @IBOutlet weak var lblPromiseDescription: UILabel!
    
    @IBOutlet weak var imgPromise: UIImageView!
    
    @IBOutlet weak var vwSeprator: UIView!
    
    
    //MARK: - lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    //MARK: - setupui
    func setupUI(){
        [lblPromise].forEach { $0?.font = UIFont.customFont(font: .medium, size: 20) }
        [lblPromiseDescription].forEach { $0?.font = UIFont.customFont(font: .regular, size: 16) }
    }
}
