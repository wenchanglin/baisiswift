//
//  TGVideoNewV.swift
//  banqianQiJie
//
//  Created by banbo on 2017/8/10.
//  Copyright © 2017年 banbo. All rights reserved.
//

import UIKit
import SVProgressHUD
class TGVideoNewV: UIView,WMPlayerDelegate,SDPhotoBrowserDelegate {
    var imageV:AsyncImageView!
    var playcountLabel:UILabel!
    var videotimeLabel:UILabel!
    var videoPlayBtn:UIButton!
    var video_player:AVPlayer!
    var playerLayer:AVPlayerLayer!
    var playerItem:AVPlayerItem!
    var avTimer:Timer!
    var wmPlayer:WMPlayer!
    var isSmallScreen:Bool = true
    var progress:UIProgressView!
    var lastTopicM:ceShiModel!
    var lastPlayBtn:UIButton!
    var topVideoModel:ceShiModel!
    {
        didSet{
           // printLog(message: "\(topVideoModel.image)")
            AsyncImageLoader.shared().cancelLoadingImages(forTarget: imageV)
            imageV.imageURL = URL(string: topVideoModel.image)
            self.playcountLabel.text = "\(topVideoModel.video_playcount)播放"
            self.videotimeLabel.text = "\(topVideoModel.video_duration / 60):\(topVideoModel.video_duration % 60)"
        }
    }
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func createUI()
    {
        imageV = AsyncImageView()
        imageV.isUserInteractionEnabled = true
        imageV.isUserInteractionEnabled = true
        imageV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(QQTableViewCell.seeBigPic)))
        self.addSubview(imageV)
        imageV.mas_makeConstraints { [weak self](make) in
            make?.top.equalTo()(self)
            make?.left.equalTo()(self)
            make?.width.equalTo()(self)
            make?.height.mas_equalTo()(240)
        }
        imageV.layoutIfNeeded()
        playcountLabel = UILabel()
        playcountLabel.text = "2万播放量"
        playcountLabel.textColor = UIColor.white
        playcountLabel.font = UIFont.systemFont(ofSize: 10)
        imageV.addSubview(playcountLabel)
        playcountLabel.mas_makeConstraints { [weak self](make) in
            make?.left.equalTo()(self)?.offset()(10)
            make?.bottom.equalTo()(self?.imageV.mas_bottom)?.offset()(-10)
        }
        videotimeLabel = UILabel()
        videotimeLabel.text = "12:21"
        videotimeLabel.textColor = UIColor.white
        videotimeLabel.font = UIFont.systemFont(ofSize: 10)
        imageV.addSubview(videotimeLabel)
        videotimeLabel.mas_makeConstraints { [weak self](make) in
            make?.right.equalTo()(self)?.offset()(-10)
            make?.bottom.equalTo()(self?.imageV.mas_bottom)?.offset()(-10)
        }
        videoPlayBtn = UIButton()
        videoPlayBtn.setImage(UIImage(named:"video-play"), for: .normal)
        videoPlayBtn.addTarget(self, action: #selector(TGVideoNewV.startPlayVideo(sender:)), for: .touchUpInside)
        imageV.addSubview(videoPlayBtn)
        videoPlayBtn.mas_makeConstraints { [weak self](make) in
            make?.centerX.and().centerY().equalTo()(self?.imageV)
            make?.width.and().height().mas_equalTo()(50)
        }
       
    }
    func seeBigPic()
    {
        let photos = SDPhotoBrowser()
        photos.imageCount = 1
        photos.currentImageIndex = 0
        photos.delegate = self
        photos.show()
    }
    func startPlayVideo(sender:UIButton)
    {
      
       
        let videoUrl = topVideoModel.video_uri
        if isSmallScreen {
            isSmallScreen = false
        }
            self.wmPlayer = WMPlayer(frame: imageV.frame)
            self.wmPlayer.delegate = self
            self.wmPlayer.closeBtnStyle = .close
            self.wmPlayer.urlString = videoUrl
            self.wmPlayer.titleLabel.text = topVideoModel.text
            self.wmPlayer.titleLabel.font = UIFont.systemFont(ofSize: 9)
            self.wmPlayer.titleLabel.adjustsFontSizeToFitWidth = true
            self.wmPlayer.play()
            self.addSubview(self.wmPlayer)
        
    }
    //MARK:- playerdelegate
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
    deinit {
        releaseWMPlayer()
    }
    func photoBrowser(_ browser: SDPhotoBrowser!, placeholderImageFor index: Int) -> UIImage! {
        return nil
    }
    func photoBrowser(_ browser: SDPhotoBrowser!, highQualityImageURLFor index: Int) -> URL! {
            return URL(string: self.topVideoModel.image)
    }
}
