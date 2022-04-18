//
//  Signup.swift
//  SHMISCustomer
//
//  Created by admin on 11/03/22.
//

import UIKit
import Reachability
class Signup: UIViewController, UITextFieldDelegate, DashBoardConnectionDeligate, UIPopoverPresentationControllerDelegate {
    
    func didFinishDashBoardConnection_Logout(_ responceData: NSMutableArray) {
       
    }
    
    func didFinishDashBoardConnection_Array(_ responceData: NSMutableArray) {
        
    }
    
    
    @IBOutlet weak var btnCheckBox:UIButton!
    
    @IBOutlet weak var scrolView: UIScrollView!
    @IBOutlet weak var signupView: UIView!
    
    @IBOutlet weak var fname: UITextField!
    @IBOutlet weak var lname: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phone: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var confirmPassword: UITextField!
    
    @IBOutlet weak var readlbl: UILabel!
    @IBOutlet weak var bgview: UIView!
    
    @IBOutlet weak var tNclbl: UILabel!
    @IBOutlet weak var signupbtn: UIButton!
    var window: UIWindow?
    let reachability = try! Reachability()
    var passwordVisible = false
    var ConfirmpasswordVisible = false
    let apiprovider = Api_Provider()
    var isTOCenabled: Bool = false
    var isotpRequested = false

    @IBOutlet weak var actyind: UIActivityIndicatorView!
    @IBOutlet weak var loadingView: UIView!
    
    
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
        fname.delegate = self
        lname.delegate = self
        email.delegate = self
        phone.delegate = self
        password.delegate = self
        confirmPassword.delegate = self
        password.isSecureTextEntry = true
        confirmPassword.isSecureTextEntry = true
        btnCheckBox.setImage(UIImage(named:"Checkmarkempty"), for: .normal)
        btnCheckBox.setImage(UIImage(named:"Checkmark"), for: .selected)
        CustomView()
    }
    
    func CustomView()  {
        bgview.layer.insertSublayer(AppColors.gradientBg(view: view, colorArray: [UIColor(red: 253/255, green: 244/255, blue: 212/255, alpha: 1.0).cgColor, UIColor.white.cgColor, UIColor(red: 253/255, green: 244/255, blue: 212/255, alpha: 1.0).cgColor], locationArray: [0.0, 0.5,1.0], isVertical: true, startpoint: CGPoint(x: 0.0, y: 1.0), endpoint: CGPoint(x: 1.0, y: 1.0), cornerradius: 0.0), at: 0)
        signupView.layer.cornerRadius = 10.0
        signupbtn.layer.cornerRadius = 10.0
        
        let myColor = UIColor.lightGray
        lname.layer.borderColor = myColor.cgColor
        fname.layer.borderColor = myColor.cgColor
        email.layer.borderColor = myColor.cgColor
        phone.layer.borderColor = myColor.cgColor
        password.layer.borderColor = myColor.cgColor
        confirmPassword.layer.borderColor = myColor.cgColor

        lname.layer.borderWidth = 1.0
        fname.layer.borderWidth = 1.0
        email.layer.borderWidth = 1.0
        phone.layer.borderWidth = 1.0
        password.layer.borderWidth = 1.0
        confirmPassword.layer.borderWidth = 1.0
        
        lname.layer.cornerRadius = 5.0
        fname.layer.cornerRadius = 5.0
        email.layer.cornerRadius = 5.0
        phone.layer.cornerRadius = 5.0
        password.layer.cornerRadius = 5.0
        confirmPassword.layer.cornerRadius = 5.0
        
        lname.setLeftPaddingPoints(10)
        lname.setRightPaddingPoints(10)
        
        fname.setLeftPaddingPoints(10)
        fname.setRightPaddingPoints(10)
        
        email.setLeftPaddingPoints(10)
        email.setRightPaddingPoints(10)
        
        phone.setLeftPaddingPoints(10)
        phone.setRightPaddingPoints(10)
        
        password.setLeftPaddingPoints(10)
        password.setRightPaddingPoints(10)
        
        confirmPassword.setLeftPaddingPoints(10)
        confirmPassword.setRightPaddingPoints(10)
        
        let button_pass = UIButton(type: .custom)
        button_pass.setImage(UIImage(named: "visibility.png"), for: .normal)
        button_pass.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button_pass.frame = CGRect(x: CGFloat(password.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button_pass.addTarget(self, action: #selector(self.viewPass), for: .touchUpInside)
        password.rightView = button_pass
        password.rightViewMode = .always
        
        
        let button_Cpass = UIButton(type: .custom)
        button_Cpass.setImage(UIImage(named: "visibility.png"), for: .normal)
        button_Cpass.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button_Cpass.frame = CGRect(x: CGFloat(confirmPassword.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button_Cpass.addTarget(self, action: #selector(self.viewConfirmPass), for: .touchUpInside)
        confirmPassword.rightView = button_Cpass
        confirmPassword.rightViewMode = .always
    
        let font = FontHelper.defaultRegularFontWithSize(size: 14)
        
            fname.attributedPlaceholder = NSAttributedString(
                string: "First Name*",
                attributes: [
                    NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                    NSAttributedString.Key.font: font
                ])
        
            lname.attributedPlaceholder = NSAttributedString(
                string: "Last Name*",
                attributes: [
                    NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                    NSAttributedString.Key.font: font
                ])
        email.attributedPlaceholder = NSAttributedString(
            string: "Email*",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                NSAttributedString.Key.font: font
            ])
        phone.attributedPlaceholder = NSAttributedString(
            string: "Mobile Number*",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                NSAttributedString.Key.font: font
            ])
        password.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                NSAttributedString.Key.font: font
            ])
        confirmPassword.attributedPlaceholder = NSAttributedString(
            string: "Confirm Password",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                NSAttributedString.Key.font: font
            ])
        
        tNclbl.attributedText = NSAttributedString(string: "Terms of Service & Privacy Policy", attributes:
            [.underlineStyle: NSUnderlineStyle.single.rawValue])
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        if (textField == fname){
            lname.becomeFirstResponder()
        }else if (textField == lname){
            email.becomeFirstResponder()
        }else if (textField == email){
            phone.becomeFirstResponder()
        }else if (textField == phone){
            textField.resignFirstResponder()
        }else if (textField == password){
            confirmPassword.becomeFirstResponder()
        }else if (textField == confirmPassword){
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
    
    
    @IBAction func viewPass(_ sender: Any) {
        if passwordVisible {
            password.isSecureTextEntry = true
            passwordVisible = false
            let button = UIButton(type: .custom)
            button.setImage(UIImage(named: "visibility.png"), for: .normal)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
            button.frame = CGRect(x: CGFloat(password.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
            button.addTarget(self, action: #selector(self.viewPass), for: .touchUpInside)
            password.rightView = button
            password.rightViewMode = .always
        }else{
            password.isSecureTextEntry = false
            passwordVisible = true
            let button = UIButton(type: .custom)
            button.setImage(UIImage(named: "visibilityoff.png"), for: .normal)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
            button.frame = CGRect(x: CGFloat(password.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
            button.addTarget(self, action: #selector(self.viewPass), for: .touchUpInside)
            password.rightView = button
            password.rightViewMode = .always
        }
    }
    
    @IBAction func viewConfirmPass(_ sender: Any) {
        if ConfirmpasswordVisible {
            confirmPassword.isSecureTextEntry = true
            ConfirmpasswordVisible = false
            let button = UIButton(type: .custom)
            button.setImage(UIImage(named: "visibility.png"), for: .normal)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
            button.frame = CGRect(x: CGFloat(confirmPassword.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
            button.addTarget(self, action: #selector(self.viewConfirmPass), for: .touchUpInside)
            confirmPassword.rightView = button
            confirmPassword.rightViewMode = .always
        }else{
            confirmPassword.isSecureTextEntry = false
            ConfirmpasswordVisible = true
            let button = UIButton(type: .custom)
            button.setImage(UIImage(named: "visibilityoff.png"), for: .normal)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
            button.frame = CGRect(x: CGFloat(confirmPassword.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
            button.addTarget(self, action: #selector(self.viewConfirmPass), for: .touchUpInside)
            confirmPassword.rightView = button
            confirmPassword.rightViewMode = .always
        }
    }
    
    //MARK:- checkMarkTapped
       @IBAction func checkMarkTapped(_ sender: UIButton) {
           UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
                       sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                       
                   }) { (success) in
                       UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: { [self] in
                           sender.isSelected = !sender.isSelected
                           isTOCenabled = !isTOCenabled
                           sender.transform = .identity
                       }, completion: nil)
                   }
       }
    
    
    @IBAction func signupEvnt(_ sender: Any) {
        
        if reachability.connection != .unavailable {
            if fname.text != "" && lname.text != "" && email.text != "" && phone.text != "" && password.text != "" && confirmPassword.text != ""{
                if password.text == confirmPassword.text {
                    if isTOCenabled {
                        Signup()
                    }else{
                        AppToast.showToast(withmessage: "Please Accept the Agreement", withview: view, withstyle: FontHelper.defaultRegularFontWithSize(size: 15))
                    }
                }else{
                    AppToast.showToast(withmessage: "Password Mismatch", withview: view, withstyle: FontHelper.defaultRegularFontWithSize(size: 15))
                }
               
            }else{
                AppToast.showToast(withmessage: "Fill all fields", withview: view, withstyle: FontHelper.defaultRegularFontWithSize(size: 15))
            }
           
        }else{
            AppToast.showToast(withmessage: "Network Not Available", withview: view, withstyle: FontHelper.defaultRegularFontWithSize(size: 15))
        }
        
//        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let popupVC = storyboard.instantiateViewController(withIdentifier: "VerifyVC") as! VerificationView
//        popupVC.phonenumber = "1234567890"
//        popupVC.modalPresentationStyle = .overCurrentContext
//        popupVC.modalTransitionStyle = .crossDissolve
//               let pVC = popupVC.popoverPresentationController
//        pVC?.permittedArrowDirections = .any
//        pVC?.delegate = self
//        pVC?.sourceView = (sender as! UIView)
//        present(popupVC, animated: true, completion: nil)
    }
    
    
    @objc func Signup()  {
        
        loadingView.isHidden = false
        actyind.isHidden = false
        
     print("key: \(UserDefaults.standard.string(forKey: "publicKey")!)")
        print("phone: \(phone.text!)")
        print("pass: \(password.text!)")
       
        do {

            let encrypted_phone =  Encryptionclass.encrypt(string: "\(UserDefaults.standard.string(forKey: "publicKey")!)", publicKey: phone.text!)
            let encrypted_pass =  Encryptionclass.encrypt(string: "\(UserDefaults.standard.string(forKey: "publicKey")!)", publicKey: password.text!)
            print("phone: \(encrypted_phone!)")
            print("pass: \(encrypted_pass!)")
            let deviceid = UIDevice.current.identifierForVendor?.uuidString
            let deviceType = UIDevice.modelName
            var parameters_patient = Dictionary<String, Any>()
            parameters_patient = ["firstName" : "\(fname.text!)", "lastName" : "\(lname.text!)", "email": "\(email.text!)", "mobileNo" : "\(encrypted_phone!)", "password" : "\(encrypted_pass!)",
            ]
            var parameters_data = Dictionary<String, Any>()
            parameters_data = ["tosAccepted": isTOCenabled, "deviceDetails": "VERSION : \(appVersion) || DEVICE : \(deviceType) || DEVICE OS : iOS", "deviceId": "\(deviceid!)"]
            print(parameters_patient)
            print(parameters_data)
            apiprovider.delegate = self
            apiprovider.fetchPostapi(api: "registration", parameters: ["patient": parameters_patient, "data": parameters_data], isauth: false, method: "Raw")

            } catch {
                print("The file could not be loaded")
            }



    }
    
    
    func didFinishDashBoardConnection_Dictionary(_ responceData: NSMutableDictionary) {
        loadingView.isHidden = true
        actyind.isHidden = true
        if responceData["status"] as! String == "success" {
            if (isotpRequested){
                loadingView.isHidden = true
                actyind.isHidden = true
                AppToast.showToast(withmessage: "OTP send to the registered number.", withview: view, withstyle: FontHelper.defaultRegularFontWithSize(size: 15))
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [self] in
                    showVerificationPage(phone: phone.text!)
                }
            }else{
                requestOTP()
            }
            
            }else  if responceData["status"] as! String == "invalid" {
               
                AppToast.showToast(withmessage: "Invalid data entered", withview: view, withstyle: FontHelper.defaultRegularFontWithSize(size: 15))
            }else{
                AppToast.showToast(withmessage: "\(responceData["msg"]!)", withview: view, withstyle: FontHelper.defaultRegularFontWithSize(size: 15))
            }
    }
    
    
    func showVerificationPage(phone: String){
        let popupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VerifyVC") as! VerificationView
        popupVC.phonenumber = phone
        popupVC.isRegister = true
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        let pVC = popupVC.popoverPresentationController
        pVC?.permittedArrowDirections = .any
        pVC?.delegate = self
        pVC?.sourceView = view
        present(popupVC, animated: true, completion: nil)
    }
    
    func requestOTP(){
        isotpRequested = true
        print("key: \(UserDefaults.standard.string(forKey: "publicKey")!)")
          
          
           do {
               print("\(phone.text!)")
               let encrypted_phone =  Encryptionclass.encrypt(string: "\(UserDefaults.standard.string(forKey: "publicKey")!)", publicKey: phone.text!)
               print("phone: \(encrypted_phone!)")
               var parameters = Dictionary<String, Any>()
               parameters = ["type" : "REGISTRATION", "mobile_no" : "\(encrypted_phone!)"
               ]
        
               print(parameters)
               
               apiprovider.delegate = self
               apiprovider.fetchPostapi(api: "request-otp", parameters: ["data": parameters], isauth: false, method: "Raw")

               } catch {
                   print("The file could not be loaded")
               }

    }
    
    
    
    @IBAction func bkEvnt(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
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


class UnderlinedLabel: UILabel {

override var text: String? {
    didSet {
        guard let text = text else { return }
        let textRange = NSRange(location: 0, length: text.count)
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttribute(.underlineStyle,
                                    value: NSUnderlineStyle.single.rawValue,
                                    range: textRange)
        // Add other attributes if needed
        self.attributedText = attributedText
        }
    }
}
