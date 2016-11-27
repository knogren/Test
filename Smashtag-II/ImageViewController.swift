//
//  ImageViewController.swift
//  Cassini
//
//  Created by Michael Shogren-Knaak on 11/9/16.
//  Copyright © 2016 Bacta.net. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentSize = imageView.frame.size
            scrollView.delegate = self
        }
    }
    
    fileprivate var imageView = UIImageView()
    
    var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
        }
    }
        
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        scrollView.addSubview(imageView)
        zoomImageToFill()
        }
    
    fileprivate func zoomImageToFill() {
        let widthRatio = view.bounds.width/imageView.bounds.width
        let heightRatio = view.bounds.height/imageView.bounds.height
        let ratioToFill = max(widthRatio, heightRatio)
        let ratioToFit = min(widthRatio, heightRatio)
        scrollView.maximumZoomScale = 2*ratioToFill
        scrollView.minimumZoomScale = ratioToFit
        scrollView.zoomScale = ratioToFill
    }
    
    internal func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
}
