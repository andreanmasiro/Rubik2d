import Foundation

public class CornerPiece: NSObject {
    
// Mark: - Position
    public enum Position: Int {
        
        case topRightFront = 0
        case topLeftFront = 1
        case topLeftBack = 2
        case topRightBack = 3
        
        case bottomLeftFront = 4
        case bottomRightFront = 5
        case bottomRightBack = 6
        case bottomLeftBack = 7
        
        static let allSorted: [Position] = (0...7).map { Position(rawValue: $0)! }
    }
    
// Mark: - Orientation
    public enum Orientation: Int {
        
        case correct = 0
        case clockwise = 1
        case counterClockwise = 2
        
        public static func +(lhs: Orientation, rhs: Orientation) -> Orientation {
            
            let value = (lhs.rawValue + rhs.rawValue) % 3
            return Orientation(rawValue: value)!
        }
        
        public static func +=(lhs: inout Orientation, rhs: Orientation) {
            let value = (lhs.rawValue + rhs.rawValue) % 3
            lhs =  Orientation(rawValue: value)!
        }
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

    public override func copy() -> Any {
        return CornerPiece(position: originalPosition, orientation: orientation)
    }
    
}

// Mark: - Corner positions in faces
extension CornerPiece.Position {
    
    private static let frontCornerPositions: [CornerPiece.Position] = [.topLeftFront, .topRightFront, .bottomRightFront, .bottomLeftFront]
    private static let rightCornerPositions: [CornerPiece.Position] = [.topRightFront, .topRightBack, .bottomRightBack, .bottomRightFront]
    private static let topCornerPositions: [CornerPiece.Position] = [.topRightFront, .topLeftFront, .topLeftBack, .topRightBack]
    private static let backCornerPositions: [CornerPiece.Position] = [.topRightBack, .topLeftBack, .bottomLeftBack, .bottomRightBack]
    private static let leftCornerPositions: [CornerPiece.Position] = [.topLeftBack, .topLeftFront, .bottomLeftFront, .bottomLeftBack]
    private static let bottomCornerPositions: [CornerPiece.Position] = [.bottomRightFront, .bottomRightBack, .bottomLeftBack, .bottomLeftFront]
    
    public static func positions(in face: Face) -> [CornerPiece.Position] {
        
        let positions: [CornerPiece.Position]
        
        switch face {
        case .front: positions = frontCornerPositions
        case .right: positions = rightCornerPositions
        case .top: positions = topCornerPositions
        case .back: positions = backCornerPositions
        case .left: positions = leftCornerPositions
        case .bottom: positions = bottomCornerPositions
        }
        
        return positions
    }
}
