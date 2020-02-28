//
//  ViewController.swift
//  SwiftCarInfoOCR
//
//  Created by Ethan Chiang on 2/13/20.
//  Copyright © 2020 EYC. All rights reserved.
//

import UIKit
import AVFoundation
import Vision

class ViewController: UIViewController, FrameExtractorDelegate,
AVCaptureVideoDataOutputSampleBufferDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var startSceenBtn: UIButton!
    @IBOutlet weak var plateText: UILabel!
    
    var frameExtractor: FrameExtractor!
    var votingManager = VotingManager()
    
    var extractCount = 0
    var startCapture = false
    private let OCRQueue = DispatchQueue(label: "OCR Queue")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.frameExtractor = FrameExtractor()
        self.frameExtractor.delegate = self
    }
    
    @IBAction func startSceenClick(_ sender: Any) {
        print("start capture section")
        self.startCapture = true
    }
    
    func callOCR(image: UIImage) {
        
        print("call OCR")
        
        let requestHandler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
        let request = VNRecognizeTextRequest { (request, error) in
        guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
        for currentObservation in observations {
            let topCandidate = currentObservation.topCandidates(5)
                if let recognizedText = topCandidate.first {
                    // Add to voting algorithm
                    //self.votingManager.add(licensePlate: recognizedText.string)
                    // Print top 5
                    
                    for candidate in topCandidate {
                        print(candidate.string, ":", candidate.confidence.description)
                    }
                    
                    
                    self.plateText.text = recognizedText.string
                    self.frameExtractor.start()
                }
            }
        }
        
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        try? requestHandler.perform([request])
    }
    
    
    func captured(image: UIImage) {
        self.imageView.image = image
        //print("extract")
        
        if (self.startCapture) {
            // Call OCR
            //self.OCRQueue.async {
                self.frameExtractor.stop()
                self.startCapture = false
                self.callOCR(image: image)
                //self.plateText.text = self.votingManager.chooseMostLikelyLicensePlate()
            //}
            
//            self.extractCount += 1
//            if (self.extractCount == 10) {
//                self.frameExtractor.stop()
//                self.extractCount = 0
//
//                // Get voting result
//                let mostLikely = self.votingManager.chooseMostLikelyLicensePlate()
//
//                self.plateText.text = mostLikely
//            }
        }
    }
}

