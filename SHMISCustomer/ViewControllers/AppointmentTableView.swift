//
//  AppointmentTableView.swift
//  SHMISCustomer
//
//  Created by admin on 25/03/22.
//

import UIKit

class AppointmentTableView: UITableViewController, DashBoardConnectionDeligate {
   
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
    
    
    
    private static let CellIdentifier = "CellIdentifier"
    var ListArray = [[String: Any]]()
    var uiColorArray = [UIColor(red: 255/255, green: 64/255, blue: 64/255, alpha: 1.0),
                        UIColor(red: 128/255, green: 176/255, blue: 72/255, alpha: 1.0),
                        UIColor(red: 255/255, green: 180/255, blue: 0/255, alpha: 1.0),
                        UIColor(red: 150/255, green: 98/255, blue: 162/255, alpha: 1.0),
                        UIColor(red: 127/255, green: 229/255, blue: 240/255, alpha: 1.0),
                        UIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 1.0),
                        UIColor(red: 183/255, green: 84/255, blue: 84/255, alpha: 1.0),
                        UIColor(red: 255/255, green: 141/255, blue: 161/255, alpha: 1.0),
                        UIColor(red: 144/255, green: 238/255, blue: 144/255, alpha: 1.0)]
    
    let apiprovider = Api_Provider()
    var loadingView: UIView?
    var page = Int()
    var pagecount = 10
    var deptID = ""
    var doctorID = ""
    var date = ""
    var window: UIWindow?
    var datepicker = UIDatePicker()
    
    
    override func viewWillAppear(_ animated: Bool) {
       fetchAppointmentList()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadingView = loadingView(withTag: 1000, andRect: UIScreen.main.bounds)
        tableView.backgroundColor = .white
        tableView.rowHeight = 240;
        tableView.estimatedRowHeight = 180
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [self] timer in
            // Set our data source and delegate.
            if loadingView != nil {
                loadingView?.removeFromSuperview()
                loadingView = nil
            }
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: AppointmentTableView.CellIdentifier)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.reloadData()
        }
     
       
    }
    
    func fetchAppointmentList(){
        var parameters = Dictionary<String, Any>()
        parameters = ["branch_id":"","data":["date":"\(date)","page": page,"page_count": pagecount]]
        apiprovider.delegate = self
        apiprovider.fetchPostapi(api: "doctor-consultation-available-in-date?department_id=\(deptID)&doctor_id=\(doctorID)" as NSString, parameters: parameters, isauth: true, method: "Raw")
    }
    
    
    func didFinishDashBoardConnection_Dictionary(_ responceData: NSMutableDictionary) {
        if loadingView != nil {
            loadingView?.removeFromSuperview()
            loadingView = nil
        }
        if responceData["status"] as? String == "success"{
            ListArray = responceData["data"] as! [[String : Any]]
            if ListArray.count > 0{
                tableView.register(UITableViewCell.self, forCellReuseIdentifier: AppointmentTableView.CellIdentifier)
                tableView.separatorStyle = .none
                tableView.delegate = self
                tableView.dataSource = self
                tableView.reloadData()
                
            }else{
                tableView.reloadData()
                let img_notFound = UIImageView(frame: CGRect(x: tableView.frame.size.width/2 - 35 , y: tableView.frame.size.height/2 - 35, width: 70, height: 70))
                img_notFound.image = UIImage(named: "NotFount.png")
                
                let lbl_notFound = UILabel(frame: CGRect(x: tableView.frame.size.width/2 - 90 , y: img_notFound.frame.origin.y + img_notFound.frame.size.height - 100, width: 180, height: 50))
                lbl_notFound.textAlignment = .center
                lbl_notFound.numberOfLines = 1
                lbl_notFound.textColor = UIColor.gray
                lbl_notFound.font = FontHelper.defaultBoldFontWithSize(size: 14)
                lbl_notFound.text = "No Appointment found."
                
                view.addSubview(img_notFound)
                view.addSubview(lbl_notFound)
            }
        }else{
            AppToast.showToast(withmessage: "\(responceData["msg"]!)", withview: view, withstyle: FontHelper.defaultRegularFontWithSize(size: 15))
        }
    }
    
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
       
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return ListArray.count
       
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           // let cellId = "cellId"
            var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: AppointmentTableView.CellIdentifier)
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: nil)
                cell?.selectionStyle = .none
                cell?.accessoryType = .none
                if Float(UIDevice.current.systemVersion) ?? 0.0 >= 8.0 {
                    cell?.layoutMargins = UIEdgeInsets.zero
                }
            }
        cell?.layoutIfNeeded()
        
        
        let section = indexPath.row
        
        let headView = UIView()
            headView.backgroundColor = UIColor.white
        
        
        var slotArray = [[String:Any]]()
        if let akey = ListArray[section]["visits"]{
            slotArray = akey as! [[String : Any]]
        }
        
        
        let Section_height = 200 + (slotArray.count * 50)
           
            
        headView.frame = CGRect(x: 0, y: 2, width: Int(tableView.frame.size.width) , height: Section_height)
        
        
        
        let circleview = UIView()
        circleview.backgroundColor = .random
        circleview.clipsToBounds = true
        circleview.frame = CGRect(x: 10, y: 15, width: 60 , height: 60)
        circleview.layer.cornerRadius = circleview.frame.size.width/2
        
        
        
        let lbltitle = UILabel(frame: CGRect(x: circleview.frame.origin.x + circleview.frame.size.width + 10 , y: 22, width: headView.frame.size.width - (circleview.frame.origin.x + circleview.frame.size.width + 10), height: 20))
        lbltitle.textAlignment = .left
        lbltitle.numberOfLines = 0
        lbltitle.tag = 100
        lbltitle.textColor = UIColor.black
        lbltitle.font = FontHelper.defaultRegularFontWithSize(size: 13)
       
            if let akey = ListArray[section]["doctor_name"]{
                lbltitle.text = "\(akey)"
            }
        
        
        
        let lblname = UILabel(frame: CGRect(x: 25, y: 25, width: 30, height: 40))
        lblname.textAlignment = .center
        lblname.numberOfLines = 1
        lblname.tag = 101
        lblname.textColor = UIColor.white
        lblname.font = FontHelper.defaultRegularFontWithSize(size: 15)
       
        
        let stringInput = lbltitle.text
        let stringInputArr = stringInput!.components(separatedBy: " ")
        var stringNeed = ""
        for string in stringInputArr {
            if string != "" {
                stringNeed = stringNeed + String(string.first!)
            }
        }
        lblname.text = String(stringNeed.prefix(2)).uppercased()
        
        circleview.addSubview(lblname)
        
        let lbldeptName = UILabel(frame: CGRect(x: circleview.frame.origin.x + circleview.frame.size.width + 10 , y: lbltitle.frame.origin.y + lbltitle.frame.size.height, width: headView.frame.size.width - 100, height: 20))
        lbldeptName.textAlignment = .left
        lbldeptName.numberOfLines = 0
        lbldeptName.tag = 102
        lbldeptName.textColor = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 1.0)
        lbldeptName.font = FontHelper.defaultRegularFontWithSize(size: 9)
        
        
            if let akey = ListArray[section]["department_name"]{
                lbldeptName.text = "\(akey)"
            }
        
        
        let imgLine = UIImageView()
        imgLine.backgroundColor = UIColor(red: 206/255, green: 206/255, blue: 206/255, alpha: 1.0)
        imgLine.frame = CGRect(x: 10, y: circleview.frame.origin.y + circleview.frame.size.height + 10, width:  headView.frame.size.width - 20, height: 0.8)
        
        

        let lblappointment = UILabel(frame: CGRect(x: 20 , y: imgLine.frame.origin.y + imgLine.frame.size.height + 10, width: 90, height: 20))
        lblappointment.textAlignment = .left
        lblappointment.numberOfLines = 1
        lblappointment.tag = 103
        lblappointment.textColor = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 1.0)
        lblappointment.font = FontHelper.defaultRegularFontWithSize(size: 10)
        lblappointment.text = "Book Appointment :"
            
        
        
        let lblappointmentdate = UILabel(frame: CGRect(x: lblappointment.frame.origin.x + lblappointment.frame.size.width + 10 , y: imgLine.frame.origin.y + imgLine.frame.size.height + 10, width: 280, height: 20))
        lblappointmentdate.textAlignment = .left
        lblappointmentdate.numberOfLines = 1
        lblappointmentdate.tag = 104
        lblappointmentdate.textColor = UIColor(red: 99/255, green: 98/255, blue: 98/255, alpha: 1.0)
        lblappointmentdate.font = FontHelper.defaultRegularFontWithSize(size: 13)
        
            if let akey = ListArray[section]["date_full"]{
                lblappointmentdate.text = "\(akey)"
            }
       
        
        
        
        let slotView = UIView(frame: CGRect(x: 20, y: lblappointment.frame.origin.y + lblappointment.frame.size.height + 20, width: headView.frame.size.width - 40 , height: 50))
        slotView.backgroundColor = UIColor(red: 40/255, green: 93/255, blue: 167/255, alpha: 1.0)
        slotView.layer.cornerRadius = 5.0
        
        for i in 0..<slotArray.count {
            
            let rectShape = CAShapeLayer()
            rectShape.bounds = slotView.frame
            rectShape.position = slotView.center
            rectShape.path = UIBezierPath(roundedRect: slotView.bounds, byRoundingCorners: [.topRight , .bottomRight], cornerRadii: CGSize(width: 10, height: 10)).cgPath

            //Here I'm masking the textView's layer with rectShape layer
            slotView.layer.mask = rectShape
            
            let imgtick = UIImageView()
            imgtick.frame = CGRect(x: 15, y: slotView.frame.size.height/2 - 11, width:  22, height: 22)
            imgtick.image = UIImage(named: "clock.png")
            
            let lbltimings = UILabel(frame: CGRect(x: slotView.frame.size.width - 130 , y: 0, width: 130, height: 50))
            lbltimings.textAlignment = .center
            lbltimings.numberOfLines = 1
            lbltimings.tag = 105
            lbltimings.backgroundColor = UIColor(red: 101/255, green: 156/255, blue: 53/255, alpha: 1.0)
            lbltimings.textColor = UIColor.white
            lbltimings.font = FontHelper.defaultRegularFontWithSize(size: 13)
          
               
               
            
            
            let lblslotCount = UILabel(frame: CGRect(x: imgtick.frame.origin.x + imgtick.frame.size.width + 10  , y: 0, width: 150, height: 50))
            lblslotCount.textAlignment = .center
            lblslotCount.numberOfLines = 1
            lblslotCount.tag = 106
            lblslotCount.backgroundColor = UIColor(red: 40/255, green: 93/255, blue: 167/255, alpha: 1.0)
            lblslotCount.textColor = UIColor.white
            lblslotCount.font = FontHelper.defaultRegularFontWithSize(size: 13)
            
            let btnslot = PassableUIButton(type: .custom)
            btnslot.frame = CGRect(x: 0, y: 0, width: slotView.frame.size.width, height: 100)
            btnslot.tag = section
            btnslot.params["currentIndex"] = i
            btnslot.addTarget(self, action: #selector(didSelect(_:)), for: .touchUpInside)
            btnslot.backgroundColor = .clear
            
            if let akey = slotArray[i]["slots_available"]{
                lbltimings.text = "\(akey) slots available"
            }
            
            if let akey = slotArray[i]["time_from"]{
                if let bkey = slotArray[i]["time_to"]{
                    lblslotCount.text = "\(akey) to \(bkey)"
                }
            }
            
            slotView.addSubview(imgtick)
            slotView.addSubview(lbltimings)
            slotView.addSubview(lblslotCount)
            slotView.addSubview(btnslot)
           
        
        }
       
        
       
      
        
        
        let imgLine1 = UIImageView()
        imgLine1.backgroundColor = UIColor(red: 206/255, green: 206/255, blue: 206/255, alpha: 1.0)
        imgLine1.frame = CGRect(x: 10, y: slotView.frame.origin.y + slotView.frame.size.height + 10, width:  headView.frame.size.width - 20, height: 0.8)
    
        
        
        let imgcalender = UIImageView()
        imgcalender.frame = CGRect(x: 15, y: imgLine1.frame.origin.y + imgLine1.frame.size.height + 20, width:  20, height: 20)
        imgcalender.image = UIImage(named: "school-calendar.png")
        
        
       
        
        let btncalender = UIButton(type: .custom)
        btncalender.frame = CGRect(x: imgcalender.frame.origin.x + imgcalender.frame.size.width + 10 , y: imgLine1.frame.origin.y + imgLine1.frame.size.height + 20, width: 100, height: 20)
        btncalender.tag = section + 100
        btncalender.addTarget(self, action: #selector(didSelectCalender(_:)), for: .touchUpInside)
        btncalender.setTitle("SHOW CALENDER", for: .normal)
        btncalender.setTitleColor(UIColor(red: 121/255, green: 91/255, blue: 246/255, alpha: 1.0), for: .normal)
        btncalender.titleLabel?.font = FontHelper.defaultRegularFontWithSize(size: 11)
        btncalender.titleLabel?.textAlignment = .left
        
        let lblbook = UILabel(frame: CGRect(x: headView.frame.size.width - 165 , y: imgLine1.frame.origin.y + imgLine1.frame.size.height + 20, width: 150, height: 20))
        lblbook.textAlignment = .right
        lblbook.numberOfLines = 1
        lblbook.tag = 107
        lblbook.textColor = UIColor(red: 65/255, green: 103/255, blue: 41/255, alpha: 1.0)
        lblbook.font = FontHelper.defaultRegularFontWithSize(size: 11)
        lblbook.text = "Book Tele Consultation Here"
        
        cell?.addSubview(headView)
    
       
        
       
        
        let bkView = UIView(frame: CGRect(x: 5, y: 10, width: headView.frame.size.width - 10, height: headView.frame.size.height - 12))
            bkView.backgroundColor = UIColor.white
            bkView.layer.borderColor = UIColor.white.cgColor
            bkView.layer.borderWidth = 0.5
            bkView.layer.shadowColor = UIColor.lightGray.cgColor
            bkView.layer.shadowOffset = CGSize(width: 0, height: 2)
            bkView.layer.shadowOpacity = 0.8
        bkView.layer.cornerRadius = 10
        
        
        
      
        cell?.addSubview(headView)
        
        headView.addSubview(bkView)
        headView.addSubview(slotView)
        headView.addSubview(circleview)
        headView.addSubview(lblname)
        headView.addSubview(lbltitle)
        headView.addSubview(lbldeptName)
        headView.addSubview(imgLine)
        headView.addSubview(lblappointment)
        headView.addSubview(lblappointmentdate)
        headView.addSubview(imgLine1)
       // headView.addSubview(imgcalender)
       // headView.addSubview(btncalender)
        headView.addSubview(lblbook)
        
        
        let estimateheight = headView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        var frame = headView.frame
        frame.size.height = estimateheight
        headView.frame = frame
        print("height : \(headView.frame.size.height)")
        
       
        

            if let aCell = cell {
                return aCell
            }
            return UITableViewCell()
        }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if UIDevice.current.userInterfaceIdiom == .pad {
                return 250
            }
        var slotArray = [[String:Any]]()
        if let akey = ListArray[indexPath.row]["visits"]{
            slotArray = akey as! [[String : Any]]
        }
        
        return CGFloat(200 + (slotArray.count * 50))
        }
    
    
        
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        return 0
        }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            return 0
        }
    
  
    
    
    @objc func didSelect(_ sender: PassableUIButton?) {
       
        var slotArray = [[String:Any]]()
        if let akey = ListArray[sender!.tag]["visits"]{
            slotArray = akey as! [[String : Any]]
        }
        let index = sender!.params["currentIndex"]
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SlotSelectVC") as? SlotView {
            viewController.Content = ListArray[sender!.tag]
            viewController.visitID = slotArray[index as! Int]["visit_id"] as! String
                   if let navigator = navigationController {
                       navigator.pushViewController(viewController, animated: true)
                   }
               }
        
    }
    
    
    @objc func didSelectCalender(_ sender: UIButton?) {
        
        
    }
    
    
   
    
    func loadingView(withTag tag: Int, andRect rect: CGRect) -> UIView? {
       let loadingScreen = UIView(frame: CGRect(x: 0, y: 0,
                                                width: UIScreen.main.bounds.size.width,
                                                height: UIScreen.main.bounds.size.height - 160))
        // loadingScreen.transform = CGAffineTransformMakeRotation(M_PI_2);
        loadingScreen.backgroundColor = UIColor.white
        loadingScreen.alpha = 1.0
        loadingScreen.tag = 300 + tag
        let transparentView = UIView(frame: UIScreen.main.bounds)
        //  transparentView.transform = CGAffineTransformMakeRotation(M_PI_2);
        transparentView.backgroundColor = UIColor.white
       transparentView.alpha = 1.0
       var loadingIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        loadingIndicator.color = UIColor.purple
        loadingIndicator.startAnimating()
        var subView = UIView()
        subView.backgroundColor = UIColor.clear
        var lblLoading = UILabel()
        lblLoading.text = "Please Wait, Loading..."
        lblLoading.backgroundColor = UIColor.clear
        lblLoading.textColor = UIColor.purple
        lblLoading.textAlignment = .center
        subView.layer.cornerRadius = 5.0
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let font = UIFont(name: "Helvetica-Bold", size: 25.0) {
                lblLoading.font = font
            }
           subView.frame = CGRect(x: loadingScreen.frame.size.width / 2 - 100, y: loadingScreen.frame.size.height / 2 - 60, width: 200, height: 120.0)
            loadingIndicator.frame = CGRect(x: subView.frame.size.width/2 - 25, y: 0.0, width: 50.0, height: 50.0)
            lblLoading.frame = CGRect(x: subView.frame.size.width/2 - 100, y: loadingIndicator.frame.origin.y + loadingIndicator.frame.size.height, width: 200.0, height: 46.0)
            
        } else {
            subView.frame = CGRect(x: loadingScreen.frame.size.width / 2 - 50, y: loadingScreen.frame.size.height / 2 - 35, width: 100, height: 70.0)
            loadingIndicator.frame = CGRect(x: subView.frame.size.width/2 - 15, y: 5, width: 30.0, height: 30.0)
            lblLoading.frame = CGRect(x: subView.frame.size.width/2 - 90, y: loadingIndicator.frame.origin.y + loadingIndicator.frame.size.height , width: 180.0, height: 20.0)
            
        }
        
        subView.addSubview(lblLoading)
        subView.addSubview(loadingIndicator)
        
        loadingScreen.addSubview(transparentView)
        loadingScreen.addSubview(subView)
        view.addSubview(loadingScreen)
        
        return loadingScreen
        
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

extension UIColor {
    public class var random: UIColor {
        return UIColor(red: CGFloat(drand48()),
                       green: CGFloat(drand48()),
                       blue: CGFloat(drand48()), alpha: 1.0)
    }
}

class PassableUIButton: UIButton{
    var params: Dictionary<String, Any>
    override init(frame: CGRect) {
        self.params = [:]
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        self.params = [:]
        super.init(coder: aDecoder)
    }
}
