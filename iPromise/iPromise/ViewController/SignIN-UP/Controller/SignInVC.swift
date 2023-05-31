//
//  SignInVC.swift
//  iPromise
//
//  Created by Apple on 14/03/23.
//

import UIKit

class SignInUpVC: UIViewController {

    // MARK: - Variables | Properties
    fileprivate lazy var theView:SignInUpView = { [unowned self] in
        return self.view as! SignInUpView
    }()
    
    private lazy var theModel:SignInUpModel = { [unowned self] in
        return SignInUpModel(controller:self)
    }()
    
    private lazy var theManager:SignInUpManager = { [unowned self] in
        return SignInUpManager(controller: self, model: theModel)
    }()
    
    

    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIAndManager()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
   
  
    //MARK: -  setupUI and manager
    func setupUIAndManager()
    {
        theView.SetupUI(delegate: theManager)
    }
    
    //MARK: -  button click
    
    @IBAction func btnLoginClicked(_ sender: UIButton) {
        moveToContinue(isAccept: true)
    }
    
    @IBAction func btnGuestClicked(_ sender: UIButton) {
        isGuest = true
        moveToContinue(isAccept: false)
    }
}

//MARK: -  other methods
extension SignInUpVC{
    func moveToContinue(isAccept : Bool){
        if promiseByDeepLink.promiseId != "" && promiseByDeepLink.phoneNumber != "" {
            promiseByDeepLink.promiseJoinStatus = isAccept
            isGuest = false
        }
        moveToNext(vc:  PhoneVC(nib: nib.phoneVC))
    }
}
