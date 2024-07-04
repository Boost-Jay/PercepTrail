//
//  ScanQRCodeViewController.swift
//  PercepTrail
//
//  Created by imac-2627 on 2024/7/4.
//

import AVFoundation
import UIKit

class ScanQRCodeViewController: UIViewController {
    // MARK: - IBOutlet

    @IBOutlet var vScanRect: UIView!

    // MARK: - Variables

    var videoPreviewLayer = AVCaptureVideoPreviewLayer() // 擷取影片時顯示影片
    let captureSession = AVCaptureSession()
    var scanQRcodePath = UIBezierPath() // 可掃描範圍的CGRect
    var blackBackgroundView = UIView() // 遮罩
    let superViewBounds = UIScreen.main.bounds // 裝置的邊界大小

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        scanQRCodeBlackView()
        cameraRequestAccess()
    }

    // MARK: - viewLayoutMarginsDidChange

    // iOS 11 後新 API，根視圖的邊距變更時會觸發該方法的回調
    override func viewLayoutMarginsDidChange() {
        scanQRCodeRectOfInterest()
        scanQRCodeBlackView()
    }

    /// 設定可掃描範圍的 CGRect
    func scanQRCodeRectOfInterest() {
        let width = superViewBounds.width / 2
        let newX = superViewBounds.width / 2 - (width / 2)
        let newY = superViewBounds.height / 2 - (width / 1.5)
        let tempPath = UIBezierPath(roundedRect: CGRect(x: newX, y: newY, width: width, height: width),
                                    cornerRadius: width / 10)
        scanQRcodePath = tempPath
    }

    /// 設定遮罩
    func scanQRCodeBlackView() {
        blackBackgroundView = UIView(frame: UIScreen.main.bounds)
        blackBackgroundView.backgroundColor = UIColor.black
        blackBackgroundView.alpha = 0.6
        blackBackgroundView.layer.mask = addTransparencyView(tempPath: scanQRcodePath) // 只有遮罩層覆蓋的地方才會顯示出來
        blackBackgroundView.layer.name = "blackBackgroundView"
        vScanRect.addSubview(blackBackgroundView)
    }

    /// 添加透明度視圖（摳圖）
    func addTransparencyView(tempPath: UIBezierPath) -> CAShapeLayer {
        let path = UIBezierPath(rect: UIScreen.main.bounds)
        path.append(tempPath)
        path.usesEvenOddFillRule = true

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.black.cgColor // 其他顏色都可以，只要不是透明的
        shapeLayer.fillRule = .evenOdd

        return shapeLayer
    }

    // MARK: - IBAction
    
    @IBAction func backVC(_ sender: Any) {
    }
    
    
    // MARK: - Function

    /// 取得相機權限
    func cameraRequestAccess() {
        if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
            DispatchQueue.main.async {
                self.scanQrCode()
                self.scanQRCodeBlackView()
            }
        } else {
            Task {
                let granted = await AVCaptureDevice.requestAccess(for: .video)
                await MainActor.run {
                    if granted {
                        // access allowed
                        print("獲取相機裝置")
                        self.scanQrCode()
                        self.scanQRCodeBlackView()
                    } else {
                        // access denied
                        print("無法獲取相機裝置")
                        return
                    }
                }
            }
        }
    }

    /// 掃描 QR Code
    func scanQrCode() {
        // 透過 AVCaptureDevice 來捕捉相機及其相關屬性
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            return
        }

        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            print(error)
            return
        }

        // 判斷是否可以將 videoInput 加入到 captureSession
        guard captureSession.canAddInput(videoInput) else {
            return
        }
        captureSession.addInput(videoInput)

        let metaDataOutput = AVCaptureMetadataOutput() // 實例化一個 AVCaptureMetadataOutput 物件

        // 透過 AVCaptureMetadataOutput 輸出資料
        // 判斷是否可以將 metaDataOutput 輸出到 captureSession
        guard captureSession.canAddOutput(metaDataOutput) else {
            return
        }
        captureSession.addOutput(metaDataOutput)

        // 設定代理 在主執行緒裡重新整理
        metaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main) // 執行處理 QRCode
        metaDataOutput.metadataObjectTypes = [.qr] // 設定可以處理哪些類型的條碼

        scanQRCodeRectOfInterest()
        // 限制可掃描範圍
        // 擴大掃描區域至原有區域的1.5倍
        let expansionFactor: CGFloat = 1.5

        // 計算新的範圍
        let newMinX = max(scanQRcodePath.bounds.minX - (scanQRcodePath.bounds.width * (expansionFactor - 1) / 2), 0)
        let newMinY = max(scanQRcodePath.bounds.minY - (scanQRcodePath.bounds.height * (expansionFactor - 1) / 2), 0)
        let newWidth = min(scanQRcodePath.bounds.width * expansionFactor,
                           superViewBounds.width - newMinX)
        let newHeight = min(scanQRcodePath.bounds.height * expansionFactor,
                            superViewBounds.height - newMinY)

        // 設置新的 rectOfInterest
        metaDataOutput.rectOfInterest = CGRect(x: newMinY / superViewBounds.height,
                                               y: newMinX / superViewBounds.width,
                                               width: newHeight / superViewBounds.height,
                                               height: newWidth / superViewBounds.width)

        // 用 AVCaptureVideoPreviewLayer 來呈現 AVCaptureSession 的資料
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.frame = vScanRect.bounds
        vScanRect.layer.addSublayer(videoPreviewLayer)
        DispatchQueue.global().async {
            self.captureSession.startRunning()
        }
    }
    
    func popViewController(_ animated: Bool = true) {
            self.navigationController?.popViewController(animated: animated)
        }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate

extension ScanQRCodeViewController: AVCaptureMetadataOutputObjectsDelegate {
    // 使用 AVCaptureMetadataOutput 物件辨識 QRCode
    // AVCaptureMetadataOutputObjectsDelegate 裡的委派方法 metadataOutout 會被呼叫
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            // AVMetadataMachineReadableCodeObject 是從 Output 擷取到 Barcode 的內容
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }

            // 判斷 metadataObj 的類型是否為 QR Code
            if readableObject.type == AVMetadataObject.ObjectType.qr {
                guard let stringValue = readableObject.stringValue else {
                    return
                } // 將讀取到的內容轉成字串
                #if DEBUG
                    print("QrCode Encode Message: \(stringValue)")
                #endif
                captureSession.stopRunning() // 停止擷取畫面

                DispatchQueue.main.async {
//                    let nextVC = ConfirmBindingCardViewController()
//                    nextVC.fromStep1 = true
//                    nextVC.qrcodeMessage = stringValue
//                    self.pushViewController(nextVC, animated: true)
                }
            }
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    let vc = UIStoryboard(name: "GroupTask", bundle: nil)
    return vc.instantiateViewController(withIdentifier: "ScanQRCodeViewController")
}
