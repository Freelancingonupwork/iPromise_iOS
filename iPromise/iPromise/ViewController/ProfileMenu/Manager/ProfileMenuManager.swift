//
//  Manager.swift
//  iPromise
//
//  Created by Apple on 16/03/23.
//

import UIKit


class ProfileMenuManager : NSObject{
    //MARK: -  variable
    fileprivate unowned var controller: ProfileMenuVC
    fileprivate unowned var model: ProfileMenuModel
    
    //MARK: -  intializer
    init(controller:ProfileMenuVC, model:ProfileMenuModel) {
        self.controller = controller
        self.model = model
    }
}
//MARK: - table view delegate
extension ProfileMenuManager : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.arrMenuItem.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell (withIdentifier: "ProfileMenuCell", for: indexPath) as! ProfileMenuCell
        if indexPath.row == model.arrMenuItem.count{
            cell.imgMenu.isHidden = true
            cell.lblMenuTitle.isHidden = true
            cell.lblVersion.isHidden = false
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
            cell.lblVersion.text = "Version \(appVersion)"
        }
        else{
            let dict = model.arrMenuItem[indexPath.row]
            cell.imgMenu.image = UIImage(named:  dict.img)
            cell.lblMenuTitle.text = dict.title
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let additionalSeparatorThickness = CGFloat(1.5)
        let additionalSeparator = UIView(frame: CGRectMake(0,
                                                           cell.frame.size.height - additionalSeparatorThickness,
                                                           cell.frame.size.width,
                                                           additionalSeparatorThickness))
        additionalSeparator.backgroundColor = indexPath.row == (model.arrMenuItem.count) ? .clear : color.backgroundColor()
        cell.addSubview(additionalSeparator)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row <= model.arrMenuItem.count-1{
            let dict = model.arrMenuItem[indexPath.row]
            controller.menuAction(dict: dict)
        }
    }
    
}
