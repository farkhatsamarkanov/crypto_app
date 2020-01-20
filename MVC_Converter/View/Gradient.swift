//
//  Gradient.swift
//  MVC_Converter
//
//  Created by Admin on 11/12/2019.
//  Copyright © 2019 ECorp. All rights reserved.
//

import Foundation
import UIKit

class GradientView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        autoresizingMask = [.flexibleWidth, .flexibleHeight]

        guard let theLayer = self.layer as? CAGradientLayer else {
            return;
        }

        theLayer.colors = [UIColor(red: 68/255.0, green: 111/255.0, blue: 203/255.0, alpha: 1.0).cgColor, UIColor(red: 80/255.0, green: 60/255.0, blue: 161/255.0, alpha: 1.0).cgColor]
        theLayer.locations = [0.0, 1.1]
        theLayer.frame = self.bounds
    }

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
}


