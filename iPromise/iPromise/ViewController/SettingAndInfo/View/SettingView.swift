//
//  View.swift
//  iPromise
//
//  Created by Apple on 16/03/23.
//
import UIKit


class SettingView : UIView{
    
    //MARK: - outlet
    @IBOutlet weak var tblMenus: UITableView!
    
    //MARK: - variable
    
    
    //MARK: - setupUI
    func setupUI(delegate : SettingManager){
        tblMenus.delegate = delegate
        tblMenus.dataSource = delegate
        registerCell()
    }
    
    func registerCell(){
        tblMenus.register(UINib(nibName: "AccountAndInfoCell", bundle: nil), forCellReuseIdentifier: "AccountAndInfoCell")
        tblMenus.separatorStyle = .none
        
        tblMenus.isScrollEnabled = true
        tblMenus.rowHeight = UITableView.automaticDimension
        tblMenus.estimatedRowHeight = UITableView.automaticDimension
        tblMenus.backgroundColor = .clear
        tblMenus.tableFooterView = UIView()
        tblMenus.reloadData()
    }
    
    
}
