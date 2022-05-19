//
//  ForgotPassword.swift
//  SHMISCustomer
//
//  Created by admin on 21/04/22.
//

import UIKit
import Reachability
class ForgotPassword: UIViewController, UITextFieldDelegate, DashBoardConnectionDeligate, UIPopoverPresentationControllerDelegate {
   
    @IBOutlet weak var bgView: UIView!
    
    
    
    func didFinishDashBoardConnection_Logout(_ responceData: NSMutableArray) {
       
    }
    
    func didFinishDashBoardConnection_Array(_ responceData: NSMutableArray) {
        
    }
    
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var mainview: UIView!
    @IBOutlet weak var submitbtn: UIButton!
    @IBOutlet weak var phonetxt: UITextField!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var actyind: UIActivityIndicatorView!
    let apiprovider = Api_Provider()
    let reachability = try! Reachability()
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
        loadingView.isHidden = true
        actyind.isHidden = true
        phonetxt.delegate = self
        CustomView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.gotOResetView(_:)), name: NSNotification.Name(rawValue: "gotOResetView"), object: nil)
    }
    
    
    @objc func gotOResetView(_ notification: NSNotification) {
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ResetPassVC") as? ResetPassword {
                       if let navigator = navigationController {
                           viewController.phoneNumber = phonetxt.text!
                           navigator.fadeTo(viewController)
                       }
                   }
    }
    
    func CustomView()  {
        bgView.layer.insertSublayer(AppColors.gradientBg(view: view, colorArray: [UIColor(red: 253/255, green: 244/255, blue: 212/255, alpha: 1.0).cgColor, UIColor.white.cgColor, UIColor(red: 253/255, green: 244/255, blue: 212/255, alpha: 1.0).cgColor], locationArray: [0.0, 0.5,1.0], isVertical: true, startpoint: CGPoint(x: 0.0, y: 1.0), endpoint: CGPoint(x: 1.0, y: 1.0), cornerradius:0.0), at: 0)
        mainview.layer.cornerRadius = 10.0
        submitbtn.layer.cornerRadius = 10.0
        
        let myColor = UIColor.lightGray
           phonetxt.layer.borderColor = myColor.cgColor

        phonetxt.layer.borderWidth = 1.0
        
        phonetxt.layer.cornerRadius = 5.0
        
        phonetxt.setLeftPaddingPoints(10)
        phonetxt.setRightPaddingPoints(10)
        
    
        let font = FontHelper.defaultRegularFontWithSize(size: 14)
        
        phonetxt.attributedPlaceholder = NSAttributedString(
                string: "  Mobile Number",
                attributes: [
                    NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                    NSAttributedString.Key.font: font
                ])
        
        
      
        
        
    }
    
    
    
    
    
    
    func didFinishDashBoardConnection_Dictionary(_ responceData: NSMutableDictionary) {
        loadingView.isHidden = true
        actyind.isHidden = true
        if responceData["status"] as! String == "success" {
                AppToast.showToast(withmessage: "OTP send to the registered number.", withview: view, withstyle: FontHelper.defaultRegularFontWithSize(size: 15))
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [self] in
                    showVerificationPage(phone: phonetxt.text!)
                }
           
        }
    }
    
    func showVerificationPage(phone: String){
        let popupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VerifyVC") as! VerificationView
        popupVC.phonenumber = phone
        popupVC.isRegister = true
        popupVC.verifyType = "FORGOT_PASSWORD"
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        let pVC = popupVC.popoverPresentationController
        pVC?.permittedArrowDirections = .any
        pVC?.delegate = self
        pVC?.sourceView = view
        present(popupVC, animated: true, completion: nil)
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
            if phonetxt.text != "" {
                
                if phonetxt.text?.count == 10 {
                    VerifyNumber()
                }else{
                    AppToast.showToast(withmessage: "Invalid Mobile Number", withview: view, withstyle: FontHelper.defaultRegularFontWithSize(size: 15))
                }
               
               
               
            }else{
                AppToast.showToast(withmessage: "Fill all fields", withview: view, withstyle: FontHelper.defaultRegularFontWithSize(size: 15))
            }
           
        }else{
            AppToast.showToast(withmessage: "Network Not Available", withview: view, withstyle: FontHelper.defaultRegularFontWithSize(size: 15))
        }
    }
    
    
    func VerifyNumber(){
        print("key: \(UserDefaults.standard.string(forKey: "publicKey")!)")
          
          
           do {
               print("\(phonetxt.text!)")
               let encrypted_phone =  Encryptionclass.encrypt(string: "\(UserDefaults.standard.string(forKey: "publicKey")!)", publicKey: phonetxt.text!)
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
