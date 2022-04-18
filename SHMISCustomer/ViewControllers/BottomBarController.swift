//
//  BottomBarController.swift
//  SHMISCustomer
//
//  Created by admin on 17/03/22.
//

import UIKit

class BottomBarController: UITabBarController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
           UITabBar.appearance().barTintColor = .white
        UITabBar.appearance().backgroundColor = .white
           
           setupVCs()
    }
    
    
    func setupVCs() {
       
           viewControllers = [
            createNavController(for : (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC") as? HomeView)!, title: NSLocalizedString("Home", comment: ""), image: UIImage(named: "Home")!, selectedimage: UIImage(named: "Home_Selected")!),
               createNavController(for: ReportsView(), title: NSLocalizedString("Reports", comment: ""), image: UIImage(named: "Reports")!, selectedimage: UIImage(named: "Reports_Selected")!),
               createNavController(for: ServicesView(), title: NSLocalizedString("Services", comment: ""), image: UIImage(named: "Services")!, selectedimage: UIImage(named: "Services_Selected")!),
               createNavController(for: (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileVC") as? ProfileView)!, title: NSLocalizedString("Profile", comment: ""), image: UIImage(named: "Profile")!, selectedimage: UIImage(named: "Profile_Selected")!)
           ]
       }
    
    
    fileprivate func createNavController(for rootViewController: UIViewController,
                                                      title: String,
                                                      image: UIImage,
                                                      selectedimage: UIImage) -> UIViewController {
            let navController = UINavigationController(rootViewController: rootViewController)
            navController.tabBarItem.title = title
            navController.tabBarItem.image = image
            navController.tabBarItem.selectedImage = selectedimage
            navController.navigationBar.prefersLargeTitles = true
            rootViewController.navigationItem.title = title
            return navController
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
