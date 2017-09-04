//
//  TGLookingAroundVC.swift
//  banqianQiJie
//
//  Created by banbo on 2017/8/9.
//  Copyright © 2017年 banbo. All rights reserved.
//

import UIKit
import MJRefresh
import MJExtension
import SVProgressHUD
class TGLookingAroundVC: UIViewController {
    var topics:NSMutableArray!
    var np:NSNumber = 0
    var _refresh:TGRefreshOC!
    var lastSelectedIndex:NSInteger!
    var collectionV:UICollectionView!
    var contentOffsetY:CGFloat!
    var contentOffsetSpeed:CGFloat! = 0
    let cellIdent = "suitingCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        topics = NSMutableArray.init()
        self.automaticallyAdjustsScrollViewInsets = false
        NotificationCenter.default.addObserver(self, selector: #selector(TGLookingAroundVC.tabBarButtonDidRepeatClick), name: NSNotification.Name(rawValue:TabBarButtonDidRepeatClickNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(TGLookingAroundVC.titleButtonDidRepeatClick), name: NSNotification.Name(rawValue:TitleButtonDidRepeatClickNotification), object: nil)
        setupLayout()
        setupRefresh()
    }
    func setupRefresh()
    {
        let refresh = TGRefreshOC()
        refresh.verticalAlignment = .midden
        refresh.automaticallyChangeAlpha = true
        refresh.refreshResultTextColor = UIColor.white
        refresh.refreshResultBgColor = UIColor.red.withAlphaComponent(0.6)
        collectionV.addSubview(refresh)
        refresh.addTarget(self, action: #selector(TGLookingAroundVC.loadNewTopics), for: .valueChanged)
        _refresh = refresh
        refresh.beginRefreshing()
        
    }
    func setupLayout()
    {
        let layout = TGLayout()
        layout.delegate = self
        let collection = UICollectionView(frame: CGRect(x:0,y:0,width:screen_width,height:screen_height-64-49),collectionViewLayout:layout)
        collection.backgroundColor = TGColor(r: 246, g: 246, b: 246)
        collection.delegate = self
        collection.dataSource = self
        self.view.addSubview(collection)
        collection.register(TGLookingAroundCell.self, forCellWithReuseIdentifier: cellIdent)
        collectionV = collection
        collectionV.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(TGLookingAroundVC.loadMoreTopics))
        
    }
    func loadNewTopics()
    {
        collectionV.mj_footer.endRefreshing()
        NetTool.shareInstance.requset(requestType: .Get, url: requestSuiTingUrl(nextpage: 0), parameters: [:]) { (responseObject, error) in
            if error != nil
            {
                if (error! as NSError).code != NSURLErrorCancelled
                {
                    SVProgressHUD.showError(withStatus: "网络繁忙,请稍后再试")
                }
                self._refresh.endRefreshing()
                return
            }
            self.np = (((responseObject! as NSDictionary).object(forKey: "info") as! NSDictionary).object(forKey: "np") as! NSNumber)
            self.topics = TGTopicNewM.mj_objectArray(withKeyValuesArray: (responseObject! as NSDictionary).object(forKey: "list"))
            self.topics.enumerateObjects({ (obj, idx, stop) in
                if ((obj as! TGTopicNewM).type!) == "html"
                {
                    self.topics.remove(obj)
                }
            })
            self._refresh.refreshResultStr = String(format:"成功刷新到%zd条数据",self.topics.count)
            DispatchQueue.main.asyncAfter(deadline:  DispatchTime.now() + 0.25, execute: {
                self._refresh.endRefreshing()
            })
            self.collectionV.reloadData()
        }
    }
    func loadMoreTopics()
    {
        collectionV.mj_footer.endRefreshing()
        NetTool.shareInstance.requset(requestType: .Get, url: requestSuiTingUrl(nextpage: np), parameters: [:]) { (responseObject, error) in
            if error != nil
            {
                if (error! as NSError).code != NSURLErrorCancelled
                {
                    SVProgressHUD.showError(withStatus: "网络繁忙,请稍后再试")
                }
                self._refresh.endRefreshing()
                return
            }
            self.np = (((responseObject! as NSDictionary).object(forKey: "info") as! NSDictionary).object(forKey: "np") as! NSNumber)
            let moreTopic = TGTopicNewM.mj_objectArray(withKeyValuesArray: (responseObject! as NSDictionary).object(forKey: "list"))
            moreTopic?.enumerateObjects({ (obj, idx, stop) in
                if ((obj as! TGTopicNewM).type!) == "html"
                {
                    self.topics.remove(obj)
                }
            })
            self.topics.addObjects(from: moreTopic as! [Any])
            self.collectionV.reloadData()
            self.collectionV.mj_footer.endRefreshing()
        }
    }
    //MARK:- 你懂的
    func titleButtonDidRepeatClick()
    {
        tabBarButtonDidRepeatClick()
    }
   
    func tabBarButtonDidRepeatClick()
    {
        if self.view.window == nil {
            return
        }
        if collectionV.scrollsToTop == false {
            return
        }
        if (lastSelectedIndex == self.tabBarController?.selectedIndex&&self.view.isShowingOnKeyWindow()) {
            self.collectionV.mj_header.beginRefreshing()
        }
        self.lastSelectedIndex = self.tabBarController?.selectedIndex
    }
    func getNextLikeIndexWithTopicId(topic:String,block:((_ nextLikeIndex:NSInteger)->Void)!)
    {
        var next: Int = -1
        var index: Int = -1
        var first: Int = -1
        self.topics.enumerateObjects({ (obj, idx, stop) in
            if(obj as! TGTopicNewM).isLikeSelected
            {
                first = (first == -1) ? idx : first
                index = ((obj as! TGTopicNewM).id == topic) ? idx : index
                next = (idx > index && index > -1) ? idx : next
            }
        })
        next = (next == -1) ? first : next
        block(next)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        
    }
    
}
extension TGLookingAroundVC:UICollectionViewDataSource,UICollectionViewDelegate,TGLayoutDelegate
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.topics.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdent, for: indexPath) as! TGLookingAroundCell
        cell.topic = self.topics.object(at: indexPath.item) as! TGTopicNewM
        cell.commentBlock = {(topicId:String)->Void in
            let commentVC = TGCommentNewVC()
           // (self.topics.object(at: indexPath.row) as! TGTopicNewM).isShowAllWithoutComment = true
           //commentVC.topic = self.topics.object(at: indexPath.row) as! TGTopicNewM
            self.navigationController?.pushViewController(commentVC, animated: true)
        }
        cell.NextBlock = {(topic:String)->Void in
            self.getNextLikeIndexWithTopicId(topic: topic, block: { (nextLikeIndex) in
                if (nextLikeIndex > -1)
                {
                    let array2 = self.collectionV.visibleCells
                    for obj in array2
                    {
                        let  path = self.collectionV.indexPath(for: obj)
                        if (nextLikeIndex == path?.item)
                        {
                            (obj as! TGLookingAroundCell).play()
                            return
                        }
                    }
                    cell.replacePlayerItem(topic: self.topics.object(at: nextLikeIndex) as! TGTopicNewM)
                }
            })
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let voiceCell:TGLookingAroundCell = cell as! TGLookingAroundCell
        if !voiceCell.topic.isAnimated {
            if cell.x == 0 {
                cell.transform = cell.transform.translatedBy(x: -screen_width * 0.25, y: 0)
            }
            else
            {
                cell.transform = cell.transform.translatedBy(x: screen_width*0.5, y: 0)
            }
            cell.alpha = 0
            UIView.animate(withDuration: 0.6, animations: {
                cell.transform = CGAffineTransform.identity
                cell.layer.transform = CATransform3DIdentity
                cell.alpha = 1
                voiceCell.topic.isAnimated = true
            }, completion: { (finished) in
                
            })
        }
    }
    //MARK:- layoutDelgate
    func layout(_ layout: TGLayout!, heightForItemAt index: UInt, itemWidth: CGFloat) -> CGFloat {
        let topic = topics[index.hashValue] as! TGTopicNewM
        return itemWidth * CGFloat(topic.height) / CGFloat(topic.width)
    }
    func rowMargin(in layout: TGLayout!) -> CGFloat {
        return 2
    }
    func columnCount(in layout: TGLayout!) -> CGFloat {
        return 2
    }
    func columnMargin(in layout: TGLayout!) -> CGFloat {
        return 2
    }
    func edgeInsets(in layout: TGLayout!) -> UIEdgeInsets {
        return UIEdgeInsetsMake(2, 0, 0, 0)
    }
}
