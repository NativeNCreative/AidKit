//
//  AKManager.swift
//  AidKit
//
//  Created by Rezeq, Maher on 7/27/17.
//  Copyright © 2017 NativeNCreative. All rights reserved.
//

import UIKit

protocol AKControllable {
    func start(_ configuration: Configurable)
    func stop()
}

final public class AKManager : NSObject {

    // MARK: - Public Variables
    static public let sharedInstance = AKManager()

    fileprivate var configuration: Configuration = Configuration{_ in}

    public let visualizer: Visualizer =  Visualizer()
    public let recorder: Recorder =  Recorder()
    public let debugger: Debugger =  Debugger()

    // MARK: - Object life cycle
    private override init() {
        super.init()

        NotificationCenter
            .default
            .addObserver(self, selector: #selector(AKManager.applicationDidBecomeActiveNotification(_:)), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Helper Functioxns
    @objc internal func applicationDidBecomeActiveNotification(_ notification: Notification) {
        UIApplication.shared.keyWindow?.swizzler()
    }

    public func start(_ configuration: Configuration? = nil) {
        self.configuration = configuration ?? self.configuration
        visualizer.start(self.configuration.visualizerConfiguration)
        recorder.start(self.configuration.recorderConfiguration)
        debugger.start(self.configuration.debuggerConfiguration)
    }
    
    public func stop() {
        visualizer.stop()
        recorder.stop()

    }
}
