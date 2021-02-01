//
//  VerticalLabel.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/03.
//

import UIKit

class VerticalLabel: UIView {
    private var _text: String = ""
    private var _fontSize: CGFloat = 16
    
    private let textColor = UIColor(named: .fudaText)
    private let font = UIFont(name: .hannari, size: 16)
    
    var text: String {
        set (v){
            _text = v
            setNeedsDisplay()
        }
        get { _text }
    }

    var fontSize: CGFloat {
        set (v){
            _fontSize = v
            setNeedsDisplay()
        }
        get { _fontSize }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        _text.enumerated().forEach { c in
            String(c.element).draw(at: CGPoint(x: 0, y: Int(_fontSize) * c.offset), withAttributes: [
                NSAttributedString.Key.foregroundColor : textColor!,
                NSAttributedString.Key.font : font!.withSize(_fontSize),
            ])
        }
    }
}
