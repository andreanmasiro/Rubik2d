import Foundation

public class EdgePiece: NSObject {
    
// Mark: - Position
    public enum Position: Int {
        
        case topFront = 0
        case topLeft = 1
        case topBack = 2
        case topRight = 3
        
        case middleRightFront = 4
        case middleRightBack = 5
        case middleLeftBack = 6
        case middleLeftFront = 7
        
        case bottomFront = 8
        case bottomRight = 9
        case bottomBack = 10
        case bottomLeft = 11
        
        static let allSorted: [Position] = (0...11).map { Position(rawValue: $0)! }
    }
    
// Mark: - Orientation
    public enum Orientation: Int {
        
        case correct = 0
        case flipped = 1
    }
    
// Mark: - Piece
    public let originalPosition: Position
    public internal(set) var orientation: Orientation
    
    public private(set) var faces: [Face]
    
    public init(position: Position, orientation: Orientation = .correct) {
        self.originalPosition = position
        self.orientation = orientation
        self.faces = Face.contained(in: position)
    }
    
    public func flip() {
        
        let value = (orientation.rawValue + 1) % 2
        
        orientation = Orientation(rawValue: value)!
    }
    
    public override func copy() -> Any {
        return EdgePiece(position: originalPosition, orientation: orientation)
    }
}

// Mark: - Edge positions in faces
extension EdgePiece.Position {
    
    private static let frontEdgePositions: [EdgePiece.Position] = [.topFront, .middleRightFront, .bottomFront, .middleLeftFront]
    private static let rightEdgePositions: [EdgePiece.Position] = [.middleRightFront, .topRight, .middleRightBack, .bottomRight]
    private static let topEdgePositions: [EdgePiece.Position] = [.topRight, .topFront, .topLeft, .topBack]
    private static let backEdgePositions: [EdgePiece.Position] = [.topBack, .middleLeftBack, .bottomBack, .middleRightBack]
    private static let leftEdgePositions: [EdgePiece.Position] = [.bottomLeft, .middleLeftBack, .topLeft, .middleLeftFront]
    private static let bottomEdgePositions: [EdgePiece.Position] = [.bottomLeft, .bottomFront, .bottomRight, .bottomBack]
    
    public static func positions(in face: Face) -> [EdgePiece.Position] {
        
        let positions: [EdgePiece.Position]
        
        switch face {
        case .front: positions = frontEdgePositions
        case .right: positions = rightEdgePositions
        case .top: positions = topEdgePositions
        case .back: positions = backEdgePositions
        case .left: positions = leftEdgePositions
        case .bottom: positions = bottomEdgePositions
        }
        
        return positions
    }
}
