//
//  BookAppointmentView.swift
//  SHMISCustomer
//
//  Created by admin on 19/03/22.
//

import UIKit
import iOSDropDown
import Reachability
class BookAppointmentView: UIViewController, DashBoardConnectionDeligate, UITextFieldDelegate, UIPopoverPresentationControllerDelegate {
    
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
    
    var deptList = [[String:Any]]()
    var doctorList = [[String:Any]]()
  
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var deptDropField: DropDown!
    
    @IBOutlet weak var doctorDropField: DropDown!
    
    @IBOutlet weak var bgview: UIView!
    @IBOutlet weak var bookView: UIView!
    @IBOutlet weak var deptlbl: UILabel!
    @IBOutlet weak var doctorlbl: UILabel!
    @IBOutlet weak var bookbtn: UIButton!
    let apiprovider = Api_Provider()
    let reachability = try! Reachability()
    var isdepartmentList = true
    var isdept = true
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var actyind: UIActivityIndicatorView!
    var deptID = ""
    var doctorID = ""
    var window: UIWindow?
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
       
    }

    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        CustomView()
        listDepartment()
       
        
//        deptDropField.didSelect(completion: { [self] (selectedText, index, id) in
//            deptDropField.hideList()
//
//        })
        
//        doctorDropField.didSelect(completion: { [self] (selectedText, index, id) in
//            doctorDropField.hideList()
//
//        })
       
//        deptDropField.delegate = self
//        doctorDropField.delegate = self
        
        let tapGestureRecognizerDepartment = UITapGestureRecognizer(target: self, action: #selector(didTapdept(_:)))
        tapGestureRecognizerDepartment.numberOfTapsRequired = 1
        deptDropField.addGestureRecognizer(tapGestureRecognizerDepartment)
        
        let tapGestureRecognizerDoctor = UITapGestureRecognizer(target: self, action: #selector(didTapdoctor(_:)))
        tapGestureRecognizerDoctor.numberOfTapsRequired = 1
        doctorDropField.addGestureRecognizer(tapGestureRecognizerDoctor)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.appointmentSelection(_:)), name: NSNotification.Name(rawValue: "appointmentSelection"), object: nil)
       
    }
    
    
    @IBAction func didTapdept(_ sender: UITapGestureRecognizer) {
        self.deptDropField.isSelected = false
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let popupVC = storyboard.instantiateViewController(withIdentifier: "AppointmentVC") as! AppointmentPopup
        popupVC.deptList = deptList
        popupVC.type = "Department"
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
               let pVC = popupVC.popoverPresentationController
        pVC?.permittedArrowDirections = .any
        pVC?.delegate = self
        pVC?.sourceView = view
        present(popupVC, animated: true, completion: nil)
    }
    
    
    @IBAction func didTapdoctor(_ sender: UITapGestureRecognizer) {
        self.doctorDropField.isSelected = false
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let popupVC = storyboard.instantiateViewController(withIdentifier: "AppointmentVC") as! AppointmentPopup
        popupVC.doctorList = doctorList
        popupVC.type = "Doctor"
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
               let pVC = popupVC.popoverPresentationController
        pVC?.permittedArrowDirections = .any
        pVC?.delegate = self
        pVC?.sourceView = view
        present(popupVC, animated: true, completion: nil)
        
    }
    
    
    @objc func appointmentSelection(_ notification: NSNotification) {
        let dict = notification.object as! NSDictionary
        var type = ""
        var contentdata = [String:Any]()

        if let akey = dict["type"]{
            type = "\(akey)"
            if type == "Department"{
                if let bkey = dict["department"]{
                    contentdata = bkey as! [String : Any]
                    if let ckey = contentdata["department_name"]{
                        deptDropField.text = "\(ckey)"
                        deptID = "\(contentdata["id"]!)"
                        var parameters = Dictionary<String, Any>()
                        parameters = ["branch_id" : "", "doctor_list": ["department":"\(deptID)"]]
                        print(parameters)
                        listDoctor(parameters: parameters)
                    }
                }
                
            }else{
                if let bkey = dict["doctor"]{
                    contentdata = bkey as! [String : Any]
                    if let ckey = contentdata["doctor_name"]{
                        doctorDropField.text = "\(ckey)"
                        doctorID = "\(contentdata["doctor_id"]!)"
                    }
                }
            }
        }
    }
    
    
    
     func CustomView(){
         Shadow.setShadow(view: bookView)
         bgview.layer.insertSublayer(AppColors.gradientBg(view: view, colorArray: [UIColor(red: 253/255, green: 244/255, blue: 212/255, alpha: 1.0).cgColor, UIColor.white.cgColor, UIColor(red: 253/255, green: 244/255, blue: 212/255, alpha: 1.0).cgColor], locationArray: [0.0, 0.5,1.0], isVertical: true, startpoint: CGPoint(x: 0.0, y: 1.0), endpoint: CGPoint(x: 1.0, y: 1.0), cornerradius: 0.0), at: 0)
         
         
         deptlbl.text = "Select Department"
         doctorlbl.text = "Select Doctor"
         deptlbl.textColor = UIColor(red: 65/255, green: 103/255, blue: 41/255, alpha: 1.0)
         doctorlbl.textColor = UIColor(red: 65/255, green: 103/255, blue: 41/255, alpha: 1.0)
         deptlbl.font = FontHelper.defaultRegularFontWithSize(size: 11)
         doctorlbl.font = FontHelper.defaultRegularFontWithSize(size: 11)
         
         
         bookView.layer.cornerRadius = 10.0
         bookbtn.layer.cornerRadius = 10.0
         
         bookbtn.setTitle("PROCEED TO BOOK APPOINTMENT", for: .normal)
         bookbtn.titleLabel?.font = FontHelper.defaultRegularFontWithSize(size: 13)
         bookbtn.layer.cornerRadius = 10.0
         
         deptDropField.borderWidth = 1.0
         deptDropField.borderColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0)
         deptDropField.cornerRadius = 5.0
         
         doctorDropField.borderWidth = 1.0
         doctorDropField.borderColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0)
         doctorDropField.cornerRadius = 5.0
         
         
       
         deptDropField.arrowColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0)
         
        
         doctorDropField.arrowColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0)
         
         deptDropField.selectedRowColor = UIColor(red: 110/255, green: 85/255, blue: 214/255, alpha: 1.0)
         doctorDropField.selectedRowColor = UIColor(red: 110/255, green: 85/255, blue: 214/255, alpha: 1.0)
         
         deptDropField.textColor = .black
         doctorDropField.textColor = .black
         
        
         deptDropField.rowBackgroundColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1.0)
         doctorDropField.rowBackgroundColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1.0)
         
         deptDropField.placeholder = "Select Department"
         doctorDropField.placeholder = "Select Doctor"
         
         deptDropField.setLeftPaddingPoints(10)
         deptDropField.setRightPaddingPoints(10)
         
         doctorDropField.setLeftPaddingPoints(10)
         doctorDropField.setRightPaddingPoints(10)
         
         
         
         
     }
     
    
    
    func listDepartment()  {
        apiprovider.delegate = self
        apiprovider.fetchapi(api: "list-departments" as NSString, isauth: true)
    }
    
    func listDoctor(parameters: Dictionary<String, Any>)  {
        apiprovider.delegate = self
        apiprovider.fetchPostapi(api: "doctor-in-department" as NSString, parameters: parameters, isauth: true, method: "Raw")
    }
    
    
    func didFinishDashBoardConnection_Dictionary(_ responceData: NSMutableDictionary) {
        if isdepartmentList {
            if responceData["status"] as? String == "success"{
                deptList = responceData["data"] as! [[String : Any]]
                if deptList.count > 0{
                    var stringArray = [String]()
                    var contentDictioonary = [String:Any]()
                    contentDictioonary["department_name"] = "All Departments"
                    contentDictioonary["id"] = ""
                    deptList.insert(contentDictioonary, at: 0)
                    for i in 0..<deptList.count {
                        let string = deptList[i]["department_name"] as! String
                        stringArray.append(string)
                    }
                    deptDropField.optionArray = stringArray
                    deptDropField.isSearchEnable = true
                    deptDropField.text = stringArray[0]
                    var parameters = Dictionary<String, Any>()
                    parameters = ["branch_id" : "", "doctor_list": ["department":""]]
                    print(parameters)
                    isdepartmentList = false
                    listDoctor(parameters: parameters)
                }
                
            }
        }else{
            loadingView.isHidden = true
            actyind.isHidden = true
            if responceData["status"] as? String == "success"{
                doctorList = responceData["data"] as! [[String : Any]]
                if doctorList.count > 0{
                    doctorDropField.isEnabled = true
                    var stringArray = [String]()
                    var contentDictioonary = [String:Any]()
                    contentDictioonary["doctor_name"] = "All Doctors"
                    contentDictioonary["doctor_id"] = ""
                    doctorList.insert(contentDictioonary, at: 0)
                    for i in 0..<doctorList.count {
                        let string = doctorList[i]["doctor_name"] as! String
                        stringArray.append(string)
                    }
                    doctorDropField.optionArray = stringArray
                    doctorDropField.isSearchEnable = true
                    doctorDropField.text = stringArray[0]
                }else{
                    doctorDropField.text = "No Doctors Available"
                    doctorID = ""
                    doctorDropField.isEnabled = false
                }
            }
        }
        
    }
    
    
//    func fetchmedicineList() {
//        isdept = false
//        var parameters = Dictionary<String, Any>()
//
//        print(currentIndex)
//        parameters = ["branch_id": "", "doctor_list" : tabDictionary[currentIndex]["id"]]
//
//
//        apiprovider.delegate = self
//        apiprovider.fetchPostapi(api: "view-telemedicine-appontment", parameters: parameters, isauth: true, method: "Raw")
//    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        // became first responder
        if textField == deptDropField {
            scrollView.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
        }else{
            scrollView.setContentOffset(CGPoint(x: 0, y: 200), animated: true)
        }
        
    }
    
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        
            textField.resignFirstResponder()

        return true
    }
    
 
    @IBAction func bkEvnt(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    @IBAction func bookEvnt(_ sender: Any) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AppointmentDetailVC") as? AppointmentDetailView {
            viewController.deptID = deptID
            viewController.doctorID = doctorID
                   if let navigator = navigationController {
                       navigator.pushViewController(viewController, animated: true)
                   }
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
