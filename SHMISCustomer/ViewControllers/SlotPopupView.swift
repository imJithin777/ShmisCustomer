//
//  SlotPopupView.swift
//  SHMISCustomer
//
//  Created by admin on 27/03/22.
//

import UIKit

class SlotPopupView: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var bgview: UIView!
    
    @IBOutlet weak var timingView: UIView!
    @IBOutlet weak var selectlabel: UILabel!
    
    @IBOutlet weak var namelbl: UILabel!
    @IBOutlet weak var deptlbl: UILabel!
    @IBOutlet weak var datelbl: UILabel!
    
    @IBOutlet weak var collectionList: UICollectionView!
    
    var Content = [String:Any]()
    let reuseIdentifier = "cell"
    var timimgArray = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("timingsArray: \(timimgArray)")
        setData()
        if (timimgArray.count == 0){
           
            let lbl_notFound = UILabel(frame: CGRect(x: 10 , y: datelbl.frame.origin.y + datelbl.frame.size.height + 10, width: bgview.frame.size.width - 20, height: bgview.frame.size.height - (datelbl.frame.origin.y + datelbl.frame.size.height + 10)))
            lbl_notFound.textAlignment = .center
            lbl_notFound.numberOfLines = 1
            lbl_notFound.textColor = UIColor.gray
            lbl_notFound.font = FontHelper.defaultBoldFontWithSize(size: 14)
            lbl_notFound.text = "No Visits found."
            
            view.addSubview(lbl_notFound)
        }else{
            self.collectionList!.register(SlotCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        }
       
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        bgview.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    
    @IBAction func didTapView(_ sender: UITapGestureRecognizer) {
       DismissView()
        
    }
    
    func DismissView(){
        dismiss(animated: true, completion: nil)
            popoverPresentationController?.delegate?.popoverPresentationControllerDidDismissPopover?(popoverPresentationController!)
    }
    
    func setData(){
        namelbl.textColor = UIColor(red: 67/255, green: 67/255, blue: 67/255, alpha: 1.0)
        namelbl.font = FontHelper.defaultRegularFontWithSize(size: 14)
        
        
            if let akey = Content["doctor_name"]{
                namelbl.text = "\(akey)"
            }
        
        
        deptlbl.textColor = UIColor(red: 67/255, green: 67/255, blue: 67/255, alpha: 1.0)
        deptlbl.font = FontHelper.defaultRegularFontWithSize(size: 14)
        
        
            if let akey = Content["department_name"]{
                deptlbl.text = "\(akey)"
            }
        
        datelbl.textColor = UIColor(red: 67/255, green: 67/255, blue: 67/255, alpha: 1.0)
        datelbl.font = FontHelper.defaultRegularFontWithSize(size: 14)
        if let akey = Content["date_full"]{
            datelbl.text = "\(akey)"
        }
    }
    
    
    
    
    // MARK: - UICollectionViewDataSource protocol
        
        // tell the collection view how many cells to make
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return timimgArray.count
        }
        
        // make a cell for each cell index path
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            // get a reference to our storyboard cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! SlotCollectionViewCell
            
            // Use the outlet in our custom class to get a reference to the UILabel in the cell
            let timelbl = UILabel(frame: CGRect(x: cell.frame.size.width/2 - 40 , y: cell.frame.size.height/2 - 20, width: 80, height: 40))
            timelbl.textAlignment = .center
            timelbl.numberOfLines = 1
            timelbl.textColor = UIColor.white
            timelbl.backgroundColor = UIColor(red: 65/255, green: 103/255, blue: 41/255, alpha: 1.0)
            timelbl.font = FontHelper.defaultRegularFontWithSize(size: 13)
            timelbl.text = timimgArray[indexPath.row]["time_from"] as? String
            timelbl.font = FontHelper.defaultRegularFontWithSize(size: 14)
            cell.addSubview(timelbl)
//            cell.timelbl.text = timimgArray[indexPath.row]["time_from"] as? String
//            cell.timelbl.font = FontHelper.defaultRegularFontWithSize(size: 14)
            // The row value is the same as the index of the desired text within the array.
            
            return cell
        }
        
        // MARK: - UICollectionViewDelegate protocol
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            // handle tap events
            print("You selected cell #\(indexPath.item)!")
            let userInfo = [ "time" : indexPath.row] as [String : Any]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "timeselect"), object: userInfo)
            DismissView()
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let noOfCellsInRow = 3

            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

            let totalSpace = flowLayout.sectionInset.left
                + flowLayout.sectionInset.right
                + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

            let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))

            return CGSize(width: size, height: 50)
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
