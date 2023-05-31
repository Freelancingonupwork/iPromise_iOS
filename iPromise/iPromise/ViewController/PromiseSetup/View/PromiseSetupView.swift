//
//  View.swift
//  iPromise
//
//  Created by Apple on 21/03/23.
//

import UIKit
import GrowingTextView
import FSCalendar
import SwiftyJSON

class PromiseSetupView : UIView{
    //MARK: - outlet
   
    @IBOutlet weak var txtPromiseTitle: GrowingTextView!
    @IBOutlet weak var txtPromiseDescription: GrowingTextView!
    
    @IBOutlet weak var vwFSCalender: FSCalendar!
    @IBOutlet weak var vwPromiseDetail: UIView!
    @IBOutlet weak var vwEndDate: UIView!
    @IBOutlet weak var vwCalender: UIView!
    @IBOutlet weak var vwCalenderUI: UIView!
    @IBOutlet weak var vwCalenderDismiss: UIView!
    @IBOutlet weak var vwInvite: UIView!
    @IBOutlet weak var vwTblInvite: UIView!
    
    @IBOutlet weak var lblInvite: UILabel!
    @IBOutlet weak var lblSetEndDate: UILabel!
    @IBOutlet weak var lblEndDate: UILabel!
    @IBOutlet weak var lblChooseMaker: UILabel!
    
    @IBOutlet weak var btnInvite: UIButton!
    @IBOutlet weak var btnMonth: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var btnSave: UIButton!

    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    
    @IBOutlet weak var stackviewIndicator: UIStackView!
    
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tblInviteMember: UITableView!
    //MARK: - variable
    var selectedValue = ""
    var doneClickValue = ""
    var isShowIndicator = false{
        didSet{
            stackviewIndicator.isHidden =  isShowIndicator ? false : true
        }
    }
    var dictPromise = (JSON)(){
        didSet{
            setData()
        }
    }
    
    //MARK: - setupUI
    func setupUI(delegate : PromiseSetupManager){
        vwCalenderUI.setTopCorner(radius: 30)
        vwPromiseDetail.makeCorner()
        [vwEndDate, vwInvite].forEach { $0.makeCorner(corner: 20) }
        
        [img1,img2,img3].forEach { $0?.makeRound() }
        
        txtPromiseTitle.font = UIFont.customFont(font: .bold, size: 18)
        txtPromiseDescription.font = UIFont.customFont(font: .regular, size: 16)
        txtPromiseDescription.minHeight = 100
        [txtPromiseTitle,txtPromiseDescription].forEach { $0?.delegate = delegate }
        
        [lblInvite, lblSetEndDate,lblEndDate].forEach{ $0.font = UIFont.customFont(font: .bold, size: 18) }
        lblChooseMaker.font = UIFont.customFont(font: .medium, size: 17)
        lblChooseMaker.text = """
                            Choose maker
                            Not selected users will be set as the viewer.
                            """
        lblChooseMaker.highlightWords(phrases: ["Not selected users will be set as the viewer."], withColor: nil, withFont: UIFont.customFont(font: .regular, size: 15))
        
        btnConfirm.setDarkButton()
        btnSave.setDarkButton()
        btnMonth.setRightSideImage()
        btnMonth.setLightButton(BGcolor: .clear)
    
        tblInviteMember.delegate = delegate
        tblInviteMember.dataSource = delegate
        vwFSCalender.delegate = delegate
        vwFSCalender.dataSource = delegate
        setupCalender()
        registerCell()
        hideInviteView()
    }
    
    //MARK: - register cell
    func registerCell(){
        tblInviteMember.register(UINib(nibName: "InviteCell", bundle: nil), forCellReuseIdentifier: "InviteCell")
        tblInviteMember.reloadData()
        tblInviteMember.separatorStyle = .none
        tblInviteMember.isScrollEnabled = false
        tblInviteMember.rowHeight = UITableView.automaticDimension
        tblInviteMember.backgroundColor = .clear
        tblInviteMember.addObserver(self, forKeyPath: "contentSize", options: .new, context: .none)
        tblInviteMember.reloadData()
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if (object as! UITableView) == self.tblInviteMember {
            if(keyPath == "contentSize"){
                if let newvalue = change?[.newKey]
                {
                    let newsize = newvalue as! CGSize
                    self.tableHeight.constant = newsize.height 
                }
            }
        }
    }
    
    func setData(){
        stackviewIndicator.isHidden = true
        
        txtPromiseTitle.text = dictPromise["title"].stringValue
        txtPromiseDescription.text = dictPromise["description"].stringValue
        
        let strDate = dictPromise["end_date"].stringValue.trunc(length: 10)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        guard let date = dateFormatter.date(from: strDate) else {
            return
        }
        
        vwFSCalender.select(date)
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = "d MMMM yyyy"
        let newStr = newDateFormatter.string(from: date)

        lblSetEndDate.text = "End Date : \(newStr)"
        lblSetEndDate.highlightWords(phrases: [newStr], withColor: color.grayColor(), withFont: UIFont.customFont(font: .regular, size: 16))
        
        showInviteView()
    }
    
    //MARK: - invite view
    func showInviteView(){
        btnInvite.isHidden = false
    }
    
    func hideInviteView(){
        btnInvite.isHidden = true
    }
     
    func setupCalender(){
        vwFSCalender.appearance.headerTitleColor = .clear
        vwFSCalender.appearance.weekdayTextColor = color.grayColor()
        vwFSCalender.appearance.weekdayFont = UIFont.customFont(font: .medium, size: 16)
        vwFSCalender.appearance.caseOptions = [.headerUsesUpperCase, .weekdayUsesUpperCase]
        vwFSCalender.appearance.headerMinimumDissolvedAlpha = 0
        vwFSCalender.headerHeight = 0
        vwFSCalender.appearance.titleFont = UIFont.customFont(font: .regular, size: 14)
        vwFSCalender.appearance.borderRadius = 0.6
        vwFSCalender.appearance.selectionColor = color.primaryColor()
        vwFSCalender.placeholderType = .none
        vwFSCalender.scrollEnabled = false
        vwFSCalender.appearance.todayColor = color.greenColor()
    }
    
    func getNextMonth(date:Date)->Date {
        return  Calendar.current.date(byAdding: .month, value: 1, to:date)!
    }
    
    func getPreviousMonth(date:Date)->Date {
        return  Calendar.current.date(byAdding: .month, value: -1, to:date)!
    }
    
    
    func moveToNextMonth(){
        vwFSCalender.setCurrentPage(getNextMonth(date: vwFSCalender.currentPage), animated: true)
    }
    
    func moveToPreviousMonth(){
        let currentMonth = Calendar.current.component(.month, from: Date())
        let newDate = Calendar.current.date(byAdding: .month, value: -1, to:vwFSCalender.currentPage)!
        let newMonth = Calendar.current.component(.month, from: newDate)
        if !(newMonth < currentMonth){
            vwFSCalender.setCurrentPage(getPreviousMonth(date: vwFSCalender.currentPage), animated: true)
        }
        else{
            Utils.showToast(strMessage: "Please select upcoming Month")
        }
    }
    
    func validateDateMovement(date : Date, isValid : @escaping ((Bool) -> Void)){

        
    }
    
    
    func hideShowCalender(){
        vwCalender.isHidden = !vwCalender.isHidden
    }
    
    func setMonthButtonTitle(title : String){
        btnMonth.setTitle(title, for: .normal)
    }
    
    
    func showYearMonthPicker(vc : UIViewController){
        AKMonthYearPickerView.sharedInstance.barTintColor = color.primaryColor()!
        AKMonthYearPickerView.sharedInstance.previousYear = 20
        AKMonthYearPickerView.sharedInstance.show(vc: vc, doneHandler: doneHandler, completetionalHandler: completetionalHandler)
    }
    
    private func doneHandler() {
        doneClickValue = selectedValue
        selectedValue = ""
        if doneClickValue != "" {
            let month = Int(doneClickValue.components(separatedBy: "-")[0]) ?? 0
            let year = Int(doneClickValue.components(separatedBy: "-")[1]) ?? 0
            let monthName = DateFormatter().monthSymbols[month - 1]
            
            let stringDate = "\(month)-\(year)"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-yyyy"
            let date = dateFormatter.date(from: stringDate)
            
            if (date! < Date()){
                Utils.showToast(strMessage: "please selected future month/year")
            }
            else{
                moveToDate(month: month, year: year)
                setMonthButtonTitle(title: "\(monthName) \(year)")
            }
        }
    
    }
    
    private func completetionalHandler(month: Int, year: Int) {
        selectedValue = "\(month)-\(year)"
    }

    
    func moveToDate(month : Int, year: Int){
        let month = month
        let year = year
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: vwFSCalender.currentPage)
        dateComponents.setValue(month, for: .month)
        dateComponents.setValue(year, for: .year)
        let date = Calendar.current.date(from: dateComponents)
        vwFSCalender.setCurrentPage(date!, animated: true)
    }
    
    func setDate(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        
        let stringDate = dateFormatter.string(from: vwFSCalender.selectedDate ?? Date())
        
        lblSetEndDate.text = "End Date : \(stringDate)"
        lblSetEndDate.highlightWords(phrases: [stringDate], withColor: color.grayColor(), withFont: UIFont.customFont(font: .regular, size: 16))

    }
}
