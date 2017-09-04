//
//  TGLookingAroundCell.swift
//  banqianQiJie
//
//  Created by banbo on 2017/8/21.
//  Copyright © 2017年 banbo. All rights reserved.
//

import UIKit
import AVFoundation
import DACircularProgress
class TGLookingAroundCell: UICollectionViewCell {
    var commentBlock:((_ topicId:String)->Void)!
    var NextBlock:((_ topicId:String)->Void)!
    var imageV:AsyncImageView!
    var headerImageView:AsyncImageView!
    var likeBtn:UIButton!
    var voiceTimeLabel:UILabel!
    var playCountLabel:UILabel!
    var voicePlayBtn:UIButton!
    var avTimer:Timer!
    var playerItem:AVPlayerItem!
    var lastPlayBtn:UIButton!
    public var voice_player:AVPlayer!
    var lastProfileImageV:UIImageView!
    var progressV:DALabeledCircularProgressView!
    var lastTopicM:TGTopicNewM!
   public var topic:TGTopicNewM!
   {
        didSet{
            AsyncImageLoader.shared().cancelLoadingImages(forTarget: imageV)
            imageV.imageURL = URL(string:topic.image)
            AsyncImageLoader.shared().cancelLoadingImages(forTarget: headerImageView)
            headerImageView.imageURL = URL(string:topic.u.header)
            voiceTimeLabel.text = "\(topic.audio_duration / 60):\(topic.audio_duration % 60)"
            likeBtn.isSelected = topic.isLikeSelected
            voicePlayBtn.setImage(UIImage(named: topic.is_voicePlaying ? "walkman_pause" : "playButtonPlay"), for: .normal)
            topic.is_voicePlaying ? addRotationAnimation() : imageV.layer.removeAllAnimations()
            if topic.is_voicePlaying
            {
            progressV.isHidden = false
            playCountLabel.text = "\( topic.audio_playcount)"
            }
            for temView in self.contentView.subviews
            {
                if temView.isMember(of: DALabeledCircularProgressView.self)
                {
                temView.isHidden = !topic.is_voicePlaying
                }
            }
            var oncetoken = 0
            if oncetoken==0
            {
                playerItem = AVPlayerItem(url: URL(string: topic.audio_uri)!)
                voice_player = AVPlayer(playerItem: playerItem)
                avTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(TGLookingAroundCell.timer), userInfo: nil, repeats: true)
                avTimer.fireDate = Date.distantFuture
                progressV = DALabeledCircularProgressView(frame: voicePlayBtn.frame)
               // imageV.addSubview(progressV)
                progressV.roundedCorners = 0
                progressV.progressLabel.textColor = UIColor.red
                progressV.trackTintColor = UIColor.white
                progressV.progressTintColor = UIColor.red
                //progressV.isHidden = true
                progressV.progressLabel.text = ""
                progressV.thicknessRatio = 0.1
                progressV.setProgress(0, animated: false)
            }
            oncetoken = 1
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
        
    }
    func showDetail()
    {
    commentBlock(self.topic.id)
    }
    func timer()
    {
        let currentTime = CMTimeGetSeconds((voice_player.currentItem?.currentTime())!)
        if currentTime > 0 {
            progressV.setProgress(CGFloat(currentTime / CMTimeGetSeconds((voice_player.currentItem?.duration)!)), animated: true)
        }
    }
    func createUI()
    {
        imageV = AsyncImageView()
        imageV.layer.cornerRadius = 5
        imageV.layer.masksToBounds = true
        imageV.isUserInteractionEnabled = true
        imageV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(TGLookingAroundCell.showDetail)))
        self.addSubview(imageV)
        imageV.mas_makeConstraints { [weak self](make) in
            make?.edges.equalTo()(self)
        }
        headerImageView = AsyncImageView()
        headerImageView.layer.cornerRadius = 12.5
        headerImageView.layer.masksToBounds = true
        self.addSubview(headerImageView)
        headerImageView.mas_makeConstraints { [weak self](make) in
            make?.top.and().left().equalTo()(self)?.offset()(2)
            make?.width.and().height().mas_equalTo()(25)
        }
        headerImageView.layoutIfNeeded()
        likeBtn = UIButton()
        likeBtn.setImage(UIImage(named:"cell_like_in_my_music_pressed"), for: .normal)
        likeBtn.addTarget(self, action: #selector(TGLookingAroundCell.loveClick(btn:)), for: .touchUpInside)
        self.addSubview(likeBtn)
        likeBtn.mas_makeConstraints { [weak self](make) in
            make?.left.equalTo()(self?.headerImageView.mas_right)?.offset()(10)
            make?.width.and().height().mas_equalTo()(30)
        }
        voiceTimeLabel = UILabel()
        voiceTimeLabel.font = UIFont.systemFont(ofSize: 9)
        voiceTimeLabel.textColor = UIColor.white
        voiceTimeLabel.numberOfLines = 0
        self.addSubview(voiceTimeLabel)
        voiceTimeLabel.mas_makeConstraints { [weak self](make) in
            make?.right.equalTo()(self)?.offset()(-5)
            make?.top.equalTo()(self)?.offset()(5)
        }
        playCountLabel = UILabel()
        playCountLabel.font = UIFont.systemFont(ofSize: 9)
        playCountLabel.textColor = UIColor.white
        playCountLabel.numberOfLines = 0
        self.addSubview(playCountLabel)
        playCountLabel.mas_makeConstraints { [weak self](make) in
            make?.bottom.equalTo()(self)?.offset()(-10)
            make?.left.equalTo()(self)?.offset()(5)
        }
        voicePlayBtn = UIButton()
        voicePlayBtn.setImage(UIImage(named:"playButtonPlay"), for: .normal)
        voicePlayBtn.addTarget(self, action: #selector(TGLookingAroundCell.play(playBtn:)), for: .touchUpInside)
        self.addSubview(voicePlayBtn)
        voicePlayBtn.mas_makeConstraints { [weak self](make) in
            make?.bottom.equalTo()(self?.bottom)?.offset()(-10)
            make?.right.equalTo()(self)?.multipliedBy()(0.6)
            make?.width.and().height().mas_equalTo()(30)
        }
        voicePlayBtn.layoutIfNeeded()
    }
    func loveClick(btn:UIButton)
    {
        if !btn.isSelected
        {
            btn.setImage(UIImage(named:"mini_loved"), for: .normal)
            btn.isSelected = true
            self.topic.isLikeSelected = btn.isSelected
        }
        else
        {
            btn.setImage(UIImage(named:"cell_like_in_my_music_pressed"), for: .normal)
            btn.isSelected = false
            self.topic.isLikeSelected = btn.isSelected
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func play()
    {
       play(playBtn: self.voicePlayBtn)
    }
    func addRotationAnimation()
    {
        let direction = -1.0
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber(value: (2 * Double.pi) * direction)
        rotationAnimation.duration = 4.0
        rotationAnimation.repeatCount = HUGE
        imageV.layer.add(rotationAnimation, forKey: "rotateAnimation")
    }
    func removeRotateAnimation()
    {
        
        imageV.layer.removeAllAnimations()
    }
    func play(playBtn:UIButton)
    {
        playBtn.isSelected = !playBtn.isSelected
       
        if lastTopicM != self.topic {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerItem)
            self.playerItem = AVPlayerItem(url: URL(string: topic.audio_uri)!)
            NotificationCenter.default.addObserver(self, selector: #selector(TGVoiceNewV.playerItemDidReachEnd(playerItem:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerItem)
            voice_player.replaceCurrentItem(with: self.playerItem)
            progressV.frame = CGRect(x: voicePlayBtn.frame.origin.x, y: voicePlayBtn.frame.origin.y, width: self.voicePlayBtn.frame.size.width, height: self.voicePlayBtn.frame.size.height)
            self.insertSubview(progressV, belowSubview: self.voicePlayBtn)
            progressV.setProgress(0, animated: false)
            progressV.isHidden = false
            voice_player.play()
            removeRotateAnimation()
            addRotationAnimation()
            avTimer.fireDate = Date()
            self.topic.is_voicePlaying = true
            voicePlayBtn.setImage(UIImage(named:"walkman_pause"), for: .normal)
        }
        else
        {
            if lastTopicM.is_voicePlaying
            {
                voice_player.pause()
                removeRotateAnimation()
                progressV.removeFromSuperview()
                avTimer.fireDate = NSDate.distantFuture
                self.topic.is_voicePlaying = false
                playBtn.setImage(UIImage(named:"playButtonPlay"), for: .normal)
            }
            else
            {
                NotificationCenter.default.addObserver(self, selector: #selector(TGVoiceNewV.playerItemDidReachEnd(playerItem:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerItem)
                progressV.frame = CGRect(x: voicePlayBtn.frame.origin.x, y: voicePlayBtn.frame.origin.y, width: self.voicePlayBtn.frame.size.width, height: self.voicePlayBtn.frame.size.height)
                self.insertSubview(progressV, belowSubview: self.voicePlayBtn)
                voice_player.play()
                removeRotateAnimation()
                addRotationAnimation()
                avTimer.fireDate = Date()
                self.topic.is_voicePlaying = true
                playBtn.setImage(UIImage(named:"walkman_pause"), for: .normal)
            }
        }
        lastTopicM = topic
        lastPlayBtn = playBtn
        lastProfileImageV = self.imageV
    }
    func replacePlayerItem(topic:TGTopicNewM)
    {
        lastTopicM = topic
        lastTopicM.is_voicePlaying = true
        voice_player.pause()
        voice_player.seek(to: kCMTimeZero)
        NotificationCenter.default.addObserver(self, selector: #selector(TGVoiceNewV.playerItemDidReachEnd(playerItem:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerItem)
        voice_player.replaceCurrentItem(with: self.playerItem)
        voice_player.play()
    }
    func playerItemDidReachEnd(playerItem:AVPlayerItem)
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerItem)
        lastTopicM.is_voicePlaying = false
        topic.is_voicePlaying = false
        lastPlayBtn.setImage(UIImage(named:"playButtonPlay"), for: .normal)
        voicePlayBtn.setImage(UIImage(named:"playButtonPlay"), for: .normal)
        voice_player.pause()
        voice_player.seek(to: kCMTimeZero)
        removeRotateAnimation()
        progressV.setProgress(0, animated: false)
        progressV.removeFromSuperview()
        progressV.isHidden = true
        self.NextBlock(lastTopicM.id)
    }
}
