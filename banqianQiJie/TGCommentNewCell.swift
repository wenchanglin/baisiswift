//
//  TGCommentNewCell.swift
//  banqianQiJie
//
//  Created by banbo on 2017/8/16.
//  Copyright © 2017年 banbo. All rights reserved.
//

import UIKit
import AVFoundation
import SVProgressHUD
class TGCommentNewCell: UITableViewCell,WMPlayerDelegate {
    var namePic:AsyncImageView!
    var nameLabel:UILabel!
    var imageV: AsyncImageView!
    var sexImageView:UIImageView!
    var timelabel:UILabel!
    var totalLikeLabel:UILabel!
    var playDurationLabel:UILabel!
    var likeBtn:UIButton!
    var HateBtn:UIButton!
    var voiceBtn:UIButton!
    var videoPlayBtn:UIButton!
    var commentLabel:UILabel!
    var playerItem:AVPlayerItem!
    var commentPlayer:AVPlayer!
    var playerLayer:AVPlayerLayer!
    var lastBtn:UIButton!
    var lastPlayBtn:UIButton!
    var lastCommentM:TGCommentNewM!
    var avTimer:Timer!
    var progress:UIProgressView!
    var wmPlayer:WMPlayer!
    var isSmallScreen:Bool = true

    var commentM:TGCommentNewM!
    {
        didSet{
            namePic.tg_setHeader(commentM.user.profile_image)
            if commentM.user.sex == "m"
            {
                sexImageView.image = UIImage(named: "Profile_manIcon")
            }
            else if commentM.user.sex == "f"
            {
                sexImageView.image = UIImage(named: "Profile_womanIcon")
            }
            nameLabel.text = commentM.user.username
            timelabel.text = commentM.ctime
            likeBtn.setTitle("\(commentM.like_count)", for: .normal)
            likeBtn.setTitleColor(UIColor.gray, for: .normal)
            HateBtn.setTitle("\(commentM.hate_count)", for: .normal)
            HateBtn.setTitleColor(UIColor.gray, for: .normal)
            if commentM.user.total_cmt_like_count >= 1000 {
                totalLikeLabel.text = "\(commentM.user.total_cmt_like_count/1000)k"
                if  commentM.user.total_cmt_like_count >= 10000
                {
                    totalLikeLabel.backgroundColor = TGColor(r: 250, g: 195, b: 198)
                }
                else
                {
                    totalLikeLabel.backgroundColor = TGColor(r: 212, g: 205, b: 214)
                }
            }
            else
            {
                totalLikeLabel.text = "\(commentM.user.total_cmt_like_count)"
                totalLikeLabel.backgroundColor = TGColor(r: 191, g: 205, b: 224)
            }
            if commentM.voiceuri != nil
            {
                voiceBtn = UIButton()
                //commentLabel.text = ""
                voiceBtn.setTitle("\(commentM.voicetime)", for: .normal)
                voiceBtn.setImage(UIImage(named:"play-voice-icon-2"), for: .normal)
                self.contentView.addSubview(voiceBtn)
                voiceBtn.addTarget(self, action: #selector(TGCommentNewCell.voicePlay(sender:)), for: .touchUpInside)
                voiceBtn.mas_makeConstraints({ [weak self](make) in
                    make?.top.equalTo()(self?.timelabel.mas_bottom)?.offset()(5)
                    make?.left.equalTo()(self?.totalLikeLabel.mas_right)?.offset()(2)
                    make?.width.mas_equalTo()(30)
                    make?.height.mas_equalTo()(30)
                })
            }
            else if commentM.image != nil
            {
                
                imageV = AsyncImageView()
                AsyncImageLoader.shared().cancelLoadingImages(forTarget: imageV)
                imageV.imageURL = URL(string:commentM.image)
                self.contentView.addSubview(imageV)
                imageV.mas_makeConstraints({[weak self](make) in
                    make?.top.equalTo()(self?.timelabel.mas_bottom)?.offset()(5)
                    make?.left.equalTo()(self?.totalLikeLabel.mas_right)?.offset()(2)
                    make?.width.and().height().mas_equalTo()(200)
                })
            }
            else if commentM.videouri != nil
            {
                imageV = AsyncImageView()
                imageV.isUserInteractionEnabled = true
                AsyncImageLoader.shared().cancelLoadingImages(forTarget: imageV)
                imageV.imageURL = URL(string:commentM.video_thumbnail)
                self.contentView.addSubview(imageV)
                imageV.mas_makeConstraints({ [weak self](make) in
                    make?.top.equalTo()(self?.timelabel.mas_bottom)?.offset()(5)
                    make?.left.equalTo()(self?.totalLikeLabel.mas_right)?.offset()(2)
                    make?.right.equalTo()(self)?.offset()(-10)
                    make?.height.mas_equalTo()(200)
                })
                videoPlayBtn = UIButton()
                videoPlayBtn.setImage(UIImage(named:"video-play"), for: .normal)
                videoPlayBtn.addTarget(self, action: #selector(TGCommentNewCell.play(playBtn:)), for: .touchUpInside)
                imageV.addSubview(videoPlayBtn)
                videoPlayBtn.mas_makeConstraints { [weak self](make) in
                    make?.centerX.and().centerY().equalTo()(self?.imageV)
                    make?.width.and().height().mas_equalTo()(50)
                }
                playDurationLabel.text = "\(commentM.videotime)"
                commentLabel = UILabel()
                commentLabel.font = UIFont.systemFont(ofSize: 11)
                commentLabel.numberOfLines = 0
                commentLabel.text = commentM.content
                commentLabel.textColor = UIColor.gray
                self.contentView.addSubview(commentLabel)
                commentLabel.mas_makeConstraints({ [weak self](make) in
                    make?.top.equalTo()(self?.imageV.mas_bottom)?.offset()(5)
                    make?.left.equalTo()(self?.totalLikeLabel.mas_right)?.offset()(2)
                    make?.right.equalTo()(self)?.offset()(-10)
                })

                
            }
            else
            {
                commentLabel = UILabel()
                commentLabel.font = UIFont.systemFont(ofSize: 11)
                commentLabel.numberOfLines = 0
                commentLabel.text = commentM.content
                commentLabel.textColor = UIColor.gray
                self.contentView.addSubview(commentLabel)
                commentLabel.mas_makeConstraints({ [weak self](make) in
                    make?.top.equalTo()(self?.timelabel.mas_bottom)?.offset()(5)
                    make?.left.equalTo()(self?.totalLikeLabel.mas_right)?.offset()(2)
                    make?.right.equalTo()(self)?.offset()(-10)
                })
            }
        }
    }
    
    func play(playBtn:UIButton)
    {
        let videoUrl = commentM.videouri
        if isSmallScreen {
            // releaseWMPlayer()
            isSmallScreen = false
        }
        self.wmPlayer = WMPlayer(frame: imageV.frame)
        self.wmPlayer.delegate = self
        self.wmPlayer.closeBtnStyle = .close
        self.wmPlayer.urlString = videoUrl
        self.wmPlayer.titleLabel.font = UIFont.systemFont(ofSize: 9)
        self.wmPlayer.titleLabel.adjustsFontSizeToFitWidth = true
        self.wmPlayer.titleLabel.text = commentM.content
        self.wmPlayer.play()
        self.addSubview(self.wmPlayer)
    }
    func wmplayer(_ wmplayer: WMPlayer!, clickedClose closeBtn: UIButton!) {
        releaseWMPlayer()
        
    }
    func wmplayer(_ wmplayer: WMPlayer!, clickedFullScreenButton fullScreenBtn: UIButton!) {
        printLog(message: "你点击了满屏")
        isSmallScreen = !isSmallScreen
        
        if isSmallScreen
        {
            toFullScreen(with: .landscapeRight)
        }
        else
        {
            releaseWMPlayer()
        }
    }
    func toFullScreen(with interfaceOrientation: UIInterfaceOrientation) {
        wmPlayer.removeFromSuperview()
        wmPlayer.transform = CGAffineTransform.identity
        if interfaceOrientation == .landscapeLeft {
            wmPlayer.transform = CGAffineTransform(rotationAngle: -.pi / 2)
        }
        else if interfaceOrientation == .landscapeRight {
            wmPlayer.transform = CGAffineTransform(rotationAngle: .pi / 2)
        }
        
        // 重新设置frame
        wmPlayer.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        wmPlayer.playerLayer.frame = CGRect(x: 0, y: 0, width: kScreenHeight, height: kScreenWidth)
        wmPlayer.bottomView.mas_remakeConstraints{(make) -> Void in
            make?.height.mas_equalTo()(40)
            make?.top.mas_equalTo()(screen_width - 40)
            make?.width.mas_equalTo()(kScreenHeight)
        }
        wmPlayer.bottomView.mas_remakeConstraints{(make) -> Void in
            make?.height.mas_equalTo()(40)
            make?.top.mas_equalTo()(kScreenWidth - 40)
            make?.width.mas_equalTo()(kScreenHeight)
        }
        wmPlayer.topView.mas_remakeConstraints{(make) -> Void in
            make?.height.mas_equalTo()(40)
            //        make.left.equalTo(wmPlayer).with.offset(0);
            make?.top.mas_equalTo()(0)
            make?.width.mas_equalTo()(kScreenHeight)
        }
        wmPlayer.titleLabel.mas_remakeConstraints { (make) in
            make?.left.equalTo()(self.wmPlayer.topView)?.offset()(45)
            make?.right.equalTo()(self.wmPlayer.topView)?.offset()(-45)
            make?.center.equalTo()(self.wmPlayer.topView)
            make?.top.equalTo()(self.wmPlayer.topView)
        }
        wmPlayer.closeBtn.mas_remakeConstraints{(make) -> Void in
            make?.right.equalTo()(self.wmPlayer)?.with().offset()((-kScreenHeight / 2))
            make?.height.mas_equalTo()(30)
            make?.width.mas_equalTo()(30)
            make?.top.equalTo()(self.wmPlayer)?.with().offset()(5)
        }
        wmPlayer.loadFailedLabel.mas_remakeConstraints{(make) -> Void in
            make?.width.mas_equalTo()(kScreenHeight)
            make?.center.mas_equalTo()(CGPoint(x: kScreenWidth / 2 - 36, y: -(kScreenWidth / 2)))
            make?.height.equalTo()(30)
        }
        wmPlayer.loadingView.mas_remakeConstraints{(make) -> Void in
            make?.center.mas_equalTo()(CGPoint(x: kScreenWidth / 2 - 37, y: -(kScreenWidth / 2 - 37)))
        }
        wmPlayer.loadFailedLabel.mas_remakeConstraints{(make) -> Void in
            make?.width.mas_equalTo()(kScreenHeight)
            make?.center.mas_equalTo()(CGPoint(x: kScreenWidth / 2 - 36, y: -(kScreenWidth / 2) + 36))
            make?.height.equalTo()(30)
        }
        UIApplication.shared.keyWindow?.addSubview(wmPlayer)
        wmPlayer.bringSubview(toFront: wmPlayer.bottomView)
    }
    func wmplayer(_ wmplayer: WMPlayer!, singleTaped singleTap: UITapGestureRecognizer!) {
        printLog(message: "didSingleTaped")
        
        isSmallScreen = !isSmallScreen
        
        if isSmallScreen
        {
            SVProgressHUD.showError(withStatus: "全屏")
            toFullScreen(with: .landscapeRight)
        }
        else
        {
            SVProgressHUD.showError(withStatus: "退出全屏")
            releaseWMPlayer()
        }
    }
    func wmplayer(_ wmplayer: WMPlayer!, doubleTaped doubleTap: UITapGestureRecognizer!) {
        // printLog(message: "didDoubleTaped")
        SVProgressHUD.showError(withStatus: "暂停")
    }

    func releaseWMPlayer()
    {
        if self.wmPlayer != nil
        {
            self.wmPlayer.player.currentItem?.cancelPendingSeeks()
            self.wmPlayer.player.currentItem?.asset.cancelLoading()
            self.wmPlayer.pause()
            self.wmPlayer.removeFromSuperview()
            self.wmPlayer.playerLayer.removeFromSuperlayer()
            self.wmPlayer.player.replaceCurrentItem(with: nil)
            self.wmPlayer.player = nil
            self.wmPlayer.currentItem = nil
            self.wmPlayer.autoDismissTimer.invalidate()
            self.wmPlayer.autoDismissTimer = nil
            self.wmPlayer.playOrPauseBtn = nil
            self.wmPlayer.playerLayer = nil
            self.wmPlayer = nil
        }
    }
    func voicePlay(sender:UIButton)
    {
        if lastCommentM != self.commentM {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerItem)
            self.playerItem = AVPlayerItem(url: URL(string: commentM.voiceuri)!)
            NotificationCenter.default.addObserver(self, selector: #selector(TGCommentNewCell.playerItemDidReachEnd(playerItem:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerItem)
            //commentPlayer.replaceCurrentItem(with: self.playerItem)
            commentPlayer = AVPlayer(playerItem: self.playerItem)
            commentPlayer.play()
            //lastCommentM.is_voicePlaying = false
            commentM.is_voicePlaying = true
        }
        else
        {
            if lastCommentM.is_voicePlaying
            {
                commentPlayer.pause()
                commentM.is_voicePlaying = false
            }
            else
            {
                commentPlayer.play()
                NotificationCenter.default.addObserver(self, selector: #selector(TGCommentNewCell.playerItemDidReachEnd(playerItem:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerItem)
                commentM.is_voicePlaying = true
            }
        }
        lastCommentM = commentM
        lastBtn = sender
    }
    func playerItemDidReachEnd(playerItem:AVPlayerItem)
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerItem)
        lastCommentM.is_videoPlaying = false
        commentM.is_voicePlaying = false
        commentPlayer.pause()
        commentPlayer.seek(to: kCMTimeZero)
       
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        releaseWMPlayer()
        
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createUI()
    }
    func createUI()
    {
        namePic = AsyncImageView()
        namePic.layer.cornerRadius = 12.5
        namePic.layer.masksToBounds = true
        self.contentView.addSubview(namePic)
        namePic.mas_makeConstraints { [weak self](make) in
            make?.left.equalTo()(self)?.offset()(10)
            make?.top.equalTo()(self)?.offset()(5)
            make?.width.and().height().mas_equalTo()(25)
        }
        sexImageView = UIImageView()
        self.contentView.addSubview(sexImageView)
        sexImageView.mas_makeConstraints { [weak self](make) in
            make?.top.equalTo()(self?.namePic)
            make?.left.equalTo()(self?.namePic.mas_right)
            make?.width.and().height().mas_equalTo()(13)
        }
        nameLabel = UILabel()
        nameLabel.numberOfLines = 0
        nameLabel.font = UIFont.systemFont(ofSize: 9)
        nameLabel.textColor = UIColor.blue
        self.contentView.addSubview(nameLabel)
        nameLabel.mas_makeConstraints { [weak self](make) in
            make?.top.equalTo()(self?.sexImageView)
            make?.left.equalTo()(self?.sexImageView.mas_right)
        }
        timelabel = UILabel()
        timelabel.numberOfLines = 0
        timelabel.font = UIFont.systemFont(ofSize: 8)
        self.contentView.addSubview(timelabel)
        timelabel.mas_makeConstraints { [weak self](make) in
            make?.left.equalTo()(self?.namePic.mas_right)?.offset()(2)
            make?.top.equalTo()(self?.sexImageView.mas_bottom)
        }
        totalLikeLabel = UILabel()
        totalLikeLabel.numberOfLines = 0
        totalLikeLabel.textAlignment = .center
        totalLikeLabel.font = UIFont.systemFont(ofSize: 9)
        self.contentView.addSubview(totalLikeLabel)
        totalLikeLabel.mas_makeConstraints { [weak self](make) in
            make?.top.equalTo()(self?.namePic.mas_bottom)?.offset()(5)
            make?.left.equalTo()(self?.namePic)
            make?.width.mas_equalTo()(self?.namePic)
            make?.height.mas_equalTo()(11)
        }
        HateBtn = UIButton()
        HateBtn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        HateBtn.setImage(UIImage(named:"icon_unlike_normal"), for: .normal)
        HateBtn.addTarget(self, action: #selector(TGCommentNewCell.hateClick(btn:)), for: .touchUpInside)
        self.contentView.addSubview(HateBtn)
        HateBtn.mas_makeConstraints { [weak self](make) in
            make?.right.equalTo()(self)?.offset()(-10)
            make?.top.equalTo()(self?.namePic)
            make?.height.mas_equalTo()(18)
            make?.width.mas_equalTo()(40)
        }
        likeBtn = UIButton()
        likeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        likeBtn.addTarget(self, action: #selector(TGCommentNewCell.likeBtn(btn:)), for: .touchUpInside)
        likeBtn.setImage(UIImage(named:"commentLikeButton"), for: .normal)
        self.contentView.addSubview(likeBtn)
        likeBtn.mas_makeConstraints { [weak self](make) in
            make?.right.equalTo()(self?.HateBtn.mas_left)?.offset()(-10)
            make?.top.equalTo()(self?.namePic)
            make?.height.mas_equalTo()(18)
            make?.width.mas_equalTo()(40)
        }
        playDurationLabel = UILabel()
        playDurationLabel.numberOfLines = 0
        playDurationLabel.textAlignment = .center
        playDurationLabel.font = UIFont.systemFont(ofSize: 9)
        self.contentView.addSubview(playDurationLabel)
        playDurationLabel.mas_makeConstraints { [weak self](make) in
            make?.top.equalTo()(self?.totalLikeLabel.mas_bottom)?.offset()(5)
            make?.left.equalTo()(self?.namePic)
            make?.width.mas_equalTo()(self?.namePic)
            make?.height.mas_equalTo()(11)
        }
        
    }
    func likeBtn(btn:UIButton)
    {
        if !btn.isSelected
        {
            btn.setImage(UIImage(named:"timeline_icon_like"), for: .normal)
            btn.isSelected = true
            btn.setTitle("\(commentM.like_count+1)", for: .normal)
        }
        else
        {
            btn.setImage(UIImage(named:"timeline_icon_unlike"), for: .normal)
            btn.isSelected = false
            btn.setTitle("\(commentM.like_count)", for: .normal)
        }
        
    }
    func hateClick(btn:UIButton)
    {
        if !btn.isSelected
        {
            btn.setImage(UIImage(named:"icon_unlike_h"), for: .normal)
            btn.isSelected = true
            btn.setTitle("\(commentM.hate_count+1)", for: .normal)
        }
        else
        {
            btn.setImage(UIImage(named:"icon_unlike_normal"), for: .normal)
            btn.isSelected = false
            btn.setTitle("\(commentM.hate_count)", for: .normal)
        }
        
    }
    override var canBecomeFirstResponder: Bool
    {
        return true
    }
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
