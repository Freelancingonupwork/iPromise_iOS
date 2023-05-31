//
//  WebviewView.swift
//  iPromise
//
//  Created by Apple on 20/03/23.
//

import UIKit
import WebKit

class WebviewView : UIView{
    
    //MARK: - outlet
    @IBOutlet weak var webview: WKWebView!
    
    //MARK: - variable

    
    //MARK: - setupUI
    func setupUI(delegate : WebviewManager){
      
    }
    
    func loadData(content : String){
        webview.loadHTMLString(content, baseURL: nil)
    }
}
