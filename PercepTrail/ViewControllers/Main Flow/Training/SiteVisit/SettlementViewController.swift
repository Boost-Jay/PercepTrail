//
//  SettlementViewController.swift
//  PercepTrail
//
//  Created by imac-2627 on 2024/6/27.
//

import UIKit

class SettlementViewController: UIViewController {
    // MARK: - Properties

    private var selectedApiVersion: ClientAPI.ApiVersion = .v1
    private var randomVC: String = ""

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        determineNextStep()
    }

    // MARK: - Function

    private func determineNextStep() {
        let selectedViewControllerType = Bool.random() ? "PairingViewController" : "IdentificationViewController"
        randomVC = selectedViewControllerType
        
        
        if selectedViewControllerType == "PairingViewController" {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
//                self.navigateToTakePhoneVC()
//            }
            Task {
                await fetchAPIAndProceed()
            }
        } else {
            Task {
                await fetchAPIAndProceed()
            }
        }
    }
    
    private func fetchAPIAndProceed() async {
        let imagesBase64 = fetchAndProcessImages()
        let images = imagesBase64.compactMap { Data(base64Encoded: $0) }.compactMap { UIImage(data: $0) }
        if images.count == 4 {
            do {
                let response = try await callAPIToChatGPTV4(question: "請從這4張照片中給我一個隨機題目，並把有相同特徵的圖片 依次把符合題目的選項用陣列表示，在範圍內的為1，不是則為0。 如下面輸出範例(跟上圖無關)： Q:何者有藥物出現？; A:{0,0,0,1};", imagesBase64: imagesBase64)
                    
                if let firstChoice = response.choices.first {
                    let content = firstChoice.message.content
                    let (question, answerText) = extractQuestionAndAnswer(from: content)
                    
                    let answerArray = parseAnswerToIntArray(answer: answerText)
                    navigateToTakePhoneVC(with: images, question: question, answer: answerArray)
                    
                
                    
                } else {
                    print("No content found in response")
                }
            } catch {
                print("API Request Failed: \(error)")
            }
        } else {
            print("Not enough images fetched for API call")
        }
    }

    private func extractQuestionAndAnswer(from text: String) -> (question: String, answer: String) {
        let questionPrefix = "Q:"
        let answerPrefix = "A:"
        let delimiter = ";"

        let questionStart = text.range(of: questionPrefix)?.upperBound ?? text.startIndex
        let questionEnd = text[questionStart...].range(of: delimiter)?.lowerBound ?? text.endIndex
        let question = String(text[questionStart..<questionEnd]).trimmingCharacters(in: .whitespacesAndNewlines)

        let answerStart = text.range(of: answerPrefix)?.upperBound ?? text.startIndex
        let answerEnd = text[answerStart...].range(of: delimiter)?.lowerBound ?? text.endIndex
        let answer = String(text[answerStart..<answerEnd]).trimmingCharacters(in: .whitespacesAndNewlines)

        return (question, answer)
    }
    
    func parseAnswerToIntArray(answer: String) -> [Int] {
        let trimmed = answer.trimmingCharacters(in: CharacterSet(charactersIn: "{} "))
        let numbers = trimmed.split(separator: ",").compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
        return numbers
    }


    
    func fetchAndProcessImages() -> [String] {
        let randomPhotos = LocalDatabase.shared.fetchRandomPhotos(limit: 4)
        return randomPhotos.compactMap { photo -> String? in
            if let img = UIImage(contentsOfFile: photo.path) {
                return convertImageToBase64String(img: img)
            }
            return nil
        }
    }
    
    func navigateToTakePhoneVC() {
            let storyboard = UIStoryboard(name: "TakePhone", bundle: nil)
            if let takePhotoVC = storyboard.instantiateViewController(withIdentifier: "TakePhoneViewController") as? TakePhoneViewController {
                takePhotoVC.fromSettlement = true
                takePhotoVC.selectedVC = randomVC
                present(takePhotoVC, animated: true, completion: nil)
            }
        }
    
    private func navigateToTakePhoneVC(with photos: [UIImage], question: String, answer: [Int]) {
        let storyboard = UIStoryboard(name: "TakePhone", bundle: nil)
        if let takePhotoVC = storyboard.instantiateViewController(withIdentifier: "TakePhoneViewController") as? TakePhoneViewController {
            takePhotoVC.fromSettlement = true
            takePhotoVC.selectedVC = randomVC
            takePhotoVC.photos = photos
            takePhotoVC.questionText = question
            takePhotoVC.answerArray = answer
            present(takePhotoVC, animated: true, completion: nil)
        }
    }


    private func convertImageToBase64String(img: UIImage) -> String {
        return img.jpegData(compressionQuality: 0.8)?.base64EncodedString() ?? ""
    }

    // MARK: - Call API ChatGPT-4o

    /// - Parameters:
    ///   - question: 提供給 ChatGPT 的問題描述
    ///   - imageBase64Str: 圖片的 Base64 編碼字符串
    /// - Returns: 從 ChatGPT 收到的回答及相關資訊
    func callAPIToChatGPTV4(question: String, imagesBase64: [String]) async throws -> ChatGPT4VisionResponse {
        let contentText = Content(type: "text", text: question)
        var totalContent = [contentText]

        // 添加每張圖片
        for imageBase64 in imagesBase64 {
            let imageUrl = ImageUrl(url: "data:image/jpeg;base64,\(imageBase64)", detail: "low")
            let contentImage = Content(type: "image_url", image_url: imageUrl)
            totalContent.append(contentImage)
        }

        let message = RequestMessages(role: "user", content: totalContent)
        let request = ChatGPT4VisionRequest(model: "gpt-4o",
                                            messages: [message],
                                            maxTokens: 2000)

        return try await NetworkManager.shared.requestDataAsync(method: .post,
                                                                path: .chatGPT4V(selectedApiVersion),
                                                                parameters: request,
                                                                needToken: true)
    }
}

@available(iOS 17.0, *)
#Preview {
    let vc = UIStoryboard(name: "SiteVisit", bundle: nil)
    return vc.instantiateViewController(withIdentifier: "SettlementViewController")
}
