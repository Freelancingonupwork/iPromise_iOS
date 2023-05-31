//
//  Manager.swift
//  iPromise
//
//  Created by Apple on 21/03/23.
//

import UIKit
import SwiftyJSON

class AddMemberManager : NSObject{
    //MARK: -  variable
    fileprivate unowned var controller: AddMemberVC
    fileprivate unowned var model: AddMemberModel

    //MARK: -  intializer
    init(controller:AddMemberVC, model:AddMemberModel) {
        self.controller = controller
        self.model = model
    }
}
//MARK: - table view delegate
extension AddMemberManager : UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? model.arrMembers.count : model.arrContact.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        returnedView.backgroundColor = .clear
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        label.font = UIFont.customFont(font: .bold, size: 18)
        label.textColor = color.blackColor()
        label.text = section == 0 ? (model.arrMembers.count > 0 ? "Invited Users" : "") : (model.arrContact.count > 0 ? "Phone Contacts" : "")
        returnedView.addSubview(label)
        return returnedView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell (withIdentifier: "AddMemberCell", for: indexPath) as! AddMemberCell
        
        let dict = indexPath.section == 0 ? model.arrMembers[indexPath.row] : model.arrContact[indexPath.row]
        cell.imgCall.isHidden = indexPath.section == 0 ? false : true
        cell.lblName.text = dict["name"].stringValue
        cell.imgMember.setImageFromUrl(url: dict["avatar"].stringValue)
        cell.lblPromises.text = "\(dict["promises"].arrayValue.count) promises"
        controller.arrSelectedMemeber.contains(dict) ? cell.setCheckedButton() : cell.setUncheckedButton()
        cell.buttonAction = { [self] sender in
            controller.manageSelectMember(member: indexPath.row, section: indexPath.section)
        }
        cell.selectionStyle = .none
        return cell
    }
    
}

