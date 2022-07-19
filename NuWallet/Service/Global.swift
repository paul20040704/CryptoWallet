//
//  Global.swift
//  CryptoWallet
//
//  Created by Fanglin Hsu on 2022/4/7.
//

import Foundation
import UIKit
import Observable

let BN = BaseNetwork.shareNetWork

let US = Util.shared

let UD = UserDefaults.standard

let PDecoder = PropertyListDecoder()

let PEncoder = PropertyListEncoder()

let ScreenWidth = UIScreen.main.bounds.width
let ScreenHeight = UIScreen.main.bounds.height

var notificationStatus: Observable<NotificationStatusType?> = Observable(nil)

let localVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
