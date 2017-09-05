//
//  QQTableViewCell.swift
//  banqianQiJie
//
//  Created by banbo on 2017/8/24.
//  Copyright © 2017年 banbo. All rights reserved.
//

import UIKit
import SVProgressHUD
class QQTableViewCell: UITableViewCell {
    var namePic:AsyncImageView!
    var nameLabel:UILabel!
    var passtimeLabel:UILabel!
    var commentLabel:UILabel!
    var moreBtn:UIButton!
    var imageV:AsyncImageView!
//    var gifV:YFGIFImageView!
    var gifV:YYAnimatedImageView!
    var gifButton:UIButton!
    var gifes:UIImageView!
    var topCommentTableV:UITableView!
    var videoV:TGVideoNewV!
    var voiceV:TGVoiceNewV!
    var clickedImageCallback: ((_ cell: QQTableViewCell, _ imageIndex: Int) -> Void)? = nil
    var clickedLikeButtonCallback: ((_ cell: QQTableViewCell, _ isLike: Bool) -> Void)? = nil
    var clickedAvatarCallback: ((_ cell: QQTableViewCell) -> Void)? = nil
    // 转发
    var clickedReCommentCallback: ((_ topicID:String) -> Void)? = nil
    // 评论
    var clickedCommentButtonCallback: ((_ topicID:String) -> Void)? = nil
    var clickedOpenCellCallback: ((_ cell: QQTableViewCell) -> Void)? = nil
    var clickedCloseCellCallback: ((_ cell: QQTableViewCell) -> Void)? = nil
    var cellHeight:CGFloat!
//    func playGIF()
//    {
//        gifButton.isHidden = true
//        gifV.isHidden = false
//        gifV.gifData = NSData(contentsOf: URL(string:self.ceshiModel.images_gif)!)! as Data
//        gifV.startGIF()
//    }
    func delayAction()
    {
        gifV.isHidden = false
        gifV.yy_setImage(with: URL(string:self.ceshiModel.images_gif), placeholder: nil, options: .progressiveBlur, progress: nil, transform: nil, completion: nil)
    }
    var ceshiModel:ceShiModel!
    {
        didSet{
            AsyncImageLoader.shared().cancelLoadingImages(forTarget: namePic)
            self.namePic.imageURL =  URL(string: ceshiModel.u.header)
            nameLabel.text = ceshiModel.u.name
            commentLabel.text = ceshiModel.text
            passtimeLabel.text = ceshiModel.passtime
            let textSizes = CGSize(width:screen_width-40,height:CGFloat(MAXFLOAT));
            let textSize:CGSize = ceshiModel.text.boundingRect(with: textSizes, options: .usesLineFragmentOrigin, attributes: [
                NSFontAttributeName : UIFont.systemFont(ofSize: 11)], context: nil).size
            if self.ceshiModel.type.lowercased() == "image" {
                AsyncImageLoader.shared().cancelLoadingImages(forTarget: imageV)
                imageV.imageURL = URL(string:self.ceshiModel.image)
                commentLabel.mas_remakeConstraints({ (make) in
                    make?.top.equalTo()(self.namePic.mas_bottom)?.offset()(5)
                    make?.left.equalTo()(self.namePic.mas_left)
                    make?.width.equalTo()(self)?.offset()(-10)
                })
                imageV.mas_remakeConstraints({[weak self](make) in
                    make?.top.equalTo()(self?.commentLabel.bottom)?.offset()(textSize.height+50.0)
                    make?.left.equalTo()(self)?.offset()(10)
                    make?.width.equalTo()(self)?.offset()(-20)
                    make?.height.mas_equalTo()(260)
                })
                imageV.layoutIfNeeded()
                if ceshiModel.top_comments != nil
                {
                    topCommentTableV = UITableView(frame: CGRect(x:0.0,y:270+textSize.height+40,width:screen_width,height:CGFloat( 30*ceshiModel.top_comments.count)+30), style: .plain)
                  //  topCommentTableV.backgroundColor = UIColor.cyan
                    self.topCommentTableV.delegate = self
                    self.topCommentTableV.isScrollEnabled = false
                    self.topCommentTableV.dataSource = self
                    self.topCommentTableV.tableFooterView = UIView()
                    self.contentView.addSubview(topCommentTableV)
                    cellHeight = namePic.frame.size.height + commentLabel.frame.size.height + imageV.frame.size.height + CGFloat(30 * ceshiModel.top_comments.count) + 15
                }
                else
                {
                    let nameArray = ["顶\(ceshiModel.up)","踩\(ceshiModel.down)","转发\(ceshiModel.forward)","评论\(ceshiModel.comment)"]
                    let imageArray = ["timeline_icon_unlike","icon_unlike_normal","timeline_icon_retweet","timeline_icon_comment"]
                    for i in 0...nameArray.count-1 {
                        let button = UIButton(frame: CGRect(x: CGFloat(i) * (screen_width/4), y: 270+textSize.height+40, width: screen_width/4, height: 30))
                        button.tag = i+1000
                        button .setTitle(nameArray[i], for: .normal)
                        button.setTitleColor(UIColor.darkGray, for: .normal)
                        button.titleLabel?.font = UIFont.systemFont(ofSize: 9)
                        button.setImage(UIImage(named:imageArray[i]), for: .normal)
                        button.addTarget(self, action: #selector(QQTableViewCell.fourBtn(btn:)), for: .touchUpInside)
                        self.addSubview(button)
                    }
                    cellHeight = namePic.frame.size.height + commentLabel.frame.size.height + imageV.frame.size.height + 15
                }
                
            }
            else if (self.ceshiModel.type.lowercased() == "gif")
            {
                
                gifes.isHidden = false
                commentLabel.mas_remakeConstraints({ (make) in
                    make?.top.equalTo()(self.namePic.mas_bottom)?.offset()(5)
                    make?.left.equalTo()(self.namePic.mas_left)
                    make?.width.equalTo()(self)?.offset()(-10)
                })
                imageV.mas_remakeConstraints({[weak self](make) in
                    make?.top.equalTo()(self?.commentLabel.bottom)?.offset()(textSize.height+50.0)
                    make?.left.equalTo()(self)?.offset()(10)
                    make?.width.equalTo()(self)?.offset()(-20)
                    make?.height.mas_equalTo()(260)
                })
                gifV.mas_remakeConstraints({[weak self](make) in
                    make?.top.equalTo()(self?.commentLabel.bottom)?.offset()(textSize.height+50)
                    make?.left.equalTo()(self)?.offset()(10)
                    make?.width.equalTo()(self)?.offset()(-20)
                    make?.height.mas_equalTo()(260)
                })
                delayAction()
                if ceshiModel.top_comments != nil
                {
                topCommentTableV = UITableView(frame: CGRect(x:0.0,y:270+textSize.height+40,width:screen_width,height:CGFloat( 30*ceshiModel.top_comments.count)+30), style: .plain)
               // topCommentTableV.backgroundColor = UIColor.cyan
                self.topCommentTableV.delegate = self
                self.topCommentTableV.isScrollEnabled = false
                self.topCommentTableV.dataSource = self
                    self.topCommentTableV.tableFooterView = UIView()
                self.contentView.addSubview(topCommentTableV)
                cellHeight = namePic.frame.size.height + commentLabel.frame.size.height + imageV.frame.size.height + CGFloat(30 * ceshiModel.top_comments.count) + 15
                }
                else
                {
                    let nameArray = ["顶\(ceshiModel.up)","踩\(ceshiModel.down)","转发\(ceshiModel.forward)","评论\(ceshiModel.comment)"]
                    let imageArray = ["timeline_icon_unlike","icon_unlike_normal","timeline_icon_retweet","timeline_icon_comment"]
                    for i in 0...nameArray.count-1 {
                        let button = UIButton(frame: CGRect(x: CGFloat(i) * (screen_width/4), y: 270+textSize.height+40, width: screen_width/4, height: 30))
                        button.tag = i+1000
                        button .setTitle(nameArray[i], for: .normal)
                        button.setTitleColor(UIColor.darkGray, for: .normal)
                        button.titleLabel?.font = UIFont.systemFont(ofSize: 9)
                        button.setImage(UIImage(named:imageArray[i]), for: .normal)
                        button.addTarget(self, action: #selector(QQTableViewCell.fourBtn(btn:)), for: .touchUpInside)
                        self.addSubview(button)
                    }
                cellHeight = namePic.frame.size.height + commentLabel.frame.size.height + imageV.frame.size.height + 15
                }
            }
//            printLog(message: ceshiModel.type)
            if (self.ceshiModel.type.lowercased() == "audio")// 声音
            {
                imageV.isHidden = true
                commentLabel.mas_remakeConstraints({ (make) in
                    make?.top.equalTo()(self.namePic.mas_bottom)?.offset()(5)
                    make?.left.equalTo()(self.namePic.mas_left)
                    make?.width.equalTo()(self)?.offset()(-10)
                })
                self.voiceV = TGVoiceNewV()
                self.voiceV.topVoiceModel = ceshiModel
                self.contentView.addSubview(voiceV)
                self.voiceV.frame = self.ceshiModel.middleFrame
                cellHeight = namePic.frame.size.height + commentLabel.frame.size.height + imageV.frame.size.height + 15
            }
            else if (self.ceshiModel.type.lowercased() == "video") // 视频
            {
                imageV.isHidden = true
                self.videoV = TGVideoNewV()
                self.contentView.addSubview(videoV)
                self.videoV.topVideoModel = ceshiModel
                commentLabel.mas_remakeConstraints({ (make) in
                    make?.top.equalTo()(self.namePic.mas_bottom)?.offset()(5)
                    make?.left.equalTo()(self.namePic.mas_left)
                    make?.width.equalTo()(self)?.offset()(-10)
                })
                videoV.mas_remakeConstraints{ (make) in
                    make?.top.equalTo()(self.commentLabel.bottom)?.offset()(textSize.height+50.0)//80
                    make?.left.equalTo()(self)?.offset()(5)
                    make?.right.equalTo()(self)?.offset()(-5)
                    make?.height.mas_equalTo()(260)
                }
                videoV.layoutIfNeeded()
                if ceshiModel.top_comments != nil
                {
                    topCommentTableV = UITableView(frame: CGRect(x:0.0,y:270+textSize.height+20,width:screen_width,height:CGFloat( 30*ceshiModel.top_comments.count)+30), style: .plain)
                   // topCommentTableV.backgroundColor = UIColor.cyan
                    self.topCommentTableV.delegate = self
                    self.topCommentTableV.isScrollEnabled = false
                    self.topCommentTableV.dataSource = self
                    self.topCommentTableV.tableFooterView = UIView()
                    self.contentView.addSubview(topCommentTableV)
                    cellHeight = namePic.frame.size.height + commentLabel.frame.size.height + imageV.frame.size.height + CGFloat(30 * ceshiModel.top_comments.count)
                }
                else
                {
                    let nameArray = ["顶\(ceshiModel.up)","踩\(ceshiModel.down)","转发\(ceshiModel.forward)","评论\(ceshiModel.comment)"]
                    let imageArray = ["timeline_icon_unlike","icon_unlike_normal","timeline_icon_retweet","timeline_icon_comment"]
                    for i in 0...nameArray.count-1 {
                        let button = UIButton(frame: CGRect(x: CGFloat(i) * (screen_width/4), y: 270+textSize.height+20, width: screen_width/4-10, height: 30))
                        button.tag = i+1000
                        button .setTitle(nameArray[i], for: .normal)
                        button.setTitleColor(UIColor.darkGray, for: .normal)
                        button.titleLabel?.font = UIFont.systemFont(ofSize: 9)
                        button.setImage(UIImage(named:imageArray[i]), for: .normal)
                        button.addTarget(self, action: #selector(QQTableViewCell.fourBtn(btn:)), for: .touchUpInside)
                        self.addSubview(button)
                    }
                    cellHeight = namePic.frame.size.height + commentLabel.frame.size.height + imageV.frame.size.height
                }
            }
            else if (self.ceshiModel.type.lowercased() == "text")
            {
                commentLabel.mas_remakeConstraints({ (make) in
                    make?.top.equalTo()(self.namePic.mas_bottom)?.offset()(5)
                    make?.left.equalTo()(self.namePic.mas_left)
                    make?.width.equalTo()(self)?.offset()(-10)
                })
                imageV.isHidden = true
                if ceshiModel.top_comments != nil
                {
                    topCommentTableV = UITableView(frame: CGRect(x:0.0,y:textSize.height+50,width:screen_width,height:CGFloat( 30*ceshiModel.top_comments.count)+30), style: .plain)
                    //topCommentTableV.backgroundColor = UIColor.cyan
                    self.topCommentTableV.delegate = self
                    self.topCommentTableV.isScrollEnabled = false
                    self.topCommentTableV.dataSource = self
                    self.topCommentTableV.tableFooterView = UIView()
                    self.contentView.addSubview(topCommentTableV)
                    cellHeight = namePic.frame.size.height + commentLabel.frame.size.height  + CGFloat(30 * ceshiModel.top_comments.count) + 20
                }
                else
                {
                    let nameArray = ["顶\(ceshiModel.up)","踩\(ceshiModel.down)","转发\(ceshiModel.forward)","评论\(ceshiModel.comment)"]
                    let imageArray = ["timeline_icon_unlike","icon_unlike_normal","timeline_icon_retweet","timeline_icon_comment"]
                    for i in 0...nameArray.count-1 {
                        let button = UIButton(frame: CGRect(x: CGFloat(i) * (screen_width/4), y: textSize.height+50, width: screen_width/4, height: 30))
                        button.tag = i+1000
                        button .setTitle(nameArray[i], for: .normal)
                        button.setTitleColor(UIColor.darkGray, for: .normal)
                        button.titleLabel?.font = UIFont.systemFont(ofSize: 9)
                        button.setImage(UIImage(named:imageArray[i]), for: .normal)
                        button.addTarget(self, action: #selector(QQTableViewCell.fourBtn(btn:)), for: .touchUpInside)
                        self.addSubview(button)
                    }
                    cellHeight = namePic.frame.size.height + commentLabel.frame.size.height + 20
                }
            }
            
        }
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
                btn.setTitle("顶\(ceshiModel.up+1)", for: .normal)
            }
            else
            {
                btn.setImage(UIImage(named:"timeline_icon_unlike"), for: .normal)
                btn.isSelected = false
                btn.setTitle("顶\(ceshiModel.up)", for: .normal)
            }
            
            break
        case 1001:
            
            printLog(message: "你点击了踩")
            if !btn.isSelected
            {
                btn.setImage(UIImage(named:"icon_unlike_h"), for: .normal)
                btn.isSelected = true
                btn.setTitle("顶\(ceshiModel.down+1)", for: .normal)
            }
            else
            {
                btn.setImage(UIImage(named:"icon_unlike_normal"), for: .normal)
                btn.isSelected = false
                btn.setTitle("踩\(ceshiModel.down)", for: .normal)
            }
            
            break
        case 1002:
            
            printLog(message: "你点击了转发,\(self.ceshiModel.id)")
            self.clickedReCommentCallback!(self.ceshiModel.id)
            break
        case 1003:
            
            printLog(message: "你点击了评论\(self.ceshiModel.id)")
            self.clickedCommentButtonCallback!(self.ceshiModel.id)
            break
        default:
            break
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createUI()
    }
    func seeBigPic()
    {
        let photos = SDPhotoBrowser()
        photos.imageCount = 1
        photos.currentImageIndex = 0
        photos.delegate = self
        photos.show()
    }
    func createUI()
    {
        namePic = AsyncImageView()
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
        commentLabel = UILabel()
        commentLabel.font = UIFont.systemFont(ofSize: 12)
        commentLabel.numberOfLines = 0
        commentLabel.textColor = UIColor.darkGray
        self.contentView.addSubview(commentLabel)
        commentLabel.mas_makeConstraints { [weak self](make) in
            make?.top.equalTo()(self?.namePic.mas_bottom)?.offset()(5)
            make?.left.equalTo()(self?.namePic.mas_left)
            make?.width.equalTo()(self)?.offset()(-10)
            make?.height.mas_equalTo()(30)
        }
        
        moreBtn = UIButton()
        moreBtn.setImage(UIImage(named:"cellmorebtnnormal"), for: .normal)
        moreBtn.addTarget(self, action: #selector(QQTableViewCell.moreBtnClick), for: .touchUpInside)
        self.contentView.addSubview(moreBtn)
        moreBtn.mas_makeConstraints { [weak self](make) in
            make?.top.equalTo()(self?.namePic)
            make?.right.equalTo()(self)?.offset()(-5)
            make?.width.and().height().mas_equalTo()(30)
        }
        
        imageV = AsyncImageView()
        imageV.layer.cornerRadius = 5
        imageV.layer.borderWidth = 2
        imageV.contentMode = .scaleAspectFill
        imageV.layer.masksToBounds = true
        imageV.layer.borderColor = UIColor.darkGray.cgColor
        imageV.isUserInteractionEnabled = true
        imageV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(QQTableViewCell.seeBigPic)))
        self.contentView.addSubview(imageV)
        imageV.mas_makeConstraints { [weak self](make) in
            make?.top.equalTo()(self?.commentLabel.bottom)?.offset()(80)
            make?.left.equalTo()(self)?.offset()(10)
            make?.width.equalTo()(self)?.offset()(-20)
            make?.height.mas_equalTo()(260)
        }
        gifV = YYAnimatedImageView()
        gifV.contentMode = .scaleAspectFill
        gifV.clipsToBounds = true
        gifV.isHidden = true
        self.contentView.addSubview(gifV)
        gifV.mas_makeConstraints { [weak self](make) in
            make?.top.equalTo()(self?.commentLabel.bottom)?.offset()(80)
            make?.left.equalTo()(self)?.offset()(10)
            make?.width.equalTo()(self)?.offset()(-20)
            make?.height.mas_equalTo()(260)
        }
        gifes = UIImageView(image: UIImage(named: "common-gif"))
        gifes.isHidden = true
        //self.contentView.insertSubview(gifes, belowSubview: gifV)
        self.contentView.addSubview(gifes)
        gifes.mas_makeConstraints { [weak self](make) in
            make?.left.equalTo()(self?.imageV)?.offset()(0)
            make?.top.equalTo()(self?.imageV)?.offset()(0)
            make?.width.and().height().mas_equalTo()(30)
        }
       
       
        
//        gifButton = UIButton()
//        gifButton.setImage(#imageLiteral(resourceName: "voice-play-start-click"), for: .normal)
//        gifButton.addTarget(self, action: #selector(QQTableViewCell.playGIF), for: .touchUpInside)
//        gifButton.isHidden = true
//        self.contentView.addSubview(gifButton)
//        gifButton.mas_makeConstraints { (make) in
//            make?.centerX.equalTo()(self.imageV)
//            make?.centerY.equalTo()(self.imageV)
//            make?.width.and().height().mas_equalTo()(30)
//        }
        namePic.layoutIfNeeded()
        commentLabel.layoutIfNeeded()
        imageV.layoutIfNeeded()
        self.layoutIfNeeded()
        
    }
    func moreBtnClick()
    {
        
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        controller.addAction(UIAlertAction(title: "评论", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.clickedCommentButtonCallback!(self.ceshiModel.id)
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
extension QQTableViewCell:SDPhotoBrowserDelegate,UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ceshiModel.top_comments.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let commentS = "nmCell"
        let cell = TGTopCommentCell(style: .default, reuseIdentifier: commentS)
        cell.selectionStyle = .none
        cell.commentM = ceshiModel.top_comments[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let textSizes = CGSize(width:screen_width-40,height:CGFloat(MAXFLOAT));
        let textSize:CGSize = ceshiModel.top_comments[indexPath.row].content.boundingRect(with: textSizes, options: .usesLineFragmentOrigin, attributes: [
            NSFontAttributeName : UIFont.systemFont(ofSize: 10)], context: nil).size
        return textSize.height + 10
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame:CGRect(x: 0, y: 0, width: screen_width, height: 30))
       let nameArray = ["顶\(ceshiModel.up)","踩\(ceshiModel.down)","转发\(ceshiModel.forward)","评论\(ceshiModel.comment)"]
        let imageArray = ["timeline_icon_unlike","icon_unlike_normal","timeline_icon_retweet","timeline_icon_comment"]
            for i in 0...nameArray.count-1 {
            let button = UIButton(frame: CGRect(x: CGFloat(i) * (screen_width/4), y: 0, width: screen_width/4, height: 30))
               button.tag = i+1000
               button .setTitle(nameArray[i], for: .normal)
              button.setTitleColor(UIColor.darkGray, for: .normal)
               button.titleLabel?.font = UIFont.systemFont(ofSize: 9)
             button.setImage(UIImage(named:imageArray[i]), for: .normal)
                button.addTarget(self, action: #selector(QQTableViewCell.fourBtn(btn:)), for: .touchUpInside)
                view.addSubview(button)
            }
        return view
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    //MARK:- 图片delegate
    func photoBrowser(_ browser: SDPhotoBrowser!, placeholderImageFor index: Int) -> UIImage! {
        return nil
    }
    func photoBrowser(_ browser: SDPhotoBrowser!, highQualityImageURLFor index: Int) -> URL! {
        if ceshiModel.type.lowercased() == "image" {
            return URL(string: self.ceshiModel.image)
        }
        else
        {
            return URL(string:self.ceshiModel.gif_thumbnail)
        }
    }
}
