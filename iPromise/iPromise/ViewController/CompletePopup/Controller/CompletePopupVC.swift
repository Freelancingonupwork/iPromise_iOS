//
//  CompletePopupVC.swift
//  iPromise
//
//  Created by Apple on 17/03/23.
//

import UIKit

class CompletePopupVC: UIViewController {


    // MARK: - Variables | Properties
    fileprivate lazy var theView:CompletePopupView = { [unowned self] in
        return self.view as! CompletePopupView
    }()
    
    private lazy var theModel:CompletePopupModel = { [unowned self] in
        return CompletePopupModel(controller:self)
    }()
    
    private lazy var theManager:CompletePopupManager = { [unowned self] in
        return CompletePopupManager(controller: self, model: theModel)
    }()
    var delegate : CustomProtocol?
    

    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        callMethods()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        theView.vwAnimation.stop()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        super.viewWillAppear(animated)
    }
   
    
    //MARK: -  call methods
    func callMethods(){
        setupUIAndManager()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.theView.vwAnimation.play()
        })
    }
   
    
    //MARK: -  setupUI and manager
    func setupUIAndManager()
    {
        theView.setupUI(delegate: theManager)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        theView.vwBack.addGestureRecognizer(tap)
    }
    
    //MARK: -  button click
    @IBAction func btnCloseClicked(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    @IBAction func btnCreatePoomiseClicked(_ sender: UIButton) {
        
    }
    @IBAction func btnQuickPromiseClicked(_ sender: UIButton) {
        
    }
}

//MARK: -  other methid
extension CompletePopupVC{
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        let vc = PromiseSetupVC(nibName: "PromiseSetupVC", bundle: nil)
        delegate?.dismissed!(vc: vc)
        self.dismiss(animated: true)
    }
}
