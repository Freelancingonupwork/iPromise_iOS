//
//  SettingVC.swift
//  iPromise
//
//  Created by Apple on 20/03/23.
//

import UIKit

class SettingVC: BaseViewController {

    //MARK: - variable
 
    fileprivate lazy var theView:SettingView = { [unowned self] in
        return self.view as! SettingView
    }()
    
    private lazy var theModel:SettingModel = { [unowned self] in
        return SettingModel(controller:self)
    }()
    
    private lazy var theManager:SettingManager = { [unowned self] in
        return SettingManager(controller: self, model: theModel)
    }()
    
    var isSetting = true
    var navTitle = ""
    

    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIAndManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationBar()
        super.viewWillAppear(animated)
     
    }
   
    //MARK: - navigation bar
    func setNavigationBar(){
        self.navigationController?.navigationBar.isHidden = false
        self.title = navTitle
    }
  
    //MARK: -  setupUI and manager
    func setupUIAndManager()
    {
        theView.setupUI(delegate: theManager)
        isSetting ? theModel.setSettingMenu() : getPages()
    }
    
}

//MARK: - othe methods
extension SettingVC{
    func moveToContinue(dict : MenuItems){
        if isSetting{
            if dict.title == settingMenuItems.account.rawValue{
                let vc = EditAccountVC(nib: nib.editAccountVC)
                moveToNext(vc: vc)
            }
            else if dict.title == settingMenuItems.notifications.rawValue{
                let vc = NotificationsVC(nib: nib.notificationsVC)
                vc.isList = false
                moveToNext(vc: vc)
            }
        }
        else{
            let vc = WebviewVC(nib: nib.webviewVC)
            vc.navTitle = dict.title
            vc.content = dict.description
            moveToNext(vc: vc)
        }
    }
}

//MARK: -  api call
extension SettingVC{
    func getPages(){
        APIHelper.sharedInstance.networkService(controller: self, apiurl: .getPages, methodType: .get, param: [:], withCompletion: { [self]responseJSON,code in
            if code == "1"{
                let data = responseJSON["data"].arrayValue
                data.forEach{ item in
                    theModel.arrMenu.append(MenuItems(img: item["image"].stringValue , title: item["title"].stringValue, description: item["content"].stringValue))
                }
                theView.tblMenus.reloadData()
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
