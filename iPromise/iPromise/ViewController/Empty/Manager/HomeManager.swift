//
//  Manager.swift
//  iPromise
//
//  Created by Apple on 15/03/23.
//

import Foundation
import BubbleShowCase

class HomeManager : NSObject{
    
    //MARK: -  variable
    fileprivate unowned var controller: HomeVC
    fileprivate unowned var model: HomeModel
    
    //MARK: -  intializer

    init(controller:HomeVC, model:HomeModel) {
        self.controller = controller
        self.model = model
    }

}
//MARK: - table view delegate
extension HomeManager : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.arrPromise.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PromiseCell", for: indexPath) as! PromiseCell
        
        let dict = model.arrPromise[indexPath.row]
        cell.imgPromise.setImageFromUrl(url: dict["image"].stringValue)
        cell.lblPromiseTitle.text = dict["title"].stringValue
        cell.lblDate.text = dict["created"].stringValue
        
        let id = Utils.getUserDetail(.id)
        let member = dict["members"].arrayValue.filter({ $0["user_id"].stringValue != id  })
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
               //[cell.vwMember1, cell.vwMember2, cell.vwMember3,cell.vwMember4].forEach { $0?.isHidden = true }
               cell.setNoMemberView()
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
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let id = model.arrPromise[indexPath.row]["member_id"].stringValue
                
        let action = UIContextualAction(style: .normal,
                                        title: "") { [weak self] (action, view, completionHandler) in
            self?.controller.completePromiseAction(id: id)
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
        let id = model.arrPromise[indexPath.row]["member_id"].stringValue
        let action = UIContextualAction(style: .normal,
                                        title: "") { [weak self] (action, view, completionHandler) in
            self?.controller.failPromiseAction(id: id)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = model.arrPromise[indexPath.row]
        controller.redirectToPromiseDEtail(dict: dict)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let dict = model.arrPromise[indexPath.row]
        if (dict["status"].stringValue).caseInsensitiveCompare(promiseCompletionStatus.completed.rawValue) == .orderedSame || (dict["status"].stringValue).caseInsensitiveCompare(promiseCompletionStatus.failed.rawValue) == .orderedSame {
            return false
        }
        else  {
            return true
        }
        
    }
}
