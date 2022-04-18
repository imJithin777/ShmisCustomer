//
//  Shadow.swift
//  Utility
//
//  Created by admin on 05/04/21.
//

import UIKit

struct Shadow {
    
    static func setShadow(view : UIView){
           view.layer.masksToBounds = false
           view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowRadius = 1.2
           view.layer.shadowOpacity = 0.3
           view.layer.shadowColor = UIColor.gray.cgColor
    }

}

