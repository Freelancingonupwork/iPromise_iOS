//
//  TrackDailyPromiseVC.swift
//  iPromise
//
//  Created by Apple on 17/03/23.
//

import UIKit
import SwiftyJSON
import AdvancedPageControl

class TrackDailyPromiseVC: BaseViewController {

    // MARK: - Variables | Properties
    fileprivate lazy var theView:TrackDailyPromiseView = { [unowned self] in
        return self.view as! TrackDailyPromiseView
    }()
    
    private lazy var theModel:TrackDailyPromiseModel = { [unowned self] in
        return TrackDailyPromiseModel(controller:self)
    }()
    
    private lazy var theManager:TrackDailyPromiseManager = { [unowned self] in
        return TrackDailyPromiseManager(controller: self, model: theModel)
    }()
    var arrPromises = [JSON](){
        didSet{
            theModel.arrPromises.append(arrPromises.first!)
            theView.setupPageControl(pages: arrPromises.count)
            if arrPromises.count == 1{
                theView.btnLeft.isHidden = true
                theView.btnRight.isHidden = true
            }
        }
    }
    var currentItem = 0{
        didSet{
            let item = arrPromises[currentItem]
            theModel.arrPromises = []
            theModel.arrPromises.append(item)
            theView.tblPromise.reloadData()
            updatePageControl(currentPage: currentItem)
        }
    }

    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIAndManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        super.viewWillAppear(animated)
     
    }

    //MARK: -  setupUI and manager
    func setupUIAndManager()
    {
        theView.setupUI(delegate: theManager)
    }
    
    //MARK: -  button click
    @IBAction func btnNotNowClicked(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnLeftClicked(_ sender: UIButton) {
        if currentItem > 0 {
            currentItem -= 1
            if currentItem == 0{
                theView.btnLeft.isHidden = true
                theView.btnRight.isHidden = false
            }
            else{
                theView.btnLeft.isHidden = false
                theView.btnRight.isHidden = false
            }
        }
    }
    
    @IBAction func btnRightClicked(_ sender: UIButton) {
        if currentItem < arrPromises.count-1 {
            currentItem += 1
            if currentItem == arrPromises.count-1{
                theView.btnRight.isHidden = true
                theView.btnLeft.isHidden = false
            }
            else{
                theView.btnLeft.isHidden = false
                theView.btnRight.isHidden = false
            }
        }
    }
}
//MARK: -  ui method
extension TrackDailyPromiseVC{
    func updatePageControl(currentPage : Int){
        theView.pageControl.setPage(currentPage)
    }
}

//MARK: - api call
extension TrackDailyPromiseVC{
    func changePromiseStatus(status : promiseCompletionStatus, item : JSON){
        let id = item["member_id"].stringValue
        let param : [String:Any] = ["status" : status.rawValue ]
        APIHelper.sharedInstance.networkService(controller: self, apiurl: .promiseStatus, extraParam: id, methodType: .put, param: param, withCompletion: { [self]responseJSON,code in
            if code == "1"{
                if status == .completed{
                    showCompleteAnimation(viewcontroller: self)
                }
                arrPromises = arrPromises.filter( { $0 != item })
                currentItem = 0
                Utils.showToast(strMessage: responseJSON["message"].stringValue)
                NotificationCenter.default.post(name: Notification.Name("refreshPromise"), object: nil)
            }
            else{
                Utils.showToast(strMessage: code)
            }
        })
    }
}
