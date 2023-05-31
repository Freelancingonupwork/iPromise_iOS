//
//  SplashVC.swift
//  iPromise
//
//  Created by Apple on 14/03/23.
//

import UIKit
import AVKit

class SplashVC: UIViewController {

    // MARK: - Variables | Properties
    fileprivate lazy var theView:SplashView = { [unowned self] in
        return self.view as! SplashView
    }()
    
    private lazy var theModel:SplashModel = { [unowned self] in
        return SplashModel(controller:self)
    }()
    
    private lazy var theManager:SplashManager = { [unowned self] in
        return SplashManager(controller: self, model: theModel)
    }()
    
    var player = AVPlayer()
    var video_file : URL?

    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIAndManager()
    }
    override func viewDidAppear(_ animated: Bool) {
        //setTimer()
        loadVideo()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
   
    
    //MARK: -  setupUI and manager
    func setupUIAndManager()
    {
        theView.SetupUI(delegate: theManager)
    }
    
    
//    func setTimer()
//    {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2, execute: { [self] in
//
//            let token = Utils.getUserDetail(.accessToken)
//            let name = Utils.getUserDetail(.name)
//            if token != "" && name != ""{
//                makeRootVC()
//            }
//            else if token != "" && name == ""
//            {
//                moveToNext(vc: NameVC(nib: nib.nameVC))
//            }
//            else{
//                moveToNext(vc: SignInUpVC(nib: nib.signInUpVC))
//            }
//
//        })
//    }
    
    //MARK: - play video
    private func loadVideo() {
       do {
           try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
       } catch { }

        player = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "splash", ofType: "mp4") ?? ""))
       let playerLayer = AVPlayerLayer(player: player)
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(notification:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)

//        let screenWidth =  UIScreen.main.bounds.width
//        let screenHeight =  UIScreen.main.bounds.height

        playerLayer.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
       playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
       playerLayer.zPosition = 0

       self.view.layer.addSublayer(playerLayer)

       player.seek(to: CMTime.zero)
       player.play()
  
   }
    
    @objc func playerDidFinishPlaying(notification: NSNotification) {
        Log.info("Video Finished")
        moveToContinue()
    }

}

//MARK: -  other methods
extension SplashVC{
    func moveToContinue()
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: { [self] in
            
            let token = Utils.getUserDetail(.accessToken)
            let name = Utils.getUserDetail(.name)
            if token != "" && name != ""{
                makeRootVC()
            }
            else if token != "" && name == ""
            {
                moveToNext(vc: NameVC(nib: nib.nameVC))
            }
            else{
                moveToNext(vc: SignInUpVC(nib: nib.signInUpVC))
            }
            
        })
    }
}
