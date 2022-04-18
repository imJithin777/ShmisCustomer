//
//  AlertView.swift
//  Utility
//
//  Created by admin on 04/12/21.
//

import UIKit

public class AlertView {
    
    static func showAlert(on vc: UIViewController, withmessage message: String, withcanceltitle cancel: String, withenabletitle enable: String, withfunction callBack:()) {
        let alert = UIAlertController(title: enable, message: message,  preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: cancel, style: UIAlertAction.Style.cancel, handler: { _ in
                //Cancel Action
            }))
            alert.addAction(UIAlertAction(title: enable,
                                          style: UIAlertAction.Style.default,
                                          handler: {(_: UIAlertAction!) in
                callBack
               
            }))
        vc.present(alert, animated: true, completion: nil)
        }

}
