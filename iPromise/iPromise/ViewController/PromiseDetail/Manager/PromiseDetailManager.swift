//
//  Manager.swift
//  iPromise
//
//  Created by Apple on 21/03/23.
//

import UIKit



class PromiseDetailManager : NSObject{
    //MARK: -  variable
    fileprivate unowned var controller: PromiseDetailVC
    fileprivate unowned var model: PromiseDetailModel

    //MARK: -  intializer
    init(controller:PromiseDetailVC, model:PromiseDetailModel) {
        self.controller = controller
        self.model = model
    }
}
//MARK: - table view delegate
extension PromiseDetailManager : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? model.arrMaker.count : model.arrMembers.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        returnedView.backgroundColor = .clear
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        label.font = UIFont.customFont(font: .bold, size: 18)
        label.textColor = color.blackColor()
        label.text = section == 0 ? "Makers (\(model.arrMaker.count))" : (model.arrMembers.count >  0 ? "Member" : "")
        returnedView.addSubview(label)
        return returnedView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell (withIdentifier: "PromiseCell", for: indexPath) as! PromiseCell
        cell.imgPromise.layer.cornerRadius = 15
        cell.imgPromise.contentMode = .scaleAspectFill
        let dict = (indexPath.section == 0) ? model.arrMaker[indexPath.row] : model.arrMembers[indexPath.row]
        let id = Utils.getUserDetail(.id)
        if id == dict["user_id"].stringValue && dict["status"].stringValue.lowercased() != promiseCompletionStatus.in_progress.rawValue {
            controller.hideButtons()
        }
        
        if id == dict["user_id"].stringValue && dict["is_maker"].intValue != 1 {
            controller.hideRightButton()
        }

        cell.lblPromiseTitle.text = dict["name"].stringValue
        cell.imgPromise.setImageFromUrl(url: dict["avatar"].stringValue)
        let status = dict["status"].stringValue.lowercased()
        if #available(iOS 13.0, *) {
            status == promiseCompletionStatus.completed.rawValue ? cell.setCompletedPromise() : (status == promiseCompletionStatus.failed.rawValue ? cell.setFailPromise() : ( dict["is_joined"].intValue == 1 ? cell.setINProgressPromise() : cell.setInvitedPromise()) )
        } else {
            // Fallback on earlier versions
        }
        

        cell.selectionStyle = .none
        return cell
    }
 
}
