//
//  PromiseSetupVC.swift
//  iPromise
//
//  Created by Apple on 22/03/23.
//

import UIKit
import SwiftyJSON

class PromiseSetupVC: BaseViewController, CustomProtocol {

    

    //MARK: - variable
 
    lazy var theView:PromiseSetupView = { [unowned self] in
        return self.view as! PromiseSetupView
    }()
    
    private lazy var theModel:PromiseSetupModel = { [unowned self] in
        return PromiseSetupModel(controller:self)
    }()
    
    private lazy var theManager:PromiseSetupManager = { [unowned self] in
        return PromiseSetupManager(controller: self, model: theModel)
    }()
    
    var arrMembers = [JSON](){
        didSet{
            let array = arrMembers.filter({ $0["user_id"].stringValue == Utils.getUserDetail(.id) })
            let array2 = arrMembers.filter({ $0["user_id"].stringValue != Utils.getUserDetail(.id) })
            let mainArray : [JSON] = array+array2
            theModel.arrMember = mainArray
        }
    }
    var dictPromise = (JSON)(){
        didSet{
            theView.dictPromise = dictPromise
            arrMembers = dictPromise["members"].arrayValue
            arrSelectedMaker = arrMembers.filter({ $0["is_maker"].stringValue == "1" })
        }
    }
    var arrSelectedMaker = [JSON]()
    var arrDeletedIDs = [String]()
    var isFromMakePromise = false{
        didSet{
            theView.isShowIndicator = isFromMakePromise ? true : false
        }
    }

    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIAndManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationBar()
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    //MARK: -  keyboard event
    @objc func keyboardWillAppear() {
        theView.vwPromiseDetail.setShadow(borderColor: color.primaryColor(), corner: 25)
    }

    @objc func keyboardWillDisappear() {
        theView.vwPromiseDetail.setShadow(borderColor: .clear, corner: 25  )
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
   
    
    
    //MARK: - navigation bar
    func setNavigationBar(){
        self.navigationController?.navigationBar.isHidden = false
       // setRightButton()
        self.title = "Set up a promise"
        
    }
    //MARK: -  setupUI and manager
    func setupUIAndManager()
    {
        theView.setupUI(delegate: theManager)
        theManager.calendarCurrentPageDidChange(theView.vwFSCalender)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        theView.vwCalenderDismiss.addGestureRecognizer(tap)
    }
    
    //MARK: - button click
    @IBAction func btnSaveClicked(_ sender: UIButton) {
        if theView.txtPromiseTitle.text.isEmpty{
            Utils.showToast(strMessage: "please enter promise title")
        }
        else if theView.txtPromiseDescription.text.isEmpty{
            Utils.showToast(strMessage: "please enter promise description")
        }
        else if theView.lblSetEndDate.text == "Set end date" {
            Utils.showToast(strMessage: "plese select promise end date")
        }
        else{
            addEditPromise()
        }
    }
    @IBAction func btnInviteClicked(_ sender: UIButton) {
        let vc =  AddMemberVC(nib: nib.addMemberVC)
        vc.strTitle = "Invite friends"
        vc.delegate = self
        moveToNext(vc: vc)
    }
    @IBAction func btnEndDateClicked(_ sender: UIButton) {
        theView.hideShowCalender()
    }

    @IBAction func btnConfirmClicked(_ sender: UIButton) {
        theView.hideShowCalender()
        theView.setDate()
    }
    @IBAction func btnNextClicked(_ sender: UIButton) {
        theView.moveToNextMonth()
    }
    @IBAction func btnPreviousClicked(_ sender: UIButton) {
        theView.moveToPreviousMonth()
    }
    @IBAction func btnMonthClicked(_ sender: UIButton) {
        theView.showYearMonthPicker(vc: self)
    }

}

//MARK: - textiew delegate
extension PromiseSetupVC : UITextViewDelegate{
    
}

//MARK: -  ui methods
extension PromiseSetupVC{
    func setMonthButton(title : String){
        theView.setMonthButtonTitle(title: title)
    }
}

//MARK: -  other method
extension PromiseSetupVC{

    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        theView.hideShowCalender()
    }
    
    func hideShowInviteButton(ishide : Bool){
        ishide ? theView.hideInviteView() : theView.showInviteView()
    }
    
    func addRemoveAsMaker(dict : JSON){
        if arrSelectedMaker.contains(dict){
            arrSelectedMaker.removeAll(where: { $0 == dict})
        }
        else{
            arrSelectedMaker.append(dict)
        }
    }
    
    func removeMember(index : Int){
        if dictPromise.count > 0{
            arrDeletedIDs.append(theModel.arrMember[index]["user_id"].stringValue)
        }
        theModel.arrMember.remove(at: index)
        theView.tblInviteMember.reloadData()
    }
    func dismissed(vc: UIViewController) {
        var viewControllers: [UIViewController] = self.navigationController!.viewControllers
        viewControllers = viewControllers.reversed()
        for aViewController in viewControllers {
            if aViewController is ProfileVC {
                self.navigationController!.popToViewController(aViewController, animated: true)
                break
            }
            else if aViewController is HomeVC {
                self.navigationController!.popToViewController(aViewController, animated: true)
                break
            }
        }
    }
    
    func passdataToBack(data: Any) {
        if let json = data as? [JSON]{
            json.forEach{ item in
                if dictPromise.count > 0 {
                    let id = item["id"].stringValue
                    if !theModel.arrMember.contains(where: { $0["user_id"].stringValue == id }){
                        theModel.arrMember.append(item)
                    }
                }
                else if !theModel.arrMember.contains(item){
                    theModel.arrMember.append(item)
                }
                
            }
            theView.tblInviteMember.reloadData()
        }
    }
    

    
    func backToViewController(){
        var viewControllers: [UIViewController] = self.navigationController!.viewControllers
        viewControllers = viewControllers.reversed()
        for aViewController in viewControllers {
            if aViewController is ProfileVC {
                self.navigationController!.popToViewController(aViewController, animated: true)
                break
            }
            else if aViewController is HomeVC {
                self.navigationController!.popToViewController(aViewController, animated: true)
                break
            }
        }
    }
    
    
    
}

//MARK: -  API call
extension PromiseSetupVC{
    func addEditPromise(){
        
        let extraParam = dictPromise.count > 0 ? "/\(dictPromise["id"].stringValue)" : ""
        let method = dictPromise.count > 0 ? "PUT" : "POST"
        promiseType =  dictPromise.count > 0 ? dictPromise["type_id"].stringValue : promiseType
        subCategoryId =  dictPromise.count > 0 ? dictPromise["subcategory_id"].stringValue : subCategoryId
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let endDate = df.string(from: theView.vwFSCalender.selectedDate ?? Date())
        
        var members = [[String:Any]]()
        theModel.arrMember.forEach{ member in
            if arrSelectedMaker.contains(member){
                members.append(["id" : dictPromise.count > 0 ? (member["user_id"].exists() ? member["user_id"].stringValue : member["id"].stringValue) : (member["id"].stringValue), "is_maker" : 1,  "phone" : member["phone"].stringValue])
            }
            else{
                members.append(["id" :  dictPromise.count > 0 ? (member["user_id"].exists() ? member["user_id"].stringValue : member["id"].stringValue) : (member["id"].stringValue), "is_maker" : 0,  "phone" : member["phone"].stringValue])
            }
          //  members.append(["id" : member["id"].stringValue, "is_maker" : arrSelectedMaker.contains(member) ? "1" : "0" , "phone" : member["phone"].stringValue ])
        }
        
        let param : [String:Any] = ["type_id" : promiseType,
                                    "subcategory_id" : subCategoryId,
                                    "title" : theView.txtPromiseTitle.text ?? "",
                                    "description" : theView.txtPromiseDescription.text ?? "",
                                    "end_date" : endDate,
                                    "users" : members,
                                    "deleted_ids" : arrDeletedIDs]
        APIHelper.sharedInstance.networkServiceJSON(controller: self, apiurl: .promise, extraParam: extraParam, methodType: method, param: param, withCompletion: { [self]responseJSON,code in
            if code == "1"
            {
                Utils.showToast(strMessage: responseJSON["message"].stringValue)
                NotificationCenter.default.post(name: Notification.Name("refreshPromise"), object: nil)
                NotificationCenter.default.post(name: Notification.Name("refreshProfilePromise"), object: nil)
                backToViewController()
            }
            else if code == errorCode{
                showLogoutAlert(vc: self, message: responseJSON["message"].stringValue)
            }
            else{
                Utils.showToast(strMessage: code)
            }
        })
    }
}
