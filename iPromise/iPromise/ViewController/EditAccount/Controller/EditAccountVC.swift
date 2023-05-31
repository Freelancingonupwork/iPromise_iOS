//
//  EditAccooutVC.swift
//  iPromise
//
//  Created by Apple on 20/03/23.
//

import UIKit
import SwiftyJSON
import SDWebImage

class EditAccountVC: BaseViewController {

    //MARK: - variable
 
    fileprivate lazy var theView:EditAccountView = { [unowned self] in
        return self.view as! EditAccountView
    }()
    
    private lazy var theModel:EditAccountModel = { [unowned self] in
        return EditAccountModel(controller:self)
    }()
    
    private lazy var theManager:EditAccountManager = { [unowned self] in
        return EditAccountManager(controller: self, model: theModel)
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
        self.title = "Account"
        setRightButton(title: "Done")
    }
    
    override func rightHandAction() {
        if (theView.txtName.text ?? "").isEmpty{
            Utils.showToast(strMessage: "please enter name")
        }
        else if (theView.txtNumber.text ?? "").isEmpty{
            Utils.showToast(strMessage: "please enter phone number")
        }
        else{
            updateProfile()
        }
    }
  
    //MARK: -  setupUI and manager
    func setupUIAndManager()
    {
        theView.setupUI(delegate: theManager)
    }
    
    @IBAction func btnCameraClicked(_ sender: UIButton) {
        DispatchQueue.main.async {
            Permissions().showAlert(aViewcontoller: self, title: "complete action using")
        }
    }
   
    @IBAction func btnDeleteClicked(_ sender: UIButton) {
        Utils.showAlert(vc: self, title: "Delete account", msg: "Deleting your account will remove all your data. Do you want to proceed?", actionTitle: "Delete", handler: { [self] in
            deleteAccount()
        })
    }
   
}
//MARK: - imagepicker delegate
extension EditAccountVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        let image1 =  info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        theView.imgProfile.image = image1
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: -  api call
extension EditAccountVC{
    func updateProfile(){
        let param : [String:Any] = ["name": theView.txtName.text ?? "", "phone" : theView.txtNumber.text ?? ""]
        APIHelper.sharedInstance.uploadImageAndData(controller: self, apiurl: .updateProfile, param: param, image: theView.imgProfile.image!, withCompletion: {responseJSON,code in
            if code == "1"{
                Utils.showToast(strMessage: responseJSON["message"].stringValue)
                saveUserData(responseJSON: responseJSON)
                NotificationCenter.default.post(name: Notification.Name("refreshProfile"), object: nil)
                SDImageCache.shared.clearMemory()
                SDImageCache.shared.clearDisk()
            }
            else if code == errorCode{
                showLogoutAlert(vc: self, message: responseJSON["message"].stringValue)
            }
            else{
                Utils.showToast(strMessage: code)
            }
        })
        
    }
    
    func deleteAccount(){
        APIHelper.sharedInstance.networkService(controller: self, apiurl: .deleteAccount, methodType: .delete, param: [:], withCompletion: {responseJSON,code in
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
