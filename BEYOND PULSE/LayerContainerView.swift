//
//  LayerContainerView.swift
//  BEYOND PULSE
//
//  Created by Milos Stosic on 8/3/17.
//  Copyright © 2017 Milos Stosic. All rights reserved.
//

import Foundation

class LayerContainerView: UIView
{
    var sing = MySingleton.sharedInstance
       var start : CGColor!
    var end : CGColor!
    override public class var layerClass: Swift.AnyClass {
        return CAGradientLayer.self
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        var a = self.sing.a
        var b = self.sing.b

        if self.sing.a.count > 0
        {
        self.start  = UIColor(red: CGFloat(a[0]), green: CGFloat(a[1]), blue: CGFloat(a[2]), alpha: CGFloat(a[3])).cgColor
        end  =  UIColor(red: CGFloat(b[0]), green: CGFloat(b[1]), blue: CGFloat(b[2]), alpha: CGFloat(b[3])).cgColor
        print(start,end)
        guard let gradientLayer = self.layer as? CAGradientLayer else { return }
        gradientLayer.colors = [
           self.start,
            self.end
        ]
    }
    
    }
    
}
