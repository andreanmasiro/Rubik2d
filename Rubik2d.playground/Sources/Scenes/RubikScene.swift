import SpriteKit

public class RubikScene: SKScene {
    
    let cube = Cube()
    var r2d: Rubik2d
    
    var lastTouchedSticker: Sticker?
    var lastTouchedFaceNode: FaceNode?
    
    public override init(size: CGSize) {
        
        r2d = Rubik2d(cube: cube)
        
        super.init(size: size)
        
        
        self.addChild(r2d)
        
        let r2dOffset = CGPoint(x: -r2d.faceNodes[.front]!.size.width/2, y: 0)
        r2d.position = size.mid + r2dOffset
        
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let nodes = self.nodes(at: touches.first!.location(in: self))
        
        lastTouchedSticker = nil
        lastTouchedFaceNode = nil

        for node in nodes where node is Sticker || node is FaceNode {
            if node is Sticker {
                lastTouchedSticker = node as? Sticker
            }
            if node is FaceNode {
                lastTouchedFaceNode = node as? FaceNode
            }
        }
        
    }
    
    public func moveCube(with gestureRecognizer: UISwipeGestureRecognizer) {
        
        if !cube.moving && !r2d.moving {
            
            guard let sticker = lastTouchedSticker else { return }
            guard let faceNode = lastTouchedFaceNode else { return }
            
            let touchedFace = r2d.face(of: faceNode)!
            
            let coordinates = faceNode.coordinates(of: sticker)!
            
            guard let face = moveFace(with: gestureRecognizer.direction, stickerCoordinates: coordinates, touchedFace: touchedFace) else { return }
            guard let magnitude = moveMagnitude(with: gestureRecognizer.direction, stickerCoordinates: coordinates) else { return }
            
            cube.perform(Move(magnitude: magnitude, face: face))
        } else {
            
        }
    }
    
    public func moveFace(with swipeDirection: UISwipeGestureRecognizerDirection, stickerCoordinates: (row: Int, column: Int), touchedFace: Face) -> Face? {
        
        let face: Face?
        switch swipeDirection {
            
        case UISwipeGestureRecognizerDirection.up, UISwipeGestureRecognizerDirection.down:
            switch stickerCoordinates.column {
            case 0: face = touchedFace.left
            case 2: face = touchedFace.right
            default: face = nil
            }
        case UISwipeGestureRecognizerDirection.right, UISwipeGestureRecognizerDirection.left:
            switch stickerCoordinates.row {
            case 0: face = touchedFace.top
            case 2: face = touchedFace.bottom
            default: face = nil
            }
        default: face = nil
        }
        
        return face
    }
    
    public func moveMagnitude(with swipeDirection: UISwipeGestureRecognizerDirection, stickerCoordinates: (row: Int, column: Int)) -> Move.Magnitude? {
        
        let magnitude: Move.Magnitude?
        switch swipeDirection {
            
        case UISwipeGestureRecognizerDirection.up:
            switch stickerCoordinates.column {
            case 0: magnitude = .counterClockwise
            case 2: magnitude = .clockwise
            default: magnitude = nil
            }
        case UISwipeGestureRecognizerDirection.down:
            switch stickerCoordinates.column {
            case 0: magnitude = .clockwise
            case 2: magnitude = .counterClockwise
            default: magnitude = nil
            }
        case UISwipeGestureRecognizerDirection.right:
            switch stickerCoordinates.row {
            case 0: magnitude = .counterClockwise
            case 2: magnitude = .clockwise
            default: magnitude = nil
            }
        case UISwipeGestureRecognizerDirection.left:
            switch stickerCoordinates.row {
            case 0: magnitude = .clockwise
            case 2: magnitude = .counterClockwise
            default: magnitude = nil
            }
        default: magnitude = nil
        }
        
        return magnitude
    }
    
    public func rotateRandomFace() {
        
        var c = 0
        if !r2d.moving {
            
            let random = Move.randomQuarter //[Move.r, Move.b][c % 2]
            cube.perform(random)
            
            c += 1
        }
    }
    
    public func scrambleCube(completionHandler: (() -> ())? = nil) {
        
        let scramble = Move.randomScramble(of: 20)
        cube.perform(scramble, withTimeInterval: r2d.animationDuration + 0.1) {
            completionHandler?()
        }
    }
    
    public func solveCube(completionHandler: (() -> ())? = nil) {
        
        let moves = cube.lastPerformedMoves.inverted
        cube.perform(moves, withTimeInterval: r2d.animationDuration + 0.1) {
            completionHandler?()
        }
        
    }
}
