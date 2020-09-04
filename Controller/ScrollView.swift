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
        let imageView = UIImageView(image: UIImage(named: imageName))
        print("屏幕宽是\(scrollView.frame.width)")
        print("图片的宽是\(imageView.bounds.width)")
        print("屏幕高是\(scrollView.frame.height)")
        print("图片的高是\(imageView.bounds.height)")
        
        //scroll的拖动功能
        scrollView.contentSize = imageView.bounds.size
        //scrollView.contentOffset = .zero
        scrollView.addSubview(imageView)
        
        //scroll的缩放功能
        scrollView.delegate = self
        
        let scaleFactor = scrollView.frame.width / imageView.bounds.width
        print("缩放比是\(scaleFactor)")
        
        scrollView.minimumZoomScale = scaleFactor
        scrollView.maximumZoomScale = 10
        scrollView.zoomScale = scaleFactor
    
        scrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss(tap:))))
        scrollView.isUserInteractionEnabled = true
        
        imageView.center = CGPoint(x: imageView.frame.width / 2, y: (imageView.frame.height / 2) + (scrollView.frame.height - imageView.frame.height) / 2)
        
    }

    
    @objc private func dismiss(tap: UITapGestureRecognizer){
        dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ScrollView: UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}