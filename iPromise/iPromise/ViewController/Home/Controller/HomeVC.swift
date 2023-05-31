//
//  HomeVC.swift
//  iPromise
//
//  Created by Apple on 14/03/23.
//

import UIKit

class HomeVC: BaseViewController {
    // MARK: - Variables | Properties
        fileprivate lazy var theView:HomeView = { [unowned self] in
            return self.view as! HomeView
        }()
        
        private lazy var theModel:HomeModel = { [unowned self] in
            return HomeModel(controller:self)
        }()
        
        private lazy var theManager:HomeManager = { [unowned self] in
    //        return HomeManager(controller: self, model: theModel, theView: theView)
            return HomeManager(controller: self, model: theModel)
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
            self.title = "Home"
           setHomeButton()
            alignTitleAtLeading()
        }
    
    override func btnNotificationClicked(_ sender: AnyObject) {
        moveToNext(vc: NotificationsVC(nib: nib.notificationsVC))
    }
    
    
    override func btnProfileClicked(_ sender: AnyObject) {
        moveToNext(vc: ProfileVC(nib: nib.profileVC))
    }
        
      
    //MARK: -  setupUI and manager
    func setupUIAndManager()
    {
        theView.setupUI(delegate: theManager)
    }
        
        //MARK: -  button click
    @IBAction func btnFilterClicked(_ sender: UIButton) {
        
    }
    @IBAction func btnCloseBannerClicked(_ sender: UIButton) {
        
    }
    @IBAction func btnAddPromiseClicked(_ sender: UIButton) {
//        let vc = PromisePopupVC(nib: nib.promisePopupVC)
//        let vc = CompletePopupVC(nib: nib.completePopupVC)
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.modalTransitionStyle = .coverVertical
//        self.present(vc, animated: true)
        
        moveToNext(vc: TrackDailyPromiseVC(nib: nib.trackDailyPromiseVC))
    }
    @IBAction func btnMyPromiseClicked(_ sender: UIButton) {
        theView.setMyPromiseActive()
    }
    @IBAction func btnInvolvedClicked(_ sender: UIButton) {
        theView.setInvolveActive()
    }
}
//MARK: - other method
extension HomeVC{
    func completePromiseAction(){
        print("complete action called")
    }
    func failPromiseAction(){
        print("fail action called")
    }
}
