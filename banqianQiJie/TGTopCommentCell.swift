//
//  TGTopCommentCell.swift
//  banqianQiJie
//
//  Created by banbo on 2017/8/11.
//  Copyright © 2017年 banbo. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
class TGTopCommentCell: UITableViewCell {
    var iconImageV:AsyncImageView!
    var userLabel:UILabel!
    var commentLabel:UILabel!
    var voiceBtn:UIButton!
    var playerItem:AVPlayerItem!
    var commentPlayer:AVPlayer!
    var lastBtn:UIButton!
    var lastCommentM:TGCommentNewM!
    var commentM:TGCommentNewM!
    {
        didSet{
           // printLog(message: "\(commentM.u.name),\(commentM.voiceuri)")
            if commentM.u.header != nil
            {
                AsyncImageLoader.shared().cancelLoadingImages(forTarget: iconImageV)
                iconImageV.imageURL = URL(string: commentM.u.header)
                
            }
            else
            {
                AsyncImageLoader.shared().cancelLoadingImages(forTarget: iconImageV)
                iconImageV.imageURL = URL(string: commentM.user.header)
            }
            let textSizes = CGSize(width:screen_width-20,height:CGFloat(MAXFLOAT));
            let textSize:CGSize = commentM.u.name.boundingRect(with: textSizes, options: .usesLineFragmentOrigin, attributes: [
                NSFontAttributeName : UIFont.systemFont(ofSize: 10)], context: nil).size
            userLabel.mas_remakeConstraints { (make) in
                make?.top.equalTo()(self.iconImageV)?.offset()(2)
                make?.left.equalTo()(self.iconImageV.mas_right)?.offset()(5)
                make?.width.mas_equalTo()(textSize.width+5)
                make?.height.mas_equalTo()(textSize.height)
            }
            userLabel.text = String(format:"%@:",commentM.u.name)
            if (commentM.attrStrM != nil) {
                commentLabel = UILabel()
                commentLabel.numberOfLines = 0
                self.contentView.addSubview(commentLabel)
                commentLabel.mas_makeConstraints { [weak self](make) in
                    make?.left.equalTo()(self?.userLabel.mas_right)
                    make?.centerY.equalTo()(self?.iconImageV)
                }
                let  firstAttributes = [NSFontAttributeName:UIFont.systemFont(ofSize: 10),NSForegroundColorAttributeName:UIColor.darkGray]
                let firstPart = commentM.attrStrM!
                firstPart.setAttributes(firstAttributes as [String : Any], range: NSRange(location: 0, length: (firstPart.length)))
                commentLabel.attributedText = firstPart
            }
            else if (commentM.voiceuri != nil)
            {
                voiceBtn = UIButton()
                self.contentView.addSubview(voiceBtn)
                voiceBtn.mas_makeConstraints({ [weak self](make) in
                    make?.left.equalTo()(self?.iconImageV.mas_right)?.offset()(5)
                    make?.centerY.equalTo()(self?.iconImageV)
                })
                voiceBtn.setTitle("\(commentM.voicetime)", for: .normal)
                setBtn(btn: self.voiceBtn, isPlay: commentM.is_voicePlaying)
                self.voiceBtn.setImage(UIImage(named:"play-voice-icon-2"), for: .normal)
                var onceToken: Int = 0
                if (onceToken == 0) {
                    self.playerItem = AVPlayerItem(url: URL(string: commentM.voiceuri)!)
                    self.commentPlayer = AVPlayer(playerItem: self.playerItem)
                    self.commentPlayer.volume = 1.0
                }
                onceToken = 1
                voiceBtn.addTarget(self, action: #selector(TGTopCommentCell.voicePlay(sender:)), for: .touchUpInside)
            }
            else
            {
                commentLabel = UILabel()
                commentLabel.numberOfLines = 0
                commentLabel.textColor = UIColor.darkGray
                commentLabel.font = UIFont.systemFont(ofSize: 10)
                self.contentView.addSubview(commentLabel)
                commentLabel.mas_makeConstraints { [weak self](make) in
                    make?.left.equalTo()(self?.userLabel.mas_right)
                    make?.top.equalTo()(self?.iconImageV)?.offset()(2)
                    make?.right.equalTo()(self)?.offset()(-10)
                }
                commentLabel.text = commentM.content
            }
        }
    }
    func voicePlay(sender:UIButton)
    {
        sender.isSelected = !sender.isSelected
        lastBtn.isSelected = !lastBtn.isSelected
        if lastCommentM != self.commentM {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerItem)
            self.playerItem = AVPlayerItem(url: URL(string: self.commentM.voiceuri)!)
            NotificationCenter.default.addObserver(self, selector: #selector(TGTopCommentCell.playerItemDidReachEnd(playItem:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerItem)
            commentPlayer.replaceCurrentItem(with: self.playerItem)
            commentPlayer.play()
            lastCommentM.is_voicePlaying = false
            self.commentM.is_voicePlaying = true
            setBtn(btn: lastBtn, isPlay: lastCommentM.is_voicePlaying)
            setBtn(btn: sender, isPlay: self.commentM.is_voicePlaying)
        }
        else
        {
            if lastCommentM.is_voicePlaying
            {
                commentPlayer.pause()
                self.commentM.is_voicePlaying = false
                setBtn(btn: sender, isPlay: self.commentM.is_voicePlaying)
            }
            else
            {
                commentPlayer.play()
                lastCommentM.is_voicePlaying = false
                setBtn(btn: lastBtn, isPlay: lastCommentM.is_voicePlaying)
                NotificationCenter.default.addObserver(self, selector: #selector(TGTopCommentCell.playerItemDidReachEnd(playItem:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerItem)
                self.commentM.is_voicePlaying = true
                setBtn(btn: sender, isPlay: self.commentM.is_voicePlaying)
            }
        }
        lastCommentM = self.commentM
        lastBtn = sender
    }
    func playerItemDidReachEnd(playItem:AVPlayerItem)
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerItem)
        lastCommentM.is_voicePlaying = false
        self.commentM.is_voicePlaying = false
        setBtn(btn: lastBtn, isPlay: lastCommentM.is_voicePlaying)
        commentPlayer.pause()
        commentPlayer.seek(to: kCMTimeZero)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override var canBecomeFirstResponder: Bool
    {
        return true
    }
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    func setBtn(btn:UIButton,isPlay:Bool) ->Void
    {
        if !(!isPlay && (btn.imageView?.isAnimating)!)  {
            btn.imageView?.stopAnimating()
        }
        else if !(isPlay == true && !(btn.imageView?.isAnimating)!)
        {
            btn.imageView?.startAnimating()
        }
        
        
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createUI()
    }
    func createUI()
    {
        iconImageV = AsyncImageView()
        iconImageV.layer.cornerRadius = 10
        iconImageV.layer.masksToBounds = true
        self.contentView.addSubview(iconImageV)
        iconImageV .mas_makeConstraints { [weak self](make) in
            make?.top.equalTo()(self)?.offset()(5)
            make?.left.equalTo()(self)?.offset()(5)
            make?.width.and().height().mas_equalTo()(20)
        }
        userLabel = UILabel()
        userLabel.numberOfLines = 0
        userLabel.font = UIFont.systemFont(ofSize: 10)
        userLabel.textColor = UIColor.red
        self.contentView.addSubview(userLabel)
        userLabel.mas_makeConstraints { (make) in
            make?.top.equalTo()(self.iconImageV)?.offset()(2)
            make?.left.equalTo()(self.iconImageV.mas_right)?.offset()(5)
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
