//
//  ForgotMRView.swift
//  SHMISCustomer
//
//  Created by admin on 13/04/22.
//

import UIKit
import Reachability
class ForgotMRView: UIViewController, UITextFieldDelegate, DashBoardConnectionDeligate, UIPopoverPresentationControllerDelegate {
   
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
    @IBOutlet weak var tokenView: UIView!
    @IBOutlet weak var tokenlbl: UILabel!
    @IBOutlet weak var mobiletxt: UITextField!
    @IBOutlet weak var requestbtn: UIButton!
    let apiprovider = Api_Provider()
    let reachability = try! Reachability()
    var token = ""
    var visitID = ""
    var isRequestedOTP = false
    var window: UIWindow?
    var Content = [String:Any]()
    var timimgArray = [[String:Any]]()
    var timeIndex = Int()
    
    @IBOutlet weak var loadingview: UIView!
    @IBOutlet weak var actyind: UIActivityIndicatorView!
    
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
        mobiletxt.delegate = self
       CustomView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.goToFormPage(_:)), name: NSNotification.Name(rawValue: "gotoFormPage"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.timeselect(_:)), name: NSNotification.Name(rawValue: "timeselect"), object: nil)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTaplabel(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tokenView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    @objc func timeselect(_ notification: NSNotification) {
        let dict = notification.object as! NSDictionary

        if let total = dict["time"]{
            timeIndex = total as! Int
            tokenlbl.text = "TK\(timimgArray[timeIndex]["token"]!) - \(timimgArray[timeIndex]["time_from"]!) - \(timimgArray[timeIndex]["time_to"]!)"
            }
     }
    
    
    @objc func goToFormPage(_ notification: NSNotification) {
        let dict = notification.object as! NSDictionary
        print("token: \(tokenlbl.text!)")
        print("visitID: \(visitID)")
        print("Content: \(Content)")
        print("timimgArray: \(timimgArray)")
        if let pageContent = dict["ContentArray"]{
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ForgotBookVC") as? ForgotMrBookingView {
                viewController.PatientsArray = pageContent as! [[String : Any]]
                viewController.token = tokenlbl.text!
                viewController.visitID = visitID
                viewController.Content = Content
                viewController.timimgArray = timimgArray
                       if let navigator = navigationController {
                           navigator.fadeTo(viewController)
                       }
                   }
        }
       
    }
    
    
    @IBAction func didTaplabel(_ sender: UITapGestureRecognizer) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let popupVC = storyboard.instantiateViewController(withIdentifier: "TimingsVC") as! SlotPopupView
        popupVC.timimgArray = timimgArray
        popupVC.Content = Content
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
               let pVC = popupVC.popoverPresentationController
        pVC?.permittedArrowDirections = .any
        pVC?.delegate = self
        pVC?.sourceView = view
        present(popupVC, animated: true, completion: nil)
        
    }
    
    
    func CustomView()  {
        
        let myColor = UIColor.lightGray
           mobiletxt.layer.borderColor = myColor.cgColor

        mobiletxt.layer.borderWidth = 1.0
        
        mobiletxt.layer.cornerRadius = 5.0
        
        mobiletxt.setLeftPaddingPoints(10)
        mobiletxt.setRightPaddingPoints(10)
        
        let font = FontHelper.defaultRegularFontWithSize(size: 14)
        
        mobiletxt.attributedPlaceholder = NSAttributedString(
                string: "  Mobile Number",
                attributes: [
                    NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                    NSAttributedString.Key.font: font
                ])
        
        requestbtn.layer.cornerRadius = 10
        requestbtn.setTitle("REQUEST OTP", for: .normal)
        requestbtn.titleLabel?.font = FontHelper.defaultRegularFontWithSize(size: 12)
        
        if token == ""{
            tokenlbl.text = "Select Time Slot"
        }else{
            tokenlbl.text = token
        }
        
        tokenlbl.font = FontHelper.defaultRegularFontWithSize(size: 15)
        
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
    
    
    func request(){
        isRequestedOTP = true
        print("key: \(UserDefaults.standard.string(forKey: "publicKey")!)")
          
          
           do {
               print("\(mobiletxt.text!)")
               let encrypted_phone =  Encryptionclass.encrypt(string: "\(UserDefaults.standard.string(forKey: "publicKey")!)", publicKey: mobiletxt.text!)
               print("phone: \(encrypted_phone!)")
               var parameters = Dictionary<String, Any>()
               parameters = ["mobile_number" : "\(encrypted_phone!)", "visit_id" :visitID
               ]
        
               print(parameters)
               
               apiprovider.delegate = self
               apiprovider.fetchPostapi(api: "booking-otp", parameters: ["data": parameters], isauth: false, method: "Raw")

               } catch {
                   print("The file could not be loaded")
               }
    }
    
    
    func didFinishDashBoardConnection_Dictionary(_ responceData: NSMutableDictionary) {
        loadingview.isHidden = true
        actyind.isHidden = true
        if responceData["status"] as! String == "success" {
            if (isRequestedOTP){
                AppToast.showToast(withmessage: "OTP send to the registered number.", withview: view, withstyle: FontHelper.defaultRegularFontWithSize(size: 15))
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [self] in
                    showVerificationPage(phone: mobiletxt.text!)
                }
            }else{
                
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
        popupVC.isRegister = false
        popupVC.isMRBooking = true
        popupVC.visitID = visitID
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        let pVC = popupVC.popoverPresentationController
        pVC?.permittedArrowDirections = .any
        pVC?.delegate = self
        pVC?.sourceView = view
        present(popupVC, animated: true, completion: nil)
    }
    
    @IBAction func bkEvnt(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func requestbtn_Evnt(_ sender: Any) {
        if reachability.connection != .unavailable {
            if mobiletxt.text != "" {
                loadingview.isHidden = false
                actyind.isHidden = false
                request()
               
            }else{
                AppToast.showToast(withmessage: "Enter Mobile Number", withview: view, withstyle: FontHelper.defaultRegularFontWithSize(size: 15))
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


extension UINavigationController {
    func fadeTo(_ viewController: UIViewController) {
        let transition: CATransition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.fade
        view.layer.add(transition, forKey: nil)
        pushViewController(viewController, animated: false)
    }
}
