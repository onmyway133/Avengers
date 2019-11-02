//
//  Detector.swift
//  Avengers
//
//  Created by khoa on 02/11/2019.
//  Copyright © 2019 Khoa Pham. All rights reserved.
//

import CoreML
import Vision
import UIKit

class Detector {
    func detect(image: UIImage, completion: @escaping (Result<String, Error>) -> Void) throws {
        let model = try VNCoreMLModel(for: IBMWatson().model)

        let request = VNCoreMLRequest(model: model, completionHandler: { request, error in
            guard
                let results = request.results as? [VNClassificationObservation],
                let topResult = results.first
            else {
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }

                return
            }

            DispatchQueue.main.async {
                let string = topResult.identifier + " (confidence \(topResult.confidence * 100)%)"
                completion(.success(string))
            }
        })

        let handler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try handler.perform([request])
            } catch {
                print(error)
            }
        }
    }
}
