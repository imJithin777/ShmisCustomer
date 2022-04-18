//
//  AppColors.swift
//  Utility
//
//  Created by admin on 13/03/21.
//

import UIKit

class AppColors: UIColor {
    
    

    var primaryBlue:UIColor{
            get{
              return UIColor(red: 0.0/255, green: 115.0/255, blue: 180.0/255, alpha: 1.0)
            }
        }
    

    
    var primaryDarkBlue:UIColor{
        get{
            return UIColor(red: 0.0/255, green: 72.0/255, blue: 132.0/255, alpha: 1.0)
        }
    }
    
    var colorAccent:UIColor{
        get{
            return UIColor(red: 124.0/255, green: 77.0/255, blue: 255.0/255, alpha: 1.0)
        }
    }
    
    var borderColor:UIColor{
        get{
            return UIColor(red: 235.0/255, green: 168.0/255, blue: 91.0/255, alpha: 1.0)
        }
    }
    
    var BannerborderColor:UIColor{
        get{
            return UIColor(red: 202.0/255, green: 203.0/255, blue: 204.0/255, alpha: 1.0)
        }
    }
    
    static func gradientBg(view: UIView, colorArray: [CGColor], locationArray: [NSNumber], isVertical: Bool, startpoint: CGPoint, endpoint: CGPoint, cornerradius: Double) -> CAGradientLayer {
        
    
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        gradient.colors = colorArray
        gradient.locations = locationArray
        gradient.cornerRadius = cornerradius
        if isVertical {
            gradient.startPoint = startpoint
            gradient.endPoint = endpoint
        }
        
        
        return gradient
        
    }
    
    
    
}
