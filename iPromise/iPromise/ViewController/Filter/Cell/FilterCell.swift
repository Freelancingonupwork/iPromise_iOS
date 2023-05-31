//
//  FilterCell.swift
//  iPromise
//
//  Created by Apple on 21/03/23.
//

import UIKit

class FilterCell: UICollectionViewCell {
    //MARK: -  outlet
    
    @IBOutlet weak var btnStatus: UIButton!
    //MARK: -  variable
    var buttonAction: ((UIButton) -> Void)?
    
    //MARK: -  lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }

    

    //MARK: -  setupui
    func setupUI(){
        btnStatus.setDarkButton( font: UIFont.customFont(font: .regular, size: 16))
        btnStatus.makeRound()
      //  btnStatus.setGradientBackground()
        setInActiveFilter()
    }

    func setActiveFilter(){
        btnStatus.setDarkButton( font: UIFont.customFont(font: .regular, size: 16))
        btnStatus.setGradientBackground()
        btnStatus.makeRound()
    }
    
    func setInActiveFilter(){
        btnStatus.setLightButton(BGcolor: color.whiteColor(), font: UIFont.customFont(font: .regular, size: 16), titleColor: color.blackColor())
        btnStatus.makeRound()
    }
    
    
    func setRightImage(){
        btnStatus.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        btnStatus.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        btnStatus.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)

    }
    //MARK: -  button click
    
    @IBAction func btnFilterClicked(_ sender: UIButton) {
        buttonAction?(sender)
    }
}
