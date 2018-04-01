//
//  Created by kingcos on 29/03/2018.
//  Copyright © 2018 kingcos. All rights reserved.
//

import UIKit

@objc(BackgroundView)
public class BackgroundView: UIView {

    public override func awakeFromNib() {
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 10.0
        clipsToBounds = true
    }

}
