//
//  TGEssenceNewVC.swift
//  banqianQiJie
//
//  Created by banbo on 2017/8/9.
//  Copyright © 2017年 banbo. All rights reserved.
//

import UIKit

class TGEssenceNewVC: UIViewController {
    var sksNavVC:SKScNavViewController! = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        let vc1 = TGRecommendedVC()
        vc1.title = "推荐"
        let vc2 = TGLookingAroundVC()
        vc2.title = "随听"
        let vc3 = TGVideoPlayVC()
        vc3.title = "视频"
        let vc4 = TGPictureVC()
        vc4.title = "图片"
        let vc5 = TGJokesVC()
        vc5.title = "段子"//
        let vc6 = TGRankingVC()
        vc6.title = "排行"//
        let vc7 = TGInteractVC()
        vc7.title = "互动区"//
        let vc8 = TGRedNetVC()
        vc8.title = "网红"//
        let vc9 = TGSocietyVC()
        vc9.title = "社会"//
        let vc10 = TGVoteVC()
        vc10.title = "投票"//
        let vc11 = TGBeautyVC()
        vc11.title = "美女"//
        let vc12 = TGColdKnowledgeVC()
        vc12.title = "冷知识"
        let vc13 = TGGameVC()
        vc13.title = "游戏"
        sksNavVC = SKScNavViewController(subViewControllers: [vc1, vc2, vc3, vc4, vc5, vc6, vc7,vc8,vc9,vc10,vc11,vc12,vc13])
        sksNavVC.showArrowButton = false//默认是true
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
       override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
