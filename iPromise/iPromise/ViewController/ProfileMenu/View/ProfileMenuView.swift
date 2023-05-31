//
//  View.swift
//  iPromise
//
//  Created by Apple on 16/03/23.
//
import UIKit


class ProfileMenuView : UIView{
    //MARK: - outlet
    @IBOutlet weak var tblMenu : UITableView!
    @IBOutlet weak var vwDismiss : UIView!
    @IBOutlet weak var vwParent: UIView!
    @IBOutlet weak var vwDismisscontroller: UIView!
    
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    //MARK: - variable
    

    //MARK: - setupUI
    func setupUI(delegate : ProfileMenuManager){
        vwDismiss.makeRound()
        vwParent.setTopCorner(radius : 30)

        
        tblMenu.delegate = delegate
        tblMenu.dataSource = delegate
        registerCell()
    }
    
    //MARK: -  register cell
    func registerCell(){
        tblMenu.register(UINib(nibName: "ProfileMenuCell", bundle: nil), forCellReuseIdentifier: "ProfileMenuCell")
        tblMenu.separatorStyle = .singleLine
        tblMenu.separatorColor = .clear
        
        tblMenu.isScrollEnabled = false
        tblMenu.rowHeight = 80
        tblMenu.estimatedRowHeight = 80
        tblMenu.backgroundColor = .clear
        tblMenu.tableFooterView = UIView()
        tblMenu.addObserver(self, forKeyPath: "contentSize", options: .new, context: .none)
        tblMenu.reloadData()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if (object as! UITableView) == self.tblMenu {
            if(keyPath == "contentSize"){
                if let newvalue = change?[.newKey]
                {
                    let newsize = newvalue as! CGSize
                    self.tableHeight.constant = newsize.height
                }
            }
        }
    }
    
}
