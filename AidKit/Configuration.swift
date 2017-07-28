//
//  Configuration.swift
//  AidKit
//
//  Created by Rezeq, Maher on 7/27/17.
//  Copyright © 2017 NativeNCreative. All rights reserved.
//
import UIKit

protocol ConfigurationProtocol {
    var color: UIColor? { get }
    var image: UIImage? { get }
}

typealias buildConfigurationClosure = (Configuration) -> Void

final public class Configuration : ConfigurationProtocol {

    init(_ build:buildConfigurationClosure) {
        build(self)
    }

    static let defaultColor =  UIColor(red: 52.0/255.0, green: 152.0/255.0, blue: 219.0/255.0, alpha: 0.8)

    public var color: UIColor? = defaultColor

    public var image: UIImage? = {

        let rect = CGRect(x: 0.0, y: 0.0, width: 60.0, height: 60.0)

        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let contextRef = UIGraphicsGetCurrentContext()
        contextRef?.setFillColor(defaultColor.cgColor)
        contextRef?.fillEllipse(in: rect)
        var image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image?.withRenderingMode(.alwaysTemplate)
    }()

}



