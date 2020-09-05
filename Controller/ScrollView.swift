//
//  ScrollView.swift
//  princonnectGuide
//
//  Created by 金超 on 2020/9/4.
//  Copyright © 2020 jinchao. All rights reserved.
//

import UIKit

class ScrollView: UIViewController {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    var imageName: String!
    var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        imageView = UIImageView(image: UIImage(named: imageName))
        
        print("图片的尺寸是\(imageView.bounds.size)")
        
        print("屏幕的尺寸是\(scrollView.frame.size)")
        
        config()
        
        //scroll的拖动功能
        scrollView.contentSize = imageView.bounds.size
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
        
        scrollView.isUserInteractionEnabled = true
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let scaleFactor = scrollView.frame.width / imageView.bounds.width
        print("缩放比是\(scaleFactor)")
        
        scrollView.minimumZoomScale = scaleFactor
        scrollView.maximumZoomScale = 5
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
            scrollView.setZoomScale(2, animated: true)
        }
    }
    
    func config(){
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
    }
}
