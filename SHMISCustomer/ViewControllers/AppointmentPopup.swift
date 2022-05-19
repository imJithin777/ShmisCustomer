//
//  AppointmentPopup.swift
//  SHMISCustomer
//
//  Created by admin on 18/05/22.
//

import UIKit

class AppointmentPopup: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var toptitle: UILabel!
    @IBOutlet weak var searchtxt: UITextField!
    @IBOutlet weak var tblContents: UITableView!
    var deptList = [[String:Any]]()
    var doctorList = [[String:Any]]()
    var searchList = [[String:Any]]()
    var type = ""
    var issearch = false
    private static let CellIdentifier = "CellIdentifier"

    override func viewDidLoad() {
        super.viewDidLoad()
        searchtxt.delegate = self
        print("deptList count\(deptList.count)")
        print("doctorList count\(doctorList.count)")
        if type == "Department" {
            toptitle.text = "All Departments"
            if (deptList.count == 0){
                let lbl_notFound = UILabel(frame: CGRect(x: 10 , y: 50, width: bgView.frame.size.width - 20, height: bgView.frame.size.height - 50))
                lbl_notFound.textAlignment = .center
                lbl_notFound.numberOfLines = 1
                lbl_notFound.textColor = UIColor.gray
                lbl_notFound.font = FontHelper.defaultBoldFontWithSize(size: 14)
                lbl_notFound.text = "No Departments found."
                
                view.addSubview(lbl_notFound)
            }else{
                print("deptlist: \(deptList)")
                tblContents.backgroundColor = .white
                tblContents.register(UITableViewCell.self, forCellReuseIdentifier: AppointmentPopup.CellIdentifier)
                tblContents.delegate = self
                tblContents.dataSource = self
                tblContents.reloadData()
            }
        }else{
            toptitle.text = "All Doctors"
            if (doctorList.count == 0){
                let lbl_notFound = UILabel(frame: CGRect(x: 10 , y: 50, width: bgView.frame.size.width - 20, height: bgView.frame.size.height - 50))
                lbl_notFound.textAlignment = .center
                lbl_notFound.numberOfLines = 1
                lbl_notFound.textColor = UIColor.gray
                lbl_notFound.font = FontHelper.defaultBoldFontWithSize(size: 14)
                lbl_notFound.text = "No Doctors found."
                
                view.addSubview(lbl_notFound)
            }else{
                print("deptlist: \(doctorList)")
                tblContents.backgroundColor = .white
                tblContents.register(UITableViewCell.self, forCellReuseIdentifier: AppointmentPopup.CellIdentifier)
                tblContents.delegate = self
                tblContents.dataSource = self
                tblContents.reloadData()
            }
        }
       
        Customview()
        searchtxt.addTarget(self, action: #selector(AppointmentPopup.textFieldDidChange(_:)),
                                  for: .editingChanged)
       
    }
    
    func Customview(){
     
        
        searchtxt.leftViewMode = UITextField.ViewMode.always
        let sideview = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
         searchtxt.rightViewMode = .always
        let imageView = UIImageView(frame: CGRect(x: sideview.frame.size.width/2 - 10, y: sideview.frame.size.height/2 - 10, width: 20, height: 20))
        let image = UIImage(named: "search.png")
        imageView.image = image
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.layer.masksToBounds = true
        sideview.addSubview(imageView)
        searchtxt.leftView = sideview
        
        
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: searchtxt.frame.height - 1, width: searchtxt.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.darkGray.cgColor
        searchtxt.borderStyle = UITextField.BorderStyle.none
        searchtxt.layer.addSublayer(bottomLine)
    }
    
    
    
    // MARK: - Table view data source

     func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
         if issearch {
             return searchList.count
         }else{
             if type == "Department" {
                 return deptList.count
             }else{
                 return doctorList.count
             }
            
         }
         
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          // let cellId = "cellId"
           var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: AppointmentPopup.CellIdentifier)
           if cell == nil {
               cell = UITableViewCell(style: .default, reuseIdentifier: nil)
               cell?.selectionStyle = .none
               cell?.accessoryType = .none
               if Float(UIDevice.current.systemVersion) ?? 0.0 >= 8.0 {
                   cell?.layoutMargins = UIEdgeInsets.zero
               }
           }
        cell?.layoutIfNeeded()
        cell?.backgroundColor = .clear
        
        let section = indexPath.row
        
        let headView = UIView(frame: CGRect(x: 0, y: 10, width: tableView.frame.size.width  , height: 30))
        headView.backgroundColor = .white
        
        
        let lbltitle = UILabel(frame: CGRect(x: 10 , y: headView.frame.size.height/2 - 10, width: headView.frame.size.width - 20, height: 20))
        lbltitle.textAlignment = .left
        lbltitle.numberOfLines = 1
        lbltitle.tag = 100
        lbltitle.textColor = UIColor(red: 83/255, green: 82/255, blue: 82/255, alpha: 1.0)
        lbltitle.font = FontHelper.defaultRegularFontWithSize(size: 13)
        
        if issearch {
            if type == "Department" {
                if let akey = searchList[section]["department_name"]{
                    lbltitle.text = "\(akey)"
                }
            }else{
                if let akey = searchList[section]["doctor_name"]{
                    lbltitle.text = "\(akey)"
                }
            }
        }else{
            if type == "Department" {
                if let akey = deptList[section]["department_name"]{
                    lbltitle.text = "\(akey)"
                }
            }else{
                if let akey = doctorList[section]["doctor_name"]{
                    lbltitle.text = "\(akey)"
                }
            }
        }
       
       
        
      
        
        let btncase = UIButton(type: .custom)
        btncase.frame = CGRect(x: 0, y: 0, width: headView.frame.size.width, height: 30)
        btncase.tag = section
        btncase.addTarget(self, action: #selector(didSelect(_:)), for: .touchUpInside)
        btncase.backgroundColor = .clear
        
        
        cell?.addSubview(headView)
        
        headView.addSubview(lbltitle)
        headView.addSubview(btncase)
        
       
       

           if let aCell = cell {
               return aCell
           }
           return UITableViewCell()
       }
   
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  40
       }
       
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

          return  0

       }
   
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
           return 0
       }
   
   
   
   @objc func didSelect(_ sender: UIButton?) {
       var userInfo = [String : Any]()
       if issearch {
           if type == "Department" {
               userInfo = [ "department" : searchList[sender!.tag], "type" : "Department"]
              
           }else{
               userInfo = [ "doctor" : searchList[sender!.tag], "type" : "Doctor"]
           }
       }else{
           if type == "Department" {
               userInfo = [ "department" : deptList[sender!.tag], "type" : "Department"]
              
           }else{
               userInfo = [ "doctor" : doctorList[sender!.tag], "type" : "Doctor"]
           }
       }
      
        
       NotificationCenter.default.post(name: NSNotification.Name(rawValue: "appointmentSelection"), object: userInfo)
       DismissView()
       
   }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        issearch = true
        if (textField.text!.count ) != 0 {
            if type == "Department" {
                searchList = deptList.filter { (object) -> Bool in
                    guard let title = object["department_name"] as? String else {return false}
                    return title.contains(textField.text!)
                }
                print("searchList: \(searchList)")
                tblContents.reloadData()
            }else{
                searchList = doctorList.filter { (object) -> Bool in
                    guard let title = object["doctor_name"] as? String else {return false}
                    return title.contains(textField.text!)
                }
                print("searchList: \(searchList)")
                tblContents.reloadData()
            }
            
           
            
        }else{
            issearch = false
            searchList = [[String:Any]]()
            tblContents.reloadData()
        }
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        
        textField.resignFirstResponder()
    
        return true
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        
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
    
    
    func DismissView(){
        dismiss(animated: true, completion: nil)
            popoverPresentationController?.delegate?.popoverPresentationControllerDidDismissPopover?(popoverPresentationController!)
    }
    
    @IBAction func close_Evnt(_ sender: Any) {
        DismissView()
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
