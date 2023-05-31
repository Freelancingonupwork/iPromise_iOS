//
//  NameVC.swift
//  iPromise
//
//  Created by Apple on 15/03/23.
//

import UIKit
import SwiftyJSON

class NameVC: BaseViewController {

    // MARK: - Variables | Properties
    fileprivate lazy var theView:NameView = { [unowned self] in
        return self.view as! NameView
    }()
    
    private lazy var theModel:NameModel = { [unowned self] in
        return NameModel(controller:self)
    }()
    
    private lazy var theManager:NameManager = { [unowned self] in
        return NameManager(controller: self, model: theModel)
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
        hideRightButton()
    }
    
  
    //MARK: -  setupUI and manager
    func setupUIAndManager()
    {
        theView.setupUI(delegate: theManager)
    }
    
    //MARK: -  button click

    @IBAction func btnSaveClicked(_ sender: UIButton) {
        if theView.txtName.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0{
            Utils.showToast(strMessage: "please enter your name")
            return
        }
        saveName()
    }
    @IBAction func btnNotNowClicked(_ sender: UIButton) {
        makeRootVC()
    }
}
//MARK: -  api call
extension NameVC{
    func saveName(){
        let param : [String:Any] = ["name" : theView.txtName.text ?? ""]
        
        APIHelper.sharedInstance.networkService(controller: self, apiurl: .registerName, methodType: .post, param: param, withCompletion: { responseJSON,code in
            if code == "1"{
                let msg = responseJSON["message"].stringValue
                var data = responseJSON["data"]["user"]
                data["token"] = JSON(Utils.getUserDetail(.accessToken))
                guard let rowData = try? data.rawData() else {return}
                Utils.showToast(strMessage: msg)
                Utils.storeDataInLocal(.userData, rowData)
                makeRootVC()
            }
            else{
                Utils.showToast(strMessage: code)
            }
        })
    }
}


