//
//  PromiseCategoryCell.swift
//  iPromise
//
//  Created by Apple on 23/03/23.
//

import UIKit

class PromiseCategoryCell: UICollectionViewCell {
    
    //MARK: -  outlet
    
    @IBOutlet weak var vwParent: UIView!
    
    @IBOutlet weak var imgCategiry: UIImageView!
    
    @IBOutlet weak var lblCategoryTitle: UILabel!
    @IBOutlet weak var lblCategorysubTitle: UILabel!
    
    //MARK: - lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    //MARK: -  setup ui
    func setupUI(){
        
        vwParent.makeCorner(corner: 15)
        
        lblCategoryTitle.font = UIFont.customFont(font: .bold, size: 18)
        lblCategorysubTitle.font = UIFont.customFont(font: .regular, size: 15)
    }

}
