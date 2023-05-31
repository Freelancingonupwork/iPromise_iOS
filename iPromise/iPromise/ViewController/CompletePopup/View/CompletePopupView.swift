//
//  View.swift
//  iPromise
//
//  Created by Apple on 16/03/23.
//
import UIKit
import Lottie


class CompletePopupView : UIView{
    
    
    //MARK: -  outlet
    
    @IBOutlet weak var vwBack: UIView!
    @IBOutlet weak var vwParent: UIView!

    @IBOutlet weak var vwAnimation: LottieAnimationView!
    
    @IBOutlet weak var lblCongratulations: UILabel!
    @IBOutlet weak var lblDescriptions: UILabel!
    
    //MARK: - variable
    static let loaderVC = CompletePopupVC(nib: nib.completePopupVC)
    
    //MARK: - setupUI
    func setupUI(delegate : CompletePopupManager){
        vwParent.makeCorner()
        
        lblCongratulations.font = UIFont.customFont(font: .bold, size: 18)
        lblDescriptions.font = UIFont.customFont(font: .regular, size: 16)
        
        setUpLoader()
    }
    
    func setUpLoader(){
        vwAnimation.loopMode = .loop
    }
    

    static func showLoader(){
        guard let rootVC = UIViewController.topViewController() else { return }
        loaderVC.view.layoutIfNeeded()
        loaderVC.modalPresentationStyle = .overFullScreen
        loaderVC.willMove(toParent: rootVC)
        rootVC.addChild(loaderVC)
        rootVC.view.addSubview(loaderVC.view)
        loaderVC.view.frame = rootVC.view.frame
        loaderVC.didMove(toParent: rootVC)
    }
    
    static func hideLoader(){
        loaderVC.view.removeFromSuperview()
        loaderVC.willMove(toParent: nil)
        loaderVC.removeFromParent()
        loaderVC.didMove(toParent: nil)
    }

}
