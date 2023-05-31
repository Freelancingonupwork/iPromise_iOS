//
//  Manager.swift
//  iPromise`
//
//  Created by Apple on 21/03/23.
//

import Foundation
import FSCalendar

class PromiseSetupManager : NSObject{
    //MARK: -  variable
    fileprivate unowned var controller: PromiseSetupVC
    fileprivate unowned var model: PromiseSetupModel

    //MARK: -  intializer
    init(controller:PromiseSetupVC, model:PromiseSetupModel) {
        self.controller = controller
        self.model = model
    }
}

//MARK: - fs calender delegate
extension PromiseSetupManager : FSCalendarDelegate, FSCalendarDataSource,FSCalendarDelegateAppearance{
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool
    {
        let todayDate = calendar.today ?? Date()
        if(date >= todayDate)
        {
            return true
        }
        Utils.showToast(strMessage: "Please select date which is greater than today date")
        return false
    }

    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        return color.blackColor()
    }

    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let currentPageDate = calendar.currentPage
        let month = Calendar.current.component(.month, from: currentPageDate)
        let mon = month
        let monthName = DateFormatter().monthSymbols[mon - 1]
        let year = Calendar.current.component(.year, from: currentPageDate)
        let yr = year
        controller.setMonthButton(title: ("\(monthName) \(yr)   "))
    }
    

}

//MARK: - table view delegate
extension PromiseSetupManager : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.arrMember.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell (withIdentifier: "InviteCell", for: indexPath) as! InviteCell
        let dict = model.arrMember[indexPath.row]
        cell.lblName.text = dict["name"].stringValue
        //9328007624
        if indexPath.row == 0{
            cell.lblName.text = "\(dict["name"].stringValue) (you)"
            cell.btnRemove.isHidden = true
            cell.btnCheckBox.isSelected = true
            cell.btnCheckBox.isUserInteractionEnabled = false
            cell.setCheckedButton()
            cell.lblName.highlightWords(phrases: ["(you)"], withColor: color.grayColor(), withFont: UIFont.customFont(font: .regular, size: 14 ))
            if !controller.arrSelectedMaker.contains(dict){
                controller.arrSelectedMaker.append(dict)
            }
        }
        else{
            [cell.btnRemove, cell.btnCheckBox].forEach {
                $0?.isHidden = false
            }
            controller.arrSelectedMaker.contains(dict) ? cell.setCheckedButton() : cell.setUncheckedButton()
        }
        cell.buttonCheckAction = { [self] sender in
            sender.isSelected = !sender.isSelected
            sender.isSelected ? cell.setCheckedButton() : cell.setUncheckedButton()
            controller.addRemoveAsMaker(dict: dict)
        }
        cell.buttonRemoveAction = { sender in
            self.controller.removeMember(index: indexPath.row)
        }
        cell.selectionStyle = .none
        return cell
    }
    
}

//MARK: -  textview delegate
extension PromiseSetupManager :  UITextViewDelegate{
    func textViewDidEndEditing(_ textView: UITextView) {
        if !controller.theView.txtPromiseTitle.text.isEmpty && !controller.theView.txtPromiseDescription.text.isEmpty{
            controller.hideShowInviteButton(ishide: false)
        }
        else{
            controller.hideShowInviteButton(ishide: true)
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        let limit = 250
        if numberOfChars < limit {
           return true
        }
        else{
            Utils.showToast(strMessage: "problem details should be less than \(limit) characters")
            return false
        }
    }
}
