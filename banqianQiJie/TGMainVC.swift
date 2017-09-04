//
//  TGMainVC.swift
//  banqianQiJie
//
//  Created by banbo on 2017/8/9.
//  Copyright © 2017年 banbo. All rights reserved.
//

import UIKit

class TGMainVC: UITabBarController,UITabBarControllerDelegate {
    override func loadView() {
        super.loadView()
        let item = UITabBarItem.appearance()
        var attrsSelected = [AnyHashable: Any]()
        attrsSelected[NSForegroundColorAttributeName] = UIColor.black
        item.setTitleTextAttributes(attrsSelected as? [String : Any] ?? [String : Any](), for: .selected)
        self.delegate = self
        var attrsNormal = [AnyHashable: Any]()
        attrsNormal[NSFontAttributeName] = UIFont.systemFont(ofSize: 12)
        item.setTitleTextAttributes(attrsNormal as? [String : Any] ?? [String : Any](), for: .normal)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.cyan
        setupAllChildVC()
        setupTabBar()
    }
    func setupAllChildVC()
    {
        let essenceVc = TGNavigationVC(rootViewController: TGEssenceNewVC())
        essenceVc.tabBarItem.title = "精华"
        essenceVc.tabBarItem.image = UIImage(named: "tabBar_essence_icon")
        essenceVc.tabBarItem?.selectedImage = imageOriginalWithName(imageName:"tabBar_essence_click_icon")
        let newVC = TGNavigationVC(rootViewController: TGNewestVC())
        newVC.tabBarItem?.title = "新帖"
        newVC.tabBarItem?.image = UIImage(named: "tabBar_new_icon")
        newVC.tabBarItem?.selectedImage = imageOriginalWithName(imageName: "tabBar_new_click_icon")
        let ftVC = TGNavigationVC(rootViewController: TGFriendTrendVC())
        ftVC.tabBarItem?.title = "关注"
        ftVC.tabBarItem?.image = UIImage(named: "tabBar_friendTrends_icon")
        ftVC.tabBarItem?.selectedImage = imageOriginalWithName(imageName: "tabBar_friendTrends_click_icon")
        let meVC = TGNavigationVC(rootViewController: TGMeVC())
        meVC.tabBarItem?.title = "我"
        meVC.tabBarItem?.image = UIImage(named: "tabBar_me_icon")
        meVC.tabBarItem.selectedImage = imageOriginalWithName(imageName: "tabBar_me_click_icon")
        self.viewControllers = [essenceVc,newVC,ftVC,meVC]
        
    }
   
    func setupTabBar()
    {
        let tabbar:TGTabBar = TGTabBar()
        self.setValue(tabbar, forKey: "tabBar")
        self.tabBar.backgroundImage = UIImage(named: "tabbar-light")
    }
       override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  

}
