//
//  ContainController.swift
//  RootTabBarController
//
//  Created by mac on 2019/6/14.
//  Copyright © 2019年 mac. All rights reserved.
//

import UIKit
import SnapKit
private let is_iphoneX = (UIScreen.main.bounds.height >= 812.0)
class ContainController: UIViewController {

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.backgroundColor = UIColor.purple
        tableView.dataSource = self
        tableView.delegate = self
        if #available(iOS 10.0, *) {
            let refresh =  UIRefreshControl()
            refresh.tintColor = UIColor.green
            refresh.attributedTitle = NSAttributedString.init(string: "reload...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.green])
            tableView.refreshControl = refresh
            tableView.refreshControl?.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
        }
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ChildOneVC --------")
        //view.backgroundColor = UIColor.green
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    
        view.addSubview(self.tableView)
        layoutTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func getCurrentVC() -> MainController? {
        var next = view.superview
        while (next != nil) {
            let nextResponder = next?.next
            if (nextResponder is MainController) {
                return nextResponder as? MainController
            }
            next = next?.superview
        }
        return nil
    }
  
    // MARK: Actions
    @objc func refreshHandler() {
        let deadlineTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: { [weak self] in
            if #available(iOS 10.0, *) {
                self?.tableView.refreshControl?.endRefreshing()
            }
            self?.tableView.reloadData()
        })
    }
    
}

extension ContainController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 108
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 18
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "cellID"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellID)
        }
        cell?.textLabel?.text = "cellId \(indexPath.row)"
        cell?.backgroundColor = UIColor.clear
        cell?.contentView.backgroundColor = UIColor.clear
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = getCurrentVC()
        vc?.navigationController?.pushViewController(FindController(), animated: true)
       
    }
}

extension ContainController: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollView.offsetY = \(scrollView.contentOffset.y)  === \(scrollView.contentSize.height)  ==== cha >\(scrollView.contentSize.height - scrollView.contentOffset.y) ==== screenH == \(screenHeight)")
        if scrollView.contentSize.height - scrollView.contentOffset.y <= screenHeight {
             print("reload - more data")
        }
    }
}

extension ContainController {
    func layoutTableView() {
        let statuBarHeight = UIApplication.shared.statusBarFrame.height
        let tabBarHeight: CGFloat = 49
        let bottomM = is_iphoneX ? (tabBarHeight + safeAreaBottomHeight + 1) : tabBarHeight + 8  // 84 86
        let topMa = is_iphoneX ? statuBarHeight + 42 : statuBarHeight + 35
        tableView.snp.makeConstraints { (make) in
           make.top.equalTo(topMa)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(-bottomM)
        }
    }

}
