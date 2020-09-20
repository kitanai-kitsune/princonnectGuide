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
        
    @IBOutlet weak var characterImageDai: UIImageView!
    @IBOutlet weak var characterImage6Dai: UIImageView!
    @IBOutlet weak var characterStar: UILabel!
    @IBOutlet weak var characterName: UILabel!
    @IBOutlet weak var haveSixStar: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadFromLoaclStorage()
        
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
    
}

extension DetailInformationController {
    
    private func loadFromLoaclStorage(){
        
        characterStar.text = String(Star)
        characterName.text = TitleName
                
        let picturesPath = "file://" + NSHomeDirectory() + "/Documents/pictures/"
        let filePath = picturesPath + "\(DaiPicName).png"
            
            characterImageDai.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(tap:))))
            
            let processor = RoundCornerImageProcessor(cornerRadius: 30.0)
            
            characterImageDai.kf.indicatorType = .activity
            characterImageDai.kf.setImage(
                with: URL(string: filePath),
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
        
        
        if have6Star == true{
            
            let filePath = picturesPath + "\(Dai6PicName).png"
                
                characterImage6Dai.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap6(tap:))))
                
                let processor = RoundCornerImageProcessor(cornerRadius: 30.0)
                
                characterImage6Dai.kf.indicatorType = .activity
                characterImage6Dai.kf.setImage(
                    with: URL(string: filePath),
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
                
        }else{
            self.haveSixStar.removeFromSuperview()
            self.characterImage6Dai.removeFromSuperview()
        }
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
    
}
