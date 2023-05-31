//
//  FilterVC.swift
//  iPromise
//
//  Created by Apple on 21/03/23.
//

import UIKit
import SwiftyJSON

class FilterVC: BaseViewController {

    //MARK: - variable
 
    fileprivate lazy var theView:FilterView = { [unowned self] in
        return self.view as! FilterView
    }()
    
    private lazy var theModel:FilterModel = { [unowned self] in
        return FilterModel(controller:self)
    }()
    
    private lazy var theManager:FilterManager = { [unowned self] in
        return FilterManager(controller: self, model: theModel)
    }()
    
    var arrStatusItems = [String](){
        didSet{
            theModel.arrStatusItems = arrStatusItems
        }
    }
    var arrCategory = [JSON](){
        didSet{
            theModel.arrCategory = arrCategory
        }
    }
    var arrSubCategory = [JSON](){
        didSet{
            theModel.arrSubCategory = arrSubCategory
        }
    }
    
    var arrSelectedStatus = [String]()
    var arrSelectedCategory = [JSON]()
    var arrSelectedSubCategory = [JSON](){
        didSet{
            theModel.arrSubCategory = arrSelectedSubCategory
        }
    }
    var delegate : CustomProtocol?

    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIAndManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationBar()
        super.viewWillAppear(animated)
     
    }
   
    //MARK: - navigation bar
    func setNavigationBar(){
        self.navigationController?.navigationBar.isHidden = false
        self.title = "Filters"
        setRightButton(title: "Reset")

    }
    
    override func rightHandAction() {
        arrSelectedStatus = []
        arrSelectedCategory = []
        arrSelectedSubCategory = []
        [theView.cvStatus, theView.cvCategory, theView.cvSubCategory].forEach{
            $0?.reloadData()
        }
    }
    
  
    //MARK: -  setupUI and manager
    func setupUIAndManager()
    {
        theView.setupUI(delegate: theManager)
    }
    
    //MARK: - button click
    @IBAction func btnShowResultClicked(_ sender: UIButton) {
        let filter : [String:Any] = ["status": arrSelectedStatus,
                                    "category": arrSelectedCategory,
                                    "subcategory": theModel.arrSubCategory]
        navigationController?.popViewController(animated: true)
        delegate?.passdataToBack?(data: filter )
    }
    
    
    @IBAction func btnsubCategoryClicked(_ sender: UIButton) {
        var data = [String]()
        var subCategory = [JSON]()
        arrSelectedCategory.forEach{ json in
            let subcategory = json["subcategories"].arrayValue
            subcategory.forEach{ subcat in
                data.append(subcat["name"].stringValue)
                subCategory.append(subcat)
            }
        }
        theView.showDropDown(arrData: data){ [self] index in
            let selectedSubcategory = subCategory[index]
            appendSubCategoryFilter(filter: selectedSubcategory)
        }
    }
}

//MARK: -  other method
extension FilterVC{
    func manageFilter(index:Int, filterType : filterType){
        if filterType == .status {
            let dict = theModel.arrStatusItems[index]
            if arrSelectedStatus.contains(dict){
                arrSelectedStatus.removeAll(where: {$0 == dict})
                theView.cvStatus.reloadData()
            }
            else{
                arrSelectedStatus.append(dict)
                theView.cvStatus.reloadData()
            }
        }
        else if filterType == .category{
            let dict = theModel.arrCategory[index]
            if arrSelectedCategory.contains(dict){
                arrSelectedCategory.removeAll(where: {$0 == dict})
                DispatchQueue.main.async {
                    self.theView.cvCategory.reloadItems(at: [IndexPath(row: index, section: 0)])
                }
                
            }
            else{
                arrSelectedCategory.append(dict)
                DispatchQueue.main.async {
                    self.theView.cvCategory.reloadItems(at: [IndexPath(row: index, section: 0)])
                }
            }
        }
        else{
            let dict = theModel.arrSubCategory[index]
            theModel.arrSubCategory.removeAll(where: {$0 == dict})
            DispatchQueue.main.async { [self] in
                theView.cvSubCategory.reloadSections(IndexSet(integer: 0))
            }
        }
    }
    

    
    func appendSubCategoryFilter(filter : JSON){
        if !theModel.arrSubCategory.contains(filter){
            theModel.arrSubCategory.append(filter)
            DispatchQueue.main.async {
                self.theView.cvSubCategory.reloadSections(IndexSet(integer: 0))
            }
        }
    }
    
}
//MARK: - api call
//extension FilterVC{

//}
