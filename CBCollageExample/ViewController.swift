//
//  ViewController.swift
//  CBCollageExample
//
//  Created by Charles@CardinalBlue on 2019/6/24.
//  Copyright © 2019 Cardinalblue. All rights reserved.
//

import UIKit
import CBCollage

class ViewController: UIViewController {

    
    lazy var targetView: UIView = {
        let targetView = UIView(frame: .zero)
        targetView.backgroundColor = UIColor.white
        targetView.frame = CGRect(x: 0, y: 0, width: 179, height: 172)
        targetView.center = CGPoint(x: 119, y: 117)
        return targetView
    }()
    
    lazy var targetView2: UIView = {
        let targetView = UIView(frame: .zero)
        targetView.backgroundColor = UIColor.red
        targetView.frame = CGRect(x: 0, y: 0, width: 68, height: 68)
        targetView.center = CGPoint(x: 121, y: 511)
        return targetView
    }()
    
    lazy var targetView3: UIView = {
        let targetView = UIView(frame: .zero)
        targetView.backgroundColor = UIColor.red
        targetView.frame = CGRect(x: 0, y: 0, width: 326, height: 524)
        targetView.center = CGPoint(x: 219, y: 301)
        return targetView
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViews()
    }
    
    func setupViews() {
        view.addSubview(targetView3)
        view.addSubview(targetView2)
        view.addSubview(targetView)
    }
    
    @IBAction func pressPlayButton(_ sender: Any) {
        guard let url = Bundle.main.url(forResource: "collage_01", withExtension: "json") else { return }
        do {
            let json = try Data(contentsOf: url, options: .alwaysMapped)
            guard let jsonObj = try JSONSerialization.jsonObject(with: json, options: .allowFragments) as? [String: Any],
                let collage = CBCollage(obj: jsonObj) else { return }
            let animationModel = collage.animationModel
            addAnimations(layer: targetView.layer, animationModel: animationModel, refId: "0")
            addAnimations(layer: targetView2.layer, animationModel: animationModel, refId: "1")
            addAnimations(layer: targetView3.layer, animationModel: animationModel, refId: "2")
        } catch {
            print("error occured \(error)")
        }
    }
    
    func generateMaskLayer(with mask: CBMask, forLayer parentLayer: CALayer) -> CALayer {
        let bounds = parentLayer.bounds
        let layer = CAShapeLayer()
        layer.frame = bounds
        layer.fillColor = UIColor(white: 0, alpha: mask.opacity).cgColor
        let path = UIBezierPath()
        for (index, normalizedPoint) in mask.vertices.enumerated() {
            let point = normalizedPoint.applying(CGAffineTransform(scaleX: bounds.width,
                                                                   y: bounds.height))
            if index == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        if mask.isClose {
            path.close()
        }
        layer.path = path.cgPath
        return layer
    }
    
    func addAnimations(layer: CALayer, animationModel: CBCollageAnimaitonModel, refId: String) {
        
        let animations = animationModel.layers[refId]!
        
        for animation in animations {
            let caAnimation = animation.caAnimaiton(forExport: false)
            layer.add(caAnimation, forKey: nil)
        }
        
        if let masks = animationModel.masks[refId] {
            let maskParent = CALayer()
            maskParent.frame = layer.bounds
            for mask in masks {
                let maskLayer = generateMaskLayer(with: mask, forLayer: layer)
                maskParent.addSublayer(maskLayer)
                if let maskAnimations = animationModel.layers[mask.identifier] {
                    for animation in maskAnimations {
                        let caAnimation = animation.caAnimaiton(forExport: false)
                        maskLayer.add(caAnimation, forKey: nil)
                    }
                }
            }
            layer.mask = maskParent
        }
        
    }
}

