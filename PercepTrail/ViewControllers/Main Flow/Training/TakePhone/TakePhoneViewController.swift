//
//  TakePhoneViewController.swift
//  PercepTrail
//
//  Created by 王柏崴 on 6/21/24.
//

import UIKit
import AVFoundation
import MaterialShowcase
import Photos

// MARK: - TakePhoneViewController

class TakePhoneViewController: UIViewController {
    // MARK: - IBOutlet

    @IBOutlet var vScanRect: UIView!
    @IBOutlet var btnTakePhone: UIButton!
    @IBOutlet var btnCheckmark: UIButton!
    @IBOutlet var btnRemove: UIButton!
    @IBOutlet var btnBackVC: UIButton!
    @IBOutlet var lbHint: UILabel!
    @IBOutlet var lbCancle: UILabel!

    // MARK: - Variables

    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var captureSession: AVCaptureSession!
    var photoOutput: AVCapturePhotoOutput?
    var capturedImage: UIImage?
    var fromTask: Bool = false
    let sequence = MaterialShowcaseSequence()
    let sequence2 = MaterialShowcaseSequence()

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
        lbCancle.isHidden = true
        btnBackVC.isHidden = false
        addShowCase()
    }

    private func addShowCase() {
        DispatchQueue.main.async {
            let oneTimeKey = "camera"
            let showcase1 = self.createShowcase(for: self.btnTakePhone,
                                                withText: "點擊此處來紀錄旅途風景",
                                                withColor: .showcase)
            let showcase2 = self.createShowcase(for: self.btnBackVC,
                                                withText: "點擊此處來返回主畫面",
                                                withColor: .showcase)

            self.sequence
                .temp(showcase1)
                .temp(showcase2)
                .setKey(key: oneTimeKey)
                .start()
        }
    }
    
    private func addShowCase2() {
        DispatchQueue.main.async {
            let oneTimeKey = "photo"
            let showcase3 = self.createShowcase(for: self.btnCheckmark,
                                                withText: "點擊此處來保存沿途風光，可以在手機相簿內查看",
                                                withColor: .blue)
            let showcase4 = self.createShowcase(for: self.btnRemove,
                                                withText: "點擊此處來重新拍攝",
                                                withColor: .blue)

            self.sequence2
                .temp(showcase3)
                .temp(showcase4)
                .setKey(key: oneTimeKey)
                .start()
        }
    }

    private func createShowcase(for view: UIView, withText: String, withColor: UIColor) -> MaterialShowcase {
        let showCase = MaterialShowcase()
        showCase.delegate = self
        showCase.setTargetView(view: view)
        showCase.primaryText = withText
        showCase.secondaryText = ""
        showCase.backgroundAlpha = 1
        showCase.shouldSetTintColor = false
        showCase.backgroundPromptColor = withColor
        showCase.backgroundPromptColorAlpha = 0.6
        showCase.backgroundViewType = .circle
        showCase.backgroundRadius = 400
        showCase.targetTintColor = .blue
        showCase.targetHolderRadius = 60
        showCase.targetHolderColor = .clear
        showCase.isTapRecognizerForTargetView = true
        
        return showCase
    }
    
    private func setupButtonStatus() {
        btnCheckmark.isHidden = true
        btnCheckmark.isEnabled = false

        btnTakePhone.isHidden = false
        btnTakePhone.isEnabled = true

        btnRemove.isHidden = true
        btnRemove.isEnabled = false
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

        if let xmarkImage = UIImage(systemName: "xmark")?.withTintColor(.white, renderingMode: .alwaysOriginal) {
            let resizedxmarkImage = xmarkImage.resizeImage(to: CGSize(width: 60, height: 60))
            btnRemove.setImage(resizedxmarkImage, for: .normal)
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
                kCVPixelBufferHeightKey as String: NSNumber(value: Float(vScanRect.bounds.height)),
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
                switch status {
                case .authorized:
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

                case .denied, .restricted:
                    Alert.showAlertWithError(title: "相簿訪問被拒",
                                             message: "此功能需要訪問您的相簿，請在設定中允許訪問",
                                             vc: self,
                                             confirmTitle: "確認", confirm: {
                                                 CommandBase.sharedInstance.openURL(with: AppDefine.SettingsURLScheme.Photos.rawValue)
                                             })

                default:
                    break
                }
            }
        }
    }

    @IBAction func cancelPhoto(_ sender: Any) {
        vScanRect.subviews.forEach { $0.removeFromSuperview() }

        // 重新啟動攝影機預覽
        if !captureSession.isRunning {
            DispatchQueue.global().async {
                self.captureSession.startRunning()
            }
        }

        btnCheckmark.isHidden = true
        btnCheckmark.isEnabled = false
        lbCancle.isHidden = true
        btnBackVC.isHidden = false
        btnBackVC.isEnabled = true
        btnTakePhone.isEnabled = true
        btnTakePhone.isHidden = false
        btnRemove.isHidden = true
        btnRemove.isEnabled = false

        lbHint.text = "拍照"
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
                    guard let self = self else { return }
                    if granted {
                        self.setupCaptureSession()
                        self.setupPreviewLayer()
                    } else {
                        // 弹出警告框
                        Alert.showAlertWithError(title: "相機訪問被拒",
                                                 message: "此功能需要使用您的相機，請在設定中允許訪問相機", vc: self,
                                                 confirmTitle: "確認", confirm: {
                                                     CommandBase.sharedInstance.openURL(with: AppDefine.SettingsURLScheme.Camera.rawValue)
                                                 })
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
        if let imagePath = saveImageToDocumentsDirectory(image: image) {
            let imageName = URL(fileURLWithPath: imagePath).lastPathComponent
            LocalDatabase.shared.insertPhoto(name: imageName, imagePath: imagePath)
            print("Photo saved to local database at \(imagePath)")
        } else {
            print("Failed to save photo to local database")
        }
    }

    private func goHomeVC() {
        if fromTask {
            let storyboard = UIStoryboard(name: "SiteVisit", bundle: nil)
            if let routeVC = storyboard.instantiateViewController(withIdentifier: "RouteViewController") as? RouteViewController {
                present(routeVC, animated: true, completion: nil)
            }
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let homeVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as? MainTabBarController {
                present(homeVC, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - TakePhoneViewController: MaterialShowcaseDelegate

extension TakePhoneViewController: MaterialShowcaseDelegate {
    func showCaseDidDismiss(showcase: MaterialShowcase, didTapTarget: Bool) {
        sequence.showCaseWillDismis()
        sequence2.showCaseWillDismis()
    }
}

// MARK: - TakePhoneViewController + AVCapturePhotoCaptureDelegate

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
        capturedImage = croppedImage

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

                self.btnRemove.isHidden = false
                self.btnRemove.isEnabled = true

                self.lbCancle.isHidden = false
                self.btnBackVC.isHidden = true
            
                self.lbHint.text = "保存"
                
                self.addShowCase2()
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
