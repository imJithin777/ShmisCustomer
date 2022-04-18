//
//  ForgotMrBookingView.swift
//  SHMISCustomer
//
//  Created by admin on 13/04/22.
//

import UIKit
import Reachability
class ForgotMrBookingView: UIViewController,  UITextFieldDelegate, DashBoardConnectionDeligate, UIPopoverPresentationControllerDelegate {
    
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
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var tokenView: UIView!
    @IBOutlet weak var tokenlbl: UILabel!
    @IBOutlet weak var mobiletxt: UITextField!
    @IBOutlet weak var nametxt: UITextField!
    @IBOutlet weak var mrNotxt: UITextField!
    @IBOutlet weak var emailtxt: UITextField!
    @IBOutlet weak var addresstxt: UITextField!
    
    @IBOutlet weak var requestbtn: UIButton!
    let apiprovider = Api_Provider()
    let reachability = try! Reachability()
    var token = ""
    var visitID = ""
    var window: UIWindow?
    var PatientsArray = [[String:Any]]()
    var timimgArray = [[String:Any]]()
    var Content = [String:Any]()
    var timeIndex = Int()
    var age = ""
    
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
        
        if PatientsArray.count > 0{
            showMRList(listarray: PatientsArray)
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
        mobiletxt.isUserInteractionEnabled = false
        nametxt.delegate = self
        mrNotxt.delegate = self
        emailtxt.delegate = self
        addresstxt.delegate = self
        CustomView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.patientSelect(_:)), name: NSNotification.Name(rawValue: "select"), object: nil)
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
    
    @objc func patientSelect(_ notification: NSNotification) {
        
        let dict = notification.object as! NSDictionary
       

        if let total = dict["patient"]{
            print(total)
            var contentdata = [String:Any]()
            contentdata = total as! [String : Any]
            if let mobile = contentdata["mobile_number"] {
                mobiletxt.text = "\(mobile)"
            }
            if let name = contentdata["patient_name"] {
                nametxt.text = "\(name)"
            }
            if let opno = contentdata["op_number"] {
                mrNotxt.text = "\(opno)"
            }
            if let email = contentdata["email"] {
                emailtxt.text = "\(email)"
            }
            if let address = contentdata["address"] {
                addresstxt.text = "\(address)"
            }
            if let Age = contentdata["age"] {
                age = "\(Age)"
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
        nametxt.layer.borderColor = myColor.cgColor
        mrNotxt.layer.borderColor = myColor.cgColor
        emailtxt.layer.borderColor = myColor.cgColor
        addresstxt.layer.borderColor = myColor.cgColor

        mobiletxt.layer.borderWidth = 1.0
        nametxt.layer.borderWidth = 1.0
        mrNotxt.layer.borderWidth = 1.0
        emailtxt.layer.borderWidth = 1.0
        addresstxt.layer.borderWidth = 1.0
        
        mobiletxt.layer.cornerRadius = 5.0
        nametxt.layer.cornerRadius = 5.0
        mrNotxt.layer.cornerRadius = 5.0
        emailtxt.layer.cornerRadius = 5.0
        addresstxt.layer.cornerRadius = 5.0
        
        mobiletxt.setLeftPaddingPoints(10)
        mobiletxt.setRightPaddingPoints(10)
        
        nametxt.setLeftPaddingPoints(10)
        nametxt.setRightPaddingPoints(10)
        
        mrNotxt.setLeftPaddingPoints(10)
        mrNotxt.setRightPaddingPoints(10)
        
        emailtxt.setLeftPaddingPoints(10)
        emailtxt.setRightPaddingPoints(10)
        
        addresstxt.setLeftPaddingPoints(10)
        addresstxt.setRightPaddingPoints(10)
        
        let font = FontHelper.defaultRegularFontWithSize(size: 14)
        
        mobiletxt.attributedPlaceholder = NSAttributedString(
                string: "  Mobile Number",
                attributes: [
                    NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                    NSAttributedString.Key.font: font
                ])
        
        nametxt.attributedPlaceholder = NSAttributedString(
                string: "  Name*",
                attributes: [
                    NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                    NSAttributedString.Key.font: font
                ])
        
        mrNotxt.attributedPlaceholder = NSAttributedString(
                string: "  Mr No",
                attributes: [
                    NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                    NSAttributedString.Key.font: font
                ])
        
        emailtxt.attributedPlaceholder = NSAttributedString(
                string: "  Email",
                attributes: [
                    NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                    NSAttributedString.Key.font: font
                ])
        
        addresstxt.attributedPlaceholder = NSAttributedString(
                string: "  Address*",
                attributes: [
                    NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                    NSAttributedString.Key.font: font
                ])
        
        requestbtn.layer.cornerRadius = 10
        requestbtn.setTitle("BOOK NOW", for: .normal)
        requestbtn.titleLabel?.font = FontHelper.defaultRegularFontWithSize(size: 12)
        
        if token == ""{
            tokenlbl.text = "Select Time Slot"
        }else{
            tokenlbl.text = token
        }
        
        tokenlbl.font = FontHelper.defaultRegularFontWithSize(size: 15)
        
    }
    
    func showMRList(listarray: [[String:Any]]){
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let popupVC = storyboard.instantiateViewController(withIdentifier: "SelectMRVC") as! MRSelectPopupView
        popupVC.ContentArray = listarray
        popupVC.isSelectedMR = true
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
               let pVC = popupVC.popoverPresentationController
        pVC?.permittedArrowDirections = .any
        pVC?.delegate = self
        pVC?.sourceView = view
        present(popupVC, animated: true, completion: nil)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
       
        if textField == nametxt {
            mrNotxt.becomeFirstResponder()
        }else if textField == mrNotxt {
            emailtxt.becomeFirstResponder()
        }else if textField == emailtxt {
             addresstxt.becomeFirstResponder()
        }else{
            scrollView.setContentOffset(.zero, animated: true)
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
        if textField == emailtxt {
            scrollView.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
        }else  if textField == addresstxt{
            scrollView.setContentOffset(CGPoint(x: 0, y: 200), animated: true)
        }else{
            scrollView.setContentOffset(.zero, animated: true)
        }
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
    
    
    
    func confirmBooking(){
        var parameters = Dictionary<String, Any>()
        parameters = ["patient_name":"\(nametxt.text!)","op_number":"\(mrNotxt.text!)","mobile_number":"\(mobiletxt.text!)","email":"\(emailtxt.text!)","age":"\(age)","address":"\(addresstxt.text!)","is_telemedicine":false,"token":"\(timimgArray[timeIndex]["id"]!)","visit_id":"\(visitID)","telemedicine_user_id":""]
        apiprovider.delegate = self
        apiprovider.fetchPostapi(api: "confirm-booking-for-op-tagged" as NSString, parameters: ["data":parameters], isauth: true, method: "Raw")
    }
    
    func didFinishDashBoardConnection_Dictionary(_ responceData: NSMutableDictionary) {
        loadingview.isHidden = true
        actyind.isHidden = true
        if responceData["status"] as? String == "success"{
           
            goToConfirmationPage(bookingContent: responceData["data"] as! [String : Any])
            
        }else{
            AppToast.showToast(withmessage: "\(responceData["msg"]!)", withview: view, withstyle: FontHelper.defaultRegularFontWithSize(size: 15))
        }
    }
    
    
    @IBAction func requestbtn_Evnt(_ sender: Any) {
        if tokenlbl.text == "Select Time Slot"{
            AppToast.showToast(withmessage: "Please Select Time Slot", withview: view, withstyle: FontHelper.defaultRegularFontWithSize(size: 15))
        }else{
            loadingview.isHidden = false
            actyind.isHidden = false
            confirmBooking()
        }
        
    }
    
    
    func goToConfirmationPage(bookingContent: [String:Any]){
        print("time_from: \(timimgArray[timeIndex]["time_from"]!)")
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BookingConfirmVC") as? BookingConfirmView {
            viewController.bookingArray = bookingContent
            viewController.contentArray = Content
            viewController.timevalue = "\(timimgArray[timeIndex]["time_from"]!)"
                   if let navigator = navigationController {
                       navigator.pushViewController(viewController, animated: true)
                   }
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
