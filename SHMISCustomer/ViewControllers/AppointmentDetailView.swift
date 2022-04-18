//
//  AppointmentDetailView.swift
//  SHMISCustomer
//
//  Created by admin on 24/03/22.
//

import UIKit
import Parchment


struct CalendarItem: PagingItem, Hashable, Comparable {
    let date: Date
    let dateText: String
    let weekdayText: String
    let monthlyText: String

    init(date: Date) {
        self.date = date
        dateText = DateFormatters.dateFormatter.string(from: date)
        weekdayText = DateFormatters.weekdayFormatter.string(from: date)
        monthlyText = DateFormatters.monthlyFormatter.string(from: date)
    }

    static func < (lhs: CalendarItem, rhs: CalendarItem) -> Bool {
        return lhs.date < rhs.date
    }
}


class AppointmentDetailView: UIViewController, DashBoardConnectionDeligate, UITableViewDelegate {
    
    func didFinishDashBoardConnection_Logout(_ responceData: NSMutableArray) {
        guard let windowScene = (self.view.window!.windowScene) else { return }
               window = UIWindow(frame: UIScreen.main.bounds)
               let home = Login()
               self.window?.rootViewController = home
               window?.makeKeyAndVisible()
               window?.windowScene = windowScene
    }
    
    func didFinishDashBoardConnection_Dictionary(_ responceData: NSMutableDictionary) {
        
    }
    
    func didFinishDashBoardConnection_Array(_ responceData: NSMutableArray) {
        
    }
    
    
    @IBOutlet weak var headview: UIView!
    var deptID = ""
    var doctorID = ""
    var date = ""
    var window: UIWindow?

    override func viewDidLoad() {
        super.viewDidLoad()
        let pagingViewController = PagingViewController()
        pagingViewController.register(CalendarPagingCell.self, for: CalendarItem.self)
        pagingViewController.menuItemSize = .fixed(width: 48, height: 88)
        pagingViewController.textColor = UIColor.gray

        // Add the paging view controller as a child view
        // controller and constrain it to all edges
        addChild(pagingViewController)
        view.addSubview(pagingViewController.view)
        view.constrainToEdges(pagingViewController.view, top: headview.frame.origin.y + headview.frame.size.height + 20)
        pagingViewController.didMove(toParent: self)

        // Set our custom data source
        pagingViewController.infiniteDataSource = self

        // Set the current date as the selected paging item
        pagingViewController.select(pagingItem: CalendarItem(date: Date()))
        
        pagingViewController.selectedScrollPosition = .left
       
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

extension AppointmentDetailView: PagingViewControllerInfiniteDataSource {
    func pagingViewController(_: PagingViewController, itemAfter pagingItem: PagingItem) -> PagingItem? {
        let calendarItem = pagingItem as! CalendarItem
        return CalendarItem(date: calendarItem.date.addingTimeInterval(86400))
    }

    func pagingViewController(_: PagingViewController, itemBefore pagingItem: PagingItem) -> PagingItem? {
        let calendarItem = pagingItem as! CalendarItem
        return CalendarItem(date: calendarItem.date.addingTimeInterval(-86400))
    }

    func pagingViewController(_: PagingViewController, viewControllerFor pagingItem: PagingItem) -> UIViewController {
        let calendarItem = pagingItem as! CalendarItem
        let formattedDate = DateFormatters.perfectFormatter.string(from: calendarItem.date)
        let viewController = AppointmentTableView()
        viewController.page = 1
        viewController.deptID = deptID
        viewController.doctorID = doctorID
        viewController.date = formattedDate
//        viewController.tableView.delegate = self
        return viewController
    
    }
}



