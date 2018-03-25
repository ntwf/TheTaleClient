//
//  String.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 03/07/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import UIKit

extension String {
    var capitalizeFirstLetter: String {
        let firstLetter = String(prefix(1)).uppercased()
        let otherString = String(dropFirst())
        
        return firstLetter + otherString
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox    = self.boundingRect(with: constraintRect,
                                               options: .usesLineFragmentOrigin,
                                               attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return boundingBox.height
    }
}
