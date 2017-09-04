//
//  TGInteractVC.swift
//  banqianQiJie
//
//  Created by banbo on 2017/8/9.
//  Copyright © 2017年 banbo. All rights reserved.
//

import UIKit

class TGInteractVC: TGVideoPlayVC {
    override func requestUrl(nextPage: NSNumber) -> String {
        return String(format: "http://s.budejie.com/topic/tag-topic/44289/hot/bs0315-iphone-4.5.6/%@-20.json", nextPage)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
