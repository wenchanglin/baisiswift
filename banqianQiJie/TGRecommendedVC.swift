//
//  TGRecommendedVC.swift
//  banqianQiJie
//
//  Created by banbo on 2017/8/9.
//  Copyright © 2017年 banbo. All rights reserved.
//

import UIKit
import SDCycleScrollView
import SDWebImage
import MJRefresh
class TGRecommendedVC: CeShi,SDCycleScrollViewDelegate {
    var imageArray: [Any] = ["http://img.spriteapp.cn/spritead/20170531/185026958423.jpg", "http://img.spriteapp.cn/spritead/20170531/185139989275.jpg", "http://img.spriteapp.cn/spritead/20170531/185540702503.jpg", "http://img.spriteapp.cn/spritead/20170612/194445627195.jpg", "http://img.spriteapp.cn/spritead/20170531/185217240322.jpg"]
    var adScrollView:SDCycleScrollView!
    override func requestUrl(nextPage: NSNumber) -> String {
        return String(format: "http://s.budejie.com/topic/list/jingxuan/1/bs0315-iphone-4.5.6/%@-20.json", nextPage)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        topics = NSMutableArray.init()
        createTableView()
        testFPSLabel()
        setupRefresh()
    }
    override func testFPSLabel()
    {
        let fpsLabel = YYFPSLabel()
        self.view.addSubview(fpsLabel)
        fpsLabel.mas_makeConstraints { (make) in
            make?.top.equalTo()(self.view)?.offset()(15)
            make?.right.equalTo()(self.view)?.offset()(-40)
            make?.width.mas_equalTo()(50)
            make?.height.mas_equalTo()(30)
        }
    }
    override func createTableView()
    {
        self.automaticallyAdjustsScrollViewInsets = false
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screen_width, height: screen_height-64-49),style:.grouped)
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
    }
    override func setupRefresh() {
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(CeShi.getNetworkData))
        tableView.mj_header.isAutomaticallyChangeAlpha = true
        tableView.mj_header.beginRefreshing()
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(CeShi.loadMoreTopics))
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        adScrollView = SDCycleScrollView(frame: CGRect(x:0,y:0,width:screen_width,height:200), imageURLStringsGroup: imageArray)
        adScrollView.delegate = self
        return adScrollView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        printLog(message: "你点击了第\(index)张")
    }
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
}

