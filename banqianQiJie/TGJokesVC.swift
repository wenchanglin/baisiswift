//
//  TGJokesVC.swift
//  banqianQiJie
//
//  Created by banbo on 2017/8/9.
//  Copyright © 2017年 banbo. All rights reserved.
//

import UIKit

class TGJokesVC: TGVideoPlayVC {
    override func requestUrl(nextPage: NSNumber) -> String {
        return String(format: "http://s.budejie.com/topic/tag-topic/64/hot/bs0315-iphone-4.5.6/%@-20.json", nextPage)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
      //  loadNewTopics()
      //  loadMoreTopics()
        // Do any additional setup after loading the view.
    }
//    override func loadNewTopics() {
//        NetTool.shareInstance.requset(requestType: .Get, url:requestDuanZiUrl(nextPage: _np), parameters: [:]) { (response, error) in
//           // print("np:\(String(describing: ((response! as NSDictionary).object(forKey: "info") as! NSDictionary).object(forKey: "np")))")
//            self._np = ((response! as NSDictionary).object(forKey: "info") as! NSDictionary).object(forKey: "np") as! NSNumber
//            self.topics = TGTopicNewM.mj_objectArray(withKeyValuesArray: (response! as NSDictionary).object(forKey: "list"))
//            self.topics.enumerateObjects({ (obj, idx, stop) in
//                if ((obj as! TGTopicNewM).type!) == "html"
//                {
//                    self.topics.remove(obj)
//                }
//            })
//            self.tableView.reloadData()
//        }
//    }
//    override func loadMoreTopics() {
//       // self.tableView.mj_header.endRefreshing()
//        NetTool.shareInstance.requset(requestType: .Get, url: requestDuanZiUrl(nextPage: _np), parameters: [:]) { (response, error) in
//          //  print("np:\(String(describing: ((response! as NSDictionary).object(forKey: "info") as! NSDictionary).object(forKey: "np")))")
//            self._np = ((response! as NSDictionary).object(forKey: "info") as! NSDictionary).object(forKey: "np") as! NSNumber
//            let moreTopics = TGTopicNewM.mj_objectArray(withKeyValuesArray: (response! as NSDictionary).object(forKey: "list"))
//            moreTopics?.enumerateObjects({ (obj, idx, stop) in
//                if ((obj as! TGTopicNewM).type!) == "html"
//                {
//                    moreTopics?.remove(obj)
//                }
//            })
//            self.topics.addObjects(from: moreTopics as! [Any])
//            self.tableView.reloadData()
////            self.tableView.mj_footer.endRefreshing()
//        }
//        
//    }
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
