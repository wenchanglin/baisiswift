//
//  TGCommentNewVC.swift
//  banqianQiJie
//
//  Created by banbo on 2017/8/15.
//  Copyright © 2017年 banbo. All rights reserved.
//

import UIKit
import MJRefresh
import MJExtension
class TGCommentNewVC: UIViewController,huiShouViewDelegate {
    public var topic:ceShiModel!
    var latestComments:NSMutableArray! //[TGCommentNewM]()
    var hotestComments:NSMutableArray! //[TGCommentNewM]()
    var tableV:UITableView!
    var np:NSNumber!
    var shuru:shuRuView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "评论"
        self.latestComments = NSMutableArray()
        self.hotestComments = NSMutableArray()
        NotificationCenter.default.addObserver(self, selector: #selector(TGCommentNewVC.KeyboardWillChangeFrame(not:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        createTableView()
        createInputView()
        loadNewTopics()
        setupRefresh()
        
    }
    func createInputView()
    {
        shuru = shuRuView()
        shuru.delgate = self
        self.view.addSubview(shuru)
        shuru.mas_makeConstraints { (make) in
            make?.bottom.equalTo()(self.view)
            make?.width.equalTo()(self.view)
            make?.height.equalTo()(40)
        }
    }
    func huiShouFrame(textfield: UITextField!) {
        shuru.mas_updateConstraints { (make) in
            make?.bottom.equalTo()(self.view)
            make?.width.equalTo()(self.view)
            make?.height.equalTo()(40)
        }
        textfield.resignFirstResponder()
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        shuru.mas_updateConstraints { (make) in
            make?.bottom.equalTo()(self.view)
            make?.width.equalTo()(self.view)
            make?.height.equalTo()(40)
        }
        shuru.textF.resignFirstResponder()
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        shuru.mas_updateConstraints { (make) in
            make?.bottom.equalTo()(self.view)
            make?.width.equalTo()(self.view)
            make?.height.equalTo()(40)
        }
        shuru.textF.resignFirstResponder()
    }
    
    func KeyboardWillChangeFrame(not:Notification)
    {
        //let kbY: CGFloat = (not.userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.origin.y
        //printLog(message: kbY)
        shuru.mas_updateConstraints { (make) in
            make?.bottom.equalTo()(self.view.mas_bottom)?.offset()(-250)
            make?.width.equalTo()(self.view)
        }
        
    }
    func createTableView()
    {
        self.automaticallyAdjustsScrollViewInsets = false
        tableV = UITableView(frame: CGRect(x: 0, y: 64, width: screen_width, height: screen_height-64-41    ),style:.plain)
        tableV.dataSource = self
        tableV.delegate = self
        tableV.backgroundColor = TGColor(r: 244, g: 244, b: 244)
        tableV.tableFooterView = UIView()
        self.view.addSubview(tableV)
    }
    func setupRefresh()
    {
        tableV.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(TGCommentNewVC.loadNewTopics))
        tableV.mj_header.isAutomaticallyChangeAlpha = true
        tableV.mj_header.beginRefreshing()
        tableV.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(TGCommentNewVC.loadMoreComment))
    }
    func loadNewTopics()
    {
        NetTool.shareInstance.requset(requestType: .Get, url: requestPingLunUrl(topicId: topic.id, string: 0, nextpage: 0), parameters: [:]) { (responseObject, error) in
           
           let newArray = TGCommentNewM.mj_objectArray(withKeyValuesArray:((responseObject! as NSDictionary).object(forKey: "normal") as! NSDictionary).object(forKey: "list"))
            newArray?.enumerateObjects({ (obj, idx, stop) in
                if ((obj as! TGCommentNewM).type!) == "html"
                {
                    newArray?.remove(obj)
                }
            })
            
            let hoteArray = TGCommentNewM.mj_objectArray(withKeyValuesArray:((responseObject! as NSDictionary).object(forKey: "hot") as! NSDictionary).object(forKey: "list"))
            hoteArray?.enumerateObjects({ (obj, idx, stop) in
                if ((obj as! TGCommentNewM).type!) == "html"
                {
                    hoteArray?.remove(obj)
                }
            })
            self.latestComments.addObjects(from: newArray as! [Any])
            self.hotestComments.addObjects(from: hoteArray as! [Any])
            self.tableV.reloadData()
            self.tableV.mj_header.endRefreshing()
            let total = ((((responseObject! as NSDictionary).object(forKey: "normal") as! NSDictionary).object(forKey: "info")as! NSDictionary).object(forKey: "count") as! NSNumber).intValue
            if ((((responseObject! as NSDictionary).object(forKey: "normal") as! NSDictionary).object(forKey: "info")as! NSDictionary).object(forKey: "count") != nil)
            {
                self.np = (((responseObject! as NSDictionary).object(forKey: "normal") as! NSDictionary).object(forKey: "info")as! NSDictionary).object(forKey: "count") as! NSNumber
            }
            self.tableV.mj_footer.isHidden = self.latestComments.count >= total
        }
    }
    func loadMoreComment()
    {
        NetTool.shareInstance.requset(requestType: .Get, url: requestPingLunUrl(topicId: topic.id,string:2,nextpage: np), parameters: [:]) { (responseObject, error) in
             let moreTopics = TGCommentNewM.mj_objectArray(withKeyValuesArray: ((responseObject! as NSDictionary).object(forKey: "normal") as! NSDictionary).object(forKey: "list"))
            moreTopics?.enumerateObjects({ (obj, idx, stop) in
                if ((obj as! TGCommentNewM).type!) == "html"
                {
                    moreTopics?.remove(obj)
                }
            })
            self.latestComments.addObjects(from:moreTopics as! [Any])
            self.tableV.reloadData()
            self.tableV.mj_footer.endRefreshing()
            
            let total = ((((responseObject! as NSDictionary).object(forKey: "normal") as! NSDictionary).object(forKey: "info")as! NSDictionary).object(forKey: "count") as! NSNumber).intValue
            if !((((responseObject! as NSDictionary).object(forKey: "normal") as! NSDictionary).object(forKey: "info")as! NSDictionary).object(forKey: "np") is NSNull)
            {
                self.np = (((responseObject! as NSDictionary).object(forKey: "normal") as! NSDictionary).object(forKey: "info")as! NSDictionary).object(forKey: "np") as! NSNumber
            }
            
            self.tableV.mj_footer.isHidden = self.latestComments.count >= total
            
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
       override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension TGCommentNewVC:UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1
        {
            return self.hotestComments.count
        }
        else if section == 2
        {
            return self.latestComments.count
        }
        else //第0行
        {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section==1||section==2
        {
            return 20
        }
        else
        {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let uiview = UIView(frame:CGRect(x: 0, y: 0, width: screen_width, height: 20))
        view.backgroundColor = TGColor(r: 241, g: 241, b: 241)
        if section == 1
        {
            let label1 = UILabel(frame: CGRect(x: 10, y: 0, width: 100, height: 20))
            label1.font = UIFont.systemFont(ofSize: 10)
            label1.text = "最热评论"
            label1.textColor = TGColor(r: 90, g: 90, b: 85)
            uiview.addSubview(label1)
        }
        else if section == 2
        {
            let label1 = UILabel(frame: CGRect(x: 10, y: 0, width: 100, height: 20))
            label1.font = UIFont.systemFont(ofSize: 10)
            label1.textColor = TGColor(r: 90, g: 90, b: 85)
            label1.text = "最新评论"
            uiview.addSubview(label1)
        }
        return uiview
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cellIdentifier = "zuireCell"
            let cell = TGCommentNewCell(style:.default,reuseIdentifier:cellIdentifier)
            cell.commentM = self.hotestComments.object(at:indexPath.row) as! TGCommentNewM
            let textSizes = CGSize(width:screen_width-40,height:CGFloat(MAXFLOAT));
            let textSize:CGSize = cell.commentM.content.boundingRect(with: textSizes, options: .usesLineFragmentOrigin, attributes: [
                NSFontAttributeName : UIFont.systemFont(ofSize: 11)], context: nil).size
            if((self.hotestComments.object(at:indexPath.row) as! TGCommentNewM).videouri != nil || (self.hotestComments.object(at:indexPath.row) as! TGCommentNewM).image != nil)
            {
            tableView.rowHeight = textSize.height + 40 + 200
            }
            else if((self.hotestComments.object(at:indexPath.row) as! TGCommentNewM).voiceuri != nil)
            {
            tableView.rowHeight = textSize.height + 40 + 10
            }
            else
            {
            tableView.rowHeight = textSize.height + 40
            }
            return cell
        }
        else if(indexPath.section==2)
        {
            let cellIdentifier = "zuixinCell"
            let cell = TGCommentNewCell(style:.default,reuseIdentifier:cellIdentifier)
            cell.commentM = self.latestComments.object(at:indexPath.row) as! TGCommentNewM
            let textSizes         = CGSize(width:screen_width-40,height:CGFloat(MAXFLOAT));
            let textSize:CGSize = cell.commentM.content.boundingRect(with: textSizes, options: .usesLineFragmentOrigin, attributes: [
                NSFontAttributeName : UIFont.systemFont(ofSize: 11)], context: nil).size
            if((self.latestComments.object(at:indexPath.row) as! TGCommentNewM).videouri != nil || (self.latestComments.object(at:indexPath.row) as! TGCommentNewM).image != nil)
            {
                tableView.rowHeight = textSize.height + 40 + 200
            }
            else if((self.latestComments.object(at:indexPath.row) as! TGCommentNewM).voiceuri != nil)
            {
                tableView.rowHeight = textSize.height + 40 + 10
            }
            else
            {
                tableView.rowHeight = textSize.height + 40
            }
            return cell
        }
        else
        {
            let cellIdentifier = "pinglunCell"
            let cell = QQTableViewCell(style: .default, reuseIdentifier: cellIdentifier)//pinglunCell(style: .default, reuseIdentifier: cellIdentifier)
            cell.clickedCommentButtonCallback = {(topic:String)->Void in
                
            }
            cell.clickedReCommentCallback = {(topic:String)->Void in
                
            }
            cell.ceshiModel = self.topic
            let textSizes = CGSize(width:screen_width-40,height:CGFloat(MAXFLOAT));
            let textSize:CGSize = cell.ceshiModel.text.boundingRect(with: textSizes, options: .usesLineFragmentOrigin, attributes: [
                NSFontAttributeName : UIFont.systemFont(ofSize: 11)], context: nil).size
            if(cell.ceshiModel.type == "image" || cell.ceshiModel.type == "gif")
            {
                tableView.rowHeight = cell.cellHeight + textSize.height + 5
            }
            else if(cell.ceshiModel.type == "video")
            {
                tableView.rowHeight = cell.cellHeight + textSize.height
            }
            else //text||voice
            {
                if cell.cellHeight == nil
                {
                    tableView.rowHeight = textSize.height + 100
                }
                else
                {
                    tableView.rowHeight = textSize.height + cell.cellHeight // +60
                }
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.responds(to: #selector(getter: cell.separatorInset)){
        cell.separatorInset = .zero
        }
        if cell.responds(to: #selector(getter: cell.layoutMargins)) {
        cell.layoutMargins = .zero
        }
    }
}
