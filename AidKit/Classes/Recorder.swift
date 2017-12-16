//
//  Recorder.swift
//  AidKit
//
//  Created by Rezeq, Maher on 7/27/17.
//  Copyright © 2017 NativeNCreative. All rights reserved.
//

import Foundation
import ReplayKit

final public class RecorderConfiguration: Configurable {
    public var name: String = "Recorder"
    public var isOn: Bool = false
}

final public class Recorder : NSObject, RPScreenRecorderDelegate, RPPreviewViewControllerDelegate, Controllable {

    public var presentedViewController: UIViewController?
    public var configuration: Configurable?

    let recorder  = RPScreenRecorder.shared()

    public override init() {
        super.init()
        RPScreenRecorder.shared().delegate = self
    }

    // TODO: Create a callback block after start recording to report error or recording started successfully
    public func start() {

        guard #available(iOS 10.0, *), (RPScreenRecorder.shared().isAvailable), let configuration = configuration, configuration.isOn else {
            // TODO Log error
            // Fallback on earlier versions
            return
        }

        RPScreenRecorder.shared().startRecording(handler: {(error: Error?) in
            if error == nil {
                // Recording started
                NSLog("Recording started")
            }
        })
    }

    public func stop() {
        recorder.stopRecording { [unowned self]  (preview, error) in
            if let preview = preview {
                preview.previewControllerDelegate = self
                if let presentedViewController = self.previewController() {
                    presentedViewController.present(preview, animated: true)
                }
            }
        }
    }

    func previewController() -> UIViewController?{
        if((presentedViewController) != nil) {
            return presentedViewController
        }
        return UIApplication.shared.keyWindow?.rootViewController
    }

    public func screenRecorder(_ screenRecorder: RPScreenRecorder, didStopRecordingWithError error: Error, previewViewController: RPPreviewViewController?) {
        NSLog("Recording stopped")
    }

    public func screenRecorderDidChangeAvailability(_ screenRecorder: RPScreenRecorder) {
        NSLog("Screen recorder is not available")
    }

    public func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        previewController.dismiss(animated: true)
    }
}
