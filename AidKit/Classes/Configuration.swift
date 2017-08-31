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

public typealias buildConfigurationClosure = (Configuration) -> Void

final public class Configuration  {

    public init(_ build:buildConfigurationClosure) {
        build(self)
    }

    public let recorderConfiguration = RecorderConfiguration()
    public let visualizerConfiguration = VisualizerConfiguration()
    public let debuggerConfiguration = DebuggerConfiguration()
    public let loggerConfiguration = LoggerConfiguration()

}

public protocol Configurable {
    var isOn: Bool {get}
    var name: String {get}
}

final public class RecorderConfiguration: Configurable {
    public var name: String = "Recorder"
    public var isOn: Bool = false
}

final public class VisualizerConfiguration: Configurable {

    public var name: String = "Visualizer"
    public var isOn: Bool = false

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

final public class DebuggerConfiguration: Configurable {

    public var name: String = "Debugger"
    public var isOn: Bool = false
}

final public class LoggerConfiguration: Configurable {

    public var name: String = "Logger"
    public var isOn: Bool = false
}

