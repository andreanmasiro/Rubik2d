import Foundation

public protocol CubeDelegate {
    
    func cube(_ cube: Cube, willPerformMove move: Move)
    func cube(_ cube: Cube, didPerformMove move: Move)
}

public class Cube {
    
    public var delegate: CubeDelegate?
    
    public private(set) var cornerPieces: [CornerPiece]
    public private(set) var edgePieces: [EdgePiece]
    
    public private(set) var moving = false
    
    public private(set) var lastPerformedMoves: [Move] = []
    
    public var numberOfSolvedCorners: Int {
        
        var number = 0
        for position in CornerPiece.Position.allSorted {
            
            let cornerPiece = cornerPieces[position]
            number += (cornerPiece.originalPosition == position) && (cornerPiece.orientation == .correct) ? 1 : 0
        }
        
        return number
    }
    
    public var numberOfSolvedEdges: Int {
        
        var number = 0
        for position in EdgePiece.Position.allSorted {
            
            let edgePiece = edgePieces[position]
            number += (edgePiece.originalPosition == position) && (edgePiece.orientation == .correct) ? 1 : 0
        }
        
        return number
    }
    
    public var numberOfSolvedPieces: Int {
        return numberOfSolvedCorners + numberOfSolvedEdges
    }
    
    public init() {
        
        cornerPieces = CornerPiece.Position.allSorted.map { CornerPiece(position: $0) }
        edgePieces = EdgePiece.Position.allSorted.map { EdgePiece(position: $0) }
    }
    
    public func perform(_ move: Move) {
        
        delegate?.cube(self, willPerformMove: move)
        
        moveCorners(with: move)
        moveEdges(with: move)
        
        delegate?.cube(self, didPerformMove: move)
        
        lastPerformedMoves.append(move)
        if numberOfSolvedPieces == 20 {
            lastPerformedMoves.removeAll()
        }
    }
    
    public func perform(_ moves: [Move]) {
        
        for move in moves {
            perform(move)
        }
    }
    
    public func perform(_ moves: [Move], withTimeInterval timeInterval: Double, completionHandler: (() -> ())? = nil) {
        
        moving = true
        DispatchQueue.global().async {
            
            for (i, move) in moves.enumerated() {
                
                DispatchQueue.main.async {
                    self.perform(move)
                }
                
                if i < moves.count - 1 {
                    Thread.sleep(forTimeInterval: timeInterval)
                }
            }
            
            self.moving = false
            completionHandler?()
        }
    }
    
    public func pieces(in face: Face) -> (corners: [CornerPiece], edges: [EdgePiece]) {
        
        let corners = CornerPiece.Position.positions(in: face).map { cornerPieces[$0] }
        let edges = EdgePiece.Position.positions(in: face).map { edgePieces[$0] }
        
        return (corners, edges)
    }
    
    private func moveCorners(with move: Move) {
        let cornerPositions = CornerPiece.Position.positions(in: move.face)
        
        let cornerCopies = cornerPieces.map { $0.copy() as! CornerPiece }
        
        let deltaIndex = -move.magnitude.rawValue
        
        for (i, position) in cornerPositions.enumerated() {
            cornerPieces[position] = cornerCopies[cornerPositions[modular: i + deltaIndex]]
            
            if move.rotatesCorners {
                let odd = (i % 2) == 0
                
                if odd {
                    cornerPieces[position].orientation += .counterClockwise
                } else {
                    cornerPieces[position].orientation += .clockwise
                }
            }
        }
    }
    
    private func moveEdges(with move: Move) {
        
        let edgePositions = EdgePiece.Position.positions(in: move.face)
        
        let edgeCopies = edgePieces.map { $0.copy() as! EdgePiece }
        
        let deltaIndex = -move.magnitude.rawValue
        
        for (i, position) in edgePositions.enumerated() {
            edgePieces[position] = edgeCopies[edgePositions[modular: i + deltaIndex]]
            
            if move.flipsEdges {
                
                edgePieces[position].flip()
            }
        }
    }
}

extension Array where Element: CornerPiece {
    
    public subscript(_ position: CornerPiece.Position) -> CornerPiece {
        get {
            return self[position.rawValue]
        }
        set {
            self[position.rawValue] = newValue as! Element
        }
    }
}

extension Array where Element: EdgePiece {
    
    public subscript(_ position: EdgePiece.Position) -> EdgePiece {
        get {
            return self[position.rawValue]
        }
        set {
            self[position.rawValue] = newValue as! Element
        }
    }
}

extension Array where Element: Move {
    
    public var inverted: [Element] {
        
        return reversed().map { ($0.inverted as! Element) }
    }
}
