//
//  DetailInformationController.swift
//  princonnectGuide
//
//  Created by 金超 on 2020/8/9.
//  Copyright © 2020 jinchao. All rights reserved.
//

import UIKit
import Kingfisher

class DetailInformationController: UIViewController {
    
    var DaiPicName:String = ""
    var Star = 1
    var Dai6PicName:String = ""
    var TitleName:String = ""
    var have6Star = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadFromURL()
        
    }
    
    @objc private func handleTap(tap: UITapGestureRecognizer){
        if tap.state == .ended{
            let scrollView = storyboard!.instantiateViewController(withIdentifier: "scrollView") as! ScrollView
            scrollView.modalPresentationStyle = .fullScreen
            scrollView.imageName = DaiPicName
            present(scrollView, animated: true, completion: nil)
        }
    }
    
    @objc private func handleTap6(tap: UITapGestureRecognizer){
        if tap.state == .ended{
            let scrollView = storyboard!.instantiateViewController(withIdentifier: "scrollView") as! ScrollView
            scrollView.modalPresentationStyle = .fullScreen
            scrollView.imageName = Dai6PicName
            present(scrollView, animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var characterImageDai: UIImageView!
    @IBOutlet weak var characterImage6Dai: UIImageView!
    @IBOutlet weak var characterStar: UILabel!
    @IBOutlet weak var characterName: UILabel!
    @IBOutlet weak var haveSixStar: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    
}

extension DetailInformationController {
    
    private func loadFromURL(){
        
        let url = URL(string: "https://raw.githubusercontent.com/kitanai-kitsune/CharacterPictures/master/pictures/\(DaiPicName).png")
        print("普通图片地址\(url as Any)")
        
        let processor = RoundCornerImageProcessor(cornerRadius: 30.0)
        
        characterImageDai.kf.indicatorType = .activity
        characterImageDai.kf.setImage(
            with: url,
            placeholder: nil,
            options: [
                .processor(processor),
                .cacheOriginalImage,
                .transition(.fade(0.7))
            ],
            
            progressBlock: {
                receivedData, totolData in
                let percentage = (Float(receivedData) / Float(totolData)) * 100.0
                self.progressBar.setProgress(percentage / 100, animated: true)
                if self.progressBar.progress == 1{
                    self.progressBar.isHidden = true
                }
                print("下载进度: \(percentage)%")
        }
        )
        
        characterImageDai.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(tap:))))
        
        characterStar.text = String(Star)
        
        characterName.text = TitleName
        
        if have6Star == true{
            haveSixStar.text = "六星大图"
            let url = URL(string: "https://raw.githubusercontent.com/kitanai-kitsune/CharacterPictures/master/pictures/\(Dai6PicName).png")
            print("六星图片地址\(url as Any)")
            
            characterImage6Dai.kf.indicatorType = .activity
            characterImage6Dai.kf.setImage(
                with: url,
                placeholder: nil,
                options: [
                    .processor(processor),
                    .cacheOriginalImage,
                    .transition(.fade(0.7))
                ],
                
                progressBlock: {
                    receivedData, totolData in
                    let percentage = (Float(receivedData) / Float(totolData)) * 100.0
                    print("下载六星图进度: \(percentage)%")
            }
            )
            
            characterImage6Dai.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap6(tap:))))
            
        }else{
            haveSixStar.text = ""
        }
        
        //计算本地缓存大小
        ImageCache.default.calculateDiskStorageSize { result in
            switch result {
            case .success(let size):
                print("磁盘缓存大小: \(Double(size) / 1024 / 1024) MB")
            case .failure(let error):
                print(error)
            }
        }
                
    }
    
    
    //无视此方法 (如需启动本地数据的话 导入图片!!)
    private func loadFromLocal(){
        
        characterImageDai.image = UIImage(named: DaiPicName)
        characterImageDai.layer.cornerRadius = 10.0//圆角
        
        characterStar.text = String(Star)
        
        characterName.text = TitleName
        
        if have6Star == true{
            haveSixStar.text = "六星大图"
            characterImage6Dai.image = UIImage(named: Dai6PicName)
            characterImage6Dai.layer.cornerRadius = 10.0
            characterImage6Dai.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap6(tap:))))
        }else{
            haveSixStar.text = ""
        }
        
        characterImageDai.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(tap:))))
    }
    
}
