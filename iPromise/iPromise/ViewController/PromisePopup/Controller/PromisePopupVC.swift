//
//  PromisePopupVC.swift
//  iPromise
//
//  Created by Apple on 16/03/23.
//

import UIKit
import SwiftyJSON

class PromisePopupVC: UIViewController {

    // MARK: - Variables | Properties
    fileprivate lazy var theView:PromisePopupView = { [unowned self] in
        return self.view as! PromisePopupView
    }()
    
    private lazy var theModel:PromisePopupModel = { [unowned self] in
        return PromisePopupModel(controller:self)
    }()
    
    private lazy var theManager:PromisePopupManager = { [unowned self] in
        return PromisePopupManager(controller: self, model: theModel)
    }()
    var delegate : CustomProtocol?
    var arrType = [JSON](){
        didSet{
            theModel.arrPromises = arrType
            theView.tblPromisePopup.reloadData()
        }
    }
    

    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        callMethods()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        super.viewWillAppear(animated)
    }
    //MARK: -  call methods
    func callMethods(){
        setupUIAndManager()
     //   getPromiseData()
    }
   
    //MARK: -  setupUI and manager
    func setupUIAndManager()
    {
        theView.setupUI(delegate: theManager)
    }
    
    //MARK: -  button click
    @IBAction func btnCloseClicked(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
//MARK: -  ui methods
extension PromisePopupVC{
    func setTableHeight(){
        theView.setEmptyTable()
    }
}

//MARK: - other method
extension PromisePopupVC{
    func moveToContinue(vc : UIViewController){
        self.dismiss(animated: true)
        delegate?.dismissed!(vc: vc)
    }

    func redirectToPromiseCreation(dict : JSON){
        promiseType = dict["id"].stringValue
        if dict["has_category"].boolValue != true{
            let vc = PromiseSetupVC(nib: nib.promiseSetupVC)
            vc.isFromMakePromise = false
            subCategoryId = ""
            moveToContinue(vc: vc)
        }
        else{
            let vc = PromiseCategoryVC(nib: nib.promiseCategoryVC)
            vc.arrCategory = dict["categories"].arrayValue
            moveToContinue(vc: vc)
        }
    }
}
//MARK: - api call
extension PromisePopupVC{
//    func getPromiseData(){
//        APIHelper.sharedInstance.networkService(controller: self, apiurl: .getPromisesData, methodType: .get, param: [:], withCompletion: { [self]responseJSON,code in
//            if code == "1"{
//                let data = responseJSON["data"].arrayValue
//                theModel.arrPromises = data
//                theView.tblPromisePopup.reloadData()
//
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
