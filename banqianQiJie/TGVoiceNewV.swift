//
//  TGVoiceNewV.swift
//  banqianQiJie
//
//  Created by banbo on 2017/8/10.
//  Copyright © 2017年 banbo. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import DACircularProgress
class TGVoiceNewV: UIView {
    var imageV:UIImageView!
    var playcountLabel:UILabel!
    var voicetimeLabel:UILabel!
    var voicePlayBtn:UIButton!
    var voice_player:AVPlayer!
    var playerItem:AVPlayerItem!
    var avTimer:Timer!
    var progress:DALabeledCircularProgressView!
    var lastTopicM:ceShiModel!
    var lastPlayBtn:UIButton!
    var topVoiceModel:ceShiModel!
    {
        didSet{
            if ((lastTopicM != nil) && topVoiceModel.id != lastTopicM.id)
            {
                progress.isHidden = true
                progress.removeFromSuperview()
            }
            self.imageV.tg_setOriginImage(topVoiceModel.image, thumbnailImage: topVoiceModel.audio_thumbnail_small, placeholder: nil, progress: nil, completed: nil)
            self.playcountLabel.text = "\(topVoiceModel.audio_playcount)播放"
            self.voicetimeLabel.text = "\(topVoiceModel.audio_duration / 60):\(topVoiceModel.audio_duration % 60)"
            self.voicePlayBtn.setImage(UIImage(named:topVoiceModel.is_voicePlaying ?"playButtonPause":"playButtonPlay"), for: .normal)
            var onceToken = 0
            if onceToken == 0
            {
                self.playerItem = AVPlayerItem(url: URL(string: topVoiceModel.audio_uri)!)
                voice_player = AVPlayer(playerItem: playerItem)
                avTimer = Timer(timeInterval: 0.1, target: self, selector: #selector(TGVoiceNewV.timer), userInfo: nil, repeats: true)
                avTimer.fireDate = NSDate.distantFuture
                progress = DALabeledCircularProgressView()
                progress.frame = CGRect(x:voicePlayBtn.frame.origin.x-2,y:voicePlayBtn.frame.origin.y-2,width:voicePlayBtn.frame.size.width+4,height:voicePlayBtn.frame.size.height+4)
                self.addSubview(progress)
                progress.roundedCorners = 1
                progress.trackTintColor = UIColor.clear
                progress.progressTintColor = UIColor.red
                progress.isHidden = true
            }
            onceToken = 1
            if topVoiceModel.is_voicePlaying
            {
                self.insertSubview(progress, belowSubview: self.voicePlayBtn)
                progress.isHidden = !topVoiceModel.is_voicePlaying
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
       
    }
    func timer()
    {
        let currentTime:Float64 = CMTimeGetSeconds((voice_player.currentItem?.currentTime())!)
        if (currentTime > 0)
        {
            progress.isHidden = false
            progress.setProgress(CGFloat(currentTime / CMTimeGetSeconds((voice_player.currentItem?.duration)!)), animated: true)
            progress.progressLabel.text = "\(progress.progress * 100)"
           // printLog(message: "---\(progress.progress)---")
        }
    }
    func createUI()
    {
        imageV = UIImageView()
        imageV.layer.cornerRadius = 5
        imageV.layer.borderWidth = 2
        imageV.layer.masksToBounds = true
        imageV.layer.borderColor = UIColor.darkGray.cgColor
        imageV.isUserInteractionEnabled = true
        imageV.backgroundColor = UIColor.darkGray
        imageV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(TGVoiceNewV.seeBigPic)))
        self.addSubview(imageV)
        imageV.mas_makeConstraints { [weak self](make) in
            make?.top.equalTo()(self)?.offset()(0)
            make?.left.equalTo()(self)?.offset()(5)
            make?.width.equalTo()(self)?.offset()(-10)
            make?.height.mas_equalTo()(240)
        }
        playcountLabel = UILabel()
        playcountLabel.text = "2万播放量"
        playcountLabel.textColor = UIColor.white
        playcountLabel.font = UIFont.systemFont(ofSize: 10)
        imageV.addSubview(playcountLabel)
        playcountLabel.mas_makeConstraints { [weak self](make) in
            make?.left.equalTo()(self)?.offset()(10)
            make?.bottom.equalTo()(self?.imageV.mas_bottom)?.offset()(-10)
        }
        voicetimeLabel = UILabel()
        voicetimeLabel.text = "12:21"
        voicetimeLabel.textColor = UIColor.white
        voicetimeLabel.font = UIFont.systemFont(ofSize: 10)
        imageV.addSubview(voicetimeLabel)
        voicetimeLabel.mas_makeConstraints { [weak self](make) in
            make?.right.equalTo()(self)?.offset()(-10)
            make?.bottom.equalTo()(self?.imageV.mas_bottom)?.offset()(-10)
        }
        voicePlayBtn = UIButton()
        voicePlayBtn.addTarget(self, action: #selector(TGVoiceNewV.play(playBtn:)), for: .touchUpInside)
        voicePlayBtn.setImage(UIImage(named:"playButtonPlay"), for: .normal)
        imageV.addSubview(voicePlayBtn)
        voicePlayBtn.mas_makeConstraints { [weak self](make) in
            make?.right.equalTo()(self?.imageV)?.multipliedBy()(0.6)
            make?.bottom.equalTo()(self?.imageV.mas_bottom)?.offset()(-10)
            make?.width.and().height().mas_equalTo()(30)
        }
    }
    func play(playBtn:UIButton)
    {
        playBtn.isSelected = !playBtn.isSelected
        if lastTopicM != self.topVoiceModel {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerItem)
            self.playerItem = AVPlayerItem(url: URL(string: topVoiceModel.audio_uri)!)
            NotificationCenter.default.addObserver(self, selector: #selector(TGVoiceNewV.playerItemDidReachEnd(playerItem:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerItem)
            voice_player.replaceCurrentItem(with: self.playerItem)
             progress.frame = CGRect(x:voicePlayBtn.frame.origin.x-2,y:voicePlayBtn.frame.origin.y-2,width:voicePlayBtn.frame.size.width+4,height:voicePlayBtn.frame.size.height+4);
            self.insertSubview(progress, belowSubview: self.voicePlayBtn)
            progress.setProgress(0, animated: false)
            voice_player.play()
            avTimer.fireDate = Date()
            self.topVoiceModel.is_voicePlaying = true
            voicePlayBtn.setImage(UIImage(named:"playButtonPause"), for: .normal)
        }
        else
        {
            if lastTopicM.is_voicePlaying
            {
                voice_player.pause()
                avTimer.fireDate = NSDate.distantFuture
                self.topVoiceModel.is_voicePlaying = false
                playBtn.setImage(UIImage(named:"playButtonPlay"), for: .normal)
            }
            else
            {
             NotificationCenter.default.addObserver(self, selector: #selector(TGVoiceNewV.playerItemDidReachEnd(playerItem:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerItem)
                progress.frame = CGRect(x:voicePlayBtn.frame.origin.x-2,y:voicePlayBtn.frame.origin.y-2,width:voicePlayBtn.frame.size.width+4,height:voicePlayBtn.frame.size.height+4);
                self.insertSubview(progress, belowSubview: self.voicePlayBtn)
                voice_player.play()
                avTimer.fireDate = Date()
                self.topVoiceModel.is_voicePlaying = true
                playBtn.setImage(UIImage(named:"playButtonPause"), for: .normal)
            }
        }
        lastTopicM = topVoiceModel
        lastPlayBtn = playBtn
        progress.isHidden = !self.topVoiceModel.is_voicePlaying
    }
    func playerItemDidReachEnd(playerItem:AVPlayerItem)
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerItem)
        lastTopicM.is_videoPlaying = false
        topVoiceModel.is_voicePlaying = false
        lastPlayBtn.setImage(UIImage(named:"playButtonPlay"), for: .normal)
        voicePlayBtn.setImage(UIImage(named:"playButtonPlay"), for: .normal)
        voice_player.seek(to: kCMTimeZero)
        progress.setProgress(0, animated: false)
        progress.isHidden = true
        progress.removeFromSuperview()
    }
    deinit {
        voice_player.pause()
        lastTopicM.is_voicePlaying = false
         lastPlayBtn.setImage(UIImage(named:"playButtonPlay"), for: .normal)
        NotificationCenter.default.removeObserver(self)
        avTimer.invalidate()
        avTimer = nil
    }

    func seeBigPic()
    {
        let vc = TGSeeBigPicNewVC()
        vc.topic = self.topVoiceModel
        UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
