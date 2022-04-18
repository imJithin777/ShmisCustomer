//
//  MRSelectPopupView.swift
//  SHMISCustomer
//
//  Created by admin on 28/03/22.
//

import UIKit

class MRSelectPopupView: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var toptitle: UILabel!
    @IBOutlet weak var bgview: UIView!
    @IBOutlet weak var mrListview: UIView!
    @IBOutlet weak var tableList: UITableView!
    var ContentArray = [[String:Any]]()
    var isSelectedMR = Bool()
    private static let CellIdentifier = "CellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isSelectedMR {
            toptitle.text = "SELECT PATIENT"
        }else{
            toptitle.text = "SELECT MR NO"
        }
        print("mrList: \(ContentArray)")
        if (ContentArray.count == 0){
            let lbl_notFound = UILabel(frame: CGRect(x: 10 , y: 50, width: bgview.frame.size.width - 20, height: bgview.frame.size.height - 50))
            lbl_notFound.textAlignment = .center
            lbl_notFound.numberOfLines = 1
            lbl_notFound.textColor = UIColor.gray
            lbl_notFound.font = FontHelper.defaultBoldFontWithSize(size: 14)
            lbl_notFound.text = "No Data found."
            
            view.addSubview(lbl_notFound)
        }else{
            tableList.backgroundColor = .white
            tableList.register(UITableViewCell.self, forCellReuseIdentifier: MRSelectPopupView.CellIdentifier)
            tableList.delegate = self
            tableList.dataSource = self
            tableList.reloadData()
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        bgview.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    @IBAction func didTapView(_ sender: UITapGestureRecognizer) {
       DismissView()
        
    }
    
    
    
    // MARK: - Table view data source

     func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return ContentArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          // let cellId = "cellId"
           var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: MRSelectPopupView.CellIdentifier)
           if cell == nil {
               cell = UITableViewCell(style: .default, reuseIdentifier: nil)
               cell?.selectionStyle = .none
               cell?.accessoryType = .none
               if Float(UIDevice.current.systemVersion) ?? 0.0 >= 8.0 {
                   cell?.layoutMargins = UIEdgeInsets.zero
               }
           }
       cell?.layoutIfNeeded()
        cell?.backgroundColor = .white
        
        let section = indexPath.row
        
        let headView = UIView(frame: CGRect(x: 0, y: 20, width: tableView.frame.size.width  , height: 60))
        headView.backgroundColor = .white
       
        
        let lblop = UILabel(frame: CGRect(x: 10 , y: 0, width: headView.frame.size.width - 20, height: 20))
        lblop.textAlignment = .left
        lblop.numberOfLines = 1
        lblop.tag = 100
        lblop.textColor = UIColor(red: 83/255, green: 82/255, blue: 82/255, alpha: 1.0)
        lblop.font = FontHelper.defaultRegularFontWithSize(size: 13)
        
        if let akey = ContentArray[section]["op"]{
            lblop.text = "\(akey)"
        }
        
        
        
        let lbltitle = UILabel(frame: CGRect(x: 10 , y: lblop.frame.origin.y + lblop.frame.size.height + 4, width: headView.frame.size.width - 20, height: 20))
        lbltitle.textAlignment = .left
        lbltitle.numberOfLines = 1
        lbltitle.tag = 101
        lbltitle.textColor = UIColor(red: 83/255, green: 82/255, blue: 82/255, alpha: 1.0)
        lbltitle.font = FontHelper.defaultRegularFontWithSize(size: 13)
        
        if let akey = ContentArray[section]["patient_name"]{
            lbltitle.text = "\(akey)"
        }
        
      
        
        let btncase = UIButton(type: .custom)
        btncase.frame = CGRect(x: 0, y: 0, width: headView.frame.size.width, height: 50)
        btncase.tag = section
        btncase.addTarget(self, action: #selector(didSelect(_:)), for: .touchUpInside)
        btncase.backgroundColor = .clear
        
        
        if isSelectedMR{
            lbltitle.frame = CGRect(x: 10 , y: 0, width: headView.frame.size.width - 20, height: 20)
            lblop.frame = CGRect(x: 10 , y: lbltitle.frame.origin.y + lbltitle.frame.size.height + 4, width: headView.frame.size.width - 20, height: 20)
            
            if let akey = ContentArray[section]["op_number"]{
                lblop.text = "\(akey)"
            }
        }
    
        
        cell?.addSubview(headView)
        
        headView.addSubview(lblop)
        headView.addSubview(lbltitle)
        headView.addSubview(btncase)
        
       
       

           if let aCell = cell {
               return aCell
           }
           return UITableViewCell()
       }
   
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  60
       }
       
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

          return  0

       }
   
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
           return 0
       }
   
   
   
   @objc func didSelect(_ sender: UIButton?) {
       var userInfo = [String : Any]()
       if isSelectedMR {
           userInfo = [ "patient" : ContentArray[sender!.tag]]
          
       }else{
           userInfo = [ "mrNO" : sender!.tag]
       }
        
       NotificationCenter.default.post(name: NSNotification.Name(rawValue: "select"), object: userInfo)
       DismissView()
       
   }
    
    func DismissView(){
        dismiss(animated: true, completion: nil)
            popoverPresentationController?.delegate?.popoverPresentationControllerDidDismissPopover?(popoverPresentationController!)
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
