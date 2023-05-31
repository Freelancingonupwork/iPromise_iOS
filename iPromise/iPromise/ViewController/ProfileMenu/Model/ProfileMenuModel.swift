//
//  Model.swift
//  iPromise
//
//  Created by Apple on 15/03/23.
//


import UIKit

struct MenuItems{
    let img : String
    let title : String
    let description : String
}


class ProfileMenuModel  {
    //MARK: - variable
    private unowned var controller : ProfileMenuVC
    
    let arrMenuItem : [MenuItems] = [
        MenuItems(img: image.setting.name, title: profileMenuItems.settigns.rawValue,description: ""),
        MenuItems(img: image.info.name, title: profileMenuItems.info.rawValue,description: ""),
        MenuItems(img: image.share.name, title: profileMenuItems.share.rawValue,description: ""),
        MenuItems(img: image.edit.name, title: profileMenuItems.feedback.rawValue,description: ""),
        MenuItems(img: image.logout.name, title: profileMenuItems.logout.rawValue,description: ""),
        ]
    
    //MARK: -  initializer
    init(controller:ProfileMenuVC) {
        self.controller = controller
    }
    
}
