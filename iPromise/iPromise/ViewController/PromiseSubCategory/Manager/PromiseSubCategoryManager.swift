//
//  Manager.swift
//  iPromise
//
//  Created by Apple on 21/03/23.
//

import UIKit

class PromiseSubCategoryManager : NSObject{
    //MARK: -  variable
    fileprivate unowned var controller: PromiseSubCategoryVC
    fileprivate unowned var model: PromiseSubCategoryModel

    //MARK: -  intializer
    init(controller:PromiseSubCategoryVC, model:PromiseSubCategoryModel) {
        self.controller = controller
        self.model = model
    }
}

//MARK: - table view delegate
extension PromiseSubCategoryManager : UITableViewDataSource, UITableViewDelegate{
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.arrSubCategory.count
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell (withIdentifier: "PromiseSubCategoryCell", for: indexPath) as! PromiseSubCategoryCell
        let dict = model.arrSubCategory[indexPath.row]
        cell.lblCategory.text = dict["name"].stringValue
        cell.imgCategory.setImageFromUrl(url: dict["image"].stringValue)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = model.arrSubCategory[indexPath.row]
        controller.moveToPromiseSetup(subcategoryID: dict["id"].stringValue)
    }
 
}
