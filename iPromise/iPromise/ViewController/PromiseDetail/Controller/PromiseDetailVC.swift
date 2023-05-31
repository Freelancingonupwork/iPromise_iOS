//
//  PromiseDetailVC.swift
//  iPromise
//
//  Created by Apple on 22/03/23.
//

import UIKit
import SwiftyJSON

class PromiseDetailVC: BaseViewController, CustomProtocol {
    //MARK: - variable
 
    fileprivate lazy var theView:PromiseDetailView = { [unowned self] in
        return self.view as! PromiseDetailView
    }()
    
    private lazy var theModel:PromiseDetailModel = { [unowned self] in
        return PromiseDetailModel(controller:self)
    }()
    
    private lazy var theManager:PromiseDetailManager = { [unowned self] in
        return PromiseDetailManager(controller: self, model: theModel)
    }()
    var dictPromise = JSON(){
        didSet{
            let users = dictPromise["members"].arrayValue
            theModel.arrMaker = users.filter( { $0["is_maker"].intValue == 1  })//.filter({$0["is_joined"].intValue == 1 })
            theModel.arrMembers = users.filter( { $0["is_maker"].intValue == 0  })//.filter({$0["is_joined"].intValue == 1 })
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
     
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBar()
    }
   
    //MARK: - navigation bar
    func setNavigationBar(){
        self.navigationController?.navigationBar.isHidden = false
        self.title = "Promise Detail"
        setProfileButton(isPromiseDetail: true)
        self.navigationController?.setNavigationBar(foreGroundColor: color.whiteColor())
        self.navigationController?.navigationBar.tintColor = color.whiteColor()
    }
    
    override func btnProfileClicked(_ sender: AnyObject) {
        let alert : UIAlertController = UIAlertController(title: "" , message: "Are you sure you want to do this?", preferredStyle: UIAlertController.Style.actionSheet)
        let addAction = UIAlertAction(title: "", style: UIAlertAction.Style.default) { [self] UIAlertAction in
            redirectAddMember()
        }
        let editAction = UIAlertAction(title: "", style: UIAlertAction.Style.default) { [self] UIAlertAction in
            redirectToPromiseSetup()
        }
        let deleteAction = UIAlertAction(title: "", style: UIAlertAction.Style.destructive) { [self] UIAlertAction in
            deletePromise()
        }
        let cancelAction = UIAlertAction(title: "", style: UIAlertAction.Style.cancel) { UIAlertAction in
            self.dismiss(animated: true, completion: nil)
        }
        
        let actionTitle = ["Add Members","Edit Promise","Delete Promise","Cancel"]
        let arrAction = [addAction, editAction, deleteAction,cancelAction]
   
        for i in 0..<arrAction.count{
            let postivieAction = UILabel()
            postivieAction.text = actionTitle[i]
            postivieAction.textColor = actionTitle[i] == "Delete Promise" ? color.primaryColor() : color.redColor()
            postivieAction.font = UIFont.customFont(font: .medium, size: 18)
            postivieAction.sizeToFit()
            let positiveImg = UIImage(view: postivieAction)

            let left = -(alert.view.frame.size.width/2) + (positiveImg!.size.width/2) + 22
            let centeredTopoImage = positiveImg!.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: left, bottom: 0, right: 0))

           arrAction[i].setValue(centeredTopoImage, forKey: "image")
        }
        
        let messageAttributes = [NSAttributedString.Key.font: UIFont.customFont(font: .regular, size: 15), NSAttributedString.Key.foregroundColor: color.blackColor()]
        let messageString = NSAttributedString(string: "Are you sure you want to do this?", attributes: messageAttributes as [NSAttributedString.Key : Any])
        alert.setValue(messageString, forKey: "attributedMessage")
        
        alert.addAction(addAction)
        alert.addAction(editAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
  
    //MARK: -  setupUI and manager
    func setupUIAndManager()
    {
        theView.setupUI(delegate: theManager)
        theView.setupData(dict: dictPromise)
    }
    
    //MARK: - button click
    @IBAction func btnCompletePromiseClicked(_ sender: UIButton) {
        let id = dictPromise["member_id"].stringValue
        changePromiseStatus(status: .completed, id: id)
    }
    @IBAction func btnFailPromiseClicked(_ sender: UIButton) {
        let id = dictPromise["member_id"].stringValue
        changePromiseStatus(status: .failed, id: id)
    }

}
//MARK: -  other methods
extension PromiseDetailVC{
    func showCompleteAnimation(){
        let vc = CompletePopupVC(nib: nib.completePopupVC)
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
    }
    
    func hideButtons(){
        theView.hideButton()
    }
    
    func redirectAddMember(){
        let vc = AddMemberVC(nib: nib.addMemberVC)
        vc.isAddMember = true
        vc.strTitle = "Add Members" 
        vc.promiseId = dictPromise["id"].stringValue
        self.moveToNext(vc: vc)
    }
    
    func redirectToPromiseSetup(){
        let vc = PromiseSetupVC(nib: nib.promiseSetupVC)
        vc.dictPromise = dictPromise
        self.moveToNext(vc: vc)
    }
    
    func dismissed(vc: UIViewController) {
        navigationController?.popViewController(animated: true)
    }
    
}
//MARK: -  api call
extension PromiseDetailVC{
    func deletePromise(){
        APIHelper.sharedInstance.networkService(controller: self, apiurl: .promise, extraParam: "/\(dictPromise["id"].stringValue)", methodType: .delete, param: [:], withCompletion: {responseJSON,code in
            if code == "1"{
                Utils.showToast(strMessage: responseJSON["message"].stringValue)
                NotificationCenter.default.post(name: Notification.Name("refreshPromise"), object: nil)
                NotificationCenter.default.post(name: Notification.Name("refreshProfilePromise"), object: nil)
                self.navigationController?.popViewController(animated: true)
            }
            else if code == errorCode{
                showLogoutAlert(vc: self, message: responseJSON["message"].stringValue)
            }
            else{
                Utils.showToast(strMessage: code)
            }
        })
    }
    
    func changePromiseStatus(status : promiseCompletionStatus, id : String){
        let param : [String:Any] = ["status" : status.rawValue ]
        APIHelper.sharedInstance.networkService(controller: self, apiurl: .promiseStatus, extraParam: id, methodType: .put, param: param, withCompletion: { [self]responseJSON,code in
            if code == "1"{
                if status == .completed{
                    self.showCompleteAnimation()
                }
                NotificationCenter.default.post(name: Notification.Name("refreshPromise"), object: nil)
                NotificationCenter.default.post(name: Notification.Name("refreshProfilePromise"), object: nil)
                Utils.showToast(strMessage: responseJSON["message"].stringValue)
            }
            else{
                Utils.showToast(strMessage: code)
            }
        })
    }
}
