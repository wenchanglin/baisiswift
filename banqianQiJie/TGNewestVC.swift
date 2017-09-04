//
//  TGNewestVC.swift
//  banqianQiJie
//
//  Created by banbo on 2017/8/9.
//  Copyright © 2017年 banbo. All rights reserved.
//

import UIKit

class TGNewestVC: UIViewController {
    var sksNavVC:SKScNavViewController! = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        let vc1 = CeShi()//TGNewestTotalVC()
        vc1.title = "全部"
        let vc2 = TGNewestVideoVC()
        vc2.title = "视频"
        let vc3 = TGNewPicVC()
        vc3.title = "图片"
        let vc4 = TGNewestJokesVC()
        vc4.title = "段子"//
        let vc5 = TGNewestInteractVC()
        vc5.title = "互动区"//
        let vc6 = TGNewestAlbumVC()
        vc6.title = "相册"//
        let vc7 = TGNewestRedNetVC()
        vc7.title = "网红"//
        let vc8 = TGNewestVoteVC()
        vc8.title = "投票"//
        let vc9 = TGBeautyVC()
        vc9.title = "美女"//
        let vc10 = TGColdKnowledgeVC()
        vc10.title = "冷知识"
        let vc11 = TGGameVC()
        vc11.title = "游戏"
        let vc12 = TGNewestSoundsVC()
        vc12.title = "声音"//
       
        sksNavVC = SKScNavViewController(subViewControllers: [vc1,vc2,vc3, vc4, vc5, vc6, vc7,vc8,vc9,vc10,vc11,vc12])
        sksNavVC.scNavBarColor = TGColor(r: 252, g: 49, b: 89)
        sksNavVC.lineColor = UIColor.white
        sksNavVC.addParentController(self)
        setupNavBar()
    }
    func setupNavBar()
    {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "nav_item_game_icon-1", highImageName: "nav_item_game_click_icon-1", target: self, action: #selector(TGEssenceNewVC.test))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "RandomAcross", highImageName: "RandomAcrossClick", target: self, action: #selector(TGEssenceNewVC.randomAcross))
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "MainTitle"))
    }
    func test()
    {
        printLog(message: "你点击了左边item", logError: true)
    }
    func randomAcross()
    {
        printLog(message: "你点击了右边item", logError: true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: AcrossEssenceNotification), object: nil)
    }

}
