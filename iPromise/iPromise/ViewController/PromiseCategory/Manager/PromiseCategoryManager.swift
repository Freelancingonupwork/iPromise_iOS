//
//  Manager.swift
//  iPromise
//
//  Created by Apple on 21/03/23.
//

import UIKit

class PromiseCategoryManager : NSObject{
    //MARK: -  variable
    fileprivate unowned var controller: PromiseCategoryVC
    fileprivate unowned var model: PromiseCategoryModel

    //MARK: -  intializer
    init(controller:PromiseCategoryVC, model:PromiseCategoryModel) {
        self.controller = controller
        self.model = model
    }
}
//MARK: -  collection view delegate
extension PromiseCategoryManager : UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.arrCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PromiseCategoryCell", for: indexPath) as! PromiseCategoryCell
        let dict = model.arrCategory[indexPath.row]
        cell.lblCategoryTitle.text = dict["name"].stringValue
        cell.lblCategorysubTitle.text = dict["description"].stringValue == "" ? "-" : dict["description"].stringValue
        cell.imgCategiry.setImageFromUrl(url: dict["image"].stringValue)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dict = model.arrCategory[indexPath.row]
        controller.moveToSubCategoryView(arrSubcategory: dict["subcategories"].arrayValue, title: dict["name"].stringValue)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = (collectionView.frame.width - 20)/2
        if model.arrCategory.count % 2 != 0 && indexPath.row == model.arrCategory.count - 1  {
            width = (collectionView.frame.width)
            return  CGSize(width: width, height: width/2)
        }
        else{
            return  CGSize(width: width, height: width)
        }
        
        
    }
}
