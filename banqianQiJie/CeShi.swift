//
//  ceshi.swift
//  banqianQiJie
//
//  Created by banbo on 2017/8/24.
//  Copyright © 2017年 banbo. All rights reserved.
//

import UIKit
import MJRefresh
class CeShi: UIViewController {
    var np:NSNumber!
    var currentCell:QQTableViewCell!
    var wmPlayer:WMPlayer!
    var currentIndexPath:NSIndexPath?
    var topics:NSMutableArray!
    var isSmallScreen:Bool!
    func requestUrl(nextPage:NSNumber)->String
    {
        return String(format:"http://s.budejie.com/topic/list/zuixin/1/bs0315-iphone-4.5.6/%@-20.json",nextPage)
    }
    var displaysAsynchronously:Bool = true
    var tableView:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        topics = NSMutableArray()
        createTableView()
        getNetworkData()
        setupRefresh()
        testFPSLabel()
    }
    func setupRefresh()
    {
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(CeShi.getNetworkData))
        tableView.mj_header.isAutomaticallyChangeAlpha = true
        tableView.mj_header.beginRefreshing()
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(CeShi.loadMoreTopics))
    }
    func loadMoreTopics()
    {
        self.tableView.mj_header.endRefreshing()
        NetTool.shareInstance.requset(requestType: .Get, url: requestUrl(nextPage: np), parameters: [:]) { (response, error) in
            self.np = ((response! as NSDictionary).object(forKey: "info") as! NSDictionary).object(forKey: "np") as! NSNumber
            let moreTopics = ceShiModel.mj_objectArray(withKeyValuesArray: (response! as NSDictionary).object(forKey: "list"))
            moreTopics?.enumerateObjects({ (obj, idx, stop) in
                if ((obj as! ceShiModel).type!) == "html"
                {
                    moreTopics?.remove(obj)
                }
            })
            self.topics.addObjects(from: moreTopics as! [Any])
            
            self.tableView.reloadData()
            self.tableView.mj_footer.endRefreshing()
        }
    }
    func getNetworkData()
    {
        NetTool.shareInstance.requset(requestType: .Get, url: requestUrl(nextPage: 0), parameters: [:]) { (responseObject, error) in
            if !(((responseObject! as NSDictionary).object(forKey: "info") as! NSDictionary).object(forKey: "np") is NSNull)
            {
            self.np = ((responseObject! as NSDictionary).object(forKey: "info") as! NSDictionary).object(forKey: "np") as! NSNumber
            }
            let newData = ceShiModel.mj_objectArray(withKeyValuesArray: (responseObject! as NSDictionary).object(forKey: "list"))
            
            newData?.enumerateObjects({ (obj, idx, stop) in
                if ((obj as! ceShiModel).type!) == "html"
                {
                    self.topics.remove(obj)
                }
            })
            self.topics.addObjects(from: newData as! [Any])
            self.tableView.mj_header.endRefreshing()
            self.tableView.reloadData()
            
        }
    }
    func createTableView(){
        self.automaticallyAdjustsScrollViewInsets = false
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screen_width, height: screen_height-64-49),style:.plain)
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
    }
    //MARK:- UIScrollViewDelegate
    func testFPSLabel()
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

}

extension CeShi:UITableViewDelegate,UITableViewDataSource
{
       //MARK:- tableviewdelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellis =  "ceshiCell"
        let cell = QQTableViewCell(style: .default, reuseIdentifier: cellis)
        let model:ceShiModel = self.topics.object(at: indexPath.row) as! ceShiModel
        cell.selectionStyle = .none
        cell.ceshiModel = model
        cell.clickedReCommentCallback = {(topicID:String)->Void in
            printLog(message: "转发")
        }
        cell.clickedCommentButtonCallback = {(topicID:String) -> Void in
            printLog(message:"评论")
            let commentVc = TGCommentNewVC()
            (self.topics.object(at: indexPath.row) as! ceShiModel).isShowAllWithoutComment = true
            commentVc.topic = self.topics.object(at: indexPath.row) as! ceShiModel
            self.navigationController?.pushViewController(commentVc, animated: true)
        }
        // cell.attriLabel.delegate = self
        cell.clickedImageCallback = {(cell:QQTableViewCell,imageIndex:NSInteger)->Void in
            printLog(message: "图片")
        }
        cell.clickedAvatarCallback = {(cell:QQTableViewCell)->Void in
            printLog(message: "头像")
        }
        weak var weakSelf = self
        cell.clickedOpenCellCallback = {(cell:QQTableViewCell)->Void in
            weakSelf?.openTableViewCell(cell:cell)
        }
        cell.clickedCloseCellCallback = {(cell:QQTableViewCell)->Void in
            weakSelf?.closeTableViewCell(cell: cell)
        }
        let textSizes = CGSize(width:screen_width-40,height:CGFloat(MAXFLOAT));
        let textSize:CGSize = cell.ceshiModel.text.boundingRect(with: textSizes, options: .usesLineFragmentOrigin, attributes: [
            NSFontAttributeName : UIFont.systemFont(ofSize: 11)], context: nil).size
        if(model.type == "image" || model.type == "gif")
        {
        tableView.rowHeight = cell.cellHeight + textSize.height + 5
        }
        else if(model.type == "video")
        {
        tableView.rowHeight = cell.cellHeight + textSize.height
        }
        else
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let commentVc = TGCommentNewVC()
        (self.topics.object(at: indexPath.row) as! ceShiModel).isShowAllWithoutComment = true
        commentVc.topic = self.topics.object(at: indexPath.row) as! ceShiModel
        self.navigationController?.pushViewController(commentVc, animated: true)
    }
    func openTableViewCell(cell:QQTableViewCell)
    {
        //        let layout:CellLayout = self.topics.object(at: cell.indexPath.row) as! CellLayout
        //        let model:ceShiModel = layout.statusModels
        //        let newLayOut:CellLayout = CellLayout(model: model, index: cell.indexPath.row)
        //        coverScreenshotAndDelayRemove(with: cell, cellHeight: newLayOut.cellHeight)
        //        self.topics.replaceObject(at: cell.indexPath.row, with: newLayOut)
        //        self.tableView.reloadRows(at: [cell.indexPath], with: .none)
    }
    func closeTableViewCell(cell:QQTableViewCell)
    {
        //        let layout:CellLayout = self.topics.object(at: cell.indexPath.row) as! CellLayout
        //        let model:ceShiModel = layout.statusModels
        //        let newLayOut = CellLayout(stautsModel: model, index: cell.indexPath.row)
        //        coverScreenshotAndDelayRemove(with: cell, cellHeight: newLayOut.cellHeight)
        //        self.topics.replaceObject(at: cell.indexPath.row, with: newLayOut)
        //        self.tableView.reloadRows(at: [cell.indexPath], with: .none)
    }
}
