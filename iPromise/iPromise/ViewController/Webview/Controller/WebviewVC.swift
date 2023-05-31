//
//  WebviewVC.swift
//  iPromise
//
//  Created by Apple on 20/03/23.
//

import UIKit

class WebviewVC: UIViewController {

    //MARK: - variable
 
    fileprivate lazy var theView:WebviewView = { [unowned self] in
        return self.view as! WebviewView
    }()
    
    private lazy var theModel:WebviewModel = { [unowned self] in
        return WebviewModel(controller:self)
    }()
    
    private lazy var theManager:WebviewManager = { [unowned self] in
        return WebviewManager(controller: self, model: theModel)
    }()
    
    var navTitle = ""
    var content = ""{
        didSet{
            loadHTMLdata()
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
   
    //MARK: - navigation bar
    func setNavigationBar(){
        self.navigationController?.navigationBar.isHidden = false
        self.title = navTitle

    }
  
    //MARK: -  setupUI and manager
    func setupUIAndManager()
    {
        theView.setupUI(delegate: theManager)
    }

}

//MARK: - ui method
extension WebviewVC{
    func loadHTMLdata(){
        theView.loadData(content: content)
    }
}
