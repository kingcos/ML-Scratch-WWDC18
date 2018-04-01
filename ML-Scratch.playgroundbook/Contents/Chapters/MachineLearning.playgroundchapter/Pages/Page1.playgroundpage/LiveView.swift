//
//  Created by kingcos on 29/03/2018.
//  Copyright © 2018 kingcos. All rights reserved.
//

import UIKit
import PlaygroundSupport

let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
let controller = storyboard.instantiateViewController(withIdentifier: "view")

PlaygroundPage.current.liveView = controller
