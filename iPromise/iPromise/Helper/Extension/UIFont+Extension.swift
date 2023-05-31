//
//  Font+Extension.swift
//  iPromise
//
//  Created by Apple on 13/03/23.
//

import UIKit


typealias MainFont = AppFont.mulish

enum AppFont {
    enum mulish: String {
        case regular = "Regular"
        case medium = "SemiBold"
        case bold = "ExtraBold"
    }
}

extension UIFont {
    class func customFont( font : MainFont, size: CGFloat) -> UIFont {
        guard let customFont = UIFont(name: "Mulish-\(font.rawValue)" , size: size) else {
            return UIFont.systemFont(ofSize:  size) }
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: customFont)
    }
}
