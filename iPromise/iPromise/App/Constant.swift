//
//  Constant.swift
//  iPromise
//
//  Created by Apple on 13/03/23.
//

import UIKit
import Foundation
import RswiftResources
import SwiftyJSON

//MARK: -  variable

let appName = "iPromise"
let appDelegate = UIApplication.shared.delegate as! AppDelegate
let color = R.color
let nib = R.nib
let image = R.image
var promiseType = ""
var subCategoryId = ""
var errorCode = "401"
var appId = "6446198862"
typealias commonHandler = (() -> ())
typealias apiResponseHandler = (_ responseJSON: (JSON), _ code:String)->()
var strFCMToken = ""
var deepLinkDomain = "https://ipromise.page.link"
var appStoreId = "1623163453" //demo ciyashop
var isBadge = false
var receivedNotification = JSON(){
    didSet{
        if receivedNotification.count > 0 {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "redirectToNotification"), object: nil)
        }
    }
}

var isGuest = false

enum promiseByDeepLink{
    static var promiseId = ""
    static var phoneNumber = ""
    static var promiseJoinStatus = false
    static var isMaker = false
}

//MARK: - screen measurement
enum screenSize {
   static let height = UIScreen.main.bounds.height
    static let width = UIScreen.main.bounds.width
}


//MARK: - keys
typealias userKey = keys.UserDefaultKeys
typealias apiKey = keys.APIKeys
typealias messageKey = keys.MessagesKeys
var mainUrl = "http://ec2-3-139-79-139.us-east-2.compute.amazonaws.com"
var appUrl = "\(mainUrl)/api/v1/"
enum keys
{
    enum UserDefaultKeys : String
    {
        case userData = "userData"
        case accessToken = "token"
        case name = "name"
        case isOnBoardingShown = "onBoarding"
        case id = "id"
        case notification = "notification_status"
        case phoneNumber = "phone"
        case avatar = "avatar"
    }
    
    enum APIKeys : String{
        case sendOTP = "send_otp"
        case verifyNumber = "verify_phone"
        case registerName = "register_name"
        case getPromisesData = "promise-types"
        case promise = "promises"
        case home = "home"
        case getMembers = "get_users"
        case getProfile = "profile"
        case setNotificationStatus = "notification_status"
        case updateProfile = "update_profile"
        case getPromiseCategory = "promise-categories"
        case getTodayPromises = "today_promises"
        case deleteAccount = "delete_account"
        case logout = "logout"
        case promiseStatus = "member_status/"
        case addMembers = "add_member/"
        case getPages = "pages"
        case getNotification = "notifications"
        case acceptDenyPromise = "member_invite/"
    }
    
    enum MessagesKeys
    {
        static let somethingWrong = "Something went wrong"
        static let noInternet = "Please check your internet"
    }

}

//MARK: - enum
enum profileMenuItems : String{
    case settigns = "Settings"
    case info = "Info"
    case share = "Share"
    case feedback = "Give Feedback"
    case logout = "Logout"
}
enum settingMenuItems : String{
    case account = "Account"
    case notifications = "Notifications"
    case share = "Share"
    case feedback = "Give Feedback"
    case logout = "Logout"
}
enum infoMenuItems : String{
    case aboutus = "About Us"
    case tNc = "Terms & Conditions"
    case privacyPolicy = "Privacy Policy"
}

enum filterType : String{
    case status = "status"
    case category = "Category"
    case subcategory = "subcategory"
}

enum promiseCompletionStatus : String{
    case in_progress = "in progress"
    case completed = "completed"
    case failed = "archived"
}

enum notificationStatus : String{
    case reminder = "reminder"
    case request = "request"
    case other = "other"
}

//MARK: - function

func makeRootVC(isLogout : Bool? = false){
    var nav = UINavigationController()
    var viewController = UIViewController()
    
    if !(isLogout ?? false){
        viewController = HomeVC(nib: nib.homeVC)
    }
    else{
        [userKey.userData.rawValue].forEach{ key in
            Utils.removeLocalStorageData(key)
        }
        viewController = SignInUpVC(nib: nib.signInUpVC)
    }
    nav = UINavigationController(rootViewController: viewController)
    appDelegate.window?.rootViewController = nav
    appDelegate.window?.makeKeyAndVisible()
}

func showLogoutAlert(vc : UIViewController, message : String){
    Utils.showAlert(vc: vc, title: "Logout", msg: message, actionTitle: "Ok", handler: {
        makeRootVC(isLogout: true)
    })
}

func saveUserData(responseJSON : JSON){
    let token = Utils.getUserDetail(.accessToken)
    var data = responseJSON["data"]//
    data.dictionaryObject?.removeValue(forKey: "promises")
    data["token"] = JSON(token)
    guard let rowData = try? data.rawData() else {return}
    Utils.storeDataInLocal(.userData, rowData)
}
func showCompleteAnimation(viewcontroller : UIViewController){
    let vc = CompletePopupVC(nib: nib.completePopupVC)
    vc.modalPresentationStyle = .overCurrentContext
    vc.modalTransitionStyle = .crossDissolve
    viewcontroller.present(vc, animated: true)
}

func shareApp(vc : UIViewController){
    if let name = URL(string: "https://itunes.apple.com/us/app/myapp/id\(appId)?ls=1&mt=8"), !name.absoluteString.isEmpty {
      let objectsToShare = [name]
      let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
      vc.present(activityVC, animated: true, completion: nil)
    } else {
      
    }
}
