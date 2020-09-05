//
//  DetailInformationController.swift
//  princonnectGuide
//
//  Created by 金超 on 2020/8/9.
//  Copyright © 2020 jinchao. All rights reserved.
//

import UIKit

class DetailInformationController: UIViewController {
    
    var DaiPicName:String = ""
    var Star = 1
    var Dai6PicName:String?
    var TitleName:String = ""
    var have6Star = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        characterImageDai.image = UIImage(named: DaiPicName)
        characterImageDai.layer.cornerRadius = 10.0//圆角
                
        characterStar.text = String(Star)
        
        characterName.text = TitleName
        
        if have6Star == true{
            haveSixStar.text = "六星大图"
            characterImage6Dai.image = UIImage(named: Dai6PicName!)
            characterImage6Dai.layer.cornerRadius = 10.0
            characterImage6Dai.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap6(tap:))))
        }else{
            haveSixStar.text = ""
        }
        
        characterImageDai.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(tap:))))

    }
    
    @objc private func handleTap(tap: UITapGestureRecognizer){
        let scrollView = storyboard!.instantiateViewController(withIdentifier: "scrollView") as! ScrollView
        scrollView.modalPresentationStyle = .fullScreen
        scrollView.imageName = DaiPicName
        present(scrollView, animated: true, completion: nil)
    }
    
    @objc private func handleTap6(tap: UITapGestureRecognizer){
        let scrollView = storyboard!.instantiateViewController(withIdentifier: "scrollView") as! ScrollView
        scrollView.modalPresentationStyle = .fullScreen
        scrollView.imageName = Dai6PicName
        present(scrollView, animated: true, completion: nil)
    }
        
    @IBOutlet weak var characterImageDai: UIImageView!
    @IBOutlet weak var characterImage6Dai: UIImageView!
    @IBOutlet weak var characterStar: UILabel!
    @IBOutlet weak var characterName: UILabel!
    @IBOutlet weak var haveSixStar: UILabel!
    

}
