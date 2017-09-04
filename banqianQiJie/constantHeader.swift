//
//  constantHeader.swift
//  banqianQiJie
//
//  Created by banbo on 2017/8/9.
//  Copyright © 2017年 banbo. All rights reserved.
//

import Foundation
import UIKit
let code2 = "phcqnauGuHYkFMRquANhmgN_IauBThfqmgKsUARhIWdGULPxnz3vndtkQW08nau_I1Y1P1Rhmhwz5Hb8nBuL5HDknWRhTA_qmvqVQhGGUhI_py4MQhF1TvChmgKY5H6hmyPW5RFRHzuET1dGULnhuAN85HchUy7s5HDhIywGujY3P1n3mWb1PvDLnvF-Pyf4mHR4nyRvmWPBmhwBPjcLPyfsPHT3uWm4FMPLpHYkFh7sTA-b5yRzPj6sPvRdFhPdTWYsFMKzuykEmyfqnauGuAu95Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiu9mLfqHbD_H70hTv6qnHn1PauVmynqnjclnj0lnj0lnj0lnj0lnj0hThYqniuVujYkFhkC5HRvnB3dFh7spyfqnW0srj64nBu9TjYsFMub5HDhTZFEujdzTLK_mgPCFMP85Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiuBnHfdnjD4rjnvPWYkFh7sTZu-TWY1QW68nBuWUHYdnHchIAYqPHDzFhqsmyPGIZbqniuYThuYTjd1uAVxnz3vnzu9IjYzFh6qP1RsFMws5y-fpAq8uHT_nBuYmycqnau1IjYkPjRsnHb3n1mvnHDkQWD4niuVmybqniu1uy3qwD-HQDFKHakHHNn_HR7fQ7uDQ7PcHzkHiR3_RYqNQD7jfzkPiRn_wdKHQDP5HikPfRb_fNc_NbwPQDdRHzkDiNchTvwW5HnvPj0zQWndnHRvnBsdPWb4ri3kPW0kPHmhmLnqPH6LP1ndm1-WPyDvnHKBrAw9nju9PHIhmH9WmH6zrjRhTv7_5iu85HDhTvd15HDhTLTqP1RsFh4ETjYYPW0sPzuVuyYqn1mYnjc8nWbvrjTdQjRvrHb4QWDvnjDdPBuk5yRzPj6sPvRdgvPsTBu_my4bTvP9TARqnam"
let screen_width = UIScreen.main.bounds.size.width
let screen_height = UIScreen.main.bounds.size.height
let  iphone6P = screen_height.isEqual(to: 736)
let iphone6 = screen_height.isEqual(to: 667)
let iphone5 = screen_height.isEqual(to:568)
let  iphone4 = screen_height.isEqual(to:480)
let BackEssenceNotification = "BackEssenceNotification"
let AcrossEssenceNotification = "AcrossEssenceNotification"
let NavigationBarHiddenNotification = "NavigationBarHiddenNotification"
let NavigationBarShowNotification = "NavigationBarShowNotification"
let TabBarButtonDidRepeatClickNotification = "TabBarButtonDidRepeatClickNotification"
let TitleButtonDidRepeatClickNotification = "TitleButtonDidRepeatClickNotification"


let CommonURL = "http://api.budejie.com/api/api_open.php"
func  TGColor(r:CGFloat,g:CGFloat,b:CGFloat) ->UIColor
{
 return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1).withAlphaComponent(0.9)
}
func RGB(r:CGFloat,g:CGFloat,b:CGFloat,alpha:CGFloat)->UIColor
{
    return UIColor(red: r/255, green: g/255, blue: b/255, alpha: alpha)
}
func requestTuiJianUrl(string:NSNumber)->String
{
   return String(format: "http://s.budejie.com/topic/list/jingxuan/1/bs0315-iphone-4.5.6/%@-20.json", string)
}
func requestPingLunUrl(topicId:String,string:NSNumber,nextpage:NSNumber)->String
{
    return String(format:"http://c.api.budejie.com/topic/comment_list/%@/%@/bs0315-iphone-4.5.6/%@-20.json",topicId,string,nextpage)
}
func requestSuiTingUrl(nextpage:NSNumber)->String
{
    return String(format:"http://s.budejie.com/topic/list/zuixin/31/bs0315-iphone-4.5.6/%@-20.json",nextpage)
}

func requestPicUrl(nextPage:NSNumber)->String
{
    return String(format:"http://s.budejie.com/topic/list/jingxuan/10/bs0315-iphone-4.5.6/%@-20.json",nextPage)
}
func requestDuanZiUrl(nextPage:NSNumber)->String
{
    return String(format:"http://s.budejie.com/topic/tag-topic/64/hot/bs0315-iphone-4.5.6/%@-20.json",nextPage)
}
func imageOriginalWithName(imageName:NSString) ->UIImage
{
    let image:UIImage = UIImage(named: imageName as String)!
    return image.withRenderingMode(.alwaysOriginal)
}
func colorWithHexString(hex:String) ->UIColor {
    
    var cString = hex.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        let index = cString.index(cString.startIndex, offsetBy:1)
        cString = cString.substring(from: index)
    }
    
    if (cString.characters.count != 6) {
        return UIColor.red
    }
    
    let rIndex = cString.index(cString.startIndex, offsetBy: 2)
    let rString = cString.substring(to: rIndex)
    let otherString = cString.substring(from: rIndex)
    let gIndex = otherString.index(otherString.startIndex, offsetBy: 2)
    let gString = otherString.substring(to: gIndex)
    let bIndex = cString.index(cString.endIndex, offsetBy: -2)
    let bString = cString.substring(from: bIndex)
    
    var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
    Scanner(string: rString).scanHexInt32(&r)
    Scanner(string: gString).scanHexInt32(&g)
    Scanner(string: bString).scanHexInt32(&b)
    
    return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
}

func printLog<T>(message:T,logError:Bool=false,file:String = #file,method: String = #function,line:Int = #line)
{
    if logError {
        print("\((file as NSString).lastPathComponent)第[\(line)行], \(method): \(message)")
    } else {
        #if DEBUG
            print("\((file as NSString).lastPathComponent)第[\(line)行], \(method): \(message)")
        #endif
    }
}

