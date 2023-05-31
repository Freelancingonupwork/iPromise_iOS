//
//  ImagePicker.swift
//  Flix
//
//  Created by Rameshchandra Solanki on 5/24/21.
//

import Foundation
import UIKit
import AVFoundation
import Photos
import MobileCoreServices
import ContactsUI

class Permissions {

    //MARK:- Alert
    func showAlert(aViewcontoller : UIViewController , title : String )
    {
        let alert : UIAlertController = UIAlertController(title: "" , message: title, preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title: "", style: UIAlertAction.Style.default) { UIAlertAction in
            self.checkCameraPermission(aViewcontoller: aViewcontoller )
        }
        let gallaryAction = UIAlertAction(title: "", style: UIAlertAction.Style.default) { UIAlertAction in
            self.checkGalleryPermission(aViewcontoller: aViewcontoller )
        }
        let cancelAction = UIAlertAction(title: "", style: UIAlertAction.Style.cancel) { UIAlertAction in
            aViewcontoller.dismiss(animated: true, completion: nil)
        }
        
        
        let actionTitle = ["Camera","Gallery","Cancel"]
        let arrAction = [cameraAction, gallaryAction,cancelAction]
   
        for i in 0..<arrAction.count{
            let postivieAction = UILabel()
            postivieAction.text = actionTitle[i]
            postivieAction.textColor = color.primaryColor()
            postivieAction.font = UIFont.customFont(font: .medium, size: 18)
            postivieAction.sizeToFit()
            let positiveImg = UIImage(view: postivieAction)

            let left = -(alert.view.frame.size.width/2) + (positiveImg!.size.width/2) + 22
            let centeredTopoImage = positiveImg!.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: left, bottom: 0, right: 0))

           arrAction[i].setValue(centeredTopoImage, forKey: "image")
        }
        
        let messageAttributes = [NSAttributedString.Key.font: UIFont.customFont(font: .regular, size: 15), NSAttributedString.Key.foregroundColor: color.blackColor()]
        let messageString = NSAttributedString(string: title, attributes: messageAttributes as [NSAttributedString.Key : Any])
        alert.setValue(messageString, forKey: "attributedMessage")
        
        
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        aViewcontoller.present(alert, animated: true, completion: nil)
    }
    
    //MARK:- camera
    func checkCameraPermission(aViewcontoller : UIViewController)
    {
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch authStatus
        {
            case .denied : Log.warning("denied status")
                allowPermissionforCamera(aViewcontoller: aViewcontoller)
                break
            case .authorized : Log.info("sucess")
                self.openCamera(aViewcontoller: aViewcontoller )
                break
            case .restricted : Log.warning("user dont allowed")
                break
            case .notDetermined : AVCaptureDevice.requestAccess(for: .video) { [self](success) in
                if success {
                    Log.info("permission granted")
                    self.openCamera(aViewcontoller: aViewcontoller )
                }
                else{
                    Log.warning("permission not granted")
                }
            }
                break
            @unknown default:
                break
        }
    }
    
    func allowPermissionforCamera( aViewcontoller : UIViewController)
    {
        Utils.showAlert(vc: aViewcontoller, title: "Error", msg: "Camera permission is denied", actionTitle: "Setting", handler: {
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: { _ in })
            }
        })
    }
    
    func openCamera(aViewcontoller : UIViewController  )
    {
        DispatchQueue.main.async {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = aViewcontoller as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
                imagePicker.sourceType = .camera 
                imagePicker.allowsEditing = true
                
                imagePicker.modalPresentationStyle = .popover
                aViewcontoller.present(imagePicker, animated: true, completion: nil)
            }
            else {
                let alert = UIAlertController(title: "No Camera", message: "Camera not Available", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {  UIAlertAction in
                    self.openGallary(aViewcontoller: aViewcontoller)
                }))
                aViewcontoller.present(alert, animated: true, completion: nil)
            }
        }
   }

    //MARK:- gallery
    func checkGalleryPermission(aViewcontoller : UIViewController)
    {
        let authStatus = PHPhotoLibrary.authorizationStatus()
        switch authStatus
        {
            case .denied : Log.warning("denied status")            
            Utils.showAlert(vc: aViewcontoller, title: "Error", msg: "Photo library status is denied", actionTitle: "Setting", handler: {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: { _ in })
                }
            })
                break
            case .authorized : Log.info("success")
                self.openGallary(aViewcontoller: aViewcontoller)
                break
            case .restricted :  Log.warning("user dont allowed")
                break
            case .notDetermined : PHPhotoLibrary.requestAuthorization({ (newStatus) in
                    if (newStatus == PHAuthorizationStatus.authorized) {
                        Log.info("permission granted")
                        self.openGallary(aViewcontoller: aViewcontoller )
                    }
                    else {
                        Log.warning("permission not granted")
                    }
                })
                break
        case .limited:
            Log.warning("limited")
        @unknown default:
            break
        }
    }
    

    
    func openGallary(aViewcontoller : UIViewController ) {
        DispatchQueue.main.async { 
         if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
             let imagePicker = UIImagePickerController()
                    imagePicker.delegate = aViewcontoller as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
                     imagePicker.sourceType = .photoLibrary
                     imagePicker.allowsEditing = true
                     aViewcontoller.present(imagePicker, animated: true, completion: nil)
             }
        }
    }
    
    
    func allowPermissionForMicroPhone(aViewcontoller : UIViewController){
        let alert = UIAlertController(title: "Error", message: "no micro phone access", preferredStyle: .alert)
        let cancelaction = UIAlertAction(title: "Cancel", style: .default)
        let settingaction = UIAlertAction(title: "Setting", style: UIAlertAction.Style.default) { UIAlertAction in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: { _ in })
            }
        }
        alert.addAction(cancelaction)
        alert.addAction(settingaction)
        aViewcontoller.present(alert, animated: true, completion: nil)
    }
    
 
    //MARK: - contact
    class func checkContactPermission(aViewcontoller : UIViewController,completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        DispatchQueue.main.async {
            switch CNContactStore.authorizationStatus(for: .contacts) {
                case .authorized:
                    completionHandler(true)
                    break
                case .denied:
                    completionHandler(false)
                Utils.showAlert(vc: aViewcontoller, title: "Error", msg: "allow access to contact permission", actionTitle: "Setting", handler: {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url, options: [:], completionHandler: { _ in })
                    }
                })
                case .restricted, .notDetermined:
                    CNContactStore().requestAccess(for: .contacts, completionHandler: { granted, error in
                        if !granted {
                            DispatchQueue.main.async { [self] in
                                Utils.showAlert(vc: aViewcontoller, title: "Error", msg: "allow access to contact permission", actionTitle: "Setting", handler: {
                                    if let url = URL(string: UIApplication.openSettingsURLString) {
                                        UIApplication.shared.open(url, options: [:], completionHandler: { _ in })
                                    }
                                })

                            }
                        }
                        else{
                            completionHandler(true)
                        }
                    })
                @unknown default:
                    break
            }
        }
     
    }

    
    

}
