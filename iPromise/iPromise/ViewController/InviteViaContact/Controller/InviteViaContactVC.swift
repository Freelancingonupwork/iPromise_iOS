//
//  InviteViaContactVC.swift
//  iPromise
//
//  Created by Apple on 16/03/23.
//

import UIKit
import MessageUI

class InviteViaContactVC: BaseViewController, MFMessageComposeViewControllerDelegate {

    // MARK: - Variables | Properties
    fileprivate lazy var theView:InviteViaContactView = { [unowned self] in
        return self.view as! InviteViaContactView
    }()
    
    private lazy var theModel:InviteViaContactModel = { [unowned self] in
        return InviteViaContactModel(controller:self)
    }()
    
    private lazy var theManager:InviteViaContactManager = { [unowned self] in
        return InviteViaContactManager(controller: self, model: theModel)
    }()
    
    

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
        //setRightButton()
    }
    
  
    //MARK: -  setupUI and manager
    func setupUIAndManager()
    {
        theView.setupUI(delegate: theManager)
    }
    
    //MARK: -  button click

    @IBAction func btnSMSClicked(_ sender: UIButton) {
        let controller = MFMessageComposeViewController()
        if (MFMessageComposeViewController.canSendText()) {
            let urlToShare = "itms-apps://itunes.apple.com/app/id\(appId)"
            controller.body = "Hey, Please join this application \(urlToShare)"
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnOtherClicked(_ sender: UIButton) {
        shareApp(vc: self)
    }

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true)
    }

}
