//
//  PromiseCategoryVC.swift
//  iPromise
//
//  Created by Apple on 23/03/23.
//

import UIKit
import SwiftyJSON

class PromiseCategoryVC: BaseViewController {

    
    //MARK: - variable
 
    fileprivate lazy var theView:PromiseCategoryView = { [unowned self] in
        return self.view as! PromiseCategoryView
    }()
    
    private lazy var theModel:PromiseCategoryModel = { [unowned self] in
        return PromiseCategoryModel(controller:self)
    }()
    
    private lazy var theManager:PromiseCategoryManager = { [unowned self] in
        return PromiseCategoryManager(controller: self, model: theModel)
    }()
    
   var arrSelectedMemeber = [Int]()
    var arrCategory = [JSON](){
        didSet{
            theModel.arrCategory = arrCategory
        }
    }

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
        self.title = "Choose a category"
        
    }
    //MARK: -  setupUI and manager
    func setupUIAndManager()
    {
        theView.setupUI(delegate: theManager)
        
    }
    
    //MARK: - button click
   
}

//MARK: -  other methos
extension PromiseCategoryVC{
    func moveToSubCategoryView(arrSubcategory : [JSON], title : String){
        let vc = PromiseSubCategoryVC(nib: nib.promiseSubCategoryVC)
        vc.arrSubCategory = arrSubcategory
        vc.strTitle = title
        moveToNext(vc: vc)
    }
}
