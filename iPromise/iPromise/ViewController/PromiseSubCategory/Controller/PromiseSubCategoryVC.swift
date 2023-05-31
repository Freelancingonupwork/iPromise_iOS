//
//  PromiseSubCategoryVC.swift
//  iPromise
//
//  Created by Apple on 23/03/23.
//

import UIKit
import SwiftyJSON

class PromiseSubCategoryVC: BaseViewController {

    
    //MARK: - variable
 
    fileprivate lazy var theView:PromiseSubCategoryView = { [unowned self] in
        return self.view as! PromiseSubCategoryView
    }()
    
    private lazy var theModel:PromiseSubCategoryModel = { [unowned self] in
        return PromiseSubCategoryModel(controller:self)
    }()
    
    private lazy var theManager:PromiseSubCategoryManager = { [unowned self] in
        return PromiseSubCategoryManager(controller: self, model: theModel)
    }()
    
    var arrSubCategory : [JSON] = [] {
        didSet{
            theModel.arrSubCategory = arrSubCategory
        }
    }
    var strTitle = ""

    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIAndManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationBar()
        super.viewWillAppear(animated)
     
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
   
    
    
    //MARK: - navigation bar
    func setNavigationBar(){
        self.navigationController?.navigationBar.isHidden = false
        self.title = strTitle
        
    }
    //MARK: -  setupUI and manager
    func setupUIAndManager()
    {
        theView.setupUI(delegate: theManager)
        
    }
    
    //MARK: - button click
   
}

//MARK: -  other methos
extension PromiseSubCategoryVC{
    func moveToPromiseSetup(subcategoryID : String){
        let vc = PromiseSetupVC(nib: nib.promiseSetupVC)
        vc.isFromMakePromise = true
        subCategoryId =  subcategoryID
        moveToNext(vc: vc)
    }
}
