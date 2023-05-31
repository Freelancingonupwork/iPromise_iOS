//
//  View.swift
//  iPromise
//
//  Created by Apple on 16/03/23.
//
import UIKit


class PromisePopupView : UIView{
    
    //MARK: -  outlet
    
    @IBOutlet weak var vwParent: UIView!
    
    @IBOutlet weak var lblHeading: UILabel!
     
    @IBOutlet weak var tblPromisePopup: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btnClose: UIButton!
    
    //MARK: - variable
  
    
    //MARK: - setupUI
    func setupUI(delegate : PromisePopupManager){
        vwParent.makeCorner()
        
        lblHeading.font = UIFont.customFont(font: .bold, size: 18)
        
        tblPromisePopup.delegate = delegate
        tblPromisePopup.dataSource = delegate
        registerCell()
        setEmptyTable()
    }
    
    //MARK: -  register cell
    func registerCell(){
        tblPromisePopup.register(UINib(nibName: "PromisePopupCell", bundle: nil), forCellReuseIdentifier: "PromisePopupCell")
        tblPromisePopup.reloadData()
        tblPromisePopup.separatorStyle = .none
        tblPromisePopup.isScrollEnabled = false
        tblPromisePopup.rowHeight = UITableView.automaticDimension
        tblPromisePopup.backgroundColor = .clear
        tblPromisePopup.addObserver(self, forKeyPath: "contentSize", options: .new, context: .none)
        tblPromisePopup.reloadData()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if (object as! UITableView) == self.tblPromisePopup {
            if(keyPath == "contentSize"){
                if let newvalue = change?[.newKey]
                {
                    let newsize = newvalue as! CGSize
                    self.tableHeight.constant = newsize.height
                    if tableHeight.constant >= screenSize.height - 100{
                        tableHeight.constant -= 100
                        tblPromisePopup.isScrollEnabled = true
                    }
                }
            }
        }
    }
    
    func setEmptyTable(){
        tableHeight.constant = 200
    }
}
