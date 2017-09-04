//
//  shuRuView.swift
//  banqianQiJie
//
//  Created by banbo on 2017/8/17.
//  Copyright © 2017年 banbo. All rights reserved.
//

import UIKit
protocol huiShouViewDelegate:NSObjectProtocol {
    func huiShouFrame(textfield:UITextField!)
    
}
class shuRuView: UIView,UITextFieldDelegate {
    var textF: UITextField!
    var bottomView:UIView!
    weak var delgate:huiShouViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func createUI()
    {
        bottomView = UIView()
        bottomView.backgroundColor = UIColor.cyan
        self.addSubview(bottomView)
        bottomView.mas_makeConstraints { (make) in
            make?.bottom.equalTo()(self)
            make?.width.equalTo()(self)
            make?.height.equalTo()(40)
        }
        let yuyinBtn = UIButton()
        yuyinBtn.setImage(UIImage(named:"comment-bar-voice"), for: .normal)
        bottomView.addSubview(yuyinBtn)
        yuyinBtn.mas_makeConstraints { (make) in
            make?.bottom.equalTo()(self)?.offset()(-5)
            make?.left.equalTo()(self)
            make?.width.and().height().mas_equalTo()(30)
        }
        textF = UITextField()
        textF.borderStyle = .roundedRect
        textF.delegate = self
        bottomView.addSubview(textF)
        textF.mas_makeConstraints { (make) in
            make?.left.equalTo()(yuyinBtn.mas_right)
            make?.bottom.equalTo()(self)?.offset()(-5)
            make?.centerY.equalTo()(yuyinBtn)
            make?.right.equalTo()(self)?.offset()(-30)
            make?.height.mas_equalTo()(30)
        }
        let jiaBtn = UIButton()
        jiaBtn.setImage(UIImage(named:"bottom-setting-add"), for: .normal)
        bottomView.addSubview(jiaBtn)
        jiaBtn.mas_makeConstraints { (make) in
            make?.left.equalTo()(self.textF.mas_right)
            make?.bottom.equalTo()(self)?.offset()(-5)
            make?.height.mas_equalTo()(30)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        delgate?.huiShouFrame(textfield: textField)
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

