//
//  NotificationsVC.swift
//  iPromise
//
//  Created by Apple on 17/03/23.
//

import UIKit
import SwiftyJSON

class NotificationsVC: BaseViewController {
    // MARK: - Variables | Properties
    fileprivate lazy var theView:NotificationsView = { [unowned self] in
        return self.view as! NotificationsView
    }()
    
    private lazy var theModel:NotificationsModel = { [unowned self] in
        return NotificationsModel(controller:self)
    }()
    
    private lazy var theManager:NotificationsManager = { [unowned self] in
        return NotificationsManager(controller: self, model: theModel)
    }()
        
    var isList = true
    var refreshControl: UIRefreshControl!

    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIAndManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationBar()
        super.viewWillAppear(animated)
     
    }
    
    override func viewDidAppear(_ animated: Bool) {
        isBadge = false
    }
   
    //MARK: - navigation bar
    func setNavigationBar(){
        self.navigationController?.navigationBar.isHidden = false
        self.title = "Notifications"
        hideRightButton()
    }
    
  
    //MARK: -  setupUI and manager
    func setupUIAndManager()
    {
        theView.setupUI(delegate: theManager)
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        theView.isList = isList
        if isList{
            getNotification()
        }
        //theView.tblNotifications.refreshControl = refreshControl
    }
}

//MARK: -  other ethod
extension NotificationsVC{
    @objc func refresh()
   {   refreshControl.endRefreshing()
       getNotification()
   }
}

//MARK: - api call
extension NotificationsVC{
    func setNotificationStatus(isOn : Bool){
        let param : [String:Any] = ["notification_status" : isOn]
        APIHelper.sharedInstance.networkService(controller: self, apiurl: .setNotificationStatus, methodType: .put, param: param, withCompletion: {responseJSON,code in
            if code == "1"{
                Utils.showToast(strMessage: responseJSON["message"].stringValue)
                saveUserData(responseJSON: responseJSON)
            }
            else if code == errorCode{
                showLogoutAlert(vc: self, message: responseJSON["message"].stringValue)
            }
            else{
                Utils.showToast(strMessage: code)
            }
        })
    }
    
    func getNotification(){
        APIHelper.sharedInstance.networkService(controller: self, apiurl: .getNotification, methodType: .get, param: [:], withCompletion: { [self]responseJSON,code in
            if code == "1"{
                let data = responseJSON["data"].arrayValue
                theModel.arrNotification = data
                theView.arrNotification = data
                theView.tblNotifications.reloadData()
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
                    showCompleteAnimation(viewcontroller: self)
                }
                getNotification()
                NotificationCenter.default.post(name: Notification.Name("refreshPromise"), object: nil)
                NotificationCenter.default.post(name: Notification.Name("refreshProfilePromise"), object: nil)
                Utils.showToast(strMessage: responseJSON["message"].stringValue)
            }
            else{
                Utils.showToast(strMessage: code)
            }
        })
    }
    
    func acceptDenyPromise(isAccept : Bool, promiseId : Int, id : String){
        let param : [String:Any] = ["is_accept" : isAccept, "id" : id]
        APIHelper.sharedInstance.networkService(controller: self, apiurl: .acceptDenyPromise, extraParam: "\(promiseId)", methodType: .put, param: param, withCompletion: { [self]responseJSON,code in
            if code == "1"{
                getNotification()
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
