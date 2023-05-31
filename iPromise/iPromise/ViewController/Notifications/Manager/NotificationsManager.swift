//
//  Manager.swift
//  iPromise
//
//  Created by Apple on 16/03/23.
//

import Foundation
import UIKit

class NotificationsManager : NSObject{
    //MARK: -  variable
    fileprivate unowned var controller: NotificationsVC
    fileprivate unowned var model: NotificationsModel
    
    //MARK: -  intializer
    init(controller:NotificationsVC, model:NotificationsModel) {
        self.controller = controller
        self.model = model
    }
}
//MARK: - table view delegate
extension NotificationsManager : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controller.isList ? model.arrNotification.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if controller.isList{
            let cell = tableView.dequeueReusableCell (withIdentifier: "NotificationsCell", for: indexPath) as! NotificationsCell
            
            let dict = model.arrNotification[indexPath.row]
            cell.lblTime.text = dict["time"].stringValue
            if dict["type"].stringValue == notificationStatus.reminder.rawValue {
                cell.showButtonUI()
                cell.lblNotification.text = "Complete \(dict["promise"]["title"].stringValue) Promise!"
                cell.lblNotification.font = UIFont.customFont(font: .bold, size: 16)
                cell.lblNotification.highlightWords(phrases: [dict["promise"]["title"].stringValue], withColor: color.primaryColor(), withFont: nil)
                cell.leftButtonAction = { [self] sender in
                    controller.changePromiseStatus(status: .failed, id: dict["promise_member_id"].stringValue)
                }
                cell.rightButtonAction = { [self] sender in
                    controller.changePromiseStatus(status: .completed, id: dict["promise_member_id"].stringValue)
                }
                cell.imgNotification.image = image.reminder()
            }
            else if dict["type"].stringValue == notificationStatus.request.rawValue {
                cell.showButtonUI()
              cell.btnNegative.setBorderButton( cornerRadius: cell.btnNegative.frame.height/2)
              cell.btnNegative.setTitle("Skip", for: .normal)
              cell.btnPositive.setDarkButton()
              cell.btnPositive.setTitle("Join", for: .normal)
              cell.btnPositive.layer.cornerRadius =  cell.btnPositive.frame.size.height/2
              cell.imgNotification.setImageFromUrl(url: dict["from_user"]["avatar"].stringValue)

              cell.lblNotification.text = "\(dict["from_user"]["name"].stringValue) invites you to \(dict["promise"]["title"].stringValue) promise"
              cell.lblNotification.highlightWords(phrases: ["\(dict["from_user"]["name"].stringValue)"], withColor: color.blackColor(), withFont: UIFont.customFont(font: .bold, size: 16))
              cell.lblNotification.highlightWords(phrases: [ "\(dict["promise"]["title"].stringValue)"], withColor: color.primaryColor(), withFont: UIFont.customFont(font: .bold, size: 16))
              cell.leftButtonAction = { [self] sender in
                  controller.acceptDenyPromise(isAccept: false, promiseId: dict["promise"]["id"].intValue, id: Utils.getUserDetail(.id) )
              }
                cell.rightButtonAction = { [self] sender in
                    controller.acceptDenyPromise(isAccept: true, promiseId: dict["promise"]["id"].intValue, id: Utils.getUserDetail(.id))
                }
            }
            else{
                cell.hideButtonUI()
                if dict["from_user"]["name"].stringValue != "" {
                    cell.imgNotification.setImageFromUrl(url: dict["from_user"]["avatar"].stringValue)
                }
                else{
                    cell.imgNotification.image = image.bell()
                }
                cell.lblNotification.text = "\(dict["from_user"]["name"].stringValue) \(dict["content"].stringValue)"
                cell.lblNotification.highlightWords(phrases: [dict["from_user"]["name"].stringValue], withColor: nil, withFont: UIFont.customFont(font: .bold, size: 16))
            }
                
            cell.selectionStyle = .none
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell (withIdentifier: "NotificationStatusCell", for: indexPath) as! NotificationStatusCell
            cell.buttonAction = { [self] sender in
                let bool = sender.isOn
                let status = bool ? "on" : "off"
                Utils.showAlert(vc: controller, title: "Notification", msg: "Do you want to turn \(status) the Notification", actionTitle: "Yes", handler: { [self] in
                    controller.setNotificationStatus(isOn: cell.switchNotification.isOn ? true : false)
                },cancelHandler: {
                    cell.switchNotification.isOn = !sender.isOn
                })
               
            }
            cell.selectionStyle = .none
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let additionalSeparatorThickness = CGFloat(1)
//        let additionalSeparator = UIView(frame: CGRectMake(0,
//                                                           cell.frame.size.height - additionalSeparatorThickness,
//                                                           cell.frame.size.width,
//                                                           additionalSeparatorThickness))
//        additionalSeparator.backgroundColor =  !controller.isList ? .clear : color.grayColor()
//        cell.addSubview(additionalSeparator)
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
