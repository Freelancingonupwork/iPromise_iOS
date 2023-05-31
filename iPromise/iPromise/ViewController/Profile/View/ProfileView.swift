//
//  View.swift
//  iPromise
//
//  Created by Apple on 16/03/23.
//
import UIKit
import SwiftyJSON

class ProfileView : UIView{
    
    
    //MARK: - outlet
    @IBOutlet weak var vwProfile : UIView!
    @IBOutlet weak var vwImg : UIView!
    @IBOutlet weak var vwNoPromise: UIView!
    
    @IBOutlet weak var imgProfile : UIImageView!
   
    @IBOutlet weak var lblNothing: UILabel!
    @IBOutlet weak var lblNoPromiseDescription: UILabel!
    @IBOutlet weak var lblMyPromise : UILabel!
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var lblPromises : UILabel!
    
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    
    @IBOutlet weak var tblPromise: UITableView!
    
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var scrollview: UIScrollView!
    //MARK: - variable
    var arrPromises = [JSON]()
    
    //MARK: - setupUI
    func setupUI(delegate : ProfileManager){
       
        vwProfile.setBottomCorner(radius: 50)
        vwNoPromise.setShadow(borderColor: .clear)
        vwImg.makeRound()
        imgProfile.makeRound()
        
        [lblMyPromise, lblName,lblNothing].forEach{
            $0?.font = UIFont.customFont(font: .bold, size: 18)
        }
        [lblPromises, lblNoPromiseDescription].forEach{ $0.font = UIFont.customFont(font: .regular, size: 16) }
            
        btnAdd.makeRound()
              
        tblPromise.delegate = delegate
        tblPromise.dataSource = delegate
        registerCell()
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
            tableHeight.constant = 300
            tblPromise.isHidden = true
            vwNoPromise.isHidden = false
        }
        else{
            tblPromise.isHidden = false
            vwNoPromise.isHidden = true
        }
    }
    
    
}

