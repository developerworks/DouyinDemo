//
//  MainViewController.swift
//  CollectionViewExample2
//
//  Created by hezhiqiang on 2018/4/6.
//  Copyright © 2018年 Totorotec. All rights reserved.
//

import UIKit
import MJRefresh
import Alamofire
import SwiftyBeaver

class MainViewController:
    UIViewController,
    UICollectionViewDelegate,
    UICollectionViewDataSource
{
    let cellId = "colorCell"
    let margin: CGFloat = 1
    let header = MJRefreshNormalHeader()
    
    var collectionView: UICollectionView?
    var covers: [String] = []
    var dynamic_covers: [String] = []
    
    var i = 0
    
    @objc func tickDown() {
        i = i + 1
        print("tickDown: \(i) ")
        SwiftyBeaver.info("tickDown: \(i)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        _ = Timer.scheduledTimer(
//            timeInterval: 1,
//            target:self,
//            selector: #selector(MainViewController.tickDown),
//            userInfo:nil,
//            repeats:true
//        )
        
        header.setRefreshingTarget(self, refreshingAction: #selector(MainViewController.headerRefresh))

        Tools.requestUserNotification()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        self.view.backgroundColor = .black
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)

        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(collectionView!)
        
        collectionView?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView?.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        collectionView?.backgroundColor = .black
        
        collectionView!.mj_header = header

        collectionView?.setCollectionViewLayout(layout, animated: true)
        collectionView?.register(ImageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        self.loadData()
    }
    
    func loadData() -> Void {
        let params: Dictionary = [
            "iid":"15293865835",
            "device_id":"39190423462",
            "os_api":"18",
            "app_name":"aweme",
            "channel":"App%20Store",
            "idfa":"0BF36679-8A93-4637-BBF0-1958EE15A135",
            "device_platform":"iphone",
            "build_number":"15805",
            "vid":"3BF14112-29F0-4CA6-9FF0-F3F0F15A23A6",
            "openudid":"2d90160a3955f7c8fdd3dac59a1bbb9c56929995",
            "device_type":"iPhone7,1",
            "app_version":"1.5.8",
            "version_code":"1.5.8",
            "os_version":"11.0.3",
            "screen_width":"1125",
            "aid":"1128",
            "ac":"WIFI",
            "count":"100",
            "cursor":"1050",
            "music_id":"6321877434513754882",
            "pull_type":"2",
            "type":"6",
            "cp":"01cb9f54c32bfd1fe1",
            "as":"a145906f5c7cb95162",
            "ts":"1509032396"
        ]
        Alamofire.request(
            Setting.API_ENDPOINT_AWEME,
            parameters: params
        ).responseJSON { response in
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                let video_info = VideoInfo(JSONString: utf8Text)
                for (_,item) in (video_info?.aweme_list?.enumerated())! {
                    self.covers.append(item.video.cover.first!)
                    let randomIndex = Int(arc4random_uniform(UInt32(item.video.dynamic_cover.count)))
                    let dynamicCoverUrl = item.video.dynamic_cover[randomIndex]
                    self.dynamic_covers.append(dynamicCoverUrl)
                    print("dynamic cover url: \(dynamicCoverUrl)")
                }
                self.collectionView?.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return covers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView!.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ImageCell
        cell.backgroundColor = .white
        cell.configureCell(url: self.dynamic_covers[indexPath.row])
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //顶部下拉刷新
    @objc func headerRefresh(){
        print("下拉刷新.")
        loadData()
        self.collectionView!.mj_header.endRefreshing()
        self.collectionView!.reloadData()
        if #available(iOS 10.0, *) {
            FeedbackGenerator.tapped(type: 4)
        }
    }
}

// 流式布局
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.size.width - 1) / 2
        let height = ( width / 270 ) * 480
//        print("dynamic cover size: width: \(width) height=\(height)")
        return CGSize(width: width, height: height)
    }
}
