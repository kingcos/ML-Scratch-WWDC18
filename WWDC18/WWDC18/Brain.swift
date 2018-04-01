//
//  Created by kingcos on 29/03/2018.
//  Copyright © 2018 kingcos. All rights reserved.
//

import UIKit
import Vision
import CoreML

@objc(Brain)
public class Brain: NSObject {
    class func detect(_ image: CIImage?, _ completion: @escaping (String) -> Void) {
        var result = "\nLoading\n"
        guard let image = image,
            let model = try? VNCoreMLModel(for: test1().model) else {
            fatalError()
        }
        
        let request = VNCoreMLRequest(model: model) { request, error in
            guard var results = request.results as? [VNClassificationObservation] else {
                fatalError()
            }
            
            while results.count > 3 {
                results.removeLast()
            }
            
            result = results.map {
                "\($0.confidence * 100)% - \($0.identifier)"
                }.reduce("") {
                    "\($0)\n\($1)"
            }
            
            completion(result)
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try handler.perform([request])
            } catch {
                print(error)
            }
        }
        
        completion(result)
    }
    
}
