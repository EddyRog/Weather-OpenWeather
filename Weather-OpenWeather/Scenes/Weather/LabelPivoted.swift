//
//  LabelPivoted.swift
//  LabelPivoted
//
//  Created by Eddy R on 13/10/2020.
//  Copyright © 2020 Eddy R. All rights reserved.
//

import UIKit
@IBDesignable
class LabelPivoted: UIView {
    var label: UILabel = UILabel()
    
    @IBInspectable
    var colorbgContainer:UIColor = .clear {
        didSet {
            self.backgroundColor = colorbg
        }
    }
    
    @IBInspectable
    var colorbg:UIColor = .clear {
        didSet {
            label.backgroundColor = colorbg
        }
    }
    
    @IBInspectable
    var colorTxt: UIColor = .white {
        didSet{
            label.textColor = colorTxt
        }
    }
    
    @IBInspectable
    var fontSize: CGFloat = 200 {
        didSet {
            label.font = label.font.withSize(fontSize)
        }
    }
    
    
    enum enumStyle {
        case upper
        case lower
        case Capit
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initSubView()
        
    }
    override func prepareForInterfaceBuilder() {
        initSubView()
    }
    
    func initSubView(){
        // default View
        self.backgroundColor = colorbgContainer
        // LabelView
        label = UILabel()
        
        label.frame.origin = CGPoint(x: 0, y: 0)
        label.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        label.font = label.font.withSize(fontSize)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.2
        label.textAlignment = .left
        label.lineBreakMode = .byClipping
        
        label.backgroundColor = colorbg // default implementation need to get default value in the IB
        label.textColor = colorTxt
        
        label.text = "_"
        
        
        addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 0 + 2, y: 0 + 2, width: bounds.width - 4, height: bounds.height - 4)
        
    }
    
    override func draw(_ rect: CGRect) {
        
    }
}


