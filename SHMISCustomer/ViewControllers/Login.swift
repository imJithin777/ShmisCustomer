//
//  Login.swift
//  Utility
//
//  Created by admin on 13/03/21.
//

import UIKit
import Reachability
class Login: UIViewController, UITextFieldDelegate, DashBoardConnectionDeligate, UIPopoverPresentationControllerDelegate {
    
    func didFinishDashBoardConnection_Logout(_ responceData: NSMutableArray) {
       
    }
    
    func didFinishDashBoardConnection_Array(_ responceData: NSMutableArray) {
        
    }
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var usertxt: UITextField!
    @IBOutlet weak var passtxt: UITextField!
    @IBOutlet weak var loginbtn: UIButton!
    
    @IBOutlet weak var signupbtn: UIButton!
    
    @IBOutlet weak var guestbtn: UIButton!
    
    @IBOutlet weak var networkView: UIView!
    @IBOutlet weak var networksSwitch: UISwitch!
    @IBOutlet weak var networklbl: UILabel!
    @IBOutlet weak var loginview: UIView!
    var passwordVisible = false
    let apiprovider = Api_Provider()
    let reachability = try! Reachability()
    var isnetwork: Bool = false
    @IBOutlet weak var loadingview: UIView!
    @IBOutlet weak var actyind: UIActivityIndicatorView!
    var window: UIWindow?
    
    
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
        loadingview.isHidden = true
        actyind.isHidden = true
        usertxt.delegate = self
        passtxt.delegate = self
        passtxt.isSecureTextEntry = true
        CustomView()
        guestbtn.isHidden = true
       
    }
    
    func CustomView()  {
        view.layer.insertSublayer(AppColors.gradientBg(view: view, colorArray: [UIColor(red: 253/255, green: 244/255, blue: 212/255, alpha: 1.0).cgColor, UIColor.white.cgColor, UIColor(red: 253/255, green: 244/255, blue: 212/255, alpha: 1.0).cgColor], locationArray: [0.0, 0.5,1.0], isVertical: true, startpoint: CGPoint(x: 0.0, y: 1.0), endpoint: CGPoint(x: 1.0, y: 1.0), cornerradius:0.0), at: 0)
        loginview.layer.cornerRadius = 10.0
        loginbtn.layer.cornerRadius = 10.0
        
        let myColor = UIColor.lightGray
           usertxt.layer.borderColor = myColor.cgColor
           passtxt.layer.borderColor = myColor.cgColor

           usertxt.layer.borderWidth = 1.0
           passtxt.layer.borderWidth = 1.0
        
        usertxt.layer.cornerRadius = 5.0
        passtxt.layer.cornerRadius = 5.0
        
        usertxt.setLeftPaddingPoints(10)
        usertxt.setRightPaddingPoints(10)
        
        passtxt.setLeftPaddingPoints(10)
        passtxt.setRightPaddingPoints(10)
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "visibility.png"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(passtxt.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button.addTarget(self, action: #selector(self.viewPass), for: .touchUpInside)
        passtxt.rightView = button
        passtxt.rightViewMode = .always
    
        let font = FontHelper.defaultRegularFontWithSize(size: 14)
        
            usertxt.attributedPlaceholder = NSAttributedString(
                string: "  Username",
                attributes: [
                    NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                    NSAttributedString.Key.font: font
                ])
        
            passtxt.attributedPlaceholder = NSAttributedString(
                string: "  Password",
                attributes: [
                    NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                    NSAttributedString.Key.font: font
                ])
        
        networklbl.font = FontHelper.defaultItalicFontWithSize(size: 11)
        networklbl.textColor = .gray
        
        
        loginbtn.layer.cornerRadius = 18
        loginbtn.layer.borderWidth = 1
        loginbtn.layer.borderColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0).cgColor
        
        signupbtn.layer.cornerRadius = 18
        signupbtn.layer.borderWidth = 1
        signupbtn.layer.borderColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0).cgColor
        
        guestbtn.layer.cornerRadius = 18
        guestbtn.layer.borderWidth = 1
        guestbtn.layer.borderColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0).cgColor
        
        
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        if (textField == usertxt){
            passtxt.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        

        return true
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        // return NO to disallow editing.
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        // became first responder
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool
    {
        // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField)
    {
        // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason)
    {
        // if implemented, called in place of textFieldDidEndEditing:
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        // return NO to not change text
        return true
    }


    func textFieldShouldClear(_ textField: UITextField) -> Bool
    {
        // called when clear button pressed. return NO to ignore (no notifications)
        return true
    }
    
    
    @IBAction func network_Evnt(_ sender: Any) {
        if networksSwitch.isOn {
            networklbl.text = "Public Network"
            isnetwork = true
            UserDefaults.standard.set(isnetwork, forKey: "PublicNetwork")
        }else{
            networklbl.text = "Hospital Network"
            isnetwork = false
            UserDefaults.standard.set(isnetwork, forKey: "PublicNetwork")
        }
    }
    
    
    @IBAction func viewPass(_ sender: Any) {
        if passwordVisible {
            passtxt.isSecureTextEntry = true
            passwordVisible = false
            let button = UIButton(type: .custom)
            button.setImage(UIImage(named: "visibility.png"), for: .normal)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
            button.frame = CGRect(x: CGFloat(passtxt.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
            button.addTarget(self, action: #selector(self.viewPass), for: .touchUpInside)
            passtxt.rightView = button
            passtxt.rightViewMode = .always
        }else{
            passtxt.isSecureTextEntry = false
            passwordVisible = true
            let button = UIButton(type: .custom)
            button.setImage(UIImage(named: "visibilityoff.png"), for: .normal)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
            button.frame = CGRect(x: CGFloat(passtxt.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
            button.addTarget(self, action: #selector(self.viewPass), for: .touchUpInside)
            passtxt.rightView = button
            passtxt.rightViewMode = .always
        }
    }
    
    @IBAction func login_Evnt(_ sender: Any) {
        
        if reachability.connection != .unavailable {
            if usertxt.text != "" && passtxt.text != ""{
                usertxt.resignFirstResponder()
                passtxt.resignFirstResponder()
               Login()
               
            }else{
                AppToast.showToast(withmessage: "Fill all fields", withview: view, withstyle: FontHelper.defaultRegularFontWithSize(size: 15))
            }
           
        }else{
            AppToast.showToast(withmessage: "Network Not Available", withview: view, withstyle: FontHelper.defaultRegularFontWithSize(size: 15))
        }
        
    }
    
    @objc func Login()  {
        
        loadingview.isHidden = false
        actyind.isHidden = false
        
     print("key: \(UserDefaults.standard.string(forKey: "publicKey")!)")
        print("user:\(usertxt.text!)")
        print("pass:\(passtxt.text!)")
       
        do {

            let encrypted_user =  Encryptionclass.encrypt(string: "\(UserDefaults.standard.string(forKey: "publicKey")!)", publicKey: usertxt.text!)
            let encrypted_pass =  Encryptionclass.encrypt(string: "\(UserDefaults.standard.string(forKey: "publicKey")!)", publicKey: passtxt.text!)
            print("user:\(encrypted_user!)")
            print("pass:\(encrypted_pass!)")
            let deviceid = UIDevice.current.identifierForVendor?.uuidString
            var parameters = Dictionary<String, Any>()
            parameters = ["username" : "\(encrypted_user!)", "password" : "\(encrypted_pass!)", "deviceId": "\(deviceid!)", "grant_type" : "password", "client_secret" : "\(apiprovider.clientSecret)", "client_id" : "\(apiprovider.clientID)", "fcm_id" : ""
            ]
            print(parameters)
            apiprovider.delegate = self
            apiprovider.fetchPostapi(api: "app-login", parameters: ["data": parameters], isauth: false, method: "Raw")

            } catch {
                print("The file could not be loaded")
            }



    }
    
    
    @IBAction func signup_Evnt(_ sender: Any) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignupVC") as? Signup {
                   if let navigator = navigationController {
                       navigator.pushViewController(viewController, animated: true)
                   }
               }
    }
    
    
    @IBAction func guest_Evnt(_ sender: Any) {
    }
    
    @IBAction func forgotEvnt(_ sender: Any) {
        
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ForgotPassVC") as? ForgotPassword {
                   if let navigator = navigationController {
                       navigator.pushViewController(viewController, animated: true)
                   }
               }
    }
    
    
    
    func didFinishDashBoardConnection_Dictionary(_ responceData: NSMutableDictionary) {
        loadingview.isHidden = true
        actyind.isHidden = true
        if responceData["status"] as! String == "info" {
            let loginkeyExists = responceData["loginOTPSend"] != nil
            
            let toskeyExists = responceData["tosData"] != nil
            
            if (loginkeyExists){
               
                AppToast.showToast(withmessage: "OTP sent to your registered mobile number", withview: view, withstyle: FontHelper.defaultRegularFontWithSize(size: 15))
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [self] in
                    showOTPVerification(number: usertxt.text!, password: passtxt.text!)
                }
            }else if (toskeyExists){
                AppToast.showToast(withmessage: "Please accept the Terms of Service", withview: view, withstyle: FontHelper.defaultRegularFontWithSize(size: 15))
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [self] in
                    showTermsView(number: usertxt.text!, password: passtxt.text!)
                }
                
            }
        }else if responceData["status"] as! String == "success" {
            var fname = ""
            var lname = ""
            var accesstoken = ""
            var refreshtoken = ""
            var userID = ""
            var data = [String: Any]()
            var user_details = [String: Any]()
            var token_details = [String: Any]()
          
            user_details = responceData["profileData"] as! [String : Any]
            token_details = responceData["accessData"] as! [String : Any]
            fname = user_details["first_name"] as! String
            lname = user_details["last_name"] as! String
            userID = user_details["user_id"] as! String
            accesstoken = token_details["access_token"] as! String
            refreshtoken = token_details["refresh_token"] as! String
            
            UserDefaults.standard.set(true, forKey: "islogin")
            UserDefaults.standard.set("\(fname) \(lname)", forKey: "Username")
            UserDefaults.standard.set(userID, forKey: "userID")
            UserDefaults.standard.set(accesstoken, forKey: "accessToken")
            UserDefaults.standard.set(refreshtoken, forKey: "RefreshToken")
            AppToast.showToast(withmessage: "Login Successful", withview: view, withstyle: FontHelper.defaultRegularFontWithSize(size: 15))
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
                goToHome()
            }
      
            
        }else{
        
            let keyExists = responceData["msg"] != nil
            
            if (keyExists){
                if responceData["msg"] as! String == "Invalid username and password combination."{
                
                        AppToast.showToast(withmessage: "\(responceData["msg"]!)", withview: view, withstyle: FontHelper.defaultRegularFontWithSize(size: 15))
                    
                }
            }else{
                AppToast.showToast(withmessage: "Error Occured. Kindly switch the Network and try again", withview: view, withstyle: FontHelper.defaultRegularFontWithSize(size: 15))
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
    
   
    
    
    func showOTPVerification(number: String, password: String){
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let popupVC = storyboard.instantiateViewController(withIdentifier: "VerifyVC") as! VerificationView
        popupVC.phonenumber = number
        popupVC.password = password
        popupVC.isRegister = false
        popupVC.isMRBooking = false
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
               let pVC = popupVC.popoverPresentationController
        pVC?.permittedArrowDirections = .any
        pVC?.delegate = self
        pVC?.sourceView = view
        present(popupVC, animated: true, completion: nil)
    }
    
    
    func showTermsView(number: String, password: String){
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let popupVC = storyboard.instantiateViewController(withIdentifier: "TermsVC") as! TermsNPolicyPopup
        popupVC.phonenumber = number
        popupVC.password = password
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
               let pVC = popupVC.popoverPresentationController
        pVC?.permittedArrowDirections = .any
        pVC?.delegate = self
        pVC?.sourceView = view
        present(popupVC, animated: true, completion: nil)
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


extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
