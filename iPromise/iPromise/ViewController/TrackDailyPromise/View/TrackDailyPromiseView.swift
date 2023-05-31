//
//  View.swift
//  iPromise
//
//  Created by Apple on 16/03/23.
//
import UIKit
import AdvancedPageControl


class TrackDailyPromiseView : UIView{
    //MARK: - outlet
   
   
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
  
    @IBOutlet weak var btnNotNow: UIButton!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    
    @IBOutlet weak var tblPromise: UITableView!
    
    @IBOutlet weak var pageControl: AdvancedPageControlView!
    
    
    //MARK: - variable
    var counter = 0
    
    //MARK: - setupUI
    func setupUI(delegate : TrackDailyPromiseManager){
       
        btnNotNow.setLightButton( font: UIFont.customFont(font: .medium, size: 15.0), titleColor: color.whiteColor())
        
        lblTitle.font = UIFont.customFont(font: .bold, size: 22)
        lblSubTitle.font = UIFont.customFont(font: .regular, size: 16)
        
        let name = Utils.getUserDetail(.name)
        lblTitle.text = "Hi \(name)!"
        
        tblPromise.delegate = delegate
        tblPromise.dataSource = delegate
        registerCell()
    }
    
    func setupPageControl(pages : Int){
        pageControl.numberOfPages = pages
        pageControl.drawer = ExtendedDotDrawer(numberOfPages: pages,
                                               height: 7,
                                               width: 7,
                                               space: 10,
                                               indicatorColor: color.whiteColor(),
                                               dotsColor: color.grayColor())
        pageControl.setPage(0)
 
    }
    
    //MARK: -  register cell
    
    func registerCell(){
        tblPromise.register(UINib(nibName: "PromiseCell", bundle: nil), forCellReuseIdentifier: "PromiseCell")
        
        tblPromise.separatorStyle = .none
        tblPromise.isScrollEnabled = false
        tblPromise.rowHeight = UITableView.automaticDimension
        tblPromise.backgroundColor = .clear
        tblPromise.reloadData()

        pageControl.tintColor = color.primaryColor()
        
    }
    
}
