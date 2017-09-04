//
//  TGTopicNewCell.swift
//  banqianQiJie
//
//  Created by banbo on 2017/8/10.
//  Copyright © 2017年 banbo. All rights reserved.
//

import UIKit
import Masonry
class TGTopicNewCell: UITableViewCell {
    var repostBlock:((_ topicId:String)->Void)!
    var commentBlock:((_ topicId: String) -> Void)!
    var namePic:UIImageView!
    var nameLabel:UILabel!
    var passtimeLabel:UILabel!
    var commentLabel:UILabel!
    var moreBtn:UIButton!
    var topCommentTableV:UITableView!
    var coverBtn:UIButton!
    var picV:TGPicNewV!
    var voiceV:TGVoiceNewV!
    var videoV:TGVideoNewV!
    var topic:ceShiModel!
    {
        didSet {
           // printLog(message: "\(self.topic.type)")
            if (self.topic.type.lowercased() == "gif"||self.topic.type.lowercased() == "image"){//动图
                self.namePic.sd_setImage(with: URL(string: topic.u.header))
                nameLabel.text = topic.u.name
                commentLabel.text = topic.text
                passtimeLabel.text = topic.passtime
                self.picV = TGPicNewV()
                self.picV.tgtopPicModel = topic
                self.contentView.addSubview(picV)
                self.picV.frame = self.topic.middleFrame
                self.picV.layoutIfNeeded()
                self.topCommentTableV = UITableView(frame: CGRect(x: 10, y:picV.frame.maxY+10, width: screen_width-20, height: self.topic.commentVH+32),style:.plain)
                self.topCommentTableV.delegate = self
                self.topCommentTableV.isScrollEnabled = false
                self.topCommentTableV.dataSource = self
                self.topCommentTableV.tableFooterView = UIView()
                self.topCommentTableV.separatorStyle = .none
                self.contentView.addSubview(self.topCommentTableV)
                
            }
            else if (self.topic.type.lowercased() == "audio")// 声音
            {
                self.namePic.sd_setImage(with: URL(string: topic.u.header))
                nameLabel.text = topic.u.name
                commentLabel.text = topic.text
                passtimeLabel.text = topic.passtime
                self.voiceV = TGVoiceNewV()
                self.voiceV.topVoiceModel = topic
                self.contentView.addSubview(voiceV)
                self.voiceV.frame = self.topic.middleFrame
                self.topCommentTableV = UITableView(frame: CGRect(x: 5, y:Int(self.topic.middleFrame.maxY+10), width: Int(screen_width-10), height: Int(self.topic.commentVH)+32),style:.plain)
                self.topCommentTableV.delegate = self
                self.topCommentTableV.dataSource = self
                self.topCommentTableV.separatorStyle = .none
                self.topCommentTableV.isScrollEnabled = false
                self.contentView.addSubview(self.topCommentTableV)
            }
            else if (self.topic.type.lowercased() == "video") // 视频
            {
                self.namePic.sd_setImage(with: URL(string: topic.u.header))
                nameLabel.text = topic.u.name
                commentLabel.text = topic.text
                passtimeLabel.text = topic.passtime
                self.videoV = TGVideoNewV()
                self.contentView.addSubview(videoV)
                self.videoV.frame = self.topic.middleFrame
                self.videoV.topVideoModel = topic
                self.topCommentTableV = UITableView(frame: CGRect(x: 5, y:self.videoV.frame.maxY+20, width: screen_width-10, height: self.topic.commentVH+32),style:.plain)
                self.topCommentTableV.delegate = self
                self.topCommentTableV.dataSource = self
                self.topCommentTableV.isScrollEnabled = false
                self.topCommentTableV.tableFooterView = UIView()
                self.topCommentTableV.separatorStyle = .none
                self.contentView.addSubview(self.topCommentTableV)
               
            }
            else if (self.topic.type.lowercased() == "text")
            {
                self.namePic.sd_setImage(with: URL(string: topic.u.header))
                nameLabel.text = topic.u.name
                commentLabel.text = topic.text
                passtimeLabel.text = topic.passtime
                let textSize = CGSize(width: screen_width - 20, height: 1000)
                let titleSize = topic.text.boundingRect(with: textSize, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12)], context: nil).size
                self.topCommentTableV = UITableView(frame: CGRect(x: 5, y:titleSize.height+50, width: screen_width-10, height: self.topic.commentVH+32),style:.plain)
                self.topCommentTableV.delegate = self
                self.topCommentTableV.dataSource = self
                self.topCommentTableV.tableFooterView = UIView()
                self.topCommentTableV.isScrollEnabled = false
                self.topCommentTableV.separatorStyle = .none
                self.contentView.addSubview(self.topCommentTableV)
            }
        }
        
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createUI()
    }
    func createUI()
    {
        namePic = UIImageView()
        namePic.layer.cornerRadius = 15
        namePic.layer.masksToBounds = true
        self.contentView.addSubview(namePic)
        namePic.mas_makeConstraints { [weak self](make) in
            make?.left.equalTo()(self)?.offset()(10)
            make?.top.equalTo()(self)?.offset()(10)
            make?.width.and().height().mas_equalTo()(30)
        }
        nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 12)
        nameLabel.textColor =  TGColor(r: 240, g: 77, b: 71)
        self.contentView.addSubview(nameLabel)
        nameLabel.mas_makeConstraints { [weak self](make) in
            make?.left.equalTo()(self?.namePic.mas_right)?.offset()(10)
            make?.top.equalTo()(self?.namePic)
        }
        passtimeLabel = UILabel()
        passtimeLabel.numberOfLines = 0
        passtimeLabel.font = UIFont.systemFont(ofSize: 10)
        passtimeLabel.textColor = UIColor.darkGray
        self.contentView.addSubview(passtimeLabel)
        passtimeLabel.mas_makeConstraints { [weak self](make) in
            make?.top.equalTo()(self?.nameLabel.mas_bottom)?.offset()(5)
            make?.left.equalTo()(self?.nameLabel)
        }
        moreBtn = UIButton()
        moreBtn.setImage(UIImage(named:"cellmorebtnnormal"), for: .normal)
        moreBtn.addTarget(self, action: #selector(TGTopicNewCell.moreBtnClick), for: .touchUpInside)
        self.contentView.addSubview(moreBtn)
        moreBtn.mas_makeConstraints { [weak self](make) in
            make?.top.equalTo()(self?.namePic)
            make?.right.equalTo()(self)?.offset()(-5)
            make?.width.and().height().mas_equalTo()(30)
        }
        commentLabel = UILabel()
        commentLabel.font = UIFont.systemFont(ofSize: 12)
        commentLabel.numberOfLines = 0
        commentLabel.adjustsFontSizeToFitWidth = true
        commentLabel.textColor = UIColor.darkGray
        self.contentView.addSubview(commentLabel)
        commentLabel.mas_makeConstraints { [weak self](make) in
            make?.top.equalTo()(self?.namePic.mas_bottom)?.offset()(5)
            make?.left.equalTo()(self?.namePic.mas_left)
            make?.width.equalTo()(self)?.offset()(-10)
        }
        
    }
    func moreBtnClick()
    {
        
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        controller.addAction(UIAlertAction(title: "评论", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.commentBlock!(self.topic.id)
        }))
        controller.addAction(UIAlertAction(title: "收藏", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            printLog(message: "点击了[收藏]按钮")
        }))
        controller.addAction(UIAlertAction(title: "举报", style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
            printLog(message: "点击了[举报]按钮")
        }))
        controller.addAction(UIAlertAction(title: "取消", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
            printLog(message: "点击了[取消]按钮")
        }))
        self.window?.rootViewController?.present(controller, animated: true, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
}
extension TGTopicNewCell:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.topic.top_comments != nil) {
            return self.topic.top_comments.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "pinglunCell"
        // let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        let cell = TGTopCommentCell(style: .default, reuseIdentifier: cellIdentifier)
        cell.backgroundColor = UIColor.lightGray
        cell.selectionStyle = .none
        cell.commentM = self.topic.top_comments[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.topic.top_comments[indexPath.row].topCommentCellHeight
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: screen_width, height: 31))
        var nameArray = [String]()
        
        nameArray = ["顶\(topic.up)","踩\(topic.down)","转发\(topic.forward)","评论\(topic.comment)"]
        
        let imageArray = ["timeline_icon_unlike","icon_unlike_normal","timeline_icon_retweet","timeline_icon_comment"]
        for i in 0...nameArray.count-1 {
            let button = UIButton(frame: CGRect(x: CGFloat(i) * (screen_width/4), y: 1, width: screen_width/4, height: 30))
            button.tag = i+1000
            button .setTitle(nameArray[i], for: .normal)
            button.setTitleColor(UIColor.darkGray, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 9)
            button.setImage(UIImage(named:imageArray[i]), for: .normal)
            button.addTarget(self, action: #selector(TGTopicNewCell.fourBtn(btn:)), for: .touchUpInside)
            view.addSubview(button)
        }
        return view
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 31
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func fourBtn(btn:UIButton)
    {
        switch btn.tag {
        case 1000:
            printLog(message: "你点击了顶")
            if !btn.isSelected
            {
                btn.setImage(UIImage(named:"timeline_icon_like"), for: .normal)
                btn.isSelected = true
                btn.setTitle("顶\(topic.up+1)", for: .normal)
            }
            else
            {
                btn.setImage(UIImage(named:"timeline_icon_unlike"), for: .normal)
                btn.isSelected = false
                btn.setTitle("顶\(topic.up)", for: .normal)
            }
            
            break
        case 1001:
            
            printLog(message: "你点击了踩")
            if !btn.isSelected
            {
                btn.setImage(UIImage(named:"icon_unlike_h"), for: .normal)
                btn.isSelected = true
                btn.setTitle("顶\(topic.down+1)", for: .normal)
            }
            else
            {
                btn.setImage(UIImage(named:"icon_unlike_normal"), for: .normal)
                btn.isSelected = false
                btn.setTitle("踩\(topic.down)", for: .normal)
            }
            
            break
        case 1002:
            
            printLog(message: "你点击了转发,\(self.topic.id)")
            self.repostBlock(self.topic.id)
            break
        case 1003:
            
            printLog(message: "你点击了评论\(self.topic.id)")
            self.commentBlock(self.topic.id)
            break
        default:
            break
        }
    }
}
