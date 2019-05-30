//
//  ViewController.swift
//  style
//
//  Created by yuchenxi on 2019/5/7.
//  Copyright © 2019 yuchenxi2000. All rights reserved.
//
//  Published under MIT License.
//

/*
 Abstract:
 View controller for selecting images and applying Vision + Core ML processing.
 
 https://developer.apple.com/documentation/vision/classifying_images_with_vision_and_core_ml
 
 LICENSE: APACHE Version 2.0, January 2004 http://www.apache.org/licenses/
 
 modified by yuchenxi.
 */

import UIKit
import CoreML
import Vision
import ImageIO

class ViewController: UIViewController {
    
    var selectedStyle : Int = 1
    
    var originalImage : UIImage?
    var images = Dictionary<Int, CIImage>()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBAction func SaveImage(_ sender: UIBarButtonItem) {
        if imageView.image != nil {
            UIImageWriteToSavedPhotosAlbum(imageView.image!, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    @objc func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer) {
        if (error as NSError?) != nil {
            messageLabel.text = "failed."
        } else {
            messageLabel.text = "saved."
        }
    }
    
    func SaveImageFailed() {
        
    }
    
    func getStyleDescription(_ style : Int) -> String {
        switch style {
        case 0:
            return "origin"
        case 1:
            return "candy"
        case 2:
            return "mosaic"
        case 3:
            return "rain"
        case 4:
            return "udnie"
        default:
            return "unknown"
        }
    }
    
    func loadModel(_ style : Int) -> MLModel {
        switch style {
        case 1:
            return candy5().model
        case 2:
            return mosaic().model
        case 3:
            return rain().model
        case 4:
            return udnie().model
        default:
            return candy5().model
        }
    }
    
    func genRequest(_ style : Int) -> VNCoreMLRequest {
        do {
            let model = loadModel(style)
            let vnmodel = try VNCoreMLModel(for: model)
            let request = VNCoreMLRequest(model: vnmodel, completionHandler: { [weak self] request, error in
                self?.processImages(for: request, error: error, style: style)
            })
            request.imageCropAndScaleOption = .scaleFill
            return request
        } catch {
            fatalError()
        }
        
    }
    
    func loadCIImage(_ ciimage : CIImage, _ style : Int) {
        let context = CIContext(options: [CIContextOption.useSoftwareRenderer: false])
        var img = ciimage
        if self.Orientation != nil, style == 0 {
            img = ciimage.oriented(self.Orientation!)
        }
        
        let uiimage = UIImage(cgImage: context.createCGImage(img, from: img.extent)!)
        
        DispatchQueue.main.async {
            self.imageView.image = uiimage
            
            self.messageLabel.text = "done. [\(self.getStyleDescription(style))]"
        }
    }
    
    var Size : CGSize?
    var Orientation : CGImagePropertyOrientation?
    
    /// - Tag: PerformRequests
    func updateViewImage(for ciimage: CIImage?, withStyle style : Int) {
        
        if let bufferimage = images[style] {
            loadCIImage(bufferimage, style)
            return
        }
        
        if style == 0 {
            return
        }
        
        var image = ciimage
        
        if image == nil {
            image = images[0]
            if image == nil {
                return
            }
        }
        DispatchQueue.main.async {
            self.messageLabel.text = "generating..."
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: image!, orientation: self.Orientation ?? CGImagePropertyOrientation.up)
            do {
                try handler.perform([self.genRequest(style)])
            } catch {
                self.DisplayError("Failed to generate image.\npreform neural transfer failed")
            }
        }
    }
    
    /// - Tag: ProcessImages
    func processImages(for request: VNRequest, error: Error?, style: Int) {
        guard let results = request.results else {
            self.DisplayError("Unable to generate image.\nresult is nil")
            return
        }
        
        let classifications = results as! [VNPixelBufferObservation]
        
        if classifications.isEmpty {
            self.DisplayError("Failed to generate image.\nnn returns nil")
        } else {
            
            var ciimage = CIImage(cvPixelBuffer: classifications[0].pixelBuffer)
            
            // resize
            if self.Size != nil {
                let ratio = (Double)(self.Size!.width) * (Double)(756) / (Double)(self.Size!.height) / (Double)(1008)
                
                let filter = CIFilter(name: "CILanczosScaleTransform")!
                filter.setValue(ciimage, forKey: kCIInputImageKey)
                filter.setValue(NSNumber(value:ratio), forKey:kCIInputAspectRatioKey)
                ciimage = filter.value(forKey: kCIOutputImageKey) as! UIKit.CIImage
                
            }
            self.images[self.selectedStyle] = ciimage

            loadCIImage(ciimage, style)
            
        }
    }
    
    @IBOutlet weak var photoButton: UIBarButtonItem!
    // MARK: - Photo Actions
    @IBAction func takePicture() {
        // Show options for the source picker only if the camera is available.
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            presentPhotoPicker(sourceType: .photoLibrary)
            return
        }
        
        let photoSourcePicker = UIAlertController()
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { [unowned self] _ in
            self.presentPhotoPicker(sourceType: .camera)
        }
        let choosePhoto = UIAlertAction(title: "Choose Photo", style: .default) { [unowned self] _ in
            self.presentPhotoPicker(sourceType: .photoLibrary)
        }
        
        photoSourcePicker.popoverPresentationController?.barButtonItem = photoButton
        photoSourcePicker.addAction(takePhoto)
        photoSourcePicker.addAction(choosePhoto)
        photoSourcePicker.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(photoSourcePicker, animated: true)
    }
    
    func presentPhotoPicker(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        picker.view.layoutIfNeeded()
        present(picker, animated: true)
    }
    
    func DisplayError(_ message : String) {
        DispatchQueue.main.async {[weak self] in
            self?.messageLabel.text = message
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "select" {
            let controller = segue.destination as? SelectViewController
            controller?.selectedStyle = self.selectedStyle
        }
    }
    
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - Handling Image Picker Selection
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        picker.dismiss(animated: true)
        
        images.removeAll()
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let ciimage = CIImage(image: image)
        if ciimage != nil {
            images[0] = ciimage
        }else{
            print("can't get ciimage from uiimage")
        }
        
        imageView.image = image
        self.Size = image.size
        self.Orientation = CGImagePropertyOrientation(image.imageOrientation)
        
        if selectedStyle != 0 {
            updateViewImage(for: ciimage, withStyle: self.selectedStyle)
        }
    }
}

extension UIImage {
    func resizeCI(size:CGSize) -> UIImage? {
        let ratio = (Double)(size.width) * (Double)(self.size.height) / (Double)(size.height) / (Double)(self.size.width)
        let image = self.ciImage
        
        let filter = CIFilter(name: "CILanczosScaleTransform")!
        filter.setValue(image, forKey: kCIInputImageKey)
        filter.setValue(NSNumber(value:ratio), forKey:kCIInputAspectRatioKey)
        let outputImage = filter.value(forKey: kCIOutputImageKey) as! UIKit.CIImage
        
        
        
        let context = CIContext(options: [CIContextOption.useSoftwareRenderer: false])
        let resizedImage = UIImage(cgImage: context.createCGImage(outputImage, from: outputImage.extent)!)
        return resizedImage
    }
    
}

func resizedImage(from image: UIImage?, for size: CGSize) -> UIImage? {
    let renderer = UIGraphicsImageRenderer(size: size)
    return renderer.image { (context) in
        image?.draw(in: CGRect(origin: .zero, size: size))
    }
}
