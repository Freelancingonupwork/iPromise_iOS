//
//  PromiseCollectionCell.swift
//  iPromise
//
//  Created by Apple on 17/03/23.
//

import UIKit

class PromiseCollectionCell: UICollectionViewCell {

  
    @IBOutlet weak var vwParent: UIView!
    @IBOutlet weak var vwMembers: UIView!
    @IBOutlet weak var vwMember1: UIView!
    @IBOutlet weak var vwMember2: UIView!
    @IBOutlet weak var vwMember3: UIView!
    @IBOutlet weak var vwMember4: UIView!
    
    @IBOutlet weak var imgPromise: UIImageView!
    @IBOutlet weak var imgMember1: UIImageView!
    @IBOutlet weak var imgMember2: UIImageView!
    @IBOutlet weak var imgMember3: UIImageView!
    @IBOutlet weak var imgMember4: UIImageView!

 
    @IBOutlet weak var lblPromiseTitle: UILabel!
    @IBOutlet weak var lblCreated: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblMoreMember: UILabel!
    
    
    
    //MARK: -  lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }

    

    //MARK: -  setupui
    func setupUI(){
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 20
      
        lblPromiseTitle.font = UIFont.customFont(font: .medium, size: 16)
        [lblCreated,lblDate].forEach { $0?.font = UIFont.customFont(font: .regular, size: 14) }
        lblMoreMember.font = UIFont.customFont(font: .medium, size: 14)
        
        [vwMember1,vwMember2,vwMember3,vwMember4].forEach{ $0?.makeRound()}
        [imgMember1,imgMember2,imgMember3,imgMember4].forEach{ $0?.makeRound()}
        vwParent.setShadow(borderColor: .clear)

    }
    
}
