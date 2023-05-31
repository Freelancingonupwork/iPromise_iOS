//
//  View.swift
//  iPromise
//
//  Created by Apple on 15/03/23.
//

import UIKit
import BubbleShowCase

class HomeView : UIView{
    //MARK: - outlet
   
    @IBOutlet weak var vwSearch: UIView!
    @IBOutlet weak var vwBanner: UIView!
    
    @IBOutlet weak var txtSearch: UITextField!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblInProgress: UILabel!
    
    @IBOutlet weak var imgNotificationBadge: UIImageView!
    
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnMyPromise: UIButton!
    @IBOutlet weak var btnInvolve: UIButton!
    
    @IBOutlet weak var tblPromise: UITableView!
    
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    //MARK: - variable
  
    
    //MARK: - setupUI
    func setupUI(delegate : HomeManager){
       
        vwSearch.setShadow(borderColor: .clear)
        vwBanner.makeCorner()
        
        lblInProgress.font = UIFont.customFont(font: .bold, size: 18)
        
        btnAdd.makeRound()
        
        btnMyPromise.setDarkButton(font: UIFont.customFont(font: .medium, size: 16))
        btnInvolve.setLightButton( font: UIFont.customFont(font: .regular, size: 16))
        
        setUpShowCase(delegate: delegate)
        
        tblPromise.delegate = delegate
        tblPromise.dataSource = delegate
        registerCell()
    }
    
    func registerCell(){
        tblPromise.register(UINib(nibName: "PromiseCell", bundle: nil), forCellReuseIdentifier: "PromiseCell")
        tblPromise.reloadData()
        tblPromise.separatorStyle = .none
        tblPromise.isScrollEnabled = false
        tblPromise.rowHeight = UITableView.automaticDimension
        tblPromise.backgroundColor = .clear
        tblPromise.addObserver(self, forKeyPath: "contentSize", options: .new, context: .none)
        tblPromise.reloadData()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if (object as! UITableView) == self.tblPromise {
            if(keyPath == "contentSize"){
                if let newvalue = change?[.newKey]
                {
                    let newsize = newvalue as! CGSize
                    print("New size - ",newsize.height)
                    self.tableHeight.constant = newsize.height
                }
            }
        }
//        if arrProduct.count == 0 {
        //tableHeight.constant = 300
//        }
    }
    
    
    func setUpShowCase(delegate : HomeManager){
//        let showCaseOnView = BubbleShowCase(target: btnFilter, arrowDirection: .down, label: "startDemoButton")
//        //showCaseOnView.titleText = "Tap here to close it"
//        showCaseOnView.descriptionText = "Lorem ipsum dolor sit amet consectetur. Enim tempus 👉"
//        showCaseOnView.arrowDirection = .right
//
//    //    showCaseOnView.shadowColor = startDemoButton.titleColor(for: .normal)
//        showCaseOnView.isCrossDismissable = false
//        showCaseOnView.flickerAnimationDuration = 10
//        showCaseOnView.delegate = delegate
//        showCaseOnView.color = color.whiteColor()!
//        showCaseOnView.descriptionFont = UIFont.customFont(font: .regular, size: 16)
//        showCaseOnView.textColor = color.blackColor()!
//        showCaseOnView.show()
        
    }
    
    func setMyPromiseActive(){
        btnMyPromise.setDarkButton(font: UIFont.customFont(font: .medium, size: 16))
        btnInvolve.setLightButton( font: UIFont.customFont(font: .regular, size: 16))
        
        btnMyPromise.setTitleColor(color.whiteColor(), for: .normal)
        btnInvolve.setTitleColor(color.grayColor(), for: .normal)
    }
    
    func setInvolveActive(){
        btnInvolve.setDarkButton(font: UIFont.customFont(font: .medium, size: 16))
        btnMyPromise.setLightButton( font: UIFont.customFont(font: .regular, size: 16))
        
        btnInvolve.setTitleColor(color.whiteColor(), for: .normal)
        btnMyPromise.setTitleColor(color.grayColor(), for: .normal)
        
    }

}
