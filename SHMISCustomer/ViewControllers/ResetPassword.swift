//
//  ResetPassword.swift
//  SHMISCustomer
//
//  Created by admin on 21/04/22.
//

import UIKit
import Reachability
class ResetPassword: UIViewController, UITextFieldDelegate, DashBoardConnectionDeligate {
   
    
    
    func didFinishDashBoardConnection_Logout(_ responceData: NSMutableArray) {
       
    }
    
    func didFinishDashBoardConnection_Array(_ responceData: NSMutableArray) {
        
    }
    
    
    @IBOutlet weak var mainview: UIView!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var submitbtn: UIButton!
    @IBOutlet weak var passtxt: UITextField!
    @IBOutlet weak var confirmpasstxt: UITextField!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var actyind: UIActivityIndicatorView!
    let apiprovider = Api_Provider()
    let reachability = try! Reachability()
    var window: UIWindow?
    var passwordVisible = false
    var ConfirmpasswordVisible = false
    var phoneNumber = ""
    
    @IBOutlet weak var bgView: UIView!
    
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
        loadingView.isHidden = true
        actyind.isHidden = true
        passtxt.delegate = self
        confirmpasstxt.delegate = self
        passtxt.isSecureTextEntry = true
        confirmpasstxt.isSecureTextEntry = true
        CustomView()
    }
    
    func CustomView()  {
        bgView.layer.insertSublayer(AppColors.gradientBg(view: view, colorArray: [UIColor(red: 253/255, green: 244/255, blue: 212/255, alpha: 1.0).cgColor, UIColor.white.cgColor, UIColor(red: 253/255, green: 244/255, blue: 212/255, alpha: 1.0).cgColor], locationArray: [0.0, 0.5,1.0], isVertical: true, startpoint: CGPoint(x: 0.0, y: 1.0), endpoint: CGPoint(x: 1.0, y: 1.0), cornerradius:0.0), at: 0)
        mainview.layer.cornerRadius = 10.0
        submitbtn.layer.cornerRadius = 10.0
        
        let myColor = UIColor.lightGray
           passtxt.layer.borderColor = myColor.cgColor
        confirmpasstxt.layer.borderColor = myColor.cgColor

        passtxt.layer.borderWidth = 1.0
        confirmpasstxt.layer.borderWidth = 1.0
        
        passtxt.layer.cornerRadius = 5.0
        confirmpasstxt.layer.cornerRadius = 5.0
        
        passtxt.setLeftPaddingPoints(10)
        passtxt.setRightPaddingPoints(10)
        
        confirmpasstxt.setLeftPaddingPoints(10)
        confirmpasstxt.setRightPaddingPoints(10)
        
        let button_pass = UIButton(type: .custom)
        button_pass.setImage(UIImage(named: "visibility.png"), for: .normal)
        button_pass.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button_pass.frame = CGRect(x: CGFloat(passtxt.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button_pass.addTarget(self, action: #selector(self.viewPass), for: .touchUpInside)
        passtxt.rightView = button_pass
        passtxt.rightViewMode = .always
        
        
        let button_Cpass = UIButton(type: .custom)
        button_Cpass.setImage(UIImage(named: "visibility.png"), for: .normal)
        button_Cpass.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button_Cpass.frame = CGRect(x: CGFloat(confirmpasstxt.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button_Cpass.addTarget(self, action: #selector(self.viewConfirmPass), for: .touchUpInside)
        confirmpasstxt.rightView = button_Cpass
        confirmpasstxt.rightViewMode = .always
        
    
        let font = FontHelper.defaultRegularFontWithSize(size: 14)
        
        passtxt.attributedPlaceholder = NSAttributedString(
                string: "  Password",
                attributes: [
                    NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                    NSAttributedString.Key.font: font
                ])
        
        confirmpasstxt.attributedPlaceholder = NSAttributedString(
                string: "  Confirm Password",
                attributes: [
                    NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                    NSAttributedString.Key.font: font
                ])
        
        
       
        
        
    }
    
    
    @objc func resetPassword()  {
        
        loadingView.isHidden = false
        actyind.isHidden = false
        
     print("key: \(UserDefaults.standard.string(forKey: "publicKey")!)")
        print("user:\(passtxt.text!)")
        print("pass:\(phoneNumber)")
       
        do {

            let encrypted_user =  Encryptionclass.encrypt(string: "\(UserDefaults.standard.string(forKey: "publicKey")!)", publicKey: phoneNumber)
            let encrypted_pass =  Encryptionclass.encrypt(string: "\(UserDefaults.standard.string(forKey: "publicKey")!)", publicKey: passtxt.text!)
            print("user:\(encrypted_user!)")
            print("pass:\(encrypted_pass!)")
            let deviceid = UIDevice.current.identifierForVendor?.uuidString
            var parameters = Dictionary<String, Any>()
            parameters = ["mobile_no" : "\(encrypted_user!)", "new_password" : "\(encrypted_pass!)"]
            print(parameters)
            apiprovider.delegate = self
            apiprovider.fetchPostapi(api: "reset-password", parameters: ["data": parameters], isauth: false, method: "Raw")

            } catch {
                print("The file could not be loaded")
            }



    }
    
    
    
    func didFinishDashBoardConnection_Dictionary(_ responceData: NSMutableDictionary) {
        loadingView.isHidden = true
        actyind.isHidden = true
        if responceData["status"] as! String == "success" {
                AppToast.showToast(withmessage: "Password Reset Successful", withview: view, withstyle: FontHelper.defaultRegularFontWithSize(size: 15))
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [self] in
                    goToHome()
                }
           
        }
    }
    
    
    
    func goToHome()  {
       
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as? Login {
                   if let navigator = navigationController {
                       navigator.pushViewController(viewController, animated: true)
                   }
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
    
    @IBAction func viewConfirmPass(_ sender: Any) {
        if ConfirmpasswordVisible {
            confirmpasstxt.isSecureTextEntry = true
            ConfirmpasswordVisible = false
            let button = UIButton(type: .custom)
            button.setImage(UIImage(named: "visibility.png"), for: .normal)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
            button.frame = CGRect(x: CGFloat(confirmpasstxt.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
            button.addTarget(self, action: #selector(self.viewConfirmPass), for: .touchUpInside)
            confirmpasstxt.rightView = button
            confirmpasstxt.rightViewMode = .always
        }else{
            confirmpasstxt.isSecureTextEntry = false
            ConfirmpasswordVisible = true
            let button = UIButton(type: .custom)
            button.setImage(UIImage(named: "visibilityoff.png"), for: .normal)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
            button.frame = CGRect(x: CGFloat(confirmpasstxt.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
            button.addTarget(self, action: #selector(self.viewConfirmPass), for: .touchUpInside)
            confirmpasstxt.rightView = button
            confirmpasstxt.rightViewMode = .always
        }
    }
    
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
       
        textField.resignFirstResponder()

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
    
    
    
    
    @IBAction func bkEvnt(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func submitEvnt(_ sender: Any) {
        if reachability.connection != .unavailable {
            if passtxt.text != "" && confirmpasstxt.text != "" {
                
                if passtxt.text == confirmpasstxt.text {
                    resetPassword()
                }else{
                    AppToast.showToast(withmessage: "Password Mismatch", withview: view, withstyle: FontHelper.defaultRegularFontWithSize(size: 15))
                }
            }else{
                AppToast.showToast(withmessage: "Fill all fields", withview: view, withstyle: FontHelper.defaultRegularFontWithSize(size: 15))
            }
           
        }else{
            AppToast.showToast(withmessage: "Network Not Available", withview: view, withstyle: FontHelper.defaultRegularFontWithSize(size: 15))
        }
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
