import UIKit

extension Face {
    
    var color: UIColor {
        
        let color: UIColor
        switch self {
        case .front: color = .cubeFront
        case .right: color = .cubeRight
        case .top: color = .cubeTop
        case .back: color = .cubeBack
        case .left: color = .cubeLeft
        case .bottom: color = .cubeBottom
        }
        
        return color
    }
}
