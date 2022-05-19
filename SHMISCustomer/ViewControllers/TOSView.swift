//
//  TOSView.swift
//  SHMISCustomer
//
//  Created by admin on 16/05/22.
//

import UIKit
import WebKit
import Reachability
class TOSView: UIViewController, WKNavigationDelegate {
    
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var actyind: UIActivityIndicatorView!
    @IBOutlet weak var loadingView: UIView!
    var TOSurl = ""
    var mainView = UIView()
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
        webView.isHidden = true
        setData()
    }
    
    func setData(){
         TOSurl = "\(UserDefaults.standard.string(forKey: "tosLink")!)"
        if TOSurl.count != 0 {
            webView.isHidden = false
            loadLink(Stringurl: TOSurl)
        }else{
            loadingView.isHidden = true
            actyind.isHidden = true
            webView.isHidden = true
            mainView = UIView(frame: CGRect(x: 0 , y: 159, width: view.frame.size.width, height: view.frame.size.height-159))
            mainView.backgroundColor = .white
            let img_notFound = UIImageView(frame: CGRect(x: mainView.frame.size.width/2 - 35 , y: mainView.frame.size.height/2 - 35, width: 70, height: 70))
            img_notFound.image = UIImage(named: "NotFount.png")
            
            let lbl_notFound = UILabel(frame: CGRect(x: view.frame.size.width/2 - 75 , y: img_notFound.frame.origin.y + img_notFound.frame.size.height + 10, width: 150, height: 50))
            lbl_notFound.textAlignment = .center
            lbl_notFound.numberOfLines = 1
            lbl_notFound.textColor = UIColor(red: 241/255, green: 151/255, blue: 142/255, alpha: 1.0)
            lbl_notFound.font = FontHelper.defaultBoldFontWithSize(size: 14)
            lbl_notFound.text = "Sorry, No data found..!"
            
            mainView.addSubview(img_notFound)
            mainView.addSubview(lbl_notFound)
            view.addSubview(mainView)
        }
    }
    
    
    func loadLink(Stringurl: String) {
        webView.backgroundColor = .white
        webView.scrollView.bounces = false
        webView.navigationDelegate = self
        let url : NSURL! = NSURL(string: "\(Stringurl)")
        webView.load(NSURLRequest(url: url as URL) as URLRequest)
        webView.allowsBackForwardNavigationGestures = true
    }
    
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!)
    {
        print(#function)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
    {
        loadingView.isHidden = true
        actyind.isHidden = true
        webView.evaluateJavaScript("navigator.userAgent", completionHandler: { result, error in

            if let userAgent = result as? String {
                print(userAgent)
            }
        })
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
