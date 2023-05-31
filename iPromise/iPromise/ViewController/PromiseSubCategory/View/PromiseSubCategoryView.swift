//
//  View.swift
//  iPromise
//
//  Created by Apple on 21/03/23.
//

import UIKit

class PromiseSubCategoryView : UIView{
    //MARK: - outlet
   
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
   
    @IBOutlet weak var tblCategory: UITableView!
    
    //MARK: - variable
    
    
    
    //MARK: - setupUI
    func setupUI(delegate : PromiseSubCategoryManager){
        [img1,img2,img3].forEach { $0?.makeRound() }
        
        tblCategory.delegate = delegate
        tblCategory.dataSource = delegate
        registerCell()
        
    }
    
    func registerCell(){
        tblCategory.register(UINib(nibName: "PromiseSubCategoryCell", bundle: nil), forCellReuseIdentifier: "PromiseSubCategoryCell")
        tblCategory.reloadData()
        tblCategory.separatorStyle = .none
        tblCategory.isScrollEnabled = true
        tblCategory.rowHeight = UITableView.automaticDimension
        tblCategory.backgroundColor = .clear
        tblCategory.reloadData()
    }
    

}
