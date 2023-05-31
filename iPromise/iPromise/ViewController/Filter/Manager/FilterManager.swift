//
//  Manager.swift
//  iPromise
//
//  Created by Apple on 21/03/23.
//

import UIKit

class FilterManager : NSObject{
    
    //MARK: -  variable
    fileprivate unowned var controller: FilterVC
    fileprivate unowned var model: FilterModel

    //MARK: -  intializer
    init(controller:FilterVC, model:FilterModel) {
        self.controller = controller
        self.model = model
    }
}
//MARK: -  collection view delegate
extension FilterManager : UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0{
            return model.arrStatusItems.count
        }
        else if collectionView.tag == 1{
            return model.arrCategory.count
        }
        else{
            return model.arrSubCategory.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as! FilterCell
        if collectionView.tag == 0{
            let dict = model.arrStatusItems[indexPath.row]
            cell.btnStatus.setTitle(dict, for: .normal)
            controller.arrSelectedStatus.contains(dict) ? cell.setActiveFilter() : cell.setInActiveFilter()
            cell.buttonAction = { [self] sender in
                controller.manageFilter(index: indexPath.row, filterType: .status)
            }
        }
        else if collectionView.tag == 1 {
            let dict =  model.arrCategory[indexPath.row]
            cell.btnStatus.setTitle(dict["name"].stringValue, for: .normal)
            controller.arrSelectedCategory.contains(dict) ? cell.setActiveFilter() : cell.setInActiveFilter()
            cell.buttonAction = { [self] sender in
                controller.manageFilter(index: indexPath.row, filterType: .category)
            }
        }
        else{
            let dict =  model.arrSubCategory[indexPath.row]
            cell.btnStatus.setTitle("\(dict["name"].stringValue) ", for: .normal)
            if #available(iOS 13.0, *) {
                cell.btnStatus.setImage(UIImage(systemName: "multiply.circle"), for: .normal)
            } else {
                // Fallback on earlier versions
            }
            cell.btnStatus.tintColor = color.grayColor()
            cell.setRightImage()
            
            cell.buttonAction = { [self] sender in
                controller.manageFilter(index: indexPath.row, filterType: .subcategory)
            }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var text = ""
        if collectionView.tag == 0{
            let dict = model.arrStatusItems[indexPath.row]
            text = dict
        }
        else{
            let dict = (collectionView.tag == 1) ? model.arrCategory[indexPath.row] : model.arrSubCategory[indexPath.row]
            text = dict["name"].stringValue
        }
     
        let font = UIFont.customFont(font: .regular, size: 16)
        let width = UILabel.textWidth(font: font, text: text)
        return collectionView.tag == 2 ? CGSize(width: (width + 60), height: 50) : CGSize(width: (width + 50), height: 50)
           
    }
}
