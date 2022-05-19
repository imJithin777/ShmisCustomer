//
//  VerificationView.swift
//  SHMISCustomer
//
//  Created by admin on 12/03/22.
//

import UIKit
import AEOTPTextField
class VerificationView: UIViewController,DashBoardConnectionDeligate, UIPopoverPresentationControllerDelegate {
    
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
    
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var verificationView: UIView!
    @IBOutlet weak var headView: UIView!
    @IBOutlet weak var phoneImg: UIImageView!
    @IBOutlet weak var confirmlbl: UILabel!
    @IBOutlet weak var validlbl: UILabel!
    @IBOutlet weak var verifybtn: UIButton!
    @IBOutlet weak var timerlbl: UILabel!
    @IBOutlet weak var notnowlbl: UIButton!
    @IBOutlet weak var resendbtn: UIButton!
    var phonenumber = ""
    var password = ""
    var isRegister = Bool()
    var isMRBooking = Bool()
    var fetchDetails = Bool()
    var isotpRequested = false
    var visitID = ""
    var verifyType = ""
    let apiprovider = Api_Provider()
    var timer = Timer()
    
    @IBOutlet var countDownLabel: UILabel!

    var count = 59
    
    @IBOutlet weak var otpTextField: AEOTPTextField!
    let staticCode = "112233"
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var actyind: UIActivityIndicatorView!
    
    
    var window: UIWindow?

    override func viewDidLoad() {
        super.viewDidLoad()
        resendbtn.isEnabled = false
        loadingView.isHidden = true
        actyind.isHidden = true
        CustomView()
        setupOTPTextField()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    func CustomView(){
        verificationView.layer.cornerRadius = 10.0
        let path = UIBezierPath(roundedRect:headView.bounds, byRoundingCorners:[.topRight, .topLeft], cornerRadii: CGSize(width: 10, height: 10))
        let maskLayer = CAShapeLayer()

        maskLayer.path = path.cgPath
        headView.layer.mask = maskLayer
        verifybtn.layer.cornerRadius = 5.0
        confirmlbl.text = "Confirm your identity by entering the verification code sent to mobile number : \(phonenumber)."
        confirmlbl.font = FontHelper.defaultRegularFontWithSize(size: 15)
        validlbl.text = "* OTP valid for 15 minutes"
        validlbl.font = FontHelper.defaultRegularFontWithSize(size: 11)
        timerlbl.font = FontHelper.defaultRegularFontWithSize(size: 13)
        notnowlbl.titleLabel?.font = FontHelper.defaultRegularFontWithSize(size: 13)
        resendbtn.titleLabel?.font = FontHelper.defaultRegularFontWithSize(size: 13)
        confirmlbl.textColor = UIColor(red: 118/255, green: 118/255, blue: 118/255, alpha: 1.0)
        timerlbl.textColor = UIColor(red: 154/255, green: 154/255, blue: 154/255, alpha: 1.0)
        validlbl.textColor = UIColor(red: 118/255, green: 118/255, blue: 118/255, alpha: 1.0)
        notnowlbl.setTitleColor(.blue, for: .normal)
        resendbtn.setTitle(" Resend", for: .normal)
        resendbtn.titleLabel?.textAlignment = .left
        notnowlbl.titleLabel!.attributedText = NSAttributedString(string: "Not Now", attributes:
            [.underlineStyle: NSUnderlineStyle.single.rawValue])
        resendbtn.titleLabel!.attributedText = NSAttributedString(string: "Not Now", attributes:
            [.underlineStyle: NSUnderlineStyle.single.rawValue])
        timerlbl.text = "1:00"
    
    }
    
    
    @objc func update() {
        if(count > 0) {
            if count <= 9 {
                timerlbl.text = "00:0\(count)"
            }else{
                timerlbl.text = "00:\(count)"
            }
            
            count -= 1
            
        }else{
            timerlbl.text = "00:00"
            resendbtn.isEnabled = true
            isotpRequested = true
            timer.invalidate()
        }
    }
    
    // MARK: Methods
    func setupOTPTextField() {
        otpTextField.otpDelegate = self
        otpTextField.otpFontSize = 16
        //otpTextField.otpFilledBackgroundColor = .white
        otpTextField.otpTextColor = .black
        otpTextField.otpFilledBorderWidth = 0
        otpTextField.configure(with: 4)
       // otpTextField.otpBackgroundColor = .white
    
    }
    
    
    func verifyOTP(otp: String) {
        loadingView.isHidden = false
        actyind.isHidden = false
        print("key: \(UserDefaults.standard.string(forKey: "publicKey")!)")
          
          
           do {

               let encrypted_phone =  Encryptionclass.encrypt(string: "\(UserDefaults.standard.string(forKey: "publicKey")!)", publicKey: phonenumber)
               let encrypted_otp =  Encryptionclass.encrypt(string: "\(UserDefaults.standard.string(forKey: "publicKey")!)", publicKey: otpTextField.text!)
               print("phone: \(encrypted_phone!)")
               print("otp: \(encrypted_otp!)")
               var parameters = Dictionary<String, Any>()
               parameters = ["otp_type" : "\(verifyType)", "mobile_no" : "\(encrypted_phone!)", "otp": "\(encrypted_otp!)"
               ]
        
               print(parameters)
               
               apiprovider.delegate = self
               apiprovider.fetchPostapi(api: "otp-verification", parameters: ["data": parameters], isauth: false, method: "Raw")

               } catch {
                   print("The file could not be loaded")
               }

    }
    
    func loginOTP(otp: String){
        loadingView.isHidden = false
        actyind.isHidden = false
        
     print("key: \(UserDefaults.standard.string(forKey: "publicKey")!)")
       
       
        do {

            let encrypted_phone =  Encryptionclass.encrypt(string: "\(UserDefaults.standard.string(forKey: "publicKey")!)", publicKey: phonenumber)
            let encrypted_pass =  Encryptionclass.encrypt(string: "\(UserDefaults.standard.string(forKey: "publicKey")!)", publicKey: password)
            print("user: \(encrypted_phone!)")
            print("pass: \(encrypted_pass!)")
            let deviceid = UIDevice.current.identifierForVendor?.uuidString
            var parameters = Dictionary<String, Any>()
            parameters = ["username" : "\(encrypted_phone!)", "password" : "\(encrypted_pass!)", "deviceId": "\(deviceid!)", "grant_type" : "password", "client_secret" : "\(apiprovider.clientSecret)", "client_id" : "\(apiprovider.clientID)", "fcm_id" : "", "loginOTP": otp
            ]
            print(parameters)
            apiprovider.delegate = self
            apiprovider.fetchPostapi(api: "app-login", parameters: ["data": parameters], isauth: false, method: "Raw")

            } catch {
                print("The file could not be loaded")
            }


    }
    
    func didFinishDashBoardConnection_Dictionary(_ responceData: NSMutableDictionary) {
        
        loadingView.isHidden = true
        actyind.isHidden = true
        if isotpRequested{
            isotpRequested = false
            loadingView.isHidden = true
            actyind.isHidden = true
            if responceData["status"] as! String == "success" {
                resendbtn.isEnabled = false
                count = 59
                timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
                AppToast.showToast(withmessage: "Resend Successful", withview: view, withstyle: FontHelper.defaultRegularFontWithSize(size: 15))
            }else{
                AppToast.showToast(withmessage: "\(responceData["msg"]!)", withview: view, withstyle: FontHelper.defaultRegularFontWithSize(size: 15))
            }
           
           
        }else{
            if isRegister {
            if responceData["status"] as! String == "success" {
                if verifyType == "REGISTRATION" {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fetchSignupApi"), object: nil)
                    dismissPopupView()
                    AppToast.showToast(withmessage: "Please Wait...", withview: view, withstyle: FontHelper.defaultRegularFontWithSize(size: 15))
                }else{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "gotOResetView"), object: nil)
                    dismissPopupView()
                }
            }
            }else{
                if (isMRBooking){
                    if fetchDetails {
                        if responceData["status"] as! String == "success" {
                            var ContentArray = [[String:Any]]()
                            ContentArray = responceData["data"] as! [[String : Any]]
                            let userInfo = [ "ContentArray" : ContentArray] as [String : Any]
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "gotoFormPage"), object: userInfo)
                            dismissPopupView()
                            
                        }
                    }else{
                        if responceData["status"] as! String == "success" {
                            fetchDetails = true
                            patientsDetails(phoneNumber: phonenumber)
                        }
                    }
                    
                }else{
                if responceData["status"] as! String == "success" {
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
                    AppToast.showToast(withmessage: "Login Successfull", withview: view, withstyle: FontHelper.defaultRegularFontWithSize(size: 15))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
                        goToHome()
                    }
                }
                else if responceData["status"] as! String == "info" {
                    let toskeyExists = responceData["tosData"] != nil
                    if (toskeyExists){
                        dismissPopupView()
                        AppToast.showToast(withmessage: "Please accept the Terms of Service.", withview: view, withstyle: FontHelper.defaultRegularFontWithSize(size: 15))
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [self] in
                            showTermsView()
                        }
                    }
                }
                }
            }
        }
        
    }
    
    func retrieveMRDetails(otp: String){
        loadingView.isHidden = false
        actyind.isHidden = false
        print("key: \(UserDefaults.standard.string(forKey: "publicKey")!)")
        print("phonenumber: \(phonenumber)")
        print("otp: \(otpTextField.text!)")
          
           do {

               let encrypted_phone =  Encryptionclass.encrypt(string: "\(UserDefaults.standard.string(forKey: "publicKey")!)", publicKey: phonenumber)
               let encrypted_otp =  Encryptionclass.encrypt(string: "\(UserDefaults.standard.string(forKey: "publicKey")!)", publicKey: otpTextField.text!)
               print("phone: \(encrypted_phone!)")
               print("otp: \(encrypted_otp!)")
               var parameters = Dictionary<String, Any>()
               parameters = ["visit_id" : "\(visitID)", "mobile_number" : "\(encrypted_phone!)", "otp": "\(encrypted_otp!)"
               ]
        
               print(parameters)
               
               apiprovider.delegate = self
               apiprovider.fetchPostapi(api: "verify-booking-otp", parameters: ["data": parameters], isauth: true, method: "Raw")

               } catch {
                   print("The file could not be loaded")
               }

    }
    
    func patientsDetails(phoneNumber: String) {
        
        do {

            let encrypted_phone =  Encryptionclass.encrypt(string: "\(UserDefaults.standard.string(forKey: "publicKey")!)", publicKey: phonenumber)
            
            print("user: \(encrypted_phone!)")
          
            var parameters = Dictionary<String, Any>()
            parameters = ["mobile_number" : "\(encrypted_phone!)"]
            
            apiprovider.delegate = self
            apiprovider.fetchPostapi(api: "patient-details-list", parameters: ["data": parameters], isauth: true, method: "Raw")
            } catch {
                print("The file could not be loaded")
            }
       

    }
    
    

    
    
    
    func requestOTP(phone: String){
        isotpRequested = true
        loadingView.isHidden = false
        actyind.isHidden = false
        print("key: \(UserDefaults.standard.string(forKey: "publicKey")!)")
        print("phone: \(phone)")
          
          
           do {

               let encrypted_phone =  Encryptionclass.encrypt(string: "\(UserDefaults.standard.string(forKey: "publicKey")!)", publicKey: phone)
               print("phone: \(encrypted_phone!)")
               var parameters = Dictionary<String, Any>()
               parameters = ["type" : "FORGOT_PASSWORD", "mobile_no" : "\(encrypted_phone!)"
               ]
        
               print(parameters)
               
               apiprovider.delegate = self
               apiprovider.fetchPostapi(api: "request-otp", parameters: ["data": parameters], isauth: false, method: "Raw")

               } catch {
                   print("The file could not be loaded")
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
    
    
    func showTermsView(){
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let popupVC = storyboard.instantiateViewController(withIdentifier: "TermsVC") as! TermsNPolicyPopup
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
               let pVC = popupVC.popoverPresentationController
        pVC?.permittedArrowDirections = .any
        pVC?.delegate = self
        pVC?.sourceView = view
        present(popupVC, animated: true, completion: nil)
    }
    
    
    func displayAlert(with title: String, message: String, actions: [UIAlertAction]? = nil) {
        guard presentedViewController == nil else { return }
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions?.forEach { action in
            alertController.addAction(action)
        }
        present(alertController, animated: true)
    }

    @IBAction func verifyEvnt(_ sender: Any) {
        print("otp: \(otpTextField.text!)")
        if isRegister{
            verifyOTP(otp: otpTextField.text!)
        }else{
            loginOTP(otp: otpTextField.text!)
        }
       
    }
    
    @IBAction func notnowEvnt(_ sender: Any) {
        dismissPopupView()
    }
    
    
    func dismissPopupView(){
        dismiss(animated: true, completion: nil)
            popoverPresentationController?.delegate?.popoverPresentationControllerDidDismissPopover?(popoverPresentationController!)
    }
    
    
    @IBAction func resendEvnt(_ sender: Any) {
        requestOTP(phone: phonenumber)
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


// MARK: - AEOTPTextField Delegate
extension VerificationView: AEOTPTextFieldDelegate {
    func didUserFinishEnter(the code: String) {
        print("otp: \(code)")
        if isRegister{
            verifyOTP(otp: code)
        }else{
            if isMRBooking {
                retrieveMRDetails(otp: code)
            }else{
                loginOTP(otp: code)
            }
            
        }
        otpTextField.resignFirstResponder()
    }
}

