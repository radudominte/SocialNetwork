//
//  CircleView.swift
//  SocialNetwork
//
//  Created by Radu Dominte on 05/02/17.
//  Copyright © 2017 Radu Dominte. All rights reserved.
//

import UIKit

class CircleView: UIImageView {

    
    
    override func layoutSubviews() {
        
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
    }
    
        
    

}
