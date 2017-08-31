//
//  Shape.swift
//  AidKit
//
//  Created by Rezeq, Maher on 7/27/17.
//  Copyright © 2017 NativeNCreative. All rights reserved.
//

import UIKit

final public class Shape: UIView {

    // MARK: - Public Variables
    internal weak var touch: UITouch?
    internal var configuration: VisualizerConfiguration
    private var size = CGSize(width: 60.0, height: 60.0)


    convenience init() {
        self.init(frame: .zero)
    }

    override init(frame: CGRect) {

        configuration = Configuration({_ in }).visualizerConfiguration

        super.init(frame: frame)

        self.backgroundColor = configuration.color
        self.layer.cornerRadius = 30;
        self.layer.masksToBounds = true;
        self.tintColor = configuration.color
        self.frame = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Touch life cycle

    internal func beginTouch() {
        alpha = 1.0
    }
    
    func endTouch() {
    }
}
