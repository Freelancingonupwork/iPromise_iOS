//
//  Utils.swift
//  Flix
//
//  Created by Kaushal Parmar on 24/06/21.
//


import SwiftyJSON
import Toaster
import UIKit

enum UserDefaultsKeys : String {
    case UserId
}
class Utils
{
  
    
    //MARK: - Toast
    class func showToast(strMessage : String)
    {
        ToastView.appearance().font = UIFont.customFont(font: .regular, size: 14)       
        ToastView.appearance().bottomOffsetPortrait = 70
        ToastView.appearance().textColor = color.whiteColor()
        ToastView.appearance().backgroundColor = color.blackColor()
        Toast(text: strMessage).show()
    }
   
    //MARK: - alert
    
    class func showAlert(vc : UIViewController, title : String, msg : String, actionTitle : String,  handler : @escaping commonHandler, cancelHandler :  @escaping (() -> Void) = {}) {

        let alert = UIAlertController(title: title, message: msg , preferredStyle: .alert)
        let cancelaction = UIAlertAction(title: "Cancel", style: .cancel) {
            action in cancelHandler()
        }
        let yesaction: UIAlertAction = UIAlertAction(title: actionTitle,  style: .destructive) {  action in
            handler()
        }

//        let actionTitle = ["Cancel", actionTitle]
//        let arrAction = [cancelaction,yesaction]
//        for i in 0..<arrAction.count{
//            let postivieAction = UILabel()
//            postivieAction.text = actionTitle[i]
//            postivieAction.textColor = actionTitle[i] != "Cancel" ? color.blackColor() : color.redColor()
//            postivieAction.font = UIFont.customFont(font: .bold, size: 16)
//            postivieAction.sizeToFit()
//            let positiveImg = UIImage(view: postivieAction)
//
//            let left = -(alert.view.frame.size.width/4) - (positiveImg!.size.width/4) //+ 22
//            let centeredTopoImage = positiveImg!.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: left, bottom: 0, right: 0))
//
//           arrAction[i].setValue(centeredTopoImage, forKey: "image")
//        }
                
        let titleAttributes = [NSAttributedString.Key.font: UIFont.customFont(font: .bold, size: 18), NSAttributedString.Key.foregroundColor: color.blackColor()]
        let titleString = NSAttributedString(string: title, attributes: titleAttributes as [NSAttributedString.Key : Any])
        let messageAttributes = [NSAttributedString.Key.font: UIFont.customFont(font: .regular, size: 15), NSAttributedString.Key.foregroundColor: color.blackColor()]
        let messageString = NSAttributedString(string: msg, attributes: messageAttributes as [NSAttributedString.Key : Any])
        alert.setValue(titleString, forKey: "attributedTitle")
        alert.setValue(messageString, forKey: "attributedMessage")

        alert.addAction(cancelaction)
        alert.addAction(yesaction)
        vc.present(alert, animated: true, completion: nil)
        
    }

    //MARK: - Set data,get Data,remove data from User Defaults

    class func storeDataInLocal(_ key: userKey, _ value: Any) {
        UserDefaults.standard.setValue(value, forKey: key.rawValue )
        UserDefaults.standard.synchronize()
    }
    
    class func removeLocalStorageData(_ key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func getDataFromLocal(_ key: userKey) -> AnyObject {
        return (UserDefaults.standard.object(forKey: key.rawValue) ?? "") as AnyObject
    }
    
    class func getUserDetail(_ key : userKey) -> String{
        guard  let userDetail = UserDefaults.standard.value(forKeyPath: userKey.userData.rawValue) as? Data else {
            return ""
        }
        let data = JSON(userDetail)
        return data[key.rawValue].stringValue

    }
}
