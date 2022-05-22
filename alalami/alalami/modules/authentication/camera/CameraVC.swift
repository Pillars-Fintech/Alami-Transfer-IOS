//
//  CameraVC.swift
//  alalami
//
//  Created by Zaid Khaled on 9/1/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit
import SwiftyCam
import PTTimer

protocol CameraCaptureDelegate {
    func didCaptureVideo(url : URL)
}
class CameraVC: SwiftyCamViewController {
    
    //timer
    var timer : PTTimer?
    var seconds = 0
    var timerValue : Int = 2
    @IBOutlet weak var lblTimer: UILabel!
    
    var delegate : CameraCaptureDelegate?
    
    @IBOutlet weak var viewCapture: CardView!
    @IBOutlet weak var btnCapture: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultCamera = .front
        maximumVideoDuration = 2
        videoQuality = .low
        videoQuality = .resolution352x288
        doubleTapCameraSwitch = false
        cameraDelegate = self
    }
    
    func startRecordingUI() {
        self.timer = PTTimer.Down(startSeconds: self.timerValue)
        self.timer?.delegate = self
        self.timer?.start()
        self.btnCapture.setImage(UIImage(named: "ic_stop_recording"), for: .normal)
        self.startVideoRecording()
    }
    
    func stopRecordingUI() {
        self.timer?.pause()
        self.lblTimer.text = "2"
        self.timerValue = 2
        self.btnCapture.setImage(UIImage(named: "is_start_recording"), for: .normal)
        self.stopVideoRecording()
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func captureAction(_ sender: Any) {
        if (self.isVideoRecording) {
            self.stopRecordingUI()
        }else {
            self.startRecordingUI()
        }
    }
}

extension CameraVC : PTTimerDelegate {
    
    func timerTimeDidChange(seconds: Int) {
        self.timerValue = seconds
        self.lblTimer.text = "\(seconds)"
        if (seconds == 0) {
            self.stopRecordingUI()
        }
    }
    
    func timerDidPause() {
        
    }
    
    func timerDidStart() {
        // update label colors, buttons for a started timer
    }
    
    func timerDidReset() {
        // update label colors, buttons now that the timer has been reset
        self.stopRecordingUI()
    }
}

extension CameraVC : SwiftyCamViewControllerDelegate {
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didBeginRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        // Called when startVideoRecording() is called
        // Called if a SwiftyCamButton begins a long press gesture
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        // Called when stopVideoRecording() is called
        // Called if a SwiftyCamButton ends a long press gesture
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishProcessVideoAt url: URL) {
        // Called when stopVideoRecording() is called and the video is finished processing
        // Returns a URL in the temporary directory where video is stored
        self.delegate?.didCaptureVideo(url: url)
        self.dismiss(animated: true, completion: nil)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFocusAtPoint point: CGPoint) {
        // Called when a user initiates a tap gesture on the preview layer
        // Will only be called if tapToFocus = true
        // Returns a CGPoint of the tap location on the preview layer
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didChangeZoomLevel zoom: CGFloat) {
        // Called when a user initiates a pinch gesture on the preview layer
        // Will only be called if pinchToZoomn = true
        // Returns a CGFloat of the current zoom level
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didSwitchCameras camera: SwiftyCamViewController.CameraSelection) {
        // Called when user switches between cameras
        // Returns current camera selection
    }
}
