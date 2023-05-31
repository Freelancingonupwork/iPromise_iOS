//
//  View.swift
//  iPromise
//
//  Created by Apple on 21/03/23.
//

import UIKit
import DropDown

class FilterView : UIView{
    //MARK: - outlet
    @IBOutlet weak var vwDropDown: UIView!
    
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblSubcategory: UILabel!
    @IBOutlet weak var lblSubcategoryText: UILabel!
    @IBOutlet weak var cvSubCategory: UICollectionView!
    
    @IBOutlet weak var cvStatus: UICollectionView!
    @IBOutlet weak var cvCategory: UICollectionView!
    
    @IBOutlet weak var cvSubCategoryHeight: NSLayoutConstraint!
    @IBOutlet weak var cvCategoryHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var btnShowResult: UIButton!
    
    //MARK: - variable
    var isResized = false
    var dropDown = DropDown()

    //MARK: - setupUI
    func setupUI(delegate : FilterManager){
        [lblStatus, lblCategory,lblSubcategory].forEach { $0?.font = UIFont.customFont(font: .bold, size: 18) }
        lblSubcategoryText.font = UIFont.customFont(font: .regular, size: 14)
        
        [cvStatus,cvCategory,cvSubCategory].forEach{
            $0.delegate = delegate
            $0.dataSource = delegate
        }
        
        vwDropDown.makeCorner()
        
        
        btnShowResult.setDarkButton()
        registerCell()
        
    }
    
    //MARK: -  register cell
    func registerCell(){
        
        [cvStatus,cvCategory,cvSubCategory].forEach{
            $0.register(UINib(nibName: "FilterCell", bundle: nil), forCellWithReuseIdentifier: "FilterCell")
            
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 0, left:0, bottom: 0, right: 0)
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            $0.collectionViewLayout = layout
            $0.isScrollEnabled = false
            $0.backgroundColor = .clear
            $0.addObserver(self, forKeyPath: "contentSize", options: .new, context: .none)
            $0.reloadData()
        }
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if (object as! UICollectionView) == self.cvCategory  /*&& !isResized*/{
            if(keyPath == "contentSize"){
                if let newvalue = change?[.newKey]
                {
                    let newsize = newvalue as! CGSize
                    self.cvCategoryHeight.constant = newsize.height
                    isResized = true
                }
            }
        }
        else if (object as! UICollectionView) == self.cvSubCategory {
            if(keyPath == "contentSize"){
                if let newvalue = change?[.newKey]
                {
                    let newsize = newvalue as! CGSize
                    self.cvSubCategoryHeight.constant = newsize.height
                }
            }
        }
//
    }

    //MARK: -  set dropdown
    
    func showDropDown(arrData : [String], completion : @escaping ((Int) -> Void?)){
        dropDown.dataSource = arrData
        dropDown.backgroundColor = color.whiteColor()!
        dropDown.textFont = UIFont.customFont(font: .regular, size: 14)
        dropDown.textColor = color.blackColor()!
        dropDown.anchorView = vwDropDown
        dropDown.bottomOffset = CGPoint(x: 0, y: vwDropDown.frame.size.height)
        dropDown.width = vwDropDown.frame.width
        dropDown.show()
        dropDown.selectionAction = {
            [weak self] (index: Int, item: String) in
            guard let _ = self else { return }
            completion(index)
        }
    }
}
