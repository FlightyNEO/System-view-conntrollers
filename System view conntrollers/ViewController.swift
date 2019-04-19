//
//  ViewController.swift
//  System view conntrollers
//
//  Created by Arkadiy Grigoryanc on 19/04/2019.
//  Copyright © 2019 Arkadiy Grigoryanc. All rights reserved.
//

// UIActivityViewController
// https://www.hackingwithswift.com/articles/118/uiactivityviewcontroller-by-example

import UIKit
import SafariServices
import MessageUI
//import Social

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

// MARK: - Actions
extension ViewController {
    
    @IBAction func actionShare(_ sender: Any) {
        
        let customItem = GitActivity(title: "Open Git", image: #imageLiteral(resourceName: "gitIcon")) { sharedItems in
            guard let sharedStrings = sharedItems as? [String] else { return }
            sharedStrings.forEach { print($0) }

        }

        let activityController = UIActivityViewController(activityItems: [self],
                                                          applicationActivities: [customItem])
        
        let excludedActivityTypes = [UIActivity.ActivityType.postToWeibo,
                                     UIActivity.ActivityType.postToTencentWeibo,
                                     UIActivity.ActivityType.postToFlickr,
                                     UIActivity.ActivityType.postToVimeo,
                                     UIActivity.ActivityType.message,
                                     UIActivity.ActivityType.mail,
                                     UIActivity.ActivityType.copyToPasteboard,
                                     UIActivity.ActivityType.print,
                                     UIActivity.ActivityType.assignToContact,
                                     UIActivity.ActivityType.saveToCameraRoll,
                                     UIActivity.ActivityType.addToReadingList,
                                     UIActivity.ActivityType.openInIBooks]
        activityController.excludedActivityTypes = excludedActivityTypes
        
        present(activityController, animated: true)
        
    }
    
    @IBAction func actionShowInSafari(_ sender: Any) {
        
        let url = URL(string: "https://github.com/FlightyNEO")
        let safariViewController = SFSafariViewController(url: url!)
        safariViewController.delegate = self
        
        present(safariViewController, animated: true)
        
    }
    
    @IBAction func actionChooseImage(_ sender: Any) {
        
        let alertController = UIAlertController(title: nil, message: "Choose source", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
                
                let imagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .camera
                imagePickerController.delegate = self
                
                self.present(imagePickerController, animated: true)
            }
            
            alertController.addAction(cameraAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            let photoLibraryAction = UIAlertAction(title: "Photo library", style: .default) { _ in
                
                let imagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .photoLibrary
                imagePickerController.delegate = self
                
                self.present(imagePickerController, animated: true)
            }
            
            alertController.addAction(photoLibraryAction)
        }
        
        present(alertController, animated: true)
        
    }
    
    @IBAction func actionSendMail(_ sender: Any) {
        
        guard MFMailComposeViewController.canSendMail() else {
            let alertController = UIAlertController(title: "Error", message: "Unable to send eMail", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel)
            alertController.addAction(okAction)
            present(alertController, animated: true)
            return
        }
        
        let eMailComposer = MFMailComposeViewController()
        eMailComposer.mailComposeDelegate = self
        eMailComposer.setSubject("My Photo")
        eMailComposer.setMessageBody("https://github.com/FlightyNEO", isHTML: false)
        
        if let imageData = imageView.image?.jpegData(compressionQuality: 1.0) {
            eMailComposer.addAttachmentData(imageData, mimeType: "image/jpeg", fileName: "image.jpeg")
        }
        
        present(eMailComposer, animated: true)
    }
    
    @IBAction func actionSendMessage(_ sender: Any) {
        
        guard MFMessageComposeViewController.canSendAttachments() else {
            let alertController = UIAlertController(title: "Error", message: "Unable to send attachment message", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel)
            alertController.addAction(okAction)
            present(alertController, animated: true)
            return
        }
        
        let messageComposer = MFMessageComposeViewController()
        messageComposer.messageComposeDelegate = self
        messageComposer.body = "https://github.com/FlightyNEO"
        if let imageData = imageView.image?.jpegData(compressionQuality: 1.0) {
            messageComposer.addAttachmentData(imageData, typeIdentifier: "image/jpeg", filename: "image.jpeg")
        }
        
        present(messageComposer, animated: true)
    }
    
}

extension ViewController: UIActivityItemSource {
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return imageView.image as Any
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        
        switch activityType {
        case .some(.postToTwitter), .some(.postToFacebook):
            return "Hello, it's me."
        case .some(.airDrop):
            return imageView.image?.jpegData(compressionQuality: 1)
        case .some(.init("gitActibity")):
            guard let url = URL(string: "https://github.com/FlightyNEO") else { return nil }
            return UIApplication.shared.open(url, options: [:])
        default:
            return imageView.image//?.jpegData(compressionQuality: 1)
        }
        
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        return "My Photo"
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, thumbnailImageForActivityType activityType: UIActivity.ActivityType?, suggestedSize size: CGSize) -> UIImage? {
        return imageView.image
    }
    
}

extension ViewController: SFSafariViewControllerDelegate {
    
}

extension ViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            dismiss(animated: true) {
                self.imageView.image = image
            }
        }
        
    }
    
    func UIImageWriteToSavedPhotosAlbum(_ image: UIImage, _ completionTarget: Any?, _ completionSelector: Selector?, _ contextInfo: UnsafeMutableRawPointer?) {
        
    }
    
}

extension ViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
}

extension ViewController: MFMessageComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true)
    }
    
}
