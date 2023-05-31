//
//  View.swift
//  iPromise
//
//  Created by Apple on 21/03/23.
//

import UIKit

class PromiseCategoryView : UIView{
    //MARK: - outlet
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
   
    @IBOutlet weak var cvCategory: UICollectionView!
    
    //MARK: - variable
    
    
    //MARK: - setupUI
    func setupUI(delegate : PromiseCategoryManager){
        [img1,img2,img3].forEach { $0?.makeRound() }
        cvCategory.delegate = delegate
        cvCategory.dataSource = delegate
        registerCell()
    }
    
    //MARK: - register cell
    func registerCell(){
        cvCategory.register(UINib(nibName: "PromiseCategoryCell", bundle: nil), forCellWithReuseIdentifier: "PromiseCategoryCell")
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left:0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        cvCategory.collectionViewLayout = layout
        cvCategory.isScrollEnabled = true
        cvCategory.backgroundColor = .clear
        cvCategory.reloadData()
        
    }
}
