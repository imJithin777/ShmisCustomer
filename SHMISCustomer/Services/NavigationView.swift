//
//  NavigationView.swift
//  SHMISCustomer
//
//  Created by admin on 13/03/22.
//

import UIKit
import ESTabBarController_swift

enum ExampleProvider {

    
    static func customBouncesStyle() -> BottomBarController {
        
        let tabBarController = ESTabBarController()
        if let tabBar = tabBarController.tabBar as? ESTabBar {
            tabBar.itemCustomPositioning = .fillIncludeSeparator
        }
        let v1 = HomeView()
        let v2 = UIViewController()
        let v3 = UIViewController()
        let v4 = UIViewController()
      //  let v5 = ExampleViewController()
        v1.tabBarItem = ESTabBarItem.init(ExampleBouncesContentView(), title: "Home", image: UIImage(named: "Home_Selected"), selectedImage: UIImage(named: "Home"))
        v2.tabBarItem = ESTabBarItem.init(ExampleBouncesContentView(), title: "Reports", image: UIImage(named: "Reports_Selected"), selectedImage: UIImage(named: "Reports"))
        v3.tabBarItem = ESTabBarItem.init(ExampleBouncesContentView(), title: "Services", image: UIImage(named: "Services_Selected"), selectedImage: UIImage(named: "Services"))
        v4.tabBarItem = ESTabBarItem.init(ExampleBouncesContentView(), title: "Profile", image: UIImage(named: "Profile_Selected"), selectedImage: UIImage(named: "Profile"))
       // v5.tabBarItem = ESTabBarItem.init(ExampleBouncesContentView(), title: "Menu", image: UIImage(named: "Menu_set"), selectedImage: UIImage(named: "Menu"))
        
        tabBarController.viewControllers = [v1,v2,v3,v4]
        
        
        let navigationController = BottomBarController.init(rootViewController: tabBarController)
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.init(red: 255/255.0, green: 28/255.0, blue: 28/255.0, alpha: 1.0),
            NSAttributedString.Key.font: UIFont(name: "Lato-Regular", size: 17)!
        ]
        navigationController.navigationBar.titleTextAttributes = attrs
        
        navigationController.navigationBar.isHidden = true
        
        
        return navigationController
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
