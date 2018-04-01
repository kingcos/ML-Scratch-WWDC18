//
//  Created by kingcos on 29/03/2018.
//  Copyright © 2018 kingcos. All rights reserved.
//

import UIKit

@objc(ViewController)
public class ViewController: UIViewController {

    @IBOutlet weak var canvasView: CanvasView!
    @IBOutlet weak var resultLabel: UILabel!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        canvasView.delegate = self
        canvasView.setup()
    }
    
    @IBAction func chooseColor(_ sender: UIButton) {
        switch sender.tag {
        case 1001:
            canvasView.lineColor = .black
        case 1002:
            canvasView.lineColor = .blue
        case 1003:
            canvasView.lineColor = .green
        case 1004:
            canvasView.lineColor = .yellow
        case 1005:
            canvasView.lineColor = .red
        default:
            fatalError()
        }
    }
    
    @IBAction func clearCanvas(_ sender: UIButton) {
        canvasView.clear()
        resultLabel.text = "\nResult\n"
    }
}
