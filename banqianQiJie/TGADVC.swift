//
//  TGADVC.swift
//  banqianQiJie
//
//  Created by banbo on 2017/8/9.
//  Copyright © 2017年 banbo. All rights reserved.
//

import UIKit
import AFNetworking
import MJExtension

import DACircularProgress
class TGADVC: UIViewController {
    var item:TGAdModel!
    var timer:Timer!
    var launchImageView:UIImageView!
    var progressV:DALabeledCircularProgressView!
    override func viewDidLoad() {
        super.viewDidLoad()
        createadView()
        setupProgressView()
        setupLaunchImage()
        loadAdData()
        self.timer = Timer(timeInterval: 0.1, target: self, selector: #selector(TGADVC.timeChange), userInfo: [:], repeats: true)
        
    }
    func setupProgressView()
    {
        self.progressV.roundedCorners = 0
        self.progressV.progressLabel.textColor = UIColor.red
        self.progressV.trackTintColor = UIColor(colorLiteralRed: 242/255, green: 242/255, blue: 242/255, alpha: 1)
        //self.progressV.isHidden = true
        self.progressV.progressLabel.text = ""
        self.progressV.thicknessRatio = 0.1
        self.progressV.setProgress(0, animated: false)
    }
    func setupLaunchImage()
    {
        if iphone6P
        {
            self.launchImageView.image = UIImage(named: "LaunchImage-800-Portrait-736h@3x")
        }
        else if iphone6
        {
            self.launchImageView.image = UIImage(named:"LaunchImage-800-667h")
        }
        else if iphone5
        {
         self.launchImageView.image = UIImage(named:"LaunchImage-568h")
        }
        else if iphone4
        {
         self.launchImageView.image = UIImage(named:"LaunchImage-700")
        }
        else
        {
         self.launchImageView.image = UIImage(named: "LaunchImage-800-Portrait-736h@3x")
        }
    }
    func loadAdData()
    {
        let magr = AFHTTPSessionManager()
        magr.responseSerializer.acceptableContentTypes = ["text/html"]
        let parameter = NSMutableDictionary()
        parameter["code2"] = code2
        magr.get("http://mobads.baidu.com/cpro/ui/mads.php", parameters: parameter, progress: nil, success: { (task, response) in
           // print("chenggong:\(String(describing: response))")
            let adDict:NSDictionary = ((response as! NSDictionary).object(forKey: "ad") as! NSArray).lastObject as! NSDictionary
            self.item = TGAdModel.mj_object(withKeyValues: adDict)
            self.launchImageView.sd_setImage(with: URL(string: self.item.w_picurl!))
        }) { (task, error) in   
            //print("cuowu\(error)")
        }
    }
    
    func timeChange()
    {
        var i = 30.0
        self.progressV.isHidden = false
        let progress: CGFloat = CGFloat(1.0 * (30.0 - i + 1) / 30.0)
        self.progressV.setProgress(CGFloat(progress), animated: true)
        if i == 0
        {
            self.progressV.isHidden = true
            UIApplication.shared.keyWindow?.rootViewController = TGMainVC()
            TGPushGuideV.show()
            self.timer.invalidate()
        }
        i -= 1
    }
    func createadView()
    {
        
        launchImageView = UIImageView(frame: UIScreen.main.bounds)
        self.launchImageView.contentMode = .scaleToFill
        launchImageView.isUserInteractionEnabled = true
        self.view.addSubview(launchImageView)
        progressV = DALabeledCircularProgressView(frame: CGRect(x: screen_width-65, y: 75, width: 50, height: 50))
        launchImageView.addSubview(progressV)
        let jumpbutton = UIButton(frame: progressV.frame)
        jumpbutton .setTitle("跳过", for: .normal)
        jumpbutton.setTitleColor(UIColor.black, for: .normal)
        progressV.frame = jumpbutton.frame
        jumpbutton.addSubview(self.progressV)
        launchImageView.addSubview(jumpbutton)
        jumpbutton.addTarget(self, action: #selector(TGADVC.clickJump(btn:)), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(TGADVC.tap))
        launchImageView.addGestureRecognizer(tap)
        launchImageView.isUserInteractionEnabled = true
    }
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    func clickJump(btn:UIButton)
    {
        
        UIApplication.shared.keyWindow?.rootViewController = TGMainVC()
        TGPushGuideV.show()
        self.timer.invalidate()
    }
    func tap()
    {
        let url = NSURL(fileURLWithPath: self.item.ori_curl!)
        let app = UIApplication.shared
        if app.canOpenURL(url as URL)
        {
            app.openURL(url as URL)
        }
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
