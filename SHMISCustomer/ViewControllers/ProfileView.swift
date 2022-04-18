//
//  ProfileView.swift
//  SHMISCustomer
//
//  Created by admin on 17/03/22.
//

import UIKit

class ProfileView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var dpImg: UIImageView!
    @IBOutlet weak var contentview: UIView!
    @IBOutlet weak var tblContents: UITableView!
    let menuItems: [String] = ["Sign Out"]
    @IBOutlet weak var namelbl: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var headView: UIView!
    
    private static let CellIdentifier = "CellIdentifier"
    var window: UIWindow?
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        CustomView()
    }
    
    func CustomView() {
        
        bgView.layer.insertSublayer(AppColors.gradientBg(view: bgView, colorArray: [UIColor(red: 253/255, green: 244/255, blue: 212/255, alpha: 1.0).cgColor, UIColor.white.cgColor, UIColor(red: 253/255, green: 244/255, blue: 212/255, alpha: 1.0).cgColor], locationArray: [0.0, 0.5,1.0], isVertical: true, startpoint: CGPoint(x: 0.0, y: 1.0), endpoint: CGPoint(x: 1.0, y: 1.0), cornerradius: 0.0), at: 0)
        
       
        namelbl.text =  UserDefaults.standard.string(forKey: "Username")?.capitalized
        namelbl.font = FontHelper.defaultRegularFontWithSize(size: 16)
        
        
        contentview.backgroundColor = .white
        
        
        tblContents.register(UITableViewCell.self, forCellReuseIdentifier: ProfileView.CellIdentifier)
        tblContents.delegate = self
        tblContents.dataSource = self
        tblContents.backgroundColor = .white
        
        
        let demoview = UIView(frame: CGRect(x: 0, y: headView.frame.size.height - 20, width: headView.frame.size.width, height: 20))
        demoview.backgroundColor = UIColor(red: 235/255, green: 51/255, blue: 35/255, alpha: 1.0)
        
        let lbltitle = UILabel(frame: CGRect(x: 20 , y: 0, width: demoview.frame.size.width - 40, height: 20))
        lbltitle.textAlignment = .center
        lbltitle.numberOfLines = 1
        lbltitle.textColor = UIColor.white
        lbltitle.text = "TEST VERSION : \(appVersion)(202.88.244.166:3412/hmis_msm/web/app.php)"
        lbltitle.font = FontHelper.defaultRegularFontWithSize(size: 10)
        demoview.addSubview(lbltitle)
        headView.addSubview(demoview)
        
    }
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
       
    }
    
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuItems.count
    }
        
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: ProfileView.CellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell?.selectionStyle = .none
            cell?.accessoryType = .none
            if Float(UIDevice.current.systemVersion) ?? 0.0 >= 8.0 {
                cell?.layoutMargins = UIEdgeInsets.zero
            }
        }
        
        
      
        
        let headView = UIView()
        headView.backgroundColor = UIColor.white
        headView.frame = CGRect(x: 0, y: 0, width: Int(tableView.frame.size.width) , height: 70)
            
        
        let menuimg = UIImageView()
        menuimg.frame = CGRect(x: 30, y: headView.frame.size.height/2 - 10, width:  20, height: 20)
        menuimg.image = UIImage(named: "\(menuItems[indexPath.row]).png")
        
        
        let lbltitle = UILabel(frame: CGRect(x: menuimg.frame.origin.x + menuimg.frame.size.width + 20 , y: headView.frame.size.height/2 - 15, width: headView.frame.size.width - (menuimg.frame.origin.x + menuimg.frame.size.width + 20), height: 30))
        lbltitle.textAlignment = .left
        lbltitle.numberOfLines = 0
        lbltitle.tag = 100
        lbltitle.textColor = UIColor.black
        lbltitle.font = FontHelper.defaultRegularFontWithSize(size: 14)
        lbltitle.text = "\(menuItems[indexPath.row])"
        
        
        
        let bkView = UIView(frame: CGRect(x: 5, y: 10, width: headView.frame.size.width - 10, height: headView.frame.size.height - 12))
            bkView.backgroundColor = UIColor.white
            bkView.layer.borderColor = UIColor.white.cgColor
            bkView.layer.borderWidth = 0.5
            bkView.layer.shadowColor = UIColor.lightGray.cgColor
            bkView.layer.shadowOffset = CGSize(width: 0, height: 2)
            bkView.layer.shadowOpacity = 0.8
        bkView.layer.cornerRadius = 3
        
        
        
      
        cell?.addSubview(headView)
        
        headView.addSubview(bkView)
        headView.addSubview(menuimg)
        headView.addSubview(lbltitle)
        
        
        
        if let aCell = cell {
            return aCell
        }
        return UITableViewCell()
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          
        return 70
        }
    
        
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        let otherAlert = UIAlertController(title: "Confirm Logout", message: "You will be Logged Out from this device", preferredStyle: UIAlertController.Style.actionSheet)

        let callFunction = UIAlertAction(title: "Logout", style: UIAlertAction.Style.destructive, handler: myHandler)

        let dismiss = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)

           // relate actions to controllers
           otherAlert.addAction(callFunction)
           otherAlert.addAction(dismiss)

        present(otherAlert, animated: true, completion: nil)
    }
    
    func myHandler(alert: UIAlertAction){
        UserDefaults.standard.set(false, forKey: "islogin")
        UserDefaults.standard.set("", forKey: "Username")
        UserDefaults.standard.set("", forKey: "accessToken")
        UserDefaults.standard.set("", forKey: "RefreshToken")
        UserDefaults.standard.set("", forKey: "userID")
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as? Login {
                   if let navigator = navigationController {
                       navigator.pushViewController(viewController, animated: true)
                   }
               }
        self.tabBarController?.tabBar.isHidden = true
      
    }
    
    
   
    
        
    
    @IBAction func notificationEvnt(_ sender: Any) {
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
