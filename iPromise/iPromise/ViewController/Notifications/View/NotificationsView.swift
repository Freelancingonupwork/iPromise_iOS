//
//  NotificationsView.swift
//  iPromise
//
//  Created by Apple on 17/03/23.
//

import UIKit
import SwiftyJSON

class NotificationsView : UIView{
    
    //MARK: - outlet
    @IBOutlet weak var tblNotifications : UITableView!
    @IBOutlet weak var vwNoPromise: UIView!
    @IBOutlet weak var lblNoNotification: UILabel!
    
    //MARK: - variable
    var isList = false {
        didSet{
            if !isList{
                tblNotifications.isHidden = false
                vwNoPromise.isHidden = true
            }
        }
    }
    var arrNotification = [JSON](){
        didSet{
            if arrNotification.count > 0{
                tblNotifications.isHidden = false
                vwNoPromise.isHidden = true
            }
            else{
                tblNotifications.isHidden = true
                vwNoPromise.isHidden = false
            }
        }
    }
    
    
    //MARK: - setupUI
    func setupUI(delegate : NotificationsManager){
        vwNoPromise.setShadow(borderColor: .clear)
        
        lblNoNotification.font = UIFont.customFont(font: .bold, size: 18)
        
        tblNotifications.delegate = delegate
        tblNotifications.dataSource = delegate
        registerCell()
    }
    
    //MARK: -  register cell
    func registerCell(){
        tblNotifications.register(UINib(nibName: "NotificationsCell", bundle: nil), forCellReuseIdentifier: "NotificationsCell")
        tblNotifications.register(UINib(nibName: "NotificationStatusCell", bundle: nil), forCellReuseIdentifier: "NotificationStatusCell")
        tblNotifications.separatorStyle = .none
        tblNotifications.separatorColor = .clear
        tblNotifications.isScrollEnabled = true
        tblNotifications.rowHeight = UITableView.automaticDimension
        tblNotifications.backgroundColor = .clear
        tblNotifications.tableFooterView = UIView()
        tblNotifications.reloadData()
    }
    
    
}
