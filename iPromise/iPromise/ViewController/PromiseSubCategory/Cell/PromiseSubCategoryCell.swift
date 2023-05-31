//
//  PromiseSubCategoryCell.swift
//  iPromise
//
//  Created by Apple on 23/03/23.
//

import UIKit

class PromiseSubCategoryCell: UITableViewCell {
    
    //MARK: - outlet
    
    @IBOutlet weak var imgCategory: UIImageView!
    
    @IBOutlet weak var lblCategory: UILabel!
    
    @IBOutlet weak var vwParent: UIView!
    
    
    //MARK: - lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: -  setupui
    
    func setupUI(){
        vwParent.makeCorner(corner: 20)
        
        lblCategory.font = UIFont.customFont(font: .bold, size: 18)
        
    }
}
