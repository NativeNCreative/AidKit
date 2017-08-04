//
//  AKManager.swift
//  AidKit
//
//  Created by Rezeq, Maher on 7/27/17.
//  Copyright © 2017 NativeNCreative. All rights reserved.
//

import UIKit

final public class AKManager : NSObject {

    // MARK: - Public Variables
    static public let sharedInstance = AKManager()

    fileprivate var configuration: Configuration?

    public let visualizer: Visualizer =  Visualizer()

    public let recorder: Recorder =  Recorder()

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

    // MARK: - Helper Functions
    @objc internal func applicationDidBecomeActiveNotification(_ notification: Notification) {
        UIApplication.shared.keyWindow?.swizzler()
    }

    public func start(_ configuration: Configuration = Configuration({_ in})) {
        visualizer.start()
        recorder.startRecording()
    }
    
    public func stop() {
        visualizer.stop()
        recorder.stopRecording()

    }
}
