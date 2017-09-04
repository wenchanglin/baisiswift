//
//  TGFriendTrendVC.swift
//  banqianQiJie
//
//  Created by banbo on 2017/8/9.
//  Copyright © 2017年 banbo. All rights reserved.
//

import UIKit

class TGFriendTrendVC: UIViewController {
    var imageV:UIImageView!
    var mainLabel:UILabel!
    var loginBtn:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"friendsRecommentIcon"), highImage: UIImage(named:"friendsRecommentIcon-click"), target: self, action: #selector(TGFriendTrendVC.friendsRecomment))
        imageV = UIImageView()
        imageV.image = UIImage(named: "header_cry_icon")
        self.view.addSubview(imageV)
        imageV.mas_makeConstraints { (make) in
            make?.top.equalTo()(self.view)?.equalTo()(200)
            make?.centerX.equalTo()(self.view)
        }
        mainLabel = UILabel()
        mainLabel.textColor = UIColor.darkGray
        mainLabel.font = UIFont.systemFont(ofSize: 12)
        mainLabel.numberOfLines = 0
        mainLabel.textAlignment = .center
        mainLabel.text = "快快登录吧,关注百思最in牛人\n  好友动态让你过把瘾儿\n    欧耶~~~"
        self.view.addSubview(mainLabel)
        mainLabel.mas_makeConstraints { (make) in
            make?.top.equalTo()(self.imageV.mas_bottom)?.offset()(10)
            make?.centerX.equalTo()(self.view)
        }
        loginBtn = UIButton()
        loginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        loginBtn.setTitle("立即登录", for: .normal)
        loginBtn.setTitleColor(UIColor.orange, for: .normal)
        loginBtn.layer.cornerRadius = 2
        loginBtn.layer.masksToBounds = true
        loginBtn.layer.borderColor = UIColor.orange.cgColor
        loginBtn.addTarget(self, action: #selector(TGFriendTrendVC.loginRegister(sender:)), for: .touchUpInside)
        self.view.addSubview(loginBtn)
        loginBtn.mas_makeConstraints { (make) in
            make?.top.equalTo()(self.mainLabel.mas_bottom)?.offset()(10)
            make?.centerX.equalTo()(self.view)
        }
    }
    func loginRegister(sender:UIButton)
    {
    self.present(TGLoginRegisterVC(), animated: true, completion: nil)
    }
    func friendsRecomment()
    {
        let recommendVC = TGRecommendVC()
        self.navigationController?.pushViewController(recommendVC, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
