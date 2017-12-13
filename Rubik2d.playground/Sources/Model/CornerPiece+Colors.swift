import UIKit

extension CornerPiece {
    
    public var colors: [UIColor] {
        return (self.faces.map { $0.color }).rotating(by: -self.orientation.rawValue)
    }
}

extension CornerPiece.Position { // face node sticker index orders
    
    public static let frontCornerOrder: [CornerPiece.Position] = [.topLeftFront, .topRightFront, .bottomLeftFront, .bottomRightFront]
    public static let rightCornerOrder: [CornerPiece.Position] = [.topRightFront, .topRightBack, .bottomRightFront, .bottomRightBack]
    public static let topCornerOrder: [CornerPiece.Position] = [.topLeftBack, .topRightBack, .topLeftFront, .topRightFront]
    public static let backCornerOrder: [CornerPiece.Position] = [.topRightBack, .topLeftBack, .bottomRightBack, .bottomLeftBack]
    public static let leftCornerOrder: [CornerPiece.Position] = [.topLeftBack, .topLeftFront, .bottomLeftBack, .bottomLeftFront]
    public static let bottomCornerOrder: [CornerPiece.Position] = [.bottomLeftFront, .bottomRightFront, .bottomLeftBack, .bottomRightBack]
    
    public static func stickerOrder(in face: Face) -> [CornerPiece.Position] {
        
        let order: [CornerPiece.Position]
        switch face {
        case .front: order = frontCornerOrder
        case .right: order = rightCornerOrder
        case .top: order = topCornerOrder
        case .back: order = backCornerOrder
        case .left: order = leftCornerOrder
        case .bottom: order = bottomCornerOrder
        }
        
        return order
    }
}
