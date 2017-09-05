//
//  pinglunCell.swift
//  banqianQiJie
//
//  Created by banbo on 2017/8/16.
//  Copyright © 2017年 banbo. All rights reserved.
//

import UIKit

class pinglunCell: TGTopicNewCell {
    override var topic: ceShiModel!
    {
        didSet {
            //printLog(message: "\(self.topic.type)")
            if (self.topic.type.lowercased() == "gif"||self.topic.type.lowercased() == "image"){//动图
                self.namePic.sd_setImage(with: URL(string: topic.u.header))
                nameLabel.text = topic.u.name
                commentLabel.text = topic.text
                passtimeLabel.text = topic.passtime
                self.picV = AsyncImageView()
                AsyncImageLoader.shared().cancelLoadingImages(forTarget: picV)
                picV.imageURL = URL(string:self.topic.image)
                picV.layer.cornerRadius = 5
                picV.layer.borderWidth = 2
                picV.contentMode = .scaleAspectFill
                picV.layer.masksToBounds = true
                picV.layer.borderColor = UIColor.darkGray.cgColor
                picV.isUserInteractionEnabled = true
                picV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(TGTopicNewCell.seeBigPic)))
                self.contentView.addSubview(picV)
                picV.mas_makeConstraints { [weak self](make) in
                    make?.top.equalTo()(self?.commentLabel.bottom)?.offset()(80)
                    make?.left.equalTo()(self)?.offset()(10)
                    make?.width.equalTo()(self)?.offset()(-20)
                    make?.height.mas_equalTo()(260)
                }
                self.picV.layoutIfNeeded()
                self.topCommentTableV.removeFromSuperview()
                var nameArray = [String]()
                
                nameArray = ["顶\(topic.up)","踩\(topic.down)","转发\(topic.forward)","评论\(topic.comment)"]
                
                let imageArray = ["timeline_icon_unlike","icon_unlike_normal","timeline_icon_retweet","timeline_icon_comment"]
                for i in 0...nameArray.count-1 {
                    let button = UIButton(frame: CGRect(x: CGFloat(i) * (screen_width/4), y: 390, width: screen_width/4, height: 30))
                    button.tag = i+1000
                    button .setTitle(nameArray[i], for: .normal)
                    button.setTitleColor(UIColor.darkGray, for: .normal)
                    button.titleLabel?.font = UIFont.systemFont(ofSize: 9)
                    button.setImage(UIImage(named:imageArray[i]), for: .normal)
                    button.addTarget(self, action: #selector(self.fourBtn(btn:)), for: .touchUpInside)
                    self.contentView.addSubview(button)
                }

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
               self.topCommentTableV.removeFromSuperview()
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
               self.topCommentTableV.removeFromSuperview()
                
            }
            else if (self.topic.type.lowercased() == "text")
            {
                self.namePic.sd_setImage(with: URL(string: topic.u.header))
                nameLabel.text = topic.u.name
                commentLabel.text = topic.text
                passtimeLabel.text = topic.passtime
               self.topCommentTableV.removeFromSuperview()
            }
        }

    }
   
}
