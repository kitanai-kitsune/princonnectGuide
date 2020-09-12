//
//  DetailInformationController.swift
//  princonnectGuide
//
//  Created by 金超 on 2020/8/9.
//  Copyright © 2020 jinchao. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase

class DetailInformationController: UIViewController {
    
    var DaiPicName:String = ""
    var Star = 1
    var Dai6PicName:String = ""
    var TitleName:String = ""
    var have6Star = false
    
    var stringurl = ""
    var stringurlforsix = ""
    
    @IBOutlet weak var characterImageDai: UIImageView!
    @IBOutlet weak var characterImage6Dai: UIImageView!
    @IBOutlet weak var characterStar: UILabel!
    @IBOutlet weak var characterName: UILabel!
    @IBOutlet weak var haveSixStar: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadFromFireBase()
        
    }
    
    @objc private func handleTap(tap: UITapGestureRecognizer){
        if tap.state == .ended{
            let scrollView = storyboard!.instantiateViewController(withIdentifier: "scrollView") as! ScrollView
            scrollView.modalPresentationStyle = .fullScreen
            scrollView.imageName = DaiPicName
            scrollView.stringurl = stringurl
            present(scrollView, animated: true, completion: nil)
        }
    }
    
    @objc private func handleTap6(tap: UITapGestureRecognizer){
        if tap.state == .ended{
            let scrollView = storyboard!.instantiateViewController(withIdentifier: "scrollView") as! ScrollView
            scrollView.modalPresentationStyle = .fullScreen
            scrollView.imageName = Dai6PicName
            scrollView.stringurl = stringurlforsix
            present(scrollView, animated: true, completion: nil)
        }
    }
    
}

extension DetailInformationController {
        
    private func loadFromFireBase(){
        
        let name = DaiPicName
        let storageRef = Storage.storage().reference()
        let ref = storageRef.child("pictures/\(name).png")
        
        characterStar.text = String(Star)
        characterName.text = TitleName
        
        ref.downloadURL { (url, error) in
            if let urltext = url?.absoluteString{
                self.stringurl = urltext
                self.loadImage(url: URL(string: urltext)!)
                
            }else{
            }
        }
        
        if have6Star == true{
            
            let name = Dai6PicName
            let storageRef = Storage.storage().reference()
            let ref = storageRef.child("pictures/\(name).png")
            
            haveSixStar.text = "六星大图"
            
            ref.downloadURL { (url, error) in
                if let urltext = url?.absoluteString{
                    self.stringurlforsix = urltext
                    self.loadSixImage(url: URL(string: urltext)!)
                }else{
                }
                
            }
        }else{
            self.haveSixStar.removeFromSuperview()
        }
        
        calculateDiskStorageSize()
        
    }
    
    private func loadImage(url: URL){
        
        characterImageDai.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(tap:))))
        
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
        
    }
    
    private func loadSixImage(url: URL){
        
        characterImage6Dai.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap6(tap:))))
        
        let processor = RoundCornerImageProcessor(cornerRadius: 30.0)
        
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
                //                self.progressBar.setProgress(percentage / 100, animated: true)
                //                if self.progressBar.progress == 1{
                //                    self.progressBar.isHidden = true
                //                }
                print("六星图下载进度: \(percentage)%")
        }
        )
        
    }
    
    //计算本地缓存大小
    private func calculateDiskStorageSize(){
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
    
    //无视此方法 (从github下载图片)
    private func loadFromGithub(){
        
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
            //haveSixStar.text = ""
            haveSixStar.removeFromSuperview()
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
    
}
