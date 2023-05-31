//
//  PhoneVC.swift
//  iPromise
//
//  Created by Apple on 14/03/23.
//

import UIKit
import FirebaseAuth
import SwiftyJSON

class PhoneVC: BaseViewController {
    // MARK: - Variables | Properties
    fileprivate lazy var theView:PhoneView = { [unowned self] in
        return self.view as! PhoneView
    }()
    
    private lazy var theModel:PhoneModel = { [unowned self] in
        return PhoneModel(controller:self)
    }()
    
    private lazy var theManager:PhoneManager = { [unowned self] in
        return PhoneManager(controller: self, model: theModel)
    }()
    var arrPage = [MenuItems]()
    

    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIAndManager()
        getPages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationBar()
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
   
    //MARK: -  keyboard event
    @objc func keyboardWillAppear() {
        theView.vwPhoneParent.setShadow(borderColor: color.primaryColor())
    }

    @objc func keyboardWillDisappear() {
        theView.vwPhoneParent.setShadow(borderColor: color.grayColor())
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
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
        theView.lblBottomText.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:))))
    }
    
    //MARK: -  button click

    @IBAction func btnContinueClicked(_ sender: UIButton) {
        if promiseByDeepLink.phoneNumber != "" && promiseByDeepLink.promiseId != "nil" && theView.vwPhone.getPhoneNumber() != promiseByDeepLink.phoneNumber{
            let lastFourDigits = theView.vwPhone.getPhoneNumber().suffix(4)
            Utils.showToast(strMessage: "Invalid Number,Please Enter number with last digit *** \(lastFourDigits)")
        }
        else{
            sendOTP()
        }
        
    }
    @IBAction func btnClearClicked(_ sender: UIButton) {
        theView.vwPhone.setPhoneNumber("")
        theView.btnClear.isHidden = true
    }
}
//MARK: -  ui methods
extension PhoneVC{
    func activeDeActiveContinueButton(){
        theView.vwPhone.isValidPhoneNumber() ? theView.btnContinue.setDarkButton() : theView.btnContinue.setDisableButton()
        if theView.vwPhone.getNationalPhoneNumber().trimmingCharacters(in: .whitespacesAndNewlines).count > 0{
            theView.btnClear.isHidden = false
        }
    }
}
//MARK: -  other method
extension PhoneVC{
    
    @objc func tapLabel(gesture: UITapGestureRecognizer) {
        let termsRange = (theView.strBottomText as NSString).range(of: "Terms of Use")
        let privacyRange = (theView.strBottomText as NSString).range(of: "Privacy Policy")
        
        if gesture.didTapAttributedTextInLabel(label: theView.lblBottomText, inRange: termsRange) {
            guard let dict = arrPage.filter( { $0.title.contains("Terms") }).first else { return  }
            moveToContinue(dict: dict)
        } else if gesture.didTapAttributedTextInLabel(label: theView.lblBottomText, inRange: privacyRange) {
            guard let dict = arrPage.filter( { $0.title == "Privacy Policy" }).first else { return  }
            moveToContinue(dict: dict)
        } else {
        }
    }
    
    func moveToContinue(){
        let vc = OtpVC(nib: R.nib.otpVC)
        vc.countryCode = theView.vwPhone.getDialCode()
        vc.phoneNumber = theView.vwPhone.getNationalPhoneNumber()
        moveToNext(vc: vc )
    }
    
    func moveToContinue(dict : MenuItems){
        let vc = WebviewVC(nib: nib.webviewVC)
        vc.navTitle = dict.title
        vc.content = dict.description
        moveToNext(vc: vc)
    }
}
//MARK: -  api call
extension PhoneVC{
    func sendOTP(){
        let country_code = theView.vwPhone.getDialCode().replacingOccurrences(of: "+", with: "")
        let param : [String:Any] = ["phone" : theView.vwPhone.getNationalPhoneNumber(),
                                    "country_code" : country_code,
                                    "device_id" : strFCMToken ]
        APIHelper.sharedInstance.networkService(controller: self, apiurl: .sendOTP  , methodType: .post, param: param, withCompletion: { [self]responseJSON,code in
            if code == "1"{
                let msg = responseJSON["message"].stringValue
                Utils.showToast(strMessage: msg)
                moveToContinue()
            }
            else{
                Utils.showToast(strMessage: code)
            }
        })
        
    }
    func getPages(){
        APIHelper.sharedInstance.networkService(controller: self, apiurl: .getPages, methodType: .get, param: [:], withCompletion: { [self]responseJSON,code in
            if code == "1"{
                let data = responseJSON["data"].arrayValue
                data.forEach{ item in
                    arrPage.append(MenuItems(img: item["image"].stringValue , title: item["title"].stringValue, description: item["content"].stringValue))
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
}
