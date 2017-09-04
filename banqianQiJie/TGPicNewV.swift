//
//  TGPicNewV.swift
//  banqianQiJie
//
//  Created by banbo on 2017/8/10.
//  Copyright © 2017年 banbo. All rights reserved.
//

import UIKit
import FLAnimatedImage

import Masonry
class TGPicNewV: UIView {
    var imageV:FLAnimatedImageView!
    var placeholderV:UIImageView!
    var gifV:UIImageView!
    var seeBigPictureBtn:UIButton!
    var url:String! = ""
    var tgtopPicModel:ceShiModel!
    {
        didSet{
            if (self.tgtopPicModel.type.lowercased() == "gif")
            {
                gifV = UIImageView(image: UIImage(named: "common-gif"))
                imageV.addSubview(gifV)
                gifV.mas_makeConstraints { [weak self](make) in
                    make?.left.equalTo()(self)?.offset()(0)
                    make?.top.equalTo()(self)?.offset()(0)
                    make?.width.and().height().mas_equalTo()(30)
                }
                self.url = self.tgtopPicModel.images_gif
                self.tg_gifForUrl(url: self.url)
            }
            else
            {
                seeBigPictureBtn = UIButton()
                seeBigPictureBtn.isUserInteractionEnabled = true
                seeBigPictureBtn.setImage(UIImage(named:"see-big-picture"), for: .normal)
                seeBigPictureBtn.setBackgroundImage(UIImage(named:"see-big-picture-background"), for: .normal)
                seeBigPictureBtn.setTitle("点击察看大图", for: .normal)
                seeBigPictureBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
                seeBigPictureBtn.addTarget(self, action: #selector(TGPicNewV.seeBigPic), for: .touchUpInside)
                imageV.addSubview(seeBigPictureBtn)
                seeBigPictureBtn.mas_makeConstraints({ [weak self](make) in
                    make?.left.equalTo()(self)?.offset()(10)
                    make?.right.equalTo()(self)?.offset()(-10)
                    make?.bottom.equalTo()(self?.imageV.mas_bottom)
                    make?.height.mas_equalTo()(30)
                })
                self.imageV.animatedImage = nil
                imageV.tg_setOriginImage(tgtopPicModel.image, thumbnailImage: tgtopPicModel.image_small, placeholder: nil, progress: { (receiveSize, expectedSize, targetURL) in
                   // printLog(message: "\(receiveSize)")
                }) { (image, error, cacheType, imageURL) in
                    if self.tgtopPicModel.isBigPicture {
                        let imageW = self.tgtopPicModel.middleFrame.size.width
                        let imageH = imageW * CGFloat(self.tgtopPicModel.height / self.tgtopPicModel.width)
                        UIGraphicsBeginImageContextWithOptions(self.tgtopPicModel.middleFrame.size, false, UIScreen.main.scale)
                        self.imageV.image?.draw(in: CGRect(x: 0, y: 0, width: imageW, height: imageH))
                        self.imageV.image = UIGraphicsGetImageFromCurrentImageContext()
                        UIGraphicsEndImageContext()
                    }
                }
            }
            
        }
        
    }
    func tg_gifForUrl(url:String) ->Void
    {
        self.imageV.animatedImage = FLAnimatedImage(animatedGIFData: NSData(contentsOf: URL(string: url)!)! as Data)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    func createUI()
    {
        imageV = FLAnimatedImageView()
        imageV.isUserInteractionEnabled = true
        imageV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(TGPicNewV.seeBigPic)))
        self.addSubview(imageV)
        imageV.mas_makeConstraints { [weak self](make) in
            make?.top.equalTo()(self)?.offset()(10)
            make?.left.equalTo()(self)?.offset()(10)
            make?.width.equalTo()(self)?.offset()(-10)
            make?.height.mas_equalTo()(270)
        }
    }
    func seeBigPic()
    {
        let vc = TGSeeBigPicNewVC()
        vc.topic = self.tgtopPicModel
        UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
