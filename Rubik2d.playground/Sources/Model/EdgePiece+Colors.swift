import UIKit

extension EdgePiece {
    
    public var colors: [UIColor] {
        return (self.faces.map { $0.color }).rotating(by: -self.orientation.rawValue)
    }
}

extension EdgePiece.Position { // face node sticker index orders
    
    public static let frontEdgeOrder: [EdgePiece.Position] = [.topFront, .middleLeftFront, .middleRightFront, .bottomFront]
    public static let rightEdgeOrder: [EdgePiece.Position] = [.topRight, .middleRightFront, .middleRightBack, .bottomRight]
    public static let topEdgeOrder: [EdgePiece.Position] = [.topBack, .topLeft, .topRight, .topFront]
    public static let backEdgeOrder: [EdgePiece.Position] = [.topBack, .middleRightBack, .middleLeftBack, .bottomBack]
    public static let leftEdgeOrder: [EdgePiece.Position] = [.topLeft, .middleLeftBack, .middleLeftFront, .bottomLeft]
    public static let bottomEdgeOrder: [EdgePiece.Position] = [.bottomFront, .bottomLeft, .bottomRight, .bottomBack]
    
    public static func stickerOrder(in face: Face) -> [EdgePiece.Position] {
        
        let order: [EdgePiece.Position]
        switch face {
        case .front: order = frontEdgeOrder
        case .right: order = rightEdgeOrder
        case .top: order = topEdgeOrder
        case .back: order = backEdgeOrder
        case .left: order = leftEdgeOrder
        case .bottom: order = bottomEdgeOrder
        }
        
        return order
    }
}
