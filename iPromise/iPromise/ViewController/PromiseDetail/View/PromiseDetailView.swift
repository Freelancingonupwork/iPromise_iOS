//
//  View.swift
//  iPromise
//
//  Created by Apple on 21/03/23.
//

import UIKit
import SwiftyJSON

class PromiseDetailView : UIView{
    //MARK: - outlet
    @IBOutlet weak var imgPromise : UIImageView!
    
    @IBOutlet weak var vwPromiseDetail : UIView!
    
    @IBOutlet weak var lblPromiseTitle : UILabel!
    @IBOutlet weak var lblPomiseDate : UILabel!
    @IBOutlet weak var lblDescription : UILabel!
    @IBOutlet weak var lblPromiseDetail : UILabel!
    
    @IBOutlet weak var tblPromiseDetail : UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btnComplete : UIButton!
    @IBOutlet weak var btnFail : UIButton!
    
   
    //MARK: - variable
    
    
    //MARK: - setupUI
    func setupUI(delegate : PromiseDetailManager){
        imgPromise.setTopCorner(radius: 30)
        
        vwPromiseDetail.setBottomCorner(radius: 30)
        
        btnComplete.setDarkButton()
        btnFail.setBorderButton(borderColor: color.redColor(), textColor: color.redColor(), cornerRadius: 16)
        
        lblPromiseTitle.font = UIFont.customFont(font: .bold, size: 18)
        lblPomiseDate.font = UIFont.customFont(font: .regular, size: 16)
        lblDescription.font = UIFont.customFont(font: .medium, size: 16)
        lblPromiseDetail.font = UIFont.customFont(font: .regular, size: 14)
        
        tblPromiseDetail.delegate = delegate
        tblPromiseDetail.dataSource = delegate
        registerCell()
        
    }
    
    func hideButton(){
        btnFail.isHidden = true
        btnComplete.isHidden = true
    }
    
    //MARK: -  register cell
    func registerCell(){
        tblPromiseDetail.register(UINib(nibName: "PromiseCell", bundle: nil), forCellReuseIdentifier: "PromiseCell")
        tblPromiseDetail.reloadData()
        tblPromiseDetail.separatorStyle = .none
        tblPromiseDetail.isScrollEnabled = false
        tblPromiseDetail.rowHeight = UITableView.automaticDimension
        tblPromiseDetail.backgroundColor = .clear
        tblPromiseDetail.addObserver(self, forKeyPath: "contentSize", options: .new, context: .none)
        tblPromiseDetail.reloadData()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if (object as! UITableView) == self.tblPromiseDetail {
            if(keyPath == "contentSize"){
                if let newvalue = change?[.newKey]
                {
                    let newsize = newvalue as! CGSize
                    self.tableHeight.constant = newsize.height
                }
            }
        }
    }
    
    func setupData(dict : JSON){
        imgPromise.setImageFromUrl(url: dict["image"].stringValue)
        
        lblPromiseTitle.text = dict["title"].stringValue
        lblPromiseDetail.text = dict["description"].stringValue
        
        let str = dict["end_date"].stringValue.trunc(length: 10)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        guard let date = dateFormatter.date(from: str) else {
            return
        }

        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = "d MMMM, yyyy"
        let newStr = newDateFormatter.string(from: date)

        lblPomiseDate.text = "Due Date \( newStr)"
    }
}
