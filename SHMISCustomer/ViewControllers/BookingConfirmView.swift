//
//  BookingConfirmView.swift
//  SHMISCustomer
//
//  Created by admin on 28/03/22.
//

import UIKit
import Reachability
class BookingConfirmView: UIViewController, DashBoardConnectionDeligate {
    
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
    
    
    @IBOutlet weak var bookingView: UIView!
    
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var initiallbl: UILabel!
    @IBOutlet weak var namelbl: UILabel!
    @IBOutlet weak var deptlbl: UILabel!
    @IBOutlet weak var pricelbl: UILabel!
    @IBOutlet weak var dateview: UIView!
    @IBOutlet weak var timeview: UIView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var cancelbtn: UIButton!
    @IBOutlet weak var laterbtn: UIButton!
    @IBOutlet weak var nowbtn: UIButton!
    
    @IBOutlet weak var dateimg: UIImageView!
    @IBOutlet weak var bookingdatelbl: UILabel!
    @IBOutlet weak var datelbl: UILabel!
    @IBOutlet weak var timeimg: UIImageView!
    @IBOutlet weak var bookingtimelbl: UILabel!
    @IBOutlet weak var timelbl: UILabel!
    
    
    @IBOutlet weak var loadingView: UIView!
    
    @IBOutlet weak var actiyind: UIActivityIndicatorView!
    var window: UIWindow?
    var ispaylater = false
    var iscancel = false
    var timevalue = ""
    
    var bookingArray = [String:Any]()
    var contentArray = [String:Any]()
    let apiprovider = Api_Provider()
    let reachability = try! Reachability()
    
    
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
        actiyind.isHidden = true
        CustomView()
        setData()
    }
    
    func setData(){
        
        let stringInput = contentArray["doctor_name"]
        let stringInputArr = (stringInput! as AnyObject).components(separatedBy: " ")
        var stringNeed = ""
        for string in stringInputArr {
            if string != "" {
                stringNeed = stringNeed + String(string.first!)
            }
        }
        initiallbl.text = String(stringNeed.prefix(2)).uppercased()
        
        namelbl.textColor = .black
        namelbl.font = FontHelper.defaultRegularFontWithSize(size: 14)
        
        
            if let akey = contentArray["doctor_name"]{
                namelbl.text = "\(akey)"
            }
        
        
        deptlbl.textColor = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 1.0)
        deptlbl.font = FontHelper.defaultRegularFontWithSize(size: 11)
        
        
            if let akey = contentArray["department_name"]{
                deptlbl.text = "\(akey)"
            }
        
        pricelbl.textColor = UIColor.white
        pricelbl.font = FontHelper.defaultRegularFontWithSize(size: 15)
        
        if let akey = bookingArray["amount"]{
            pricelbl.text = "₹ \(akey)"
        }
       
        
        bookingdatelbl.font = FontHelper.defaultRegularFontWithSize(size: 14)
        var datevalue = ""
        if let akey = contentArray["date"]{
            datevalue = "\(akey)"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let date = dateFormatter.date(from: datevalue)
        dateFormatter.dateFormat = "MMM d E"
        let resultString = dateFormatter.string(from: date!)
        print(resultString)
        
        bookingdatelbl.text = resultString
        
        
        datelbl.textColor = UIColor.black
        datelbl.font = FontHelper.defaultRegularFontWithSize(size: 11)
        datelbl.text = "Date"
        
        
        bookingtimelbl.font = FontHelper.defaultRegularFontWithSize(size: 14)
        bookingtimelbl.text = "\(timevalue)"
        
        
        timelbl.textColor = UIColor.black
        timelbl.font = FontHelper.defaultRegularFontWithSize(size: 11)
        timelbl.text = "Time"
    }
    
    func CustomView(){
        
        bgView.layer.insertSublayer(AppColors.gradientBg(view: view, colorArray: [UIColor(red: 253/255, green: 244/255, blue: 212/255, alpha: 1.0).cgColor, UIColor.white.cgColor, UIColor(red: 253/255, green: 244/255, blue: 212/255, alpha: 1.0).cgColor], locationArray: [0.0, 0.5,1.0], isVertical: true, startpoint: CGPoint(x: 0.0, y: 1.0), endpoint: CGPoint(x: 1.0, y: 1.0), cornerradius: 0.0), at: 0)
        
        
        bookingView.backgroundColor = .white
        bookingView.layer.cornerRadius = 15.0
        
        profileView.backgroundColor = .random
        profileView.layer.cornerRadius = profileView.frame.size.width/2
        
        
        cancelbtn.layer.cornerRadius = 8.0
        laterbtn.layer.cornerRadius = 8.0
        nowbtn.layer.cornerRadius = 8.0
        pricelbl.layer.cornerRadius = 14
        pricelbl.layer.masksToBounds = true
        
        cancelbtn.layer.borderWidth = 1.0
        cancelbtn.layer.borderColor = UIColor(red: 48/255, green: 93/255, blue: 112/255, alpha: 1.0).cgColor
        cancelbtn.setTitleColor(UIColor(red: 48/255, green: 93/255, blue: 112/255, alpha: 1.0), for: .normal)
        
        cancelbtn.titleLabel?.font = FontHelper.defaultRegularFontWithSize(size: 14)
        laterbtn.titleLabel?.font = FontHelper.defaultRegularFontWithSize(size: 14)
        nowbtn.titleLabel?.font = FontHelper.defaultRegularFontWithSize(size: 14)
    }
    
    func cancelBooking(){
        iscancel = true
        var parameters = Dictionary<String, Any>()
        parameters = ["transaction_id":"\(bookingArray["transaction_id"]!)"]
        apiprovider.delegate = self
        apiprovider.fetchPostapi(api: "cancel-booking" as NSString, parameters: ["data":parameters], isauth: true, method: "Raw")
    }
    
    func fetchpayLater(){
        ispaylater = true
        var parameters = Dictionary<String, Any>()
        parameters = ["transaction_id":"\(bookingArray["transaction_id"]!)","is_free_visit":false]
        apiprovider.delegate = self
        apiprovider.fetchPostapi(api: "booking-pay-later" as NSString, parameters: ["data":parameters], isauth: true, method: "Raw")
    }
    
    
    func didFinishDashBoardConnection_Dictionary(_ responceData: NSMutableDictionary) {
        loadingView.isHidden = true
        actiyind.isHidden = true
        if responceData["status"] as? String == "success"{
            if iscancel {
                iscancel = false
                self.navigationController!.popViewController(animated: true)
                AppToast.showToast(withmessage: "Your Appointment is Cancelled", withview: view, withstyle: FontHelper.defaultRegularFontWithSize(size: 15))
            }else if ispaylater {
                ispaylater = false
                AppToast.showToast(withmessage: "Your Appointment is Booked", withview: view, withstyle: FontHelper.defaultRegularFontWithSize(size: 15))
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
                    goToHome()
                }
               
            }else{
                
            }
            
        }else{
            AppToast.showToast(withmessage: "\(responceData["msg"]!)", withview: view, withstyle: FontHelper.defaultRegularFontWithSize(size: 15))
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
    
    func cancelBookingPage(){
        let alert = UIAlertController(title: "Alert", message: "Are you sure want to Cancel the selected Appointment", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { [self] action in
            if reachability.connection != .unavailable {
                loadingView.isHidden = false
                actiyind.isHidden = false
                cancelBooking()
            }else{
                AppToast.showToast(withmessage: "Network Not Available", withview: view, withstyle: FontHelper.defaultRegularFontWithSize(size: 15))
            }
        }))
        alert.addAction(UIAlertAction(title: "NO", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    
    @IBAction func cancel_Evnt(_ sender: Any) {
        cancelBookingPage()
      
    }
    
    @IBAction func later_Evnt(_ sender: Any) {
        if reachability.connection != .unavailable {
            loadingView.isHidden = false
            actiyind.isHidden = false
            fetchpayLater()
        }else{
            AppToast.showToast(withmessage: "Network Not Available", withview: view, withstyle: FontHelper.defaultRegularFontWithSize(size: 15))
        }
    }
    
    @IBAction func now_Evnt(_ sender: Any) {
    }
    
    
    @IBAction func bkEvnt(_ sender: Any) {
        cancelBookingPage()
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
