//
//  LoaderVC.swift
//  MentalHealthApp
//
//  Created by Apple on 24/01/23.
//

import UIKit
import Lottie

class LoaderVC: UIViewController {

    //MARK: -  variable
    static let loaderVC = LoaderVC(nibName: "LoaderVC", bundle: nil)
    @IBOutlet weak var loader: LottieAnimationView!
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLoader()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loader.play()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        loader.stop()
    }
    
    //MARK: - animation methods
    func setUpLoader(){
        loader.loopMode = .loop
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
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
