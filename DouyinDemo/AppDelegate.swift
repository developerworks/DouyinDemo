//
//  AppDelegate.swift
//  DouyinDemo
//
//  Created by hezhiqiang on 2018/4/7.
//  Copyright © 2018年 Totorotec. All rights reserved.
//

import UIKit
import ZLaunchAd

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var backgroundTask:UIBackgroundTaskIdentifier! = nil

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        Tools.configLogger()
        
        let mainViewController = MainViewController()
        let navigationController = UINavigationController(rootViewController: mainViewController)
        navigationController.isNavigationBarHidden = true
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        setupLaunchAd_01 {
            print("setupLaunchAd_01")
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.yellow
            mainViewController.navigationController?.pushViewController(vc, animated: true)
        }
        return true
    }

    // 临时中断处理
    func applicationWillResignActive(_ application: UIApplication) {
        print(">>> 临时中断处理...")
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print(">>> 应用程序已进入后台...")
        if self.backgroundTask != nil {
            application.endBackgroundTask(self.backgroundTask)
            self.backgroundTask = UIBackgroundTaskInvalid
        }
        //注册后台任务
        self.backgroundTask = application.beginBackgroundTask(expirationHandler: {
            () -> Void in
            //如果没有调用endBackgroundTask，时间耗尽时应用程序将被终止
            application.endBackgroundTask(self.backgroundTask)
            self.backgroundTask = UIBackgroundTaskInvalid
        })
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        print(">>> 应用程序将要进入前台...")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print(">>> 应用程序已经变为活动装...")
    }

    // 这个方法让你的应用知道它马上要被干掉了并且将从内存完全清除掉。
    // 你应该使用这个方法来执行任何你的应用最后的清理工作，比如释放共享资源，保存用户数据，使timers失效，
    // 实现这个方法你大约有5秒钟的时间来执行你的任务并且返回，
    // 如果这个方法在时间失效前没有返回，那么系统可能会一并杀死这个进程。
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        print(">>> 应用程序即将终止...")
        print(">>> 释放共享资源...")
        print(">>> 保护用户数据...")
        print(">>> 删除计时器...")
    }


}


extension AppDelegate {
    func initApp() -> Void {
        let mainViewController = MainViewController()
        let navigationController = UINavigationController(rootViewController: mainViewController)
        navigationController.isNavigationBarHidden = true
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

extension AppDelegate {
    /// 本地图片
    func setupLaunchAd_01(adClick: @escaping (()->())) {
        let adView = ZLaunchAd.create(showEnterForeground: true)
        let imageResource = ZLaunchAdImageResourceConfigure()
        imageResource.imageNameOrImageURL = "163yun"
        imageResource.imageDuration = 5
        imageResource.imageFrame = UIScreen.main.bounds
        adView.setImageResource(imageResource, action: {
            adClick()
        })
    }
}
extension AppDelegate {
    /// 网络图片
    func setupLaunchAd_02(adClick: @escaping (()->())) {
        let adView = ZLaunchAd.create(waitTime: 3, showEnterForeground: true)
        request { model in
            let buttonConfig = ZLaunchSkipButtonConfig()
            buttonConfig.skipBtnType = model.skipBtnType
            let imageResource = ZLaunchAdImageResourceConfigure()
            imageResource.imageNameOrImageURL = model.imgUrl
            imageResource.animationType = model.animationType
            imageResource.imageDuration = model.duration
            //            imageResource.imageFrame = CGRect(x: 0, y: 0, width: Z_SCREEN_WIDTH, height: Z_SCREEN_WIDTH*model.height/model.width)
            imageResource.imageFrame = UIScreen.main.bounds
            /// 设置图片、跳过按钮
            adView.setImageResource(imageResource, buttonConfig: buttonConfig, action: {
                adClick()
            })
        }
    }
}

extension AppDelegate {
    /// 进入前台时发出请求，加载不同的广告
    /// 网络请求写在`adNetRequest`闭包中
    func setupLaunchAd_03(adClick: @escaping (()->())) {
        ZLaunchAd.create(showEnterForeground: true, adNetRequest: { adView in
            self.request { model in
                let buttonConfig = ZLaunchSkipButtonConfig()
                buttonConfig.skipBtnType = model.skipBtnType
                let imageResource = ZLaunchAdImageResourceConfigure()
                imageResource.imageNameOrImageURL = model.imgUrl
                imageResource.animationType = model.animationType
                imageResource.imageDuration = model.duration
                //                imageResource.imageFrame = CGRect(x: 0, y: 0, width: Z_SCREEN_WIDTH, height: Z_SCREEN_WIDTH*model.height/model.width)
                imageResource.imageFrame = UIScreen.main.bounds
                /// 设置图片、跳过按钮
                adView.setImageResource(imageResource, buttonConfig: buttonConfig, action: {
                    adClick()
                })
            }
        })
    }
}

extension AppDelegate {
    /// 模拟请求数据，此处解析json文件
    func request(_ completion: @escaping (AdModel)->()) -> Void {
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            if let path = Bundle.main.path(forResource: "data", ofType: "json") {
                let url = URL(fileURLWithPath: path)
                do {
                    let data = try Data(contentsOf: url)
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    if let dict = json as? [String: Any],
                        let dataArray = dict["data"] as? [[String: Any]] {
                        /// 随机显示
                        let idx = Int(arc4random()) % dataArray.count
                        let model = AdModel(dataArray[idx])
                        completion(model)
                    }
                } catch  {
                    print(error)
                }
            }
        }
    }
}
