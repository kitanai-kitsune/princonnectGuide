//
//  DetailInformationController.swift
//  princonnectGuide
//
//  Created by 金超 on 2020/8/9.
//  Copyright © 2020 jinchao. All rights reserved.
//

import UIKit
import ImageViewer

class DetailInformationController: UIViewController {
    
    var DaiPicName:String = ""
    var Star = 1
    var Dai6PicName:String = ""
    var TitleName:String = ""
    var have6Star = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        characterImageDai.image = UIImage(named: DaiPicName)
        characterImageDai.layer.cornerRadius = 10.0//圆角
        
//        characterImageDai.layer.shadowColor = UIColor.black.cgColor
//        characterImageDai.layer.shadowOffset = CGSize(width: 5, height: 5)//影子的方向
//        characterImageDai.layer.shadowOpacity = 0.5//透明度
//        characterImageDai.layer.shadowRadius = 10
//        characterImageDai.layer.masksToBounds = false
        
        characterStar.text = String(Star)
        
        
        characterImage6Dai.image = UIImage(named: Dai6PicName)
        characterImage6Dai.layer.cornerRadius = 10.0
        
        
        characterName.text = TitleName
        
        
        if have6Star == true{
            haveSixStar.text = "六星大图"
        }else{
            haveSixStar.text = ""
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(tap:)))
        characterImageDai.addGestureRecognizer(tap)

    }
    
    @objc func handleTap(tap: UITapGestureRecognizer){
        showImage()
    }
    
    func showImage(){

        let imageView = UIImageView(image: UIImage(named: DaiPicName))
                
        imageView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)

        let width = imageView.widthAnchor.constraint(equalToConstant: view.frame.width)
        let height = imageView.heightAnchor.constraint(equalToConstant: view.frame.width/1.778)
        let xAnchor = imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let yAnchor = imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        NSLayoutConstraint.activate([width,height,xAnchor,yAnchor])
        view.layoutIfNeeded()
    }

    
    @IBOutlet weak var characterImageDai: UIImageView!
    @IBOutlet weak var characterImage6Dai: UIImageView!
    @IBOutlet weak var characterStar: UILabel!
    @IBOutlet weak var characterName: UILabel!
    @IBOutlet weak var haveSixStar: UILabel!
    

}
