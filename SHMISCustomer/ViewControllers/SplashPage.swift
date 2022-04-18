//
//  SplashPage.swift
//  BansalNews
//
//  Created by admin on 05/11/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import Reachability


class SplashPage: UIViewController, DashBoardConnectionDeligate {
    func didFinishDashBoardConnection_Logout(_ responceData: NSMutableArray) {
        guard let windowScene = (self.view.window!.windowScene) else { return }
               window = UIWindow(frame: UIScreen.main.bounds)
               let home = Login()
               self.window?.rootViewController = home
               window?.makeKeyAndVisible()
               window?.windowScene = windowScene
    }
    
    
    func didFinishDashBoardConnection_Array(_ responceData: NSMutableArray) {
        
    }
    
    
    private var myColor = AppColors()
    var window: UIWindow?
    
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var transimage: UIImageView!
    @IBOutlet weak var launchView: UIView!
    @IBOutlet weak var launchText: UILabel!
    @IBOutlet weak var launchText2: UILabel!
    
    @IBOutlet weak var powerView: UIView!
    @IBOutlet weak var powerLogo: UIImageView!
    @IBOutlet weak var powerText: UILabel!
    @IBOutlet weak var gradientView: UIImageView!
    
    
    
    
    
    @IBOutlet weak var gradientImg: UIImageView!
    
   
    let apiprovider = Api_Provider()
    var recTimer: Timer? = nil
    let reachability = try! Reachability()
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
        
        
       
    }
    
    @objc func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            print("Reachable via WiFi")
        case .cellular:
            print("Reachable via Cellular")
        case .none:
            print("Network not reachable")
        case .unavailable:
            print("Network not reachable")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.layer.insertSublayer(AppColors.gradientBg(view: view, colorArray: [UIColor(red: 84/255, green: 158/255, blue: 210/255, alpha: 1.0).cgColor, UIColor.white.cgColor], locationArray: [0.5, 1.0], isVertical: false, startpoint: CGPoint(x: 0, y: 0), endpoint: CGPoint(x: 0, y: 0), cornerradius: 0.0), at: 0)
        CustomView()
        print(UserDefaults.standard.string(forKey: "accessToken"))
        if reachability.connection != .unavailable {
            apiprovider.delegate = self
            apiprovider.fetchapi(api: "get-version" as NSString, isauth: false)
        }else{
            AppToast.showToast(withmessage: "Network not Available", withview: view, withstyle: FontHelper.defaultRegularFontWithSize(size: 15))
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { [self] timer in
                Navigate()
            }
        }
      
        
    }
    
    
   
    
    func CustomView() {
       
        view.layer.insertSublayer(AppColors.gradientBg(view: view, colorArray: [UIColor(red: 84/255, green: 158/255, blue: 210/255, alpha: 1.0).cgColor, UIColor.white.cgColor], locationArray: [1.0, 0.5], isVertical: false, startpoint: CGPoint(x: 0, y: 0), endpoint: CGPoint(x: 0, y: 0), cornerradius: 0.0), at: 0)
        gradientView.layer.insertSublayer(AppColors.gradientBg(view: view, colorArray: [UIColor(red: 84/255, green: 158/255, blue: 210/255, alpha: 1.0).cgColor, UIColor.white.cgColor], locationArray: [1.0, 0.5], isVertical: false, startpoint: CGPoint(x: 0, y: 0), endpoint: CGPoint(x: 0, y: 0), cornerradius: 0.0), at: 0)
        
//        logo.layer.masksToBounds = true
//        logo.layer.borderWidth = 1.5
//        logo.layer.borderColor = myColor.borderColor.cgColor
//        logoView.layer.cornerRadius = 2.0
        
    
        
        launchText.text = "AMAZING TECHNOLOGY \n EXTRA ORDINARY CARE"
        launchText.textColor = UIColor(red: -0.117, green: 0.287, blue: 0.535, alpha: 1.0)
        launchText2.text = "V \(appVersion)"
        launchText2.textColor = UIColor(red: -0.106, green: 0.266, blue: 0.52, alpha: 1.0)
        
        
        launchText.font = FontHelper.defaultBoldFontWithSize(size: 17)
        launchText2.font = FontHelper.defaultRegularFontWithSize(size: 13)
        
        powerView.backgroundColor = .white
        
        powerText.text = "Powered by"
        powerText.font = FontHelper.defaultRegularFontWithSize(size: 10)
        powerText.textColor = UIColor(red: -0.106, green: 0.266, blue: 0.52, alpha: 1.0)
        
        

    }
    
    
    func didFinishDashBoardConnection_Dictionary(_ responceData: NSMutableDictionary) {
        if responceData["status"] as! String == "success" {
            UserDefaults.standard.set("\(responceData["public_key"]!)", forKey: "publicKey")
           
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { [self] timer in
                Navigate()
            }
        }else{
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { [self] timer in
                Navigate()
            }
        }
    }
    
    
   
    func Navigate()  {
        
        if UserDefaults.standard.bool(forKey: "islogin") {
            goToHome()
        }
        else{
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as? Login {
                       if let navigator = navigationController {
                           navigator.pushViewController(viewController, animated: true)
                       }
                   }
            
          
        }
      
    }
    
    
    func goToHome()  {
       
        
        guard let windowScene = (self.view.window!.windowScene) else { return }
               window = UIWindow(frame: UIScreen.main.bounds)
               let home = BottomBarController()
               home.selectedIndex = 0
               self.window?.rootViewController = home
               window?.makeKeyAndVisible()
               window?.windowScene = windowScene
        
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

