//
//  UIViewController+Extension.swift
//  iPromise
//
//  Created by Apple on 14/03/23.
//

import UIKit



extension UIViewController{
    
    var topVC: UIViewController? {
          return self.topVC(currentViewController: self)
      }

      private func topVC(currentViewController: UIViewController) -> UIViewController {
          if let tabBarController = currentViewController as? UITabBarController,
              let selectedViewController = tabBarController.selectedViewController {
              return self.topVC(currentViewController: selectedViewController)
          } else if let navigationController = currentViewController as? UINavigationController,
              let visibleViewController = navigationController.visibleViewController {
              return self.topVC(currentViewController: visibleViewController)
         } else if let presentedViewController = currentViewController.presentedViewController {
              return self.topVC(currentViewController: presentedViewController)
         } else {
              return currentViewController
          }
      }

    
    func moveToNext(vc: UIViewController){
        navigationController?.pushViewController(vc, animated: true)
    }

    open override func awakeAfter(using coder: NSCoder) -> Any? {
        if #available(iOS 14.0, *) {
            navigationItem.backButtonDisplayMode = .minimal
        } else {
            // Fallback on earlier versions
        } // This will help us to remove text
        return super.awakeAfter(using: coder)
    }
    
    class func topViewController(controller: UIViewController? =
                                 UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController{
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
    
    func setBackground(view:UIView){
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    }
    
}


class BaseViewController : UIViewController{
    
    override func viewDidLoad() {
    
    }
    
    func setRightButton(title : String? = ""){
            if title == "" {
                if #available(iOS 13.0, *) {
                    navigationItem.rightBarButtonItem?.tintColor =   color.grayColor()
                    let myimage = UIImage(systemName: "multiply")
                    navigationItem.rightBarButtonItem = UIBarButtonItem(image: myimage, style: .plain, target: self, action: #selector(rightHandAction))
                    
                }
            }
            else{
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: title,
                                                                         style: .plain,
                                                                         target: self,
                                                                         action: #selector(rightHandAction))
                navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: color.primaryColor() as Any, NSAttributedString.Key.font: UIFont.customFont(font: .medium, size: 17)], for: .normal)
            }

    }
    
    func setHomeButton(notificationImg : UIImage? = image.homeNotification())
    {
        let notificationImage    = notificationImg?.withRenderingMode(.alwaysOriginal)
        let profileImage  = image.homeProfile()?.withRenderingMode(.alwaysOriginal)
        let notificationButton   = UIBarButtonItem(image: notificationImage,  style: .plain, target: self, action: #selector(btnNotificationClicked(_:)))
        let profileButton = UIBarButtonItem(image: profileImage,  style: .plain, target: self, action:  #selector(btnProfileClicked(_:)))
        navigationItem.rightBarButtonItems = [notificationButton, profileButton]
        
    }
    
    func setProfileButton(isPromiseDetail : Bool? = false, notificationImg : UIImage? = image.notificationWhite()){
        let notificationImage = notificationImg 
        let menuImage  = image.menuWhite()
        let notificationButton   = UIBarButtonItem(image: notificationImage,  style: .plain, target: self, action: #selector(btnNotificationClicked(_:)))
        let menuButton = UIBarButtonItem(image: menuImage,  style: .plain, target: self, action:  #selector(btnProfileClicked(_:)))
        [notificationButton, menuButton].forEach { $0.tintColor = color.whiteColor()}
        navigationItem.rightBarButtonItems = (isPromiseDetail ?? false) ? [menuButton] :  [notificationButton, menuButton]
    }
    
    
    @objc func btnNotificationClicked(_ sender: AnyObject){
        Log.info("btnNotificationClicked bar button action")
    }

    @objc func btnProfileClicked(_ sender: AnyObject){
        Log.info("btnProfileClicked bar button action")
    }
   
    @objc  func rightHandAction() {
        Log.info("right bar button action")
        
    }
    
    func alignTitleAtLeading(forgroundColor : UIColor? = color.blackColor()){
        guard let navFrame = navigationController?.navigationBar.frame else{
            return
        }
        
        let parentView = UIView(frame: CGRect(x: 0, y: 0, width: navFrame.width*3, height: navFrame.height))
        self.navigationItem.titleView = parentView
        
        let label = UILabel(frame: .init(x: parentView.frame.minX, y: parentView.frame.minY, width: parentView.frame.width, height: parentView.frame.height))
        label.backgroundColor = .clear
        label.numberOfLines = 2
        label.font =  UIFont.customFont(font: .bold, size: 22)
        label.textAlignment = .left
        label.textColor = forgroundColor
        label.text = self.title
        
        parentView.addSubview(label)
    }
    
    
    
    func hideLeftButton(){
        navigationItem.hidesBackButton = true
    }
    
    func hideRightButton(){
        if let button = self.navigationItem.rightBarButtonItem {
            button.isEnabled = false
            button.tintColor = UIColor.clear
        } // hide right button
    }

}
extension BaseViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
