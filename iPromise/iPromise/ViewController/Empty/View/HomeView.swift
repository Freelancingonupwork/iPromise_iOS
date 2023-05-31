//
//  View.swift
//  iPromise
//
//  Created by Apple on 15/03/23.
//

import UIKit
import SwiftyJSON

class HomeView : UIView{
    //MARK: - outlet
   
    @IBOutlet weak var vwSearch: UIView!
    @IBOutlet weak var vwBanner: UIView!
    @IBOutlet weak var vwNoPromise: UIView!
   
    @IBOutlet weak var txtSearch: UITextField!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblInProgress: UILabel!
    @IBOutlet weak var lblNothing: UILabel!
    @IBOutlet weak var lblNoPromiseDescription: UILabel!
    
    
    @IBOutlet weak var imgNotificationBadge: UIImageView!
    
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnMyPromise: UIButton!
    @IBOutlet weak var btnInvolve: UIButton!
    
    @IBOutlet weak var tblPromise: UITableView!
    
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var scrollview: UIScrollView!
    //MARK: - variable
    var arrPromises = [JSON]()
    var strNoPromiseText = "Don't be shy, create your first promise" {
            didSet{
                customLabelUI()
            }
        }

    //MARK: - setupUI
    func setupUI(delegate : HomeManager){
        vwNoPromise.setShadow(borderColor: .clear)
        vwSearch.setShadow(borderColor: .clear)
        vwBanner.makeCorner()
        
        [lblInProgress,lblNothing].forEach{
            $0?.font = UIFont.customFont(font: .bold, size: 18)
        }
        [lblNoPromiseDescription].forEach{ $0.font = UIFont.customFont(font: .regular, size: 16) }
        
        btnAdd.makeRound()
        
      
        setMyPromiseActive()
        
        txtSearch.returnKeyType = .search
        txtSearch.attributedPlaceholder = txtSearch.setAttributeText(placeHolderString: "Search")
        [txtSearch].forEach{
            $0.delegate = delegate as? any UITextFieldDelegate
            $0.font = UIFont.customFont(font: .regular, size: 16)
            $0.textColor = color.blackColor()
            $0.adjustsFontSizeToFitWidth = true
            $0.tintColor = color.blackColor()
        }
        
        tblPromise.delegate = delegate
        tblPromise.dataSource = delegate
        registerCell()
        customLabelUI()
    }
    
    func customLabelUI()
    {
        lblNoPromiseDescription.text = strNoPromiseText
        lblNoPromiseDescription.isUserInteractionEnabled = true
        lblNoPromiseDescription.highlightWords(phrases:  ["invite via SMS"], withColor: color.primaryColor(), withFont: UIFont.customFont(font: .bold, size: 16))
    }
    
    func setMyPromiseActive(){
        btnMyPromise.setDarkButton(font: UIFont.customFont(font: .medium, size: 16))
        btnInvolve.setLightButton( BGcolor: color.whiteColor(), font: UIFont.customFont(font: .regular, size: 16), titleColor: color.grayColor())
        
        btnMyPromise.setTitleColor(color.whiteColor(), for: .normal)
    }
    
    func setInvolveActive(){
        btnInvolve.setDarkButton(font: UIFont.customFont(font: .medium, size: 16))
        btnMyPromise.setLightButton( BGcolor: color.whiteColor(), font: UIFont.customFont(font: .regular, size: 16), titleColor: color.grayColor())
        
        btnInvolve.setTitleColor(color.whiteColor(), for: .normal)
    }

    
    //MARK: -  register cell
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
                    self.tableHeight.constant = newsize.height
                }
            }
        }
        if arrPromises.count == 0 {
            tableHeight.constant = 330
            tblPromise.isHidden = true
            vwNoPromise.isHidden = false
        }
        else{
            tblPromise.isHidden = false
            vwNoPromise.isHidden = true
        }
    }
    
}
