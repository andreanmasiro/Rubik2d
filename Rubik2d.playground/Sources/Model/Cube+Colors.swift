import UIKit

extension Cube {
    
    public typealias CornerColorTuple = (position: CornerPiece.Position, color: UIColor)
    public typealias EdgeColorTuple = (position: EdgePiece.Position, color: UIColor)
    
    public func colors(in face: Face) -> (cornerColors: [CornerColorTuple], edgeColors: [EdgeColorTuple]) {
        
        let cornerColors = self.cornerColors(in: face)
        let edgeColors = self.edgeColors(in: face)
        
        return (cornerColors, edgeColors)
    }
    
    private func cornerColors(in face: Face) -> [(CornerPiece.Position, UIColor)] {
        
        let pieces = self.pieces(in: face)
        
        var index = 0
        
        let cornerPositions = CornerPiece.Position.positions(in: face)
        let cornerColors = pieces.corners.map { (piece) -> (CornerPiece.Position, UIColor) in
            
            let cornerPosition = cornerPositions[index]
            
            let cornerColorIndex = self.colorIndex(in: face, cornerPosition: cornerPosition)
            index += 1
            
            return (cornerPosition, piece.colors[cornerColorIndex])
        }
        
        
        
        return cornerColors
    }
    
    private func edgeColors(in face: Face) -> [(EdgePiece.Position, UIColor)] {
        
        let pieces = self.pieces(in: face)
        
        var index = 0
        
        let edgePositions = EdgePiece.Position.positions(in: face)
        let edgeColors = pieces.edges.map { (piece) -> (EdgePiece.Position, UIColor) in
            
            let edgePosition = edgePositions[index]
            
            let edgeColorIndex = self.colorIndex(in: face, edgePosition: edgePosition)
            index += 1
            
            return (edgePosition, piece.colors[edgeColorIndex])
        }
        
        return edgeColors
    }
    
    private func colorIndex(in face: Face, cornerPosition: CornerPiece.Position) -> Int {
        
        return Face.contained(in: cornerPosition).index(of: face)!
    }
    
    private func colorIndex(in face: Face, edgePosition: EdgePiece.Position) -> Int {
        
        return Face.contained(in: edgePosition).index(of: face)!
    }
}
