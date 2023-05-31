//
//  AddMemberVC.swift
//  iPromise
//
//  Created by Apple on 22/03/23.
//

import UIKit
import SwiftyJSON

class AddMemberVC: BaseViewController, CustomProtocol {

    //MARK: - variable
 
    fileprivate lazy var theView:AddMemberView = { [unowned self] in
        return self.view as! AddMemberView
    }()
    
    private lazy var theModel:AddMemberModel = { [unowned self] in
        return AddMemberModel(controller:self)
    }()
    
    private lazy var theManager:AddMemberManager = { [unowned self] in
        return AddMemberManager(controller: self, model: theModel)
    }()
    
   var arrSelectedMemeber = [JSON]()
    var delegate : CustomProtocol?
    var isAddMember = false{
        didSet{
            theView.isAddMember = isAddMember
        }
    }
    var promiseId = ""
    var strTitle = ""
    var arrPhoneContacts = [phoneContactModel]()
    var arrMainMemberJSON = [JSON]()
    var arrMainContactJSON = [JSON]()
    var arrContact = [[String:Any]]()
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        callMethods()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationBar()
        super.viewWillAppear(animated)
     
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: -  call methods
    func callMethods(){
        setupUIAndManager()
        getContacts()
        //getMembers()
        theView.txtSearch.delegate = self
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
   
   
    //MARK: -  keyboard event
//    @objc func keyboardWillAppear() {
//        theView.hideBanner()
//    }
//
//    @objc func keyboardWillDisappear() {
//        theView.showBanner()
//    }

    
    //MARK: - navigation bar
    func setNavigationBar(){
        self.navigationController?.navigationBar.isHidden = false
        self.title = strTitle
        if !isAddMember{
            alignTitleAtLeading()
            //setRightButton(title: "Cancel")
        }
    }
    //MARK: -  setupUI and manager
    func setupUIAndManager()
    {
        theView.setupUI(delegate: theManager)
        theView.txtSearch.delegate = self
        theView.txtSearch.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    //MARK: - button click
    @IBAction func btnInviteClicked(_ sender: UIButton) {
        let vc = InviteViaContactVC(nib: nib.inviteViaContactVC)
        moveToNext(vc: vc)
    }
    @IBAction func btnCloseBannerClicked(_ sender: UIButton) {
        theView.hideBanner(isHideByClick: true)
    }
    
    @IBAction func btnOtherClicked(_ sender: UIButton) {
        shareApp(vc: self)
    }
    
    @IBAction func btnInviteMemberClicked(_ sender: UIButton) {
        if !isAddMember{
            delegate?.passdataToBack?(data: arrSelectedMemeber)
            navigationController?.popViewController(animated: true)
        }
        else{
            addMember()
        }
    }
}
//MARK: -  ui method
extension AddMemberVC{

    @objc func textFieldDidChange(textField: UITextField)
    {
        if(textField == theView.txtSearch){
            let arraySearchMember = arrMainMemberJSON.filter { (json) -> Bool in
            let name = json["name"].stringValue + " " + json["phone"].stringValue
                Log.info("\(name)-\(textField.text ?? "")")
                if(name.lowercased().contains((textField.text?.lowercased())!))
                {
                    return true
                }
                return false
            }
            let arraySearchContact = arrMainContactJSON.filter { (json) -> Bool in
            let name = json["name"].stringValue + " " + json["phone"].stringValue
                Log.info("\(name)-\(textField.text ?? "")")
                return (name.lowercased().contains((textField.text?.lowercased())!)) ? true : false
            }
            
            if(textField.text!.count > 0)
            {
                theModel.arrMembers = arraySearchMember
                theModel.arrContact = arraySearchContact
                theView.tblMembers.reloadData()
            }else{
                theModel.arrMembers = arrMainMemberJSON
                theModel.arrContact = arrMainContactJSON
                theView.tblMembers.reloadData()
            }
        }
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
       if textField == theView.txtSearch{
          // getMembers()
           return true
       }
       return true
    }
}
//MARK: -  other method
extension AddMemberVC{
    
    func getContacts(){
        
        Permissions.checkContactPermission(aViewcontoller: self, completionHandler: { [self] bool in
            if bool && arrPhoneContacts.count == 0{
                loadContacts()
            }
        })

    }
    func loadContacts() {
      
        arrPhoneContacts.removeAll()
        var allContacts = [phoneContactModel]()
        for contact in phoneContacts.getContacts() {
            if (!contact.familyName.isEmpty || !contact.givenName.isEmpty) && contact.phoneNumbers.count != 0{
                allContacts.append(phoneContactModel(contact: contact))
            }
        }
        arrPhoneContacts.append(contentsOf: allContacts)
        arrPhoneContacts = arrPhoneContacts.sorted(by: { $0.name ?? "" < $1.name ?? ""} )
        arrPhoneContacts.forEach{
            let data = ["name" : $0.name ?? "" , "phone" :  $0.phoneNumber.first ?? ""]
            arrContact.append(data)
        }
        Log.info("arrContact - \(arrContact)")
        Log.info("\(json(from:arrContact as Any) ?? "---")")
        getMembers()
        //theModel.arrMembers = arrPhoneContacts
//        DispatchQueue.main.async { [self] in
//            theView.tblMembers.reloadData()
//        }
     
    }
    
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }

    func manageSelectMember(member : Int, section : Int){
        let member = section == 0 ? theModel.arrMembers[member] : theModel.arrContact[member]
        if arrSelectedMemeber.contains(member){
            arrSelectedMemeber.removeAll(where: { $0 == member})
            theView.tblMembers.reloadData()
        }
        else{
            arrSelectedMemeber.append(member)
            theView.tblMembers.reloadData()
        }
        
        arrSelectedMemeber.count > 0 ? theView.setButtonActive(count: arrSelectedMemeber.count) : theView.setInactiveButton()
    }
    
    func moveBack(){
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
//MARK: -  api call
extension AddMemberVC{
    func getMembers(){
        DispatchQueue.main.async { [self] in
            let param : [String:Any] = ["search" : theView.txtSearch.text ?? "", "contacts" : arrContact]
            APIHelper.sharedInstance.networkServiceJSON(controller: self, apiurl: .getMembers, methodType: "POST", param: param, withCompletion: { [self]responseJSON,code in
                if code == "1"{
                    theModel.arrMembers = []
                    let contact = responseJSON["data"]["contacts"].arrayValue
                    let user = responseJSON["data"]["users"].arrayValue
                    theModel.arrMembers.append(contentsOf: user)
                    theModel.arrContact.append(contentsOf: contact)
                    arrMainMemberJSON = theModel.arrMembers
                    arrMainContactJSON = theModel.arrContact
                    theView.tblMembers.reloadData()
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
    
    func addMember(){

        var members = [[String:Any]]()
        arrSelectedMemeber.forEach{ member in
            members.append(["id" : member["id"].intValue, "is_maker" : 0,  "phone" : member["phone"].stringValue])
            //["id" :  dictPromise.count > 0 ? (member["user_id"].exists() ? member["user_id"].stringValue : member["id"].stringValue) : (member["id"].stringValue), "is_maker" : 0, ]
        }
        

        let param :[String:Any] = ["users":members]

        APIHelper.sharedInstance.networkServiceJSON(controller: self, apiurl: .addMembers, extraParam: promiseId, methodType: "POST", param: param, withCompletion: { [self]responseJSON,code in
            if code == "1"{
                Utils.showToast(strMessage:  responseJSON["message"].stringValue)
                NotificationCenter.default.post(name: Notification.Name("refreshPromise"), object: nil)
                NotificationCenter.default.post(name: Notification.Name("refreshProfilePromise"), object: nil)
                moveBack()
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
