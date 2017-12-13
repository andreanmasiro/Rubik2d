import Foundation
import UIKit.UIColor

public enum Face: Int {
    
    case front = 0
    case right = 1
    case top = 2
    case back = 3
    case left = 4
    case bottom = 5
    
    public static var random: Face {
        let randomRawValue = Int(arc4random_uniform(6))
        return Face(rawValue: randomRawValue)!
    }
    
    public static let all: [Face] = [.front, .right, .top, .back, .left, .bottom]
    
    public static func contained(in position: CornerPiece.Position) -> [Face] {
        
        var faces = [Face]()
        
        switch position {
        case .topRightFront, .topLeftFront, .topLeftBack, .topRightBack: faces.append(.top)
        case .bottomRightFront, .bottomLeftFront, .bottomLeftBack, .bottomRightBack: faces.append(.bottom)
        }
        
        switch position {
        case .topRightFront, .bottomRightBack: faces.append(.right)
        case .topLeftBack, .bottomLeftFront: faces.append(.left)
        case .bottomRightFront, .topLeftFront: faces.append(.front)
        case .topRightBack, .bottomLeftBack: faces.append(.back)
        }
        
        switch position {
        case .topRightFront, .bottomLeftFront: faces.append(.front)
        case .topLeftBack, .bottomRightBack: faces.append(.back)
        case .topLeftFront, .bottomLeftBack: faces.append(.left)
        case .topRightBack, .bottomRightFront: faces.append(.right)
        }
        
        return faces
    }
    
    public static func contained(in position: EdgePiece.Position) -> [Face] {
        
        var faces = [Face]()
        switch position {
        case .topRight, .topFront, .topLeft, .topBack: faces.append(.top)
        case .bottomRight, .bottomFront, .bottomLeft, .bottomBack: faces.append(.bottom)
        case .middleRightFront, .middleRightBack: faces.append(.right)
        case .middleLeftFront, .middleLeftBack: faces.append(.left)
        }
        
        switch position {
        case .topRight, .bottomRight: faces.append(.right)
        case .topLeft, .bottomLeft: faces.append(.left)
        case .topFront, .bottomFront, .middleRightFront, .middleLeftFront: faces.append(.front)
        case .topBack, .bottomBack, .middleRightBack, .middleLeftBack: faces.append(.back)
        }
        
        return faces
    }
    
    public var top: Face {
        
        let top: Face
        switch self {
        case .front, .left, .right, .back: top = .top
        case .top: top = .back
        case .bottom: top = .front
        }
        
        return top
    }
    
    public var left: Face {
        
        let left: Face
        switch self {
        case .front, .top, .bottom: left = .left
        case .back: left = .right
        case .right: left = .front
        case .left: left = .back
        }
        
        return left
    }
    
    public var right: Face {
        
        let right: Face
        switch self {
        case .front, .top, .bottom: right = .right
        case .back: right = .left
        case .right: right = .back
        case .left: right = .front
        }
        
        return right
    }
    
    public var bottom: Face {
        
        let bottom: Face
        switch self {
        case .front, .left, .back, .right: bottom = .bottom
        case .top: bottom = .front
        case .bottom: bottom = .back
        }
        
        return bottom
    }
    
    public var opposite: Face {
        
        return rawValue < 3 ? Face(rawValue: rawValue + 3)! : Face(rawValue: rawValue - 3)!
    }
    
    public var adjacentFaces: [Face] {
        return [self.top, self.left, self.bottom, self.right]
    }
}

extension Face: CustomStringConvertible {
    
    public var description: String {
        
        let description: String
        
        switch self {
        case .front: description = "F"
        case .right: description = "R"
        case .top: description = "U"
        case .back: description = "B"
        case .left: description = "L"
        case .bottom: description = "D"
        }
        
        return description
    }
}
