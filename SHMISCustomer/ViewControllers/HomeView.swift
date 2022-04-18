//
//  HomeView.swift
//  Utility
//
//  Created by admin on 15/03/21.
//

import UIKit
import ImageSlideshow
import Reachability
class HomeView: UIViewController{
    
    @IBOutlet weak var headView: UIView!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var sliderView: ImageSlideshow!
    private var myColor = AppColors()
    let localSource = [BundleImageSource(imageString: "slider_1"), BundleImageSource(imageString: "slider_2"), BundleImageSource(imageString: "slider_3"), BundleImageSource(imageString: "slider_4")]
    let reachability = try! Reachability()
    
    @IBOutlet weak var sliderCollection: UICollectionView!
    
    
    @IBOutlet weak var bookAppointmentBtn: UIButton!
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    
    var content = [["heading": "SMART-HMIS", "description": "An easy-to-use innovation technology platform for Hospital Automation"],["heading": "WHAT SMART-HMIS PROVIDES ?", "description": "Enhance productivity with real-time analytics"],["heading": "WHAT SMART-HMIS PROVIDES ?", "description": "Well versed patient management system to accomodate new patients"],["heading": "WHAT SMART-HMIS PROVIDES ?", "description": "Achieve operational efficiency with seamless and transparent communication with diifferent departments"]]
    
    func registerNib() {
        let nib = UINib(nibName: CollectionViewCell.nibName, bundle: nil)
        sliderCollection?.register(nib, forCellWithReuseIdentifier: CollectionViewCell.reuseIdentifier)
        if let flowLayout = self.sliderCollection?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
        }
    }
    
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
        registerNib()
        CustomView()
        initializeImageSlider()
        startTimer()
        NotificationCenter.default.addObserver(self, selector: #selector(self.Logout(_:)), name: NSNotification.Name(rawValue: "Logout"), object: nil)

    }
    
    @objc func Logout(_ notification: NSNotification) {
       
     }
    
    func CustomView() {
        let demoview = UIView(frame: CGRect(x: 0, y: headView.frame.size.height - 20, width: headView.frame.size.width, height: 20))
        demoview.backgroundColor = UIColor(red: 235/255, green: 51/255, blue: 35/255, alpha: 1.0)
        
        let lbltitle = UILabel(frame: CGRect(x: 20 , y: 0, width: demoview.frame.size.width - 40, height: 20))
        lbltitle.textAlignment = .center
        lbltitle.numberOfLines = 1
        lbltitle.textColor = UIColor.white
        lbltitle.text = "TEST VERSION : \(appVersion)(202.88.244.166:3412/hmis_msm/web/app.php)"
        lbltitle.font = FontHelper.defaultRegularFontWithSize(size: 10)
        demoview.addSubview(lbltitle)
        headView.addSubview(demoview)
        
       
       

        bookAppointmentBtn.titleLabel?.font = FontHelper.defaultRegularFontWithSize(size: 15)
        bookAppointmentBtn.layer.cornerRadius = 10.0
        bookAppointmentBtn.layer.insertSublayer(AppColors.gradientBg(view: bookAppointmentBtn, colorArray: [UIColor(red: 35/255, green: 14/255, blue: 52/255, alpha: 1.0).cgColor, UIColor(red: 151/255, green: 37/255, blue: 54/255, alpha: 1.0).cgColor], locationArray: [0.0, 0.5], isVertical: true, startpoint: CGPoint(x: 0, y: 0.5), endpoint: CGPoint(x: 1, y: 0.5), cornerradius: 10.0), at: 0)
       
       
        
    }
    
    func initializeImageSlider(){
        sliderView.slideshowInterval = 3.0
        sliderView.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        sliderView.contentScaleMode = UIViewContentMode.scaleAspectFill

        sliderView.pageIndicator = .none

        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        sliderView.activityIndicator = DefaultActivityIndicator()
        sliderView.delegate = self

        // can be used with other sample sources as `afNetworkingSource`, `alamofireSource` or `sdWebImageSource` or `kingfisherSource`
        sliderView.setImageInputs(localSource)

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(HomeView.didTap))
        sliderView.addGestureRecognizer(recognizer)
    }
    
    
    @objc func didTap() {
//        let fullScreenController = sliderView.presentFullScreenController(from: self)
//        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
//        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
    
    func startTimer() {

        var timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(HomeView.scrollToNextCell), userInfo: nil, repeats: true)
       }
    

    @objc func scrollToNextCell(){

           //get cell size
           let cellSize = CGSize(width: sliderCollection.frame.width - 40, height: sliderCollection.frame.height);

           //get current content Offset of the Collection view
           let contentOffset = sliderCollection.contentOffset;

           //scroll to next cell
        sliderCollection.scrollRectToVisible(CGRect(x: contentOffset.x + cellSize.width, y: contentOffset.y, width: cellSize.width, height: cellSize.height), animated: true);


       }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewHeight = Float(scrollView.frame.size.width)
        let scrollContentSizeHeight = Float(scrollView.contentSize.width)
        let scrollOffset = Float(scrollView.contentOffset.x)

        if scrollOffset == 0 {
            // then we are at the top
           
        } else if scrollOffset + scrollViewHeight == scrollContentSizeHeight {
            // then we are at the end
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { [self] timer in
                sliderCollection.setContentOffset(CGPoint.zero, animated: true)
            }
            
        }
    }
      
    @IBAction func logout_Evnt(_ sender: Any) {
        
      
    }
        

func myHandler(alert: UIAlertAction){
    UserDefaults.standard.set(false, forKey: "islogin")
    UserDefaults.standard.set("", forKey: "Username")
    UserDefaults.standard.set("", forKey: "accessToken")
    UserDefaults.standard.set("", forKey: "RefreshToken")
    UserDefaults.standard.set(false, forKey: "PublicNetwork")
    if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as? Login {
               if let navigator = navigationController {
                   navigator.pushViewController(viewController, animated: true)
               }
           }
}
    
    @IBAction func appointmentEvnt(_ sender: Any) {
        bookAppointmentBtn.titleLabel?.font = FontHelper.defaultRegularFontWithSize(size: 15)
        bookAppointmentBtn.layer.cornerRadius = 10.0
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BookVC") as? BookAppointmentView {
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


extension HomeView: ImageSlideshowDelegate {
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        print("current page:", page)
    }
}


extension HomeView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return content.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseIdentifier,
                                                         for: indexPath) as? CollectionViewCell {
            let heading = content[indexPath.row]["heading"]
            let description = content[indexPath.row]["description"]
            cell.configureCell(heading: heading!,description: description!)
            return cell
        }
        return UICollectionViewCell()
    }
}


extension HomeView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cell: CollectionViewCell = Bundle.main.loadNibNamed(CollectionViewCell.nibName,
                                                                      owner: self,
                                                                      options: nil)?.first as? CollectionViewCell else {
            return CGSize.zero
        }
        cell.configureCell(heading: content[indexPath.row]["heading"]!, description: content[indexPath.row]["description"]!)
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
       // let size: CGSize = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return CGSize(width: cell.textview.frame.size.width, height: 100)
    }
}

