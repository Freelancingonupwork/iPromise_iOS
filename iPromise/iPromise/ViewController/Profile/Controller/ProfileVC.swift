//
//  ProfileVC.swift
//  iPromise
//
//  Created by Apple on 20/03/23.
//

import UIKit
import SwiftyJSON

class ProfileVC: BaseViewController, CustomProtocol {
   
    
    // MARK: - Variables | Properties
    fileprivate lazy var theView:ProfileView = { [unowned self] in
        return self.view as! ProfileView
    }()
    
    private lazy var theModel:ProfileModel = { [unowned self] in
        return ProfileModel(controller:self)
    }()
    
    private lazy var theManager:ProfileManager = { [unowned self] in
        return ProfileManager(controller: self, model: theModel)
    }()
    var arrPromises = [JSON]()
    var refreshControl: UIRefreshControl!
    
    var arrStatusItems = ["Completed","Archived"]
    var arrCategory = [JSON]()
    var arrPromiseType = [JSON]()
    var arrSelectedStatus = [String]()
    var arrSelectedCategory = [JSON]()
    var arrSelectedSubCategory = [JSON]()
    var param = [String:Any]()
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
       callMethods()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        setNavigationBar()
        if isBadge{
            setProfileButton(notificationImg: image.notificationWithBadgeProfile())
        }
        super.viewWillAppear(animated)
     
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBar()
    }
   
    //MARK: -  call methods
    func callMethods(){
        setupUIAndManager()
        getProfile()
        //getFilters()
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("refreshProfile"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("refreshProfilePromise"), object: nil)
    }
    
    //MARK: - navigation bar
    func setNavigationBar(){
        self.navigationController?.navigationBar.isHidden = false
        self.title = "My Profile"
        setProfileButton()
        alignTitleAtLeading(forgroundColor: color.whiteColor())
        self.navigationController?.setNavigationBar(foreGroundColor: color.whiteColor())
        self.navigationController?.navigationBar.tintColor = color.whiteColor()
    }
    override func btnNotificationClicked(_ sender: AnyObject) {
        let vc = NotificationsVC(nib: nib.notificationsVC)
        vc.isList = true
        moveToNext(vc: vc)
    }
    override func btnProfileClicked(_ sender: AnyObject) {

        let vc = ProfileMenuVC(nib: nib.profileMenuVC)
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve //.coverVertical
        vc.delegate = self
        self.present(vc, animated: true)
        
    }

    //MARK: -  setupUI and manager
    func setupUIAndManager()
    {
        theView.setupUI(delegate: theManager)
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        theView.scrollview.refreshControl = refreshControl
    }
        
        //MARK: -  button click
    @IBAction func btnFilterClicked(_ sender: UIButton) {
        let vc =  FilterVC(nib: nib.filterVC)
        vc.delegate = self
        vc.arrCategory = arrCategory
        vc.arrStatusItems = arrStatusItems
        vc.arrSelectedStatus = arrSelectedStatus
        vc.arrSelectedCategory = arrSelectedCategory
        vc.arrSelectedSubCategory = arrSelectedSubCategory
        moveToNext(vc: vc)
    }
   
    @IBAction func btnAddPromiseClicked(_ sender: UIButton) {
        let vc = PromisePopupVC(nib: nib.promisePopupVC)
        vc.arrType = arrPromiseType
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.delegate = self
        self.present(vc, animated: true)
    }
  
}
//MARK: - other method
extension ProfileVC{
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        getProfile()
    }
    
    func completePromiseAction(id : String){
        changePromiseStatus(status: .completed, id: id)
    }
    
    func failPromiseAction(id : String){
        changePromiseStatus(status: .failed, id: id)
    }
    
    func dismissed(vc: UIViewController) {
        moveToNext(vc: vc)
    }
    @objc func refresh()
   {
       refreshControl.endRefreshing()
       arrSelectedStatus = []
       arrSelectedCategory = []
       arrSelectedSubCategory = []
       param = ["status": [],
               "categories": [],
               "subcategories": []]
       getProfile()
   }
    
    func setFilters(){
        let catIds: [String] = arrSelectedCategory.map{String($0["id"].stringValue) }
        let subCatIds: [String] = arrSelectedSubCategory.map{String($0["id"].stringValue) }
        param = ["status": arrSelectedStatus.map({ $0.lowercased() }),
                "categories": catIds,
                "subcategories": subCatIds]
        getProfile()
    }
    
    func passdataToBack(data: Any) {
        if let dict = data as? [String:Any]{
            arrSelectedStatus = dict["status"] as? [String] ?? []
            arrSelectedCategory = dict["category"] as? [JSON] ?? []
            arrSelectedSubCategory = dict["subcategory"] as? [JSON] ?? []
            setFilters()
        }
    }
    
    func redirectToPromiseDetail(dict : JSON){
        let vc = PromiseDetailVC(nib: nib.promiseDetailVC)
        vc.dictPromise = dict
        moveToNext(vc: vc)
    }
}

//MARK: - api call
extension ProfileVC{
    func getProfile(){
        APIHelper.sharedInstance.networkService(controller: self, apiurl: .getProfile, methodType: .post, param: param, withCompletion: { [self] responseJSON,code in
            if code == "1"{
                let data = responseJSON["data"]
                
                theView.lblName.text = data["name"].stringValue
                theView.lblPromises.text = "You have \(data["promises"].arrayValue.count) Promises"
                theView.imgProfile.setImageFromUrl(url: data["avatar"].stringValue)
//                theModel.arrPromise = data["promises"].arrayValue
//                theView.arrPromises = data["promises"].arrayValue
                theModel.arrPromise = data["promises"].arrayValue
                theView.arrPromises = data["promises"].arrayValue
                arrCategory = data["filter_categories"].arrayValue
                arrPromiseType = data["types"].arrayValue
                
                
                theView.tblPromise.reloadData()
                if responseJSON["data"]["notifications_count"].intValue == 0 {
                    setProfileButton()
                }
                else{
                    setProfileButton(notificationImg: image.notificationWithBadgeProfile())
                }
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
    
    func changePromiseStatus(status : promiseCompletionStatus, id : String){
        let param : [String:Any] = ["status" : status.rawValue ]
        APIHelper.sharedInstance.networkService(controller: self, apiurl: .promiseStatus, extraParam: id, methodType: .put, param: param, withCompletion: { [self]responseJSON,code in
            if code == "1"{
                if status == .completed{
                    showCompleteAnimation(viewcontroller: self)
                }
                getProfile()
                Utils.showToast(strMessage: responseJSON["message"].stringValue)
            }
            else{
                Utils.showToast(strMessage: code)
            }
        })
    }
    
//    func getFilters(){
//        APIHelper.sharedInstance.networkService(controller: self, apiurl: .getPromiseCategory, methodType: .get, param: [:], withCompletion: { [self]responseJSON,code in
//            if code == "1"{
//                let data = responseJSON["data"].arrayValue
//                DispatchQueue.main.async { [self] in
//                    arrCategory = data
//                }
//            }
//            else if code == errorCode{
//                showLogoutAlert(vc: self, message: responseJSON["message"].stringValue)
//            }
//            else{
//                Utils.showToast(strMessage: code)
//            }
//        })
//    }
    
}
