//
//  Toast.swift
//  Utility
//
//  Created by admin on 16/03/21.
//

import UIKit

struct AppToast {
        
    static func showToast(withmessage toast:String, withview Pageframe: UIView, withstyle font: UIFont) {
        
        let widthIs = Float(toast.boundingRect(
            with: Pageframe.frame.size,
            options: .usesLineFragmentOrigin,
            attributes: [
                NSAttributedString.Key.font: font
            ],
            context: nil).size.width)
         
        let toastLabel = UILabel(frame: CGRect(x: Pageframe.frame.size.width/2 - ((CGFloat(widthIs) + 40)/2), y: Pageframe.frame.size.height-100, width: CGFloat(widthIs) + 40, height: 35))
            toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            toastLabel.textColor = UIColor.white
            toastLabel.font = font
            toastLabel.textAlignment = .center;
            toastLabel.text = toast
            toastLabel.alpha = 1.0
            toastLabel.layer.cornerRadius = 15;
            toastLabel.clipsToBounds  =  true
            Pageframe.addSubview(toastLabel)
            UIView.animate(withDuration: 2.0, delay: 1.1, options: .curveEaseOut, animations: {
                 toastLabel.alpha = 0.0
            }, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()
            })
        }

        
}
