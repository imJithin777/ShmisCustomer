//
//  NavigationView.swift
//  SHMISCustomer
//
//  Created by admin on 13/03/22.
//

import UIKit
import ESTabBarController_swift

enum ExampleProvider {

    
    static func customBouncesStyle() -> ViewController {
        
        let tabBarController = ESTabBarController()
        if let tabBar = tabBarController.tabBar as? ESTabBar {
            tabBar.itemCustomPositioning = .fillIncludeSeparator
        }
        let v1 = HomeViewController()
        let v2 = LiveTVViewController()
        let v3 = NewsmainViewController()
        let v4 = InfoViewController()
      //  let v5 = ExampleViewController()
        v1.tabBarItem = ESTabBarItem.init(ExampleBouncesContentView(), title: "Home", image: UIImage(named: "Home_set"), selectedImage: UIImage(named: "Home"))
        v2.tabBarItem = ESTabBarItem.init(ExampleBouncesContentView(), title: "Live TV", image: UIImage(named: "Live TV_set"), selectedImage: UIImage(named: "Live TV"))
        v3.tabBarItem = ESTabBarItem.init(ExampleBouncesContentView(), title: "News", image: UIImage(named: "Article_set"), selectedImage: UIImage(named: "Article"))
        v4.tabBarItem = ESTabBarItem.init(ExampleBouncesContentView(), title: "More", image: UIImage(named: "More_set"), selectedImage: UIImage(named: "More"))
       // v5.tabBarItem = ESTabBarItem.init(ExampleBouncesContentView(), title: "Menu", image: UIImage(named: "Menu_set"), selectedImage: UIImage(named: "Menu"))
        
        tabBarController.viewControllers = [v1,v2,v3,v4]
        
        
        let navigationController = ViewController.init(rootViewController: tabBarController)
        tabBarController.title = "manihira"
        let attrs = [
            NSAttributedStringKey.foregroundColor: UIColor.init(red: 255/255.0, green: 28/255.0, blue: 28/255.0, alpha: 1.0),
            NSAttributedStringKey.font: UIFont(name: "intro", size: 17)!
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
