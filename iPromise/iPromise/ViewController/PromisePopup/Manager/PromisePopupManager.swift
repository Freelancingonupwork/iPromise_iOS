//
//  Manager.swift
//  iPromise
//
//  Created by Apple on 16/03/23.
//

import UIKit


class PromisePopupManager : NSObject{
    //MARK: -  variable
    fileprivate unowned var controller: PromisePopupVC
    fileprivate unowned var model: PromisePopupModel
    
    //MARK: -  intializer
    init(controller:PromisePopupVC, model:PromisePopupModel) {
        self.controller = controller
        self.model = model
    }
}
//MARK: - table view delegate
extension PromisePopupManager : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if model.arrPromises.count == 0{
            controller.setTableHeight()
        }
        return model.arrPromises.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell (withIdentifier: "PromisePopupCell", for: indexPath) as! PromisePopupCell
        
        let dict = model.arrPromises[indexPath.row]
        cell.lblPromise.text = dict["name"].stringValue
        cell.lblPromiseDescription.text = dict["description"].stringValue == "" ? "-" :  dict["description"].stringValue
        cell.imgPromise.setImageFromUrl(url: dict["image"].stringValue)
        if indexPath.row == model.arrPromises.count - 1{
            cell.vwSeprator.isHidden = true
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = model.arrPromises[indexPath.row]
        controller.redirectToPromiseCreation(dict: dict)
    }
}
