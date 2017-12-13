import SpriteKit

public class Rubik2d: SKNode {
    
    public typealias FaceColors = (cornerColors: Cube.CornerColorTuple, edgeColors: Cube.EdgeColorTuple)
    
    public let animationDuration: Double = 0.4
    public static let facesSpacing: CGFloat = 13
    
    public var faceNodes: [Face: FaceNode] = [:]
    
    fileprivate var movementQueue: [Move] = []
    fileprivate var currentMove: Move?
    
    public var moving: Bool {
        return currentMove != nil
    }
    
    public var cube: Cube
    
    public init(cube: Cube) {
        
        self.cube = cube
        
        super.init()
        
        self.cube.delegate = self
        
        initializeFaces()
        setFacesPositions()
    }
    
    private func initializeFaces() {
        for face in Face.all {
            
            let faceNode = FaceNode(color: face.color)
            
            faceNodes[face] = faceNode
            updateColors(in: face)
            
            addChild(faceNode)
        }
        
    }
    
    fileprivate func updateColors(in face: Face) {
        
        let faceColors = cube.colors(in: face)
        let faceNode = faceNodes[face]!
        
        for (cornerPosition, cornerColor) in faceColors.cornerColors {
            faceNode.colorizeSticker(with: cornerColor, inCornerPosition: cornerPosition, in: face)
        }
        
        for (edgePosition, edgeColor) in faceColors.edgeColors {
            faceNode.colorizeSticker(with: edgeColor, inEdgePosition: edgePosition, in: face)
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setFacesPositions() {
        
        let frontPosition = CGPoint.zero
        faceNodes[.front]!.position = frontPosition
        
        faceNodes[.right]?.position = frontPosition + CGPoint(x: faceNodes[.front]!.size.width + Rubik2d.facesSpacing, y: 0)
        
        faceNodes[.back]?.position = frontPosition + CGPoint(x: faceNodes[.front]!.size.width + faceNodes[.right]!.size.width + (Rubik2d.facesSpacing * 2), y: 0)
        
        faceNodes[.left]?.position = frontPosition + CGPoint(x: -(faceNodes[.front]!.size.width + Rubik2d.facesSpacing), y: 0)
        
        faceNodes[.top]?.position = frontPosition + CGPoint(x: 0, y: faceNodes[.front]!.size.height + Rubik2d.facesSpacing)
        
        faceNodes[.bottom]?.position = frontPosition + CGPoint(x: 0, y: -(faceNodes[.front]!.size.height + Rubik2d.facesSpacing))
    }
    
    public func face(of faceNode: FaceNode) -> Face? {
        
        for item in faceNodes.enumerated() where item.element.value === faceNode {
            
            return item.element.key
        }
        
        return nil
    }
    
}

extension Rubik2d: CubeDelegate {
    
    public func cube(_ cube: Cube, willPerformMove move: Move) {
        
    }
    
    public func cube(_ cube: Cube, didPerformMove move: Move) {
        
        movementQueue.append(move)
        if currentMove == nil {
            
            finishedCurrentMove()
        }
    }
    
    private func finishedCurrentMove() {
        
        currentMove = nil
        
        if movementQueue.count > 0 {
            
            let move = movementQueue.remove(at: 0)
            currentMove = move
            animateMovement(move, duration: animationDuration) {
                self.finishedCurrentMove()
            }
        }
    }
    
    func animateMovement(_ move: Move, duration: Double, completionHandler: (() -> ())? = nil) {
        
        let faceNode = faceNodes[move.face]
        faceNode?.rotate(with: move.magnitude, duration: duration) {
            faceNode?.resetRotation()
            self.updateColors(in: move.face)
            completionHandler?()
        }
        
        move.face.adjacentFaces.forEach { animateMovement(move, in: $0, duration: duration) }
    }
    
    func animateMovement(_ move: Move, in face: Face, duration: Double) {
        
        let assistantRowLocation = self.assistantRowLocation(for: move, in: face)
        
        let sourceFace = assistantRowLocation.associatedFace(in: face)

        let affectedFaceNode = faceNodes[face]!
        
        let affectedRowIndex = move.face.adjacentFaces.index(of: face)!
        let newRowIndex = move.face.adjacentFaces.index(of: sourceFace)!
        
        let affectedRowCoordinates = move.adjacentAffectedRows[affectedRowIndex]
        let newRowCoordinates = move.adjacentAffectedRows[newRowIndex]
        
        let affectedRow = affectedFaceNode.stickers(at: affectedRowCoordinates.row, horizontal: affectedRowCoordinates.horizontal, copy: false)
        
        affectedFaceNode.assistantRow = assistantRow(for: face, from: sourceFace, affectedRowCoordinates: affectedRowCoordinates, newRowCoordinates: newRowCoordinates, assistantRowLocation: assistantRowLocation)
        
        let assistantRowPosition = assistantRowLocation.position(for: face)
        let delta = assistantRowLocation.destination(assistantRowPosition.inverted) - assistantRowPosition.point
        
        let move = SKAction.move(by: delta.vector, duration: duration)
        move.timingMode = .easeOut
        
        affectedFaceNode.assistantRow?.run(move) {
            
            affectedFaceNode.assistantRow = nil
            self.updateColors(in: face)
        }
        
        affectedRow.forEach {
            
            $0.run(move) {
                affectedFaceNode.resetStickersPositions()
            }
        }
        
    }
    
    func assistantRow(for face: Face, from sourceFace: Face, affectedRowCoordinates: (row: Int, horizontal: Bool), newRowCoordinates: (row: Int, horizontal: Bool), assistantRowLocation: FaceNode.AssistantRowLocation) -> SKNode {
        
        let newRowPosition = assistantRowLocation.position(for: face)
        
        let positionDeltaMultiplier: (CGFloat, CGFloat)
        switch (sourceFace, newRowPosition.inverted) {
        case (face.top, true), (face.bottom, false): positionDeltaMultiplier = (0, -1)
        case (face.right, true), (face.left, false): positionDeltaMultiplier = (-1, 0)
        case (face.top, false), (face.bottom, true): positionDeltaMultiplier = (0, 1)
        case (face.right, false), (face.left, true): positionDeltaMultiplier = (1, 0)
        default: positionDeltaMultiplier = (0, 0)
        }
        
        let positionDelta: (CGFloat, CGFloat)
        switch sourceFace {
        case face.top, face.bottom: positionDelta = (0, FaceNode.stickerSize.height + FaceNode.stickerSpacing)
        case face.right, face.left: positionDelta = (FaceNode.stickerSize.width + FaceNode.stickerSpacing, 0)
        default: positionDelta = (0, 0)
        }
        
        let assistantRow = SKNode()
        let sourceFaceNode = faceNodes[sourceFace]!
        let newRow = sourceFaceNode.stickers(at: newRowCoordinates.row, horizontal: newRowCoordinates.horizontal, copy: true)
        
        for (i, sticker) in newRow.enumerated() {
            
            let positionDelta = positionDelta * positionDeltaMultiplier
            sticker.position = (CGFloat(i) * CGPoint(positionDelta))
            assistantRow.addChild(sticker)
        }
        assistantRow.position = newRowPosition.point
        
        return assistantRow
    }
    
    func assistantRowLocation(for move: Move, in face: Face) -> FaceNode.AssistantRowLocation {
        
        let assistantRowLocation: FaceNode.AssistantRowLocation
        
        switch move.face {
        case face.top:
            switch move.magnitude {
            case .clockwise:
                assistantRowLocation = .rightTop
            default:
                assistantRowLocation = .leftTop
            }
        case face.right:
            switch move.magnitude {
            case .clockwise:
                assistantRowLocation = .bottomRight
            default:
                assistantRowLocation = .topRight
            }
        case face.left:
            switch move.magnitude {
            case .clockwise:
                assistantRowLocation = .topLeft
            default:
                assistantRowLocation = .bottomLeft
            }
        case face.bottom:
            switch move.magnitude {
            case .clockwise:
                assistantRowLocation = .leftBottom
            default:
                assistantRowLocation = .rightBottom
            }
        default: fatalError("invalid ")
        }
        
        return assistantRowLocation
    }
    
}
