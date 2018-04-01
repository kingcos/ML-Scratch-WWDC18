//
//  Created by kingcos on 29/03/2018.
//  Copyright © 2018 kingcos. All rights reserved.
//

import UIKit
import ARKit
import Vision
import CoreML
import SceneKit

@objc(ARViewController)
public class ARViewController: UIViewController {

    @IBOutlet weak var arSceneView: ARSCNView!
    @IBOutlet weak var resultLabel: UILabel!
    
    var prediction: String?
    var visionRequests = [VNRequest]()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLogics()
        
        arSceneView.layer.borderColor = UIColor.black.cgColor
        arSceneView.layer.borderWidth = 1.0
        arSceneView.layer.cornerRadius = 10.0
        arSceneView.clipsToBounds = true
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = .horizontal
        arSceneView.session.run(config, options: [])
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        arSceneView.session.pause()
    }

    func setupLogics() {
        // ARScene
        arSceneView.scene = SCNScene()
        
        // CoreML
        guard let model = try? VNCoreMLModel(for: test1().model) else {
                fatalError()
        }
        
        let request = VNCoreMLRequest(model: model, completionHandler: requestCompletionHandler)
        request.imageCropAndScaleOption = .centerCrop
        
        visionRequests = [request]
        startLoopRequest()
    }
}

// Action
extension ARViewController {
    @IBAction func add(_ sender: UIButton) {
        print(#function)
        let point = CGPoint(x: arSceneView.bounds.midX, y: arSceneView.bounds.midY)
        let hitTestResults = arSceneView.hitTest(point,
                                                 types: .featurePoint)
        if let result = hitTestResults.first {
            let column = result.worldTransform.columns.3
            let position = SCNVector3(column.x,
                                      column.y,
                                      column.z)
            
            let textNode = addTextNode(prediction ?? "0", at: position)
            arSceneView.scene.rootNode.addChildNode(textNode)
        }
    }
}

extension ARViewController {
    func addTextNode(_ text: String, at position: SCNVector3) -> SCNNode {
        let text = SCNText(string: text, extrusionDepth: 0.01)
        text.font = UIFont.systemFont(ofSize: 1)
        text.alignmentMode = kCAAlignmentCenter
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        text.materials = [material]
        
        let node = SCNNode()
        node.position = position
        node.scale = SCNVector3(0.01, 0.01, 0.01)
        node.geometry = text
        
        return node
    }
    
    func requestCompletionHandler(request: VNRequest, error: Error?) {
        guard var results = request.results as? [VNClassificationObservation] else {
            fatalError()
        }
        
        while results.count > 3 {
            results.removeLast()
        }
        
        let result = results.map {
            "\($0.confidence * 100)% - \($0.identifier)"
            }.reduce("") {
                "\($0)\n\($1)"
        }
        
        DispatchQueue.main.async {
            self.resultLabel.text = result
            self.prediction = results.first?.identifier
        }
    }
    
    func startLoopRequest() {
        DispatchQueue(label: "com.maimieng.wwdc18").async {
            self.updateCoreML()
            self.startLoopRequest()
        }
    }
    
    func updateCoreML() {
        guard let capturedImage = arSceneView.session.currentFrame?.capturedImage else { return }
        let ciImage = CIImage(cvPixelBuffer: capturedImage)
        let imageRequestHandler = VNImageRequestHandler(ciImage: ciImage)
        do {
            try imageRequestHandler.perform(visionRequests)
        } catch {
            print(error)
        }
    }
}
