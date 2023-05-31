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
//    fileprivate unowned var theView : HomeView
    
    //MARK: -  intializer
//    init(controller:HomeVC, model:HomeModel, theView : HomeView) {
//        self.controller = controller
//        self.model = model
//        self.theView = theView
//    }
    init(controller:HomeVC, model:HomeModel) {
        self.controller = controller
        self.model = model
    }

}
//MARK: - table view delegate
extension HomeManager : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

//        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: tableView.frame.size.height))
//        let imageView = UIImageView(frame: CGRect(x: 0, y: 20, width: tableView.frame.size.width, height: tableView.frame.size.height-100))
//        imageView.image = image.noPromise()
//        imageView.contentMode = .scaleAspectFill
//
//        let label = UILabel(frame: CGRect(x: 0, y: imageView.frame.size.height + 20, width: imageView.frame.size.width, height: 25))
//        label.font = UIFont.customFont(font: .bold, size: 20)
//        label.text = "Nothing yet"
//        label.textColor = color.blackColor()
//        label.textAlignment = .center
//
//        let label2 = UILabel(frame: CGRect(x: 0, y: imageView.frame.size.height + 50, width: imageView.frame.size.width, height: 20))
//        label2.font = UIFont.customFont(font: .regular, size: 16)
//        label2.text = "Don't be shy, create your first promise"
//        label2.numberOfLines = 0
//        label2.textAlignment = .center
//        label2.textColor = color.blackColor()
//
//        view.addSubview(imageView)
//        view.addSubview(label)
//        view.addSubview(label2)
//        view.backgroundColor = .clear
//        tableView.backgroundView = view
        return 7
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell (withIdentifier: "PromiseCell", for: indexPath) as! PromiseCell
        var member = 0

        if indexPath.row == 0 {
            member = 6
            cell.lblMoreMember.text = "\(member - 3)+"
        }
        else if indexPath.row == 1 {
            member = 3
            cell.vwMember4.isHidden = true
        }
        else if indexPath.row == 2 {
            member = 2
            [cell.vwMember3,cell.vwMember4].forEach { $0?.isHidden = true }
        }
        else if indexPath.row == 3 {
            member = 1
            [cell.vwMember2, cell.vwMember3,cell.vwMember4].forEach { $0?.isHidden = true }
        }
        else if indexPath.row == 4 {
            cell.vwMembers.isHidden = true
        }
        else if indexPath.row == 5 {
            //cell.vwMembers.isHidden = true
            cell.setFailPromise()
        }
        else if indexPath.row == 6 {
            //cell.vwMembers.isHidden = true
            cell.setCompletedPromise()
        }

            
            
        cell.selectionStyle = .none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal,
                                        title: "") { [weak self] (action, view, completionHandler) in
            self?.controller.completePromiseAction()
                                            completionHandler(true)
        }

        
        action.image = image.completeAction1()?.withTintColor(color.whiteColor()!)
        action.image?.withTintColor(color.whiteColor()!)
        action.backgroundColor = color.greenColor()
        
        
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal,
                                        title: "") { [weak self] (action, view, completionHandler) in
            self?.controller.failPromiseAction()
                                            completionHandler(true)
        }

        
        action.image = image.failAction()?.withTintColor(color.whiteColor()!)
        action.image?.withTintColor(color.whiteColor()!)
        action.backgroundColor = color.redColor()
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    
}


extension HomeManager: BubbleShowCaseDelegate {

    func bubbleShowCase(_ bubbleShowCase: BubbleShowCase, didTap target: UIView!, gestureRecognizer: UITapGestureRecognizer) {
        guard let showCaseLabel = bubbleShowCase.label else { return }
        guard showCaseLabel == "startDemoButton" else { return }
//        
//        showSimpleAlert(title: "Hey!", message: "You can react to certain gestures. See ShowCaseDelegate for more information.") { [weak self] in
//            guard let `self` = self else { return }
//            self.startDemoDidTap(self.startDemoButton)
//        }
        
        bubbleShowCase.dismiss()
    }
    
}
