//
//  ProfileMenuVC.swift
//  iPromise
//
//  Created by Apple on 20/03/23.
//

import UIKit
import MessageUI

class ProfileMenuVC: BaseViewController, MFMailComposeViewControllerDelegate {
    
    //MARK: - variable

    fileprivate lazy var theView:ProfileMenuView = { [unowned self] in
        return self.view as! ProfileMenuView
    }()
    
    private lazy var theModel:ProfileMenuModel = { [unowned self] in
        return ProfileMenuModel(controller:self)
    }()
    
    private lazy var theManager:ProfileMenuManager = { [unowned self] in
        return ProfileMenuManager(controller: self, model: theModel)
    }()
    
    var delegate : CustomProtocol?

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
        self.navigationController?.navigationBar.isHidden = true
    }
  
    //MARK: -  setupUI and manager
    func setupUIAndManager()
    {
        theView.setupUI(delegate: theManager)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        theView.vwDismisscontroller.addGestureRecognizer(tap)
    }
    
}

//MARK: -  other method
extension ProfileMenuVC{
    func sendFeedback(){
        if MFMailComposeViewController.canSendMail() {
            let mailComposerVC = MFMailComposeViewController()
            mailComposerVC.mailComposeDelegate = self
            mailComposerVC.setToRecipients([""])
            mailComposerVC.setSubject("")
            mailComposerVC.setMessageBody("", isHTML: false)
            self.present(mailComposerVC, animated: true, completion: nil)
        }
    }
    func logOut(){
        Utils.showAlert(vc: self, title: "Log Out", msg: "Are you sure you want to leave Ipromise?", actionTitle: "Log Out", handler: { [self] in
            logoutCall()
        })
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.dismiss(animated: true)
    }
    
    func menuAction(dict : MenuItems){
        if dict.title == profileMenuItems.settigns.rawValue{
            self.dismiss(animated: true, completion: { [self] in
                let vc =  SettingVC(nib: nib.settingVC)
                vc.isSetting = true
                vc.navTitle = "Settings"
                delegate?.dismissed!(vc:vc)
            })
        }
        else if dict.title == profileMenuItems.info.rawValue{
            self.dismiss(animated: true, completion: { [self] in
                let vc =  SettingVC(nib: nib.settingVC)
                vc.isSetting = false
                vc.navTitle = "Info"
                delegate?.dismissed!(vc: vc)
            })
        }
        else if dict.title == profileMenuItems.share.rawValue{
            shareApp(vc: self)
        }
        else if dict.title == profileMenuItems.feedback.rawValue {
            sendFeedback()
        }
        else if dict.title == profileMenuItems.logout.rawValue{
            logOut()
        }
    }
}
//MARK: -  api call
extension ProfileMenuVC{
    func logoutCall(){
        APIHelper.sharedInstance.networkService(controller: self , apiurl: .logout, methodType: .post, param: [:], withCompletion: {responseJSON,code in
            if code == "1"{
                Utils.showToast(strMessage: responseJSON["message"].stringValue)
                makeRootVC(isLogout: true)
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
