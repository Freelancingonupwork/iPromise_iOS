//
//  Manager.swift
//  iPromise
//
//  Created by Apple on 16/03/23.
//

import Foundation
import UIKit


class SettingManager : NSObject{
    //MARK: -  variable
    fileprivate unowned var controller: SettingVC
    fileprivate unowned var model: SettingModel
    
    //MARK: -  intializer
    init(controller:SettingVC, model:SettingModel) {
        self.controller = controller
        self.model = model
    }
}
//MARK: - table view delegate
extension SettingManager : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.arrMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell (withIdentifier: "AccountAndInfoCell", for: indexPath) as! AccountAndInfoCell
        let dict = model.arrMenu[indexPath.row]
        cell.lblTitle.text = dict.title
        if controller.isSetting{
            cell.imgMenu.image = UIImage(named: dict.img)
        }
        else{
            cell.imgMenu.setImageFromUrl(url: dict.img)
        }
        
        cell.selectionStyle = .none
        return cell
    }
    

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = model.arrMenu[indexPath.row]
        controller.moveToContinue(dict: dict)
    }
    
}
