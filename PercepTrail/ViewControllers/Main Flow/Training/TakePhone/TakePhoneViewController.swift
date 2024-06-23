//
//  TakePhoneViewController.swift
//  PercepTrail
//
//  Created by 王柏崴 on 6/21/24.
//

import AVFoundation
import Photos
import PhotosUI
import UIKit

// MARK: - TakePhoneViewController

class TakePhoneViewController: UIViewController {
    // MARK: - IBOutlet

    @IBOutlet var vScanRect: UIView!
    @IBOutlet var btnTakePhone: UIButton!
    @IBOutlet var btnCheckmark: UIButton!
    @IBOutlet var lbHint: UILabel!

    // MARK: - Variables

    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var captureSession: AVCaptureSession!
    var photoOutput: AVCapturePhotoOutput?
    var capturedImage: UIImage?

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        requestCameraAccessAndSetupSession()
        setupUI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        videoPreviewLayer?.frame = vScanRect.bounds
    }

    // MARK: - UI Settings

    fileprivate func setupUI() {
        setupButtonImage()
        setupButtonStatus()
        lbHint.text = "拍照"
    }

    private func setupButtonStatus() {
        btnCheckmark.isHidden = true
        btnCheckmark.isEnabled = false

        btnTakePhone.isHidden = false
        btnTakePhone.isEnabled = true
    }

    private func setupButtonImage() {
        if let image1 = UIImage(systemName: "camera.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal) {
            let resizedImage = image1.resizeImage(to: CGSize(width: 70, height: 60))
            btnTakePhone.setImage(resizedImage, for: .normal)
        }

        if let checkmarkImage = UIImage(systemName: "checkmark")?.withTintColor(.white, renderingMode: .alwaysOriginal) {
            let resizedCheckmarkImage = checkmarkImage.resizeImage(to: CGSize(width: 60, height: 60))
            btnCheckmark.setImage(resizedCheckmarkImage, for: .normal)
        }
    }

    // MARK: - IBAction

    @IBAction func pressedPhoto(_ sender: Any) {
        let settings = AVCapturePhotoSettings()
        // 指定拍攝的預覽格式，包括像素格式
        if let availablePreviewPhotoPixelFormatTypes = settings.availablePreviewPhotoPixelFormatTypes.first {
            settings.previewPhotoFormat = [
                kCVPixelBufferPixelFormatTypeKey as String: availablePreviewPhotoPixelFormatTypes,
                kCVPixelBufferWidthKey as String: NSNumber(value: Float(vScanRect.bounds.width)),
                kCVPixelBufferHeightKey as String: NSNumber(value: Float(vScanRect.bounds.height))
            ]
        }
        photoOutput?.capturePhoto(with: settings, delegate: self)
    }

    @IBAction func savePhoto(_ sender: Any) {
        guard let image = capturedImage else {
            Alert.showToastWith(message: "沒有圖片可保存", vc: self, during: .short)
            return
        }

        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                if status == .authorized {
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAsset(from: image)
                    }) { success, error in
                        if let error = error {
                            Alert.showToastWith(message: "保存失敗: \(error.localizedDescription)", vc: self, during: .long)
                        } else if success {
                            // 圖片保存到 文件系統(應用沙盒) 和 SQLite
                            self.saveImageToDatabase(image: image)
                            Alert.showToastWith(message: "保存成功！", vc: self, during: .long, dismiss: {
                                self.goHomeVC()
                            })
                        } else {
                            Alert.showToastWith(message: "保存失敗！", vc: self, during: .long)
                        }
                    }
                } else {
                    Alert.showToastWith(message: "相簿存取被拒！", vc: self, during: .long)
                }
            }
        }
    }

    @IBAction func goHomeVC(_ sender: Any) {
        goHomeVC()
    }

    // MARK: - Action

    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("Error saving photo: \(error)")
        } else {
            print("Photo saved successfully")
        }
    }

    // MARK: - Function

    private func setupPreviewLayer() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.frame = vScanRect.bounds
        vScanRect.layer.addSublayer(videoPreviewLayer)
    }

    private func setupCaptureSession() {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .high

        guard let captureDevice = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: captureDevice),
              captureSession.canAddInput(input) else {
            print("Failed to set up the camera input")
            return
        }
        captureSession.addInput(input)

        // Set up photo output
        let output = AVCapturePhotoOutput()
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
            photoOutput = output
        }

        captureSession.startRunning()
    }

    private func requestCameraAccessAndSetupSession() {
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
                        print("Access denied")
                    }
                }
            }

        default:
            print("Access to camera was denied or restricted")
        }
    }

    private func generateUniqueFileName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        return dateFormatter.string(from: Date()) + ".jpg"
    }

    private func saveImageToDocumentsDirectory(image: UIImage) -> String? {
        let fileName = generateUniqueFileName()
        let fileManager = FileManager.default
        let docURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = docURL.appendingPathComponent(fileName)

        if let imageData = image.jpegData(compressionQuality: 0.8) {
            try? imageData.write(to: fileURL)
            return fileURL.path
        }
        return nil
    }

    private func saveImageToDatabase(image: UIImage) {
        if let imagePath = self.saveImageToDocumentsDirectory(image: image) {
            let imageName = URL(fileURLWithPath: imagePath).lastPathComponent
            LocalDatabase.shared.insertPhoto(name: imageName, imagePath: imagePath)
            print("Photo saved to local database at \(imagePath)")
        } else {
            print("Failed to save photo to local database")
        }
    }

    private func goHomeVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let homeVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as? MainTabBarController {
            self.present(homeVC, animated: true, completion: nil)
        }
    }
}

// MARK: AVCapturePhotoCaptureDelegate

extension TakePhoneViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Error capturing photo: \(error)")
            return
        }

        guard let imageData = photo.fileDataRepresentation() else {
            print("No image data to process")
            return
        }

        guard let image = UIImage(data: imageData) else {
            print("Failed to convert imageData to UIImage")
            return
        }

        // 裁剪圖像以符合預覽層的視角
        let croppedImage = cropImageToPreviewLayer(originalImage: image)
        self.capturedImage = croppedImage

        DispatchQueue.main.async {
            if let croppedImage = croppedImage {
                let imageView = UIImageView(image: croppedImage)
                imageView.frame = self.vScanRect.bounds
                imageView.contentMode = .scaleAspectFill
                self.vScanRect.addSubview(imageView)

                self.captureSession.stopRunning()

                self.btnCheckmark.isHidden = false
                self.btnCheckmark.isEnabled = true

                self.btnTakePhone.isHidden = true
                self.btnTakePhone.isEnabled = false

                self.lbHint.text = "保存"
            } else {
                print("Failed to crop image")
            }
        }
    }

    func cropImageToPreviewLayer(originalImage: UIImage) -> UIImage? {
        // 從layer轉換矩形
        let outputRect = videoPreviewLayer.metadataOutputRectConverted(fromLayerRect: videoPreviewLayer.bounds)
        guard let cgImage = originalImage.cgImage else { return nil }

        let width = CGFloat(cgImage.width)
        let height = CGFloat(cgImage.height)
        let cropRect = CGRect(x: outputRect.origin.x * width, y: outputRect.origin.y * height, width: outputRect.size.width * width, height: outputRect.size.height * height)

        guard let croppedCgImage = cgImage.cropping(to: cropRect) else { return nil }
        return UIImage(cgImage: croppedCgImage, scale: originalImage.scale, orientation: originalImage.imageOrientation)
    }
}
