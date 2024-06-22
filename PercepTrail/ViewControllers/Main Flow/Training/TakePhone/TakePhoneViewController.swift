//
//  TakePhoneViewController.swift
//  PercepTrail
//
//  Created by 王柏崴 on 6/21/24.
//

import AVFoundation
import UIKit

class TakePhoneViewController: UIViewController {
    // MARK: - IBOutlet

    @IBOutlet var vScanRect: UIView!
    @IBOutlet var btnTakePhone: UIButton!
    @IBOutlet var btnCheckmark: UIButton!
    @IBOutlet var lbHint: UILabel!

    // MARK: - Variables

    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var captureSession: AVCaptureSession!

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        requestCameraAccessAndSetupSession()
        setupButtonImage()
    }

    func setupButtonImage() {
        let image1 = UIImage(systemName: "camera.fill")?.resizeImage(to: CGSize(width: 70, height: 60))
        btnTakePhone.setImage(image1, for: .normal)

        if let checkmarkImage = UIImage(systemName: "checkmark")?.withTintColor(.white, renderingMode: .alwaysOriginal) {
            let resizedCheckmarkImage = checkmarkImage.resizeImage(to: CGSize(width: 60, height: 60))
            btnCheckmark.setImage(resizedCheckmarkImage, for: .normal)
        }
    }

    // MARK: - IBAction

    @IBAction func pressedPhoto(_ sender: Any) {
    }

    @IBAction func savePhoto(_ sender: Any) {
    }

    // MARK: - Function

    func setupPreviewLayer() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.frame = vScanRect.bounds
        vScanRect.layer.addSublayer(videoPreviewLayer)
    }

    func setupCaptureSession() {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .high

        guard let captureDevice = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: captureDevice),
              captureSession.canAddInput(input) else {
            print("Failed to set up the camera input")
            return
        }
        captureSession.addInput(input)
        captureSession.startRunning()
    }

    func requestCameraAccessAndSetupSession() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupCaptureSession()
            setupPreviewLayer()

        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
                        self?.setupCaptureSession()
                        self?.setupPreviewLayer()
                    } else {
                        // Handle the case where user denies the access
                        print("Access denied")
                    }
                }
            }

        default:
            print("Access to camera was denied or restricted")
        }
    }
}
