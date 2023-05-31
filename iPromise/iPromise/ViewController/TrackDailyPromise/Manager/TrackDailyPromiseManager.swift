//
//  Manager.swift
//  iPromise
//
//  Created by Apple on 16/03/23.
//

import Foundation
import UIKit


class TrackDailyPromiseManager : NSObject{
    //MARK: -  variable
    fileprivate unowned var controller: TrackDailyPromiseVC
    fileprivate unowned var model: TrackDailyPromiseModel
    
    //MARK: -  intializer
    init(controller:TrackDailyPromiseVC, model:TrackDailyPromiseModel) {
        self.controller = controller
        self.model = model
    }
}
//MARK: - collection view delegate
extension TrackDailyPromiseManager :  UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.arrPromises.count > 0 ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PromiseCell", for: indexPath) as! PromiseCell
        
        let dict = model.arrPromises[indexPath.row]
        cell.imgPromise.setImageFromUrl(url: dict["image"].stringValue)
        cell.lblPromiseTitle.text = dict["title"].stringValue
        cell.lblDate.text = dict["created"].stringValue
        
        let member = dict["members"].arrayValue //.filter({ $0["is_joined"].intValue == 1  })
        cell.vwMembers.isHidden = false
        
        if (dict["status"].stringValue).caseInsensitiveCompare(promiseCompletionStatus.completed.rawValue) == .orderedSame {
            if #available(iOS 13.0, *) {
                cell.setCompletedPromise()
            } else {
                // Fallback on earlier versions
            }
        }
        else if (dict["status"].stringValue).caseInsensitiveCompare(promiseCompletionStatus.failed.rawValue) == .orderedSame{
            cell.setFailPromise()
        }
        else{
            cell.setMemberView()
           if member.count == 0 {
               [cell.vwMember1, cell.vwMember2, cell.vwMember3,cell.vwMember4].forEach { $0?.isHidden = true }
           }
           else if member.count == 1{
               cell.imgMember1.setImageFromUrl(url: member[0]["avatar"].stringValue)
               [cell.vwMember1].forEach { $0?.isHidden = false }
               [cell.vwMember2, cell.vwMember3,cell.vwMember4].forEach { $0?.isHidden = true }
           }
           else if member.count == 2{
               cell.imgMember1.setImageFromUrl(url: member[0]["avatar"].stringValue)
               cell.imgMember2.setImageFromUrl(url: member[1]["avatar"].stringValue)
               [cell.vwMember1, cell.vwMember2].forEach { $0?.isHidden = false }
               [cell.vwMember3,cell.vwMember4].forEach { $0?.isHidden = true }
           }
           else if member.count == 3{
               cell.imgMember1.setImageFromUrl(url: member[0]["avatar"].stringValue)
               cell.imgMember2.setImageFromUrl(url: member[1]["avatar"].stringValue)
               cell.imgMember3.setImageFromUrl(url: member[2]["avatar"].stringValue)
               [cell.vwMember1, cell.vwMember2,cell.vwMember3].forEach { $0?.isHidden = false }
               cell.vwMember4.isHidden = true
           }
           else if member.count > 3{
               cell.imgMember1.setImageFromUrl(url: member[0]["avatar"].stringValue)
               cell.imgMember2.setImageFromUrl(url: member[1]["avatar"].stringValue)
               cell.imgMember3.setImageFromUrl(url: member[2]["avatar"].stringValue)
               [cell.vwMember1,cell.vwMember2, cell.vwMember3,cell.vwMember4].forEach { $0?.isHidden = false }
               cell.lblMoreMember.text = "\(member.count - 3)+"
           }
        }
        cell.selectionStyle = .none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let item = model.arrPromises[indexPath.row]
                
        let action = UIContextualAction(style: .normal,
                                        title: "") { [weak self] (action, view, completionHandler) in
            self?.controller.changePromiseStatus(status: .completed, item: item)
                                            completionHandler(true)
        }
        if #available(iOS 13.0, *) {
            action.image = image.completeAction1()?.withTintColor(color.greenColor()!)
        } else {
            // Fallback on earlier versions
        }
        action.backgroundColor = color.greenColor()?.withAlphaComponent(0.0)
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let item = model.arrPromises[indexPath.row]
        let action = UIContextualAction(style: .normal,
                                        title: "") { [weak self] (action, view, completionHandler) in
            self?.controller.changePromiseStatus( status: .failed, item: item)
                                            completionHandler(true)
        }

        if #available(iOS 13.0, *) {
            action.image = image.failAction()?.withTintColor(color.redColor()!)
        } else {
            // Fallback on earlier versions
        }
        action.backgroundColor = color.redColor()?.withAlphaComponent(0.0)
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}
