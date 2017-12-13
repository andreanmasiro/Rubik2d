import Foundation

public class Move {
    
    public enum Magnitude: Int {
        
        case clockwise = 1
        case counterClockwise = -1
        case half = 2
        
        public static var random: Magnitude {
            let randomIndex = Int(arc4random_uniform(3))
            
            let randomRawValue = [1, -1, 2][randomIndex]
            
            return Magnitude(rawValue: randomRawValue)!
        }
        
        public static var randomQuarter: Magnitude {
            
            let randomIndex = Int(arc4random_uniform(2))
            
            let randomRawValue = [1, -1][randomIndex]
            
            return Magnitude(rawValue: randomRawValue)!
        }
        
        public static prefix func !(lhs: Magnitude) -> Magnitude {
            
            return Magnitude(rawValue: -lhs.rawValue) ?? lhs
        }
    }
    
    var magnitude: Magnitude
    var face: Face
    
    var rotatesCorners: Bool {
        
        return magnitude != .half && (face != .top && face != .bottom)
    }
    
    var flipsEdges: Bool {
        
        return magnitude != .half && (face == .right || face == .left)
    }
    
    public static var random: Move {
        return Move(magnitude: Magnitude.random, face: Face.random)
    }
    
    public static var randomQuarter: Move {
        return Move(magnitude: Magnitude.randomQuarter, face: Face.random)
    }
    
    /** 
        order: 
            top, left, bottom, right
     */
    public var adjacentAffectedRows: [(row: Int, horizontal: Bool)] {
        
        let affectedRows: [(Int, Bool)]
        switch self.face {
            
        case .front: affectedRows = [(2, true), (2, false), (0, true), (0, false)]
        case .right: affectedRows = [(2, false), (2, false), (2, false), (0, false)]
        case .top: affectedRows = [(0, true), (0, true), (0, true), (0, true)]
        case .back: affectedRows = [(0, true), (2, false), (2, true), (0, false)]
        case .left: affectedRows = [(0, false), (2, false), (0, false), (0, false)]
        case .bottom: affectedRows = [(2, true), (2, true), (2, true), (2, true)]
        }
        
        return affectedRows
    }
    
    public var inverted: Move {
        
        return Move(magnitude: !self.magnitude, face: self.face)
    }
    
    public init(magnitude: Magnitude, face: Face) {
        self.magnitude = magnitude
        self.face = face
    }
    
    public static func +(lhs: Move, rhs: Move) -> [Move] {
        
        if lhs.face == rhs.face {
            // 2, 0, 3, -2, 1, 4
            
            let rawValueSum = (lhs.magnitude.rawValue + rhs.magnitude.rawValue).mod(4)
            
            let magnitude = Magnitude(rawValue: rawValueSum == 3 ? -1 : rawValueSum)!
            
            return [Move(magnitude: magnitude, face: lhs.face)]
            
        } else {
            
            return [lhs, rhs]
        }
    }
}

extension Move: CustomStringConvertible {
    
    public var description: String {
        
        let description: String
        switch self.magnitude {
        case .counterClockwise: description = face.description + "'"
        case .half: description = face.description + "2"
        default: description = face.description
        }
        
        return description
    }
}

// Mark: - Movement constants
extension Move {
    
    public static let f: Move = Move(magnitude: .clockwise, face: .front)
    public static let r: Move = Move(magnitude: .clockwise, face: .right)
    public static let u: Move = Move(magnitude: .clockwise, face: .top)
    public static let b: Move = Move(magnitude: .clockwise, face: .back)
    public static let l: Move = Move(magnitude: .clockwise, face: .left)
    public static let d: Move = Move(magnitude: .clockwise, face: .bottom)
    
    public static let f2: Move = Move(magnitude: .half, face: .front)
    public static let r2: Move = Move(magnitude: .half, face: .right)
    public static let u2: Move = Move(magnitude: .half, face: .top)
    public static let b2: Move = Move(magnitude: .half, face: .back)
    public static let l2: Move = Move(magnitude: .half, face: .left)
    public static let d2: Move = Move(magnitude: .half, face: .bottom)
    
    public static let fl: Move = Move(magnitude: .counterClockwise, face: .front)
    public static let rl: Move = Move(magnitude: .counterClockwise, face: .right)
    public static let ul: Move = Move(magnitude: .counterClockwise, face: .top)
    public static let bl: Move = Move(magnitude: .counterClockwise, face: .back)
    public static let ll: Move = Move(magnitude: .counterClockwise, face: .left)
    public static let dl: Move = Move(magnitude: .counterClockwise, face: .bottom)
}

// Mark: - Algorithms
extension Move {

    // PLL
    public static let tPLL: [Move] = [.r, .u, .rl, .ul, .rl, .f, .r2, .ul, .rl, .ul, .r, .u, .rl, .fl]
    public static let hPll: [Move] = [.r2, .l2, .dl, .r2, .l2, .u2, .r2, .l2, .dl, .r2, .l2]
    
    // OLL
    public static let suneOll: [Move] = [.r, .u, .rl, .u, .r, .u2, .rl]
    public static let tOll: [Move] = [.f, .r, .u, .rl, .ul, .fl]
    public static let pOll: [Move] = [.f, .u, .r, .ul, .rl, .fl]
    
    // Test
    public static let rotateFRUCorner: [Move] = [.rl, .dl, .r, .d, .rl, .dl, .r, .d]
}
