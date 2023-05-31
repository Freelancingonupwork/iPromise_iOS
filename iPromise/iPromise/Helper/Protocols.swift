//
//  File.swift
//  iPromise
//
//  Created by Apple on 30/03/23.
//

import UIKit

@objc protocol CustomProtocol {
    @objc optional func dismissed(vc : UIViewController)
    @objc optional func passdataToBack(data : Any)
}
