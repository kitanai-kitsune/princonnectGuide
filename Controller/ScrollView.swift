//
//  ScrollView.swift
//  princonnectGuide
//
//  Created by 金超 on 2020/9/4.
//  Copyright © 2020 jinchao. All rights reserved.
//

import UIKit
import Kingfisher

class ScrollView: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var imageName: String = ""
    var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView = UIImageView(image: (UIImage(named: "placeholder")))
        
        let documentDirectory = "file://" + NSHomeDirectory() + "/Documents"
        let path = documentDirectory + "/pictures/\(imageName).png"
        let url = URL(string: path)
        
        imageView.kf.setImage(
            with: url,
            placeholder: nil,
            options: [
                .transition(.fade(0.5))
            ]
        )
        
        config()
        
        //scroll的拖动功能
        scrollView.contentSize = imageView.bounds.size
        print("ContentSize是\(scrollView.contentSize)")
        scrollView.addSubview(imageView)
        
        //scroll的缩放功能
        scrollView.delegate = self
        
        let tapOnce = UITapGestureRecognizer(target: self, action: #selector(dismiss(tap:)))
        scrollView.addGestureRecognizer(tapOnce)
        
        let tapTwice = UITapGestureRecognizer(target: self, action: #selector(zoomin(tap:)))
        tapTwice.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(tapTwice)
        
        //优先检测tapTwice,若检测不到,或检测失败,则检测tapOnce,检测成功后,触发方法
        tapOnce.require(toFail: tapTwice)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let scaleFactor = scrollView.frame.width / imageView.bounds.width
        //print("缩放比是\(scaleFactor)")
        
        scrollView.minimumZoomScale = scaleFactor
        scrollView.zoomScale = scaleFactor
        //scrollView.setZoomScale(2, animated: true)//同上但带动画效果 比如双击放大2倍
        
    }
    
    
    @objc private func dismiss(tap: UITapGestureRecognizer){
        if tap.state == .ended{
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func zoomin(tap: UITapGestureRecognizer){
        if tap.state == .ended{
            if scrollView.zoomScale > scrollView.minimumZoomScale{
                scrollView.setZoomScale(self.scrollView.minimumZoomScale, animated: true)
            }else{
                scrollView.setZoomScale(self.scrollView.maximumZoomScale, animated: true)
            }
        }
    }
    
    private func config(){
        scrollView.indicatorStyle = .default//滚动条的属性
        scrollView.showsVerticalScrollIndicator = false//垂直滚动条
        scrollView.showsHorizontalScrollIndicator = false//水平滚动条
    }
    
}

extension ScrollView: UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    //缩放时保持局中 缩放因子要放在viewDidLayoutSubviews中
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if imageView.frame.height < scrollView.frame.height{
            imageView.center = CGPoint(x: imageView.frame.width / 2, y: (imageView.frame.height / 2) + (scrollView.frame.height - imageView.frame.height) / 2)
        }
        print("图片的frame是\(imageView.frame.size)")
        print("图片的bounds是\(imageView.bounds.size)")
    }
}
