//
//  TermsNPolicyPopup.swift
//  SHMISCustomer
//
//  Created by admin on 16/03/22.
//

import UIKit
import Reachability
class TermsNPolicyPopup: UIViewController, DashBoardConnectionDeligate, UIPopoverPresentationControllerDelegate {
    
    func didFinishDashBoardConnection_Logout(_ responceData: NSMutableArray) {
       
    }
    
    
    func didFinishDashBoardConnection_Array(_ responceData: NSMutableArray) {
        
    }
    
   
    @IBOutlet weak var bgview: UIView!
    
    @IBOutlet weak var termsView: UIView!
    @IBOutlet weak var headview: UIView!
    @IBOutlet weak var agreementlbl: UILabel!
    @IBOutlet weak var checkbtn: UIButton!
    @IBOutlet weak var termslbl: UILabel!
    @IBOutlet weak var readlbl: UILabel!
    @IBOutlet weak var submitbtn: UIButton!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var actyind: UIActivityIndicatorView!
    
    let apiprovider = Api_Provider()
    let reachability = try! Reachability()
    var isTOCenabled: Bool = false
    
    var phonenumber = ""
    var password = ""
    
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
        CustomView()
        checkbtn.setImage(UIImage(named:"Checkmarkempty"), for: .normal)
        checkbtn.setImage(UIImage(named:"Checkmark"), for: .selected)
    
    }
    
    
    func CustomView(){
        termsView.layer.cornerRadius = 10.0
        let path = UIBezierPath(roundedRect:headview.bounds, byRoundingCorners:[.topRight, .topLeft], cornerRadii: CGSize(width: 10, height: 10))
        let maskLayer = CAShapeLayer()

        maskLayer.path = path.cgPath
        headview.layer.mask = maskLayer
        submitbtn.layer.cornerRadius = 5.0
        submitbtn.setTitle("Submit", for: .normal)
    
    }
    
    
    @objc func Login()  {
        
        loadingView.isHidden = false
        actyind.isHidden = false
        
     print("key: \(UserDefaults.standard.string(forKey: "publicKey")!)")
       
       
        do {
            print("phonenumber: \(phonenumber)")
            print("password: \(password)")
            let encrypted_user =  Encryptionclass.encrypt(string: "\(UserDefaults.standard.string(forKey: "publicKey")!)", publicKey: phonenumber)
            let encrypted_pass =  Encryptionclass.encrypt(string: "\(UserDefaults.standard.string(forKey: "publicKey")!)", publicKey: password)
            print("user: \(encrypted_user!)")
            print("pass: \(encrypted_pass!)")
            let deviceid = UIDevice.current.identifierForVendor?.uuidString
            let deviceType = UIDevice.modelName
            var parameters_data = Dictionary<String, Any>()
            var parameters_patient = Dictionary<String, Any>()
            parameters_patient = ["username" : "\(encrypted_user!)", "password" : "\(encrypted_pass!)", "deviceId": "\(deviceid!)", "grant_type" : "password", "client_secret" : "\(apiprovider.clientSecret)", "client_id" : "\(apiprovider.clientID)", "fcm_id" : ""
            ]
            parameters_data = ["tosAccepted": isTOCenabled, "deviceDetails": "VERSION : \(appVersion) || DEVICE : \(deviceType) || DEVICE OS : iOS", "deviceId": "\(deviceid!)"]
            print(parameters_patient)
            print(parameters_data)
            apiprovider.delegate = self
            apiprovider.fetchPostapi(api: "app-login", parameters: ["patient": parameters_patient, "data": parameters_data], isauth: false, method: "Raw")

            } catch {
                print("The file could not be loaded")
            }



    }
    
    
    
    func didFinishDashBoardConnection_Dictionary(_ responceData: NSMutableDictionary) {
        loadingView.isHidden = true
        actyind.isHidden = true
        if responceData["status"] as! String == "info" {
            let loginkeyExists = responceData["loginOTPSend"] != nil
            
            if (loginkeyExists){
                dismissPopupView()
                AppToast.showToast(withmessage: "OTP sent to your registered mobile number", withview: view, withstyle: FontHelper.defaultRegularFontWithSize(size: 15))
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [self] in
                    showOTPVerification(number: phonenumber, password: password)
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
            if let akey = responceData["data"]{
                data = akey as! [String : Any]
                user_details = data["profileData"] as! [String : Any]
                token_details = data["accessData"] as! [String : Any]
                fname = user_details["first_name"] as! String
                lname = user_details["last_name"] as! String
                userID = user_details["user_id"] as! String
                accesstoken = token_details["access_token"] as! String
                refreshtoken = token_details["refresh_token"] as! String
            }
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
    
    
    
    func displayAlert(with title: String, message: String, actions: [UIAlertAction]? = nil) {
        guard presentedViewController == nil else { return }
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions?.forEach { action in
            alertController.addAction(action)
        }
        present(alertController, animated: true)
    }
    
    
    
    
    
    @IBAction func checkbox_Evnt(_ sender: UIButton) {
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
    
    func dismissPopupView(){
        dismiss(animated: true, completion: nil)
            popoverPresentationController?.delegate?.popoverPresentationControllerDidDismissPopover?(popoverPresentationController!)
    }
    
    
    
    @IBAction func submitEvnt(_ sender: Any) {
        if reachability.connection != .unavailable {
            if isTOCenabled{
               
               Login()
               
            }else{
                AppToast.showToast(withmessage: "Please Accept the Terms of Service", withview: view, withstyle: FontHelper.defaultRegularFontWithSize(size: 15))
            }
           
        }else{
            AppToast.showToast(withmessage: "Network Not Available", withview: view, withstyle: FontHelper.defaultRegularFontWithSize(size: 15))
        }
    }
    
    
    @IBAction func bkEvnt(_ sender: Any) {
        dismissPopupView()
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
