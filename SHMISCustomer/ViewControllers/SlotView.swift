//
//  SlotView.swift
//  SHMISCustomer
//
//  Created by admin on 26/03/22.
//

import UIKit
import Reachability
class SlotView: UIViewController, DashBoardConnectionDeligate, UIPopoverPresentationControllerDelegate {
    
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
    
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var dpview: UIView!
    @IBOutlet weak var initialslbl: UILabel!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var deptName: UILabel!
    @IBOutlet weak var datelbl: UILabel!
    
    @IBOutlet weak var slotview: UIView!
    @IBOutlet weak var consultationlbl: UILabel!
    @IBOutlet weak var lblswitch: UISwitch!
    @IBOutlet weak var timeslotbnt: UIButton!
    @IBOutlet weak var mrNobtn: UIButton!
    @IBOutlet weak var donthavemrbtn: UIButton!
    
    @IBOutlet weak var booknowbtn: UIButton!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var actyind: UIActivityIndicatorView!
    
    let apiprovider = Api_Provider()
    var Content = [String:Any]()
    var slotArray = [[String:Any]]()
    var mrIndex = Int()
    var timeIndex = Int()
    var mrArray = [[String:Any]]()
    var visitID = ""
    let reachability = try! Reachability()
    var istiming = true
    var isBooking = false
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
        consultationlbl.isHidden = true
        lblswitch.isHidden = true
        loadingView.isHidden = true
        actyind.isHidden = true
        booknowbtn.isHidden = true
        CustomView()
        if reachability.connection != .unavailable {
            fetchtimingList()
        }else{
            AppToast.showToast(withmessage: "Network Not Available", withview: view, withstyle: FontHelper.defaultRegularFontWithSize(size: 15))
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.timeselect(_:)), name: NSNotification.Name(rawValue: "timeselect"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.mrselect(_:)), name: NSNotification.Name(rawValue: "select"), object: nil)
    }
    
    
    @objc func timeselect(_ notification: NSNotification) {
        let dict = notification.object as! NSDictionary

        if let total = dict["time"]{
            timeIndex = total as! Int
            timeslotbnt.setTitle("TK\(slotArray[timeIndex]["token"]!) - \(slotArray[timeIndex]["time_from"]!) - \(slotArray[timeIndex]["time_to"]!)", for: .normal)
            }
        if (timeslotbnt.titleLabel?.text != "Select Time Slot" && mrNobtn.titleLabel?.text != "Select MR NO"){
            booknowbtn.isHidden = false
        }
     }
    
    @objc func mrselect(_ notification: NSNotification) {
        let dict = notification.object as! NSDictionary
        if let total = dict["mrNO"]{
            mrIndex = total as! Int
            mrNobtn.setTitle("\(mrArray[mrIndex]["op"]!)", for: .normal)
            }
        if (timeslotbnt.titleLabel?.text != "Select Time Slot" && mrNobtn.titleLabel?.text != "Select MR NO"){
            booknowbtn.isHidden = false
        }
            
     }
    
    func CustomView(){
        bgView.layer.insertSublayer(AppColors.gradientBg(view: view, colorArray: [UIColor(red: 253/255, green: 244/255, blue: 212/255, alpha: 1.0).cgColor, UIColor.white.cgColor, UIColor(red: 253/255, green: 244/255, blue: 212/255, alpha: 1.0).cgColor], locationArray: [0.0, 0.5,1.0], isVertical: true, startpoint: CGPoint(x: 0.0, y: 1.0), endpoint: CGPoint(x: 1.0, y: 1.0), cornerradius: 0.0), at: 0)
        profileView.layer.cornerRadius = 10.0
        slotview.layer.cornerRadius = 10.0
        
        Shadow.setShadow(view: profileView)
        Shadow.setShadow(view: slotview)
        
        dpview.backgroundColor = .random
        dpview.layer.cornerRadius = dpview.frame.size.width/2
        
        initialslbl.textColor = UIColor.white
        initialslbl.font = FontHelper.defaultRegularFontWithSize(size: 15)
       
        
        let stringInput = Content["doctor_name"]
        let stringInputArr = (stringInput! as AnyObject).components(separatedBy: " ")
        var stringNeed = ""
        for string in stringInputArr {
            if string != "" {
                stringNeed = stringNeed + String(string.first!)
            }
        }
        initialslbl.text = String(stringNeed.prefix(2)).uppercased()
        
        lblname.textColor = .black
        lblname.font = FontHelper.defaultRegularFontWithSize(size: 13)
        
        
            if let akey = Content["doctor_name"]{
                lblname.text = "\(akey)"
            }
        
        
        deptName.textColor = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 1.0)
        deptName.font = FontHelper.defaultRegularFontWithSize(size: 10)
        
        
            if let akey = Content["department_name"]{
                deptName.text = "\(akey)"
            }
        
        datelbl.textColor = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 1.0)
        datelbl.font = FontHelper.defaultRegularFontWithSize(size: 11)
        if let akey = Content["date_full"]{
            datelbl.text = "Booking Date: \(akey)"
        }
        
        lblswitch.onTintColor = UIColor(red: 111/255, green: 86/255, blue: 214/255, alpha: 1.0)
        lblswitch.tintColor = UIColor(red: 189/255, green: 189/255, blue: 189/255, alpha: 1.0)
        lblswitch.thumbTintColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1.0)
   
        timeslotbnt.layer.cornerRadius = 10
        timeslotbnt.setTitle("Select Time Slot", for: .normal)
        timeslotbnt.setTitleColor(.white, for: .normal)
        timeslotbnt.titleLabel?.font = FontHelper.defaultRegularFontWithSize(size: 14)
        
        mrNobtn.layer.cornerRadius = 10
        mrNobtn.setTitle("Select MR NO", for: .normal)
        mrNobtn.setTitleColor(.white, for: .normal)
        mrNobtn.titleLabel?.font = FontHelper.defaultRegularFontWithSize(size: 14)
        
        let buttonAttributes: [NSAttributedString.Key: Any] = [
              .font: FontHelper.defaultRegularFontWithSize(size: 14),
              .underlineStyle: NSUnderlineStyle.single.rawValue
          ]
        
        donthavemrbtn.setTitleColor(UIColor(red: 0/255, green: 0/255, blue: 230/255, alpha: 1.0), for: .normal)
        
        let attributeString = NSMutableAttributedString(
               string: "Don't have MR NO?",
               attributes: buttonAttributes
            )
        donthavemrbtn.setAttributedTitle(attributeString, for: .normal)
        
        
        booknowbtn.layer.cornerRadius = 10
        booknowbtn.setTitle("BOOK NOW", for: .normal)
        booknowbtn.setTitleColor(.white, for: .normal)
        booknowbtn.titleLabel?.font = FontHelper.defaultRegularFontWithSize(size: 14)
    }
    
    
    func fetchtimingList(){
        var parameters = Dictionary<String, Any>()
        parameters = ["visit_id":"\(visitID)"]
        apiprovider.delegate = self
        apiprovider.fetchPostapi(api: "get-tokens-against-visit-detail" as NSString, parameters: ["data":parameters], isauth: true, method: "Raw")
    }
    
    func fetchMRList(){
        var parameters = Dictionary<String, Any>()
        parameters = ["has_others":false]
        apiprovider.delegate = self
        apiprovider.fetchPostapi(api: "op-tagged-list" as NSString, parameters: ["data":parameters], isauth: true, method: "Raw")
    }
    
    
    func confirmBooking(){
        var parameters = Dictionary<String, Any>()
        parameters = ["patient_name":"\(mrArray[mrIndex]["patient_name"]!)","op_number":"\(mrArray[mrIndex]["op"]!)","mobile_number":"\(mrArray[mrIndex]["mobile_no"]!)","email":"\(mrArray[mrIndex]["email"]!)","age":"\(mrArray[mrIndex]["age"]!)","address":"\(mrArray[mrIndex]["address"]!)","is_telemedicine":false,"token":"\(slotArray[timeIndex]["id"]!)","visit_id":"\(visitID)","telemedicine_user_id":""]
        apiprovider.delegate = self
        apiprovider.fetchPostapi(api: "confirm-booking-for-op-tagged" as NSString, parameters: ["data":parameters], isauth: true, method: "Raw")
    }
    
    func didFinishDashBoardConnection_Dictionary(_ responceData: NSMutableDictionary) {
        loadingView.isHidden = true
        actyind.isHidden = true
        if responceData["status"] as? String == "success"{
            if isBooking {
                goToConfirmationPage(bookingContent: responceData["data"] as! [String : Any])
            }else{
                if istiming {
                    slotArray = responceData["data"] as! [[String : Any]]
                    if slotArray.count > 0{
                        showtimings()
                        istiming = false
                        fetchMRList()
                    }
                }else{
                    mrArray = responceData["data"] as! [[String : Any]]
                    if mrArray.count > 0{
                        istiming = true
                    }
                }
            }
            
           
        }else{
            AppToast.showToast(withmessage: "\(responceData["msg"]!)", withview: view, withstyle: FontHelper.defaultRegularFontWithSize(size: 15))
        }
    }
    
    func goToConfirmationPage(bookingContent: [String:Any]){
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BookingConfirmVC") as? BookingConfirmView {
            viewController.bookingArray = bookingContent
            viewController.contentArray = Content
            viewController.timevalue = "\(slotArray[timeIndex]["time_from"]!)"
                   if let navigator = navigationController {
                       navigator.pushViewController(viewController, animated: true)
                   }
               }
    }
    
    
    func showtimings(){
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let popupVC = storyboard.instantiateViewController(withIdentifier: "TimingsVC") as! SlotPopupView
        popupVC.timimgArray = slotArray
        popupVC.Content = Content
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
               let pVC = popupVC.popoverPresentationController
        pVC?.permittedArrowDirections = .any
        pVC?.delegate = self
        pVC?.sourceView = view
        present(popupVC, animated: true, completion: nil)
    }
    
    
    func showMRList(){
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let popupVC = storyboard.instantiateViewController(withIdentifier: "SelectMRVC") as! MRSelectPopupView
        popupVC.ContentArray = mrArray
        popupVC.isSelectedMR = false
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
    
    @IBAction func timeslotEvnt(_ sender: Any) {
        showtimings()
    }
    
    @IBAction func mrNOEvnt(_ sender: Any) {
        showMRList()
    }
    
    
    @IBAction func donthavemr_Evnt(_ sender: Any) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ForgotVC") as? ForgotMRView {
            viewController.token = (timeslotbnt.titleLabel?.text)!
            viewController.visitID = visitID
            viewController.Content = Content
            viewController.timimgArray = slotArray
                   if let navigator = navigationController {
                       navigator.pushViewController(viewController, animated: true)
                   }
               }
        
    }
    
    @IBAction func switch_Evnt(_ sender: Any) {
    }
    
    @IBAction func booknow_Evnt(_ sender: Any) {
        loadingView.isHidden = false
        actyind.isHidden = false
        isBooking = true
        confirmBooking()
        
        
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
