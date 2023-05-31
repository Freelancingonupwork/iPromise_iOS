//
//  Model.swift
//  iPromise
//
//  Created by Apple on 16/03/23.
//


class SettingModel  {
    //MARK: - variable
    private unowned var controller : SettingVC
    var arrMenu : [MenuItems] = []

    //MARK: -  initializer
    init(controller:SettingVC) {
        self.controller = controller
    }
        
    func setSettingMenu(){
        arrMenu = [
            MenuItems(img: image.account.name, title: settingMenuItems.account.rawValue,description: ""),
            MenuItems(img: image.notification.name, title: settingMenuItems.notifications.rawValue,description: ""),
        ]
    }
}

