//
//  Created by kingcos on 01/04/2018.
//  Copyright © 2018 kingcos. All rights reserved.
//

import UIKit
import Photos

class Helper {
    class func saveToAlumn(_ image: UIImage?) {
        guard let image = image else { fatalError() }
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }) { isSuccessful, error in
            if let error = error as NSError? {
                print(error.description)
            }
        }
    }
}

extension UIImage {
    func crop(_ rect: CGRect?) -> UIImage {
        guard var rect = rect else { fatalError() }

        rect.origin.x *= scale
        rect.origin.y *= scale
        rect.size.width *= scale
        rect.size.height *= scale

        guard let cgImage = cgImage?.cropping(to: rect) else {
            fatalError("Crop failed")
        }

        let croppedImage = UIImage(cgImage: cgImage,
                                   scale: scale,
                                   orientation: imageOrientation)
        return croppedImage
    }
}

extension CGPoint {
    func scaled(to size: CGSize) -> CGPoint {
        return CGPoint(x: x * size.width,
                       y: y * size.height)
    }
}
