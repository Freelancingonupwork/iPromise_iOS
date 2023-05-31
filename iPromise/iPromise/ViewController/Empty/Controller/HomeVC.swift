//
//  HomeVC.swift
//  iPromise
//
//  Created by Apple on 14/03/23.
//

import UIKit
import SwiftyJSON
import FirebaseDynamicLinks

class HomeVC: BaseViewController, CustomProtocol {

    // MARK: - Variables | Properties
        fileprivate lazy var theView:HomeView = { [unowned self] in
            return self.view as! HomeView
        }()
        
        private lazy var theModel:HomeModel = { [unowned self] in
            return HomeModel(controller:self)
        }()
        
        private lazy var theManager:HomeManager = { [unowned self] in
            return HomeManager(controller: self, model: theModel)
        }()
        
    var arrPromises = (JSON)()
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
            setHomeButton(notificationImg: image.notificationWithBadgeHome())
        }
        super.viewWillAppear(animated)
     
    }
       
    override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
        let isShown = Utils.getDataFromLocal(.isOnBoardingShown) as? Bool ?? false
        if !isShown{
            showButtonAddOverlay()
        }
     }

    //MARK: -  call methods
    func callMethods(){
        setupUIAndManager()
        getPromises()
      //  getFilters()
        getTodayPromise()
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)),
                                               name: Notification.Name("refreshPromise"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.redirectToNotification), name: NSNotification.Name(rawValue: "redirectToNotification"), object: nil)
        redirectToNotification()
        if promiseByDeepLink.promiseId != "" && promiseByDeepLink.phoneNumber != ""{
            acceptDenyPromise()
        }
    }
    @objc func redirectToNotification() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
            if receivedNotification.count > 0{
                let vc = NotificationsVC(nib: nib.notificationsVC)
                vc.isList = true
                self.navigationController?.pushViewController(vc, animated: true)
                receivedNotification = JSON()
            }
        })
    }
    
    //MARK: - navigation bar
    
    func setNavigationBar(){
        self.navigationController?.navigationBar.isHidden = false
        self.title = "Home"
       setHomeButton()
        alignTitleAtLeading()
    }
    
    override func btnNotificationClicked(_ sender: AnyObject) {
        let vc = NotificationsVC(nib: nib.notificationsVC)
        vc.isList = true
        moveToNext(vc: vc)
    }
    
    
    override func btnProfileClicked(_ sender: AnyObject) {
        moveToNext(vc: ProfileVC(nib: nib.profileVC))
    }
        
      
    //MARK: -  setupUI and manager
    func setupUIAndManager()
    {
        theView.setupUI(delegate: theManager)
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        theView.lblNoPromiseDescription.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:))))
        theView.scrollview.refreshControl = refreshControl
        theView.txtSearch.delegate = self
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
    @IBAction func btnCloseBannerClicked(_ sender: UIButton) {
        
    }
    @IBAction func btnAddPromiseClicked(_ sender: UIButton) {
        let vc = PromisePopupVC(nib: nib.promisePopupVC)
        vc.arrType = arrPromiseType
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.delegate = self
        self.present(vc, animated: true)
    }
    @IBAction func btnMyPromiseClicked(_ sender: UIButton) {
        theView.setMyPromiseActive()
        theModel.arrPromise = arrPromises["my_promises"].arrayValue
        theView.arrPromises = arrPromises["my_promises"].arrayValue
        if theModel.arrPromise.count == 0 {
            theView.strNoPromiseText = "Don't be shy, create your first promise"
        }
        theView.tblPromise.reloadData()
    }
    @IBAction func btnInvolvedClicked(_ sender: UIButton) {
        theView.setInvolveActive()
        theModel.arrPromise = arrPromises["involved"].arrayValue
        theView.arrPromises = arrPromises["involved"].arrayValue
        if theModel.arrPromise.count == 0 {
            theView.strNoPromiseText = """
                Don’t be shy, invite a friend to join iPromise and include you in their promises today!
                Invite via SMS
                """
        }
        theView.tblPromise.reloadData()
    }
}

//MARK: -  ui method
extension HomeVC{
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        if textField == theView.txtSearch{
            setFilters()
            return true
        }
        return true
    }
}

//MARK: - other method
extension HomeVC{
    
    @objc func tapLabel(gesture: UITapGestureRecognizer) {
        let inviteRange = (theView.strNoPromiseText as NSString).range(of: "Invite via SMS")
        if gesture.didTapAttributedTextInLabel(label: theView.lblNoPromiseDescription, inRange: inviteRange) {
            shareApp(vc: self)
        }
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        getPromises()
    }
    
    func setFilters(){
        let catIds: [String] = arrSelectedCategory.map{String($0["id"].stringValue) }
        let subCatIds: [String] = arrSelectedSubCategory.map{String($0["id"].stringValue) }
        param = ["status": arrSelectedStatus.map({ $0.lowercased() }),
                 "categories": catIds,
                 "subcategories": subCatIds,
                 "search" : theView.txtSearch.text ?? ""]
        getPromises()
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
    
    func showDailyTrack(arraPromise : [JSON]){
        let vc = TrackDailyPromiseVC(nib: nib.trackDailyPromiseVC)
        vc.arrPromises = arraPromise
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
    }
    
    @objc func refresh()
   {
       theView.setMyPromiseActive()
       refreshControl.endRefreshing()
       arrSelectedStatus = []
       arrSelectedCategory = []
       arrSelectedSubCategory = []
       theView.txtSearch.text = ""
       param = ["status": [],
               "categories": [],
               "subcategories": [],
                "search" : ""]
       getPromises()
   }
    
    func passdataToBack(data: Any) {
        if let dict = data as? [String:Any]{
            arrSelectedStatus = dict["status"] as? [String] ?? []
            arrSelectedCategory = dict["category"] as? [JSON] ?? []
            arrSelectedSubCategory = dict["subcategory"] as? [JSON] ?? []
            setFilters()
        }
    }
    
   
    func redirectToPromiseDEtail(dict : JSON){
        let vc = PromiseDetailVC(nib: nib.promiseDetailVC)
        vc.dictPromise = dict
        moveToNext(vc: vc)
    }
}

//MARK: -  on boarding views
extension HomeVC{
    func showButtonAddOverlay() {
        showOnBoadingView(anchorView: theView.btnAdd, position: .left, arroImage: image.leftArrow()!, text: "Tap this add button to create your first promise now!", onTap: { [self] in
            showCompletePromiseOverlay()
        })
    }
    func showCompletePromiseOverlay(){
        showOnBoadingView(anchorView: theView.btnInvolve, position: .bottom, arroImage: image.bottomArrow()!, text: "This is your promise. Swipe right to complete it. 👉 ", promiseImg: image.completePromiseOverlay(), onTap: { [self] in
            showFailPromiseOverlay()
        })
    }
    
    func showFailPromiseOverlay(){
        showOnBoadingView(anchorView: theView.btnInvolve, position: .bottom, arroImage: image.bottomArrow()!, text: "This is the status of your promise. Swipe left to archive. 👈 ", promiseImg: image.failPromiseOverlay(), isFail: true, onTap: { [self] in
            showProfileOverlay()
        })
    }
    
    func showProfileOverlay(){
        let barButtonItem = self.navigationItem.rightBarButtonItems?.first
        let buttonItemView = barButtonItem!.value(forKey: "view")
        //This is your account profile section. Tap to update your profile settings.
        showOnBoadingView(anchorView: buttonItemView as! UIView, position: .top, arroImage: image.upArrow()!, text: "This is your notification center. Tap to view new updates.", onTap: { [self] in
            showNotificationOverlay()
        })
    }
    
    func showNotificationOverlay(){
        let barButtonItem = self.navigationItem.rightBarButtonItems?.last
        let buttonItemView = barButtonItem!.value(forKey: "view")
        //This is your notification center. Tap to view new updates
        showOnBoadingView(anchorView: buttonItemView as! UIView, position: .top, arroImage: image.upArrow()!, text: "This is your account profile section. Tap to update your profile settings.", onTap: { [self] in
            showFilterOverlay()
        })
    }
    
    func showFilterOverlay(){
        showOnBoadingView(anchorView: theView.btnFilter, position: .top, arroImage: image.upArrow()!, text: "Here you can filter your promises by categories or tags.", onTap: { [self] in
            showButtonInvolveOverlay()
        })
    }
    
    func showButtonInvolveOverlay(){
        showOnBoadingView(anchorView: theView.btnInvolve, position: .top, arroImage: image.upArrow()!, text: "Here you will see the promises you're currently involved in.", onTap: { 
            Utils.storeDataInLocal(.isOnBoardingShown, true)
        })
    }
    
    func showOnBoadingView(anchorView : UIView, position : arrowPosition, arroImage : UIImage, text : String, promiseImg : UIImage? = nil, isFail : Bool? = false, onTap : @escaping (()->Void)){
        let overlayView = OverlayView(title: text, anchorView: anchorView, arrowImg: arroImage, position: position, promiseImg: promiseImg, isFail: isFail)
        overlayView.frame = view.frame
        view.addSubview(overlayView)

        overlayView.onTap = { [weak overlayView] in
            overlayView?.hideOverlay { _ in
                overlayView?.removeFromSuperview()
                onTap()
            }
        }
        overlayView.onSkipTap = { [weak overlayView] in
            overlayView?.hideOverlay { _ in
                overlayView?.removeFromSuperview()
                Utils.storeDataInLocal(.isOnBoardingShown, true)
            }
        }
        overlayView.showOverlay()
    }
}

//MARK: -  api call
extension HomeVC{
    func getPromises(){
        APIHelper.sharedInstance.networkService(controller: self, apiurl: .home, methodType: .post, param: param , withCompletion: { [self]responseJSON,code in
            if code == "1"{
                let data = responseJSON["data"]
                arrPromises = data["promises"]
                theModel.arrPromise = arrPromises["my_promises"].arrayValue
                theView.arrPromises = arrPromises["my_promises"].arrayValue
                arrCategory = data["filter_categories"].arrayValue
                arrPromiseType = data["types"].arrayValue
                theView.setMyPromiseActive()
                theView.tblPromise.reloadData()
                if responseJSON["data"]["notifications_count"].intValue == 0 {
                    setHomeButton()
                }
                else{
                    isBadge = true
                    setHomeButton(notificationImg: image.notificationWithBadgeHome())
                }
            }
            else if code == errorCode{
                showLogoutAlert(vc: self, message: responseJSON["message"].stringValue)
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
    
    func getTodayPromise(){
        APIHelper.sharedInstance.networkService(controller: self, apiurl: .getTodayPromises, methodType: .get, param: [:], withCompletion: { [self]responseJSON,code in
            if code == "1"{
                let data = responseJSON["data"].arrayValue
                if data.count > 0 {
                    showDailyTrack(arraPromise: data)
                }
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
                getPromises()
                Utils.showToast(strMessage: responseJSON["message"].stringValue)
            }
            else{
                Utils.showToast(strMessage: code)
            }
        })
    }
    
    func acceptDenyPromise(){
        let id = Utils.getUserDetail(.id)
        let param : [String:Any] = ["is_accept" : promiseByDeepLink.promiseJoinStatus, "id" : id, "is_maker" : promiseByDeepLink.isMaker ]
        APIHelper.sharedInstance.networkService(controller: self, apiurl: .acceptDenyPromise, extraParam: "\(promiseByDeepLink.promiseId)", methodType: .put, param: param, withCompletion: { responseJSON,code in
            if code == "1"{
                NotificationCenter.default.post(name: Notification.Name("refreshPromise"), object: nil)
                Utils.showToast(strMessage: responseJSON["message"].stringValue)
            }
            else{
                Utils.showToast(strMessage: code)
            }
        })
    }
}
