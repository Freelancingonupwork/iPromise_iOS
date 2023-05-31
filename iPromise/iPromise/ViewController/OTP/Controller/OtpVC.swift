//
//  OtpVC.swift
//  iPromise
//
//  Created by Apple on 15/03/23.
//

import UIKit
import FirebaseAuth

class OtpVC: BaseViewController {
    // MARK: - Variables | Properties
    fileprivate lazy var theView:OtpView = { [unowned self] in
        return self.view as! OtpView
    }()
    
    private lazy var theModel:OtpModel = { [unowned self] in
        return OtpModel(controller:self)
    }()
    
    private lazy var theManager:OtpManager = { [unowned self] in
        return OtpManager(controller: self, model: theModel)
    }()
    
    var phoneNumber = "" {
        didSet{
            theView.phoneNumber = "\(countryCode)\(phoneNumber)"
        }
    }
    var countryCode = ""
    

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
       // setRightButton()
    }
    
  
    //MARK: -  setupUI and manager
    func setupUIAndManager()
    {
        theView.setupUI(delegate: theManager)
    }
    
    //MARK: -  button click

    @IBAction func btnSendAgainClicked(_ sender: UIButton) {
        sendOTP()
    }
    @IBAction func btnVerifyClicked(_ sender: UIButton) {
        verifyNumber()
    }
}

//MARK: - ui methods
extension OtpVC{
    func setVeriryActiveDeactive(bool : Bool){
        bool ? theView.btnVerify.setDarkButton() :  theView.btnVerify.setDisableButton()
    }
}

//MARK: - other method
extension OtpVC{

    func moveToContinue(vc : UIViewController){
         moveToNext(vc: vc )
    }
}

//MARK: -  api call
extension OtpVC{
    func verifyNumber(){
        let param : [String:Any] = ["phone" : "\(countryCode)\(phoneNumber)", "otp" : theView.vwOTP.getOTP()]
        
        APIHelper.sharedInstance.networkService(controller: self, apiurl: .verifyNumber, methodType: .post, param: param, withCompletion: { [self]responseJSON,code in 
            if code == "1"{
                let msg = responseJSON["message"].stringValue
                guard let rowData = try? responseJSON["data"].rawData() else {return}
                Utils.showToast(strMessage: msg)
                Utils.storeDataInLocal(.userData, rowData)
                if responseJSON["data"]["name"].stringValue == "" {
                    moveToContinue(vc: NameVC(nib: nib.nameVC) )
                }
                else{
                  makeRootVC()
                }
            }
            else{
                Utils.showToast(strMessage: code)
                theView.showInvalidOtp()
            }
        })
    }
    
    func sendOTP(){
        let param : [String:Any] = ["phone" : phoneNumber,
                                    "country_code" : countryCode,
                                    "device_id" : strFCMToken ]
        APIHelper.sharedInstance.networkService(controller: self, apiurl: .sendOTP  , methodType: .post, param: param, withCompletion: { [self]responseJSON,code in
            if code == "1"{
                let msg = responseJSON["message"].stringValue
                Utils.showToast(strMessage: msg)
            }
            else{
                Utils.showToast(strMessage: code)
            }
        })
        
    }
}
