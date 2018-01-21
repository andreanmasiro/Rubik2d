import SpriteKit


public class FaceNode: SKNode {
    
    public static let stickerSize = CGSize(width: 25, height: 25)
    public static let stickerSpacing = CGFloat(5)
    
    public var size: CGSize {
        let side = (FaceNode.stickerSize.width * CGFloat(cubeDimension)) + (FaceNode.stickerSpacing * CGFloat(cubeDimension - 1))
        return CGSize(width: side, height: side)
    }
    private let cubeDimension = 3
    
    private let faceNode = SKNode()
    
    /** order:
     from top to bottom
     from left to right
     */
    public private(set) var stickers: [Sticker] = []
    
    public var assistantRow: SKNode? {
    
        didSet {
            oldValue?.removeFromParent()
            
            if let assistantRow = assistantRow {
                assistantRowCropNode.addChild(assistantRow)
            }
        }
    }
    public var assistantRowCropNode = SKCropNode()
    public var cropRectNode: SKShapeNode!
    
    public init(color: UIColor = .purple) {
        
        super.init()
        
        let cropMaskRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        cropRectNode = SKShapeNode(rect: cropMaskRect)
        cropRectNode.lineWidth = 0
        cropRectNode.strokeColor = .purple
        cropRectNode.fillColor = .purple
        cropRectNode.zPosition = 1000
        
        cropRectNode.position = CGPoint(x: -cropRectNode.frame.size.width/2, y: -cropRectNode.frame.size.height/2)

        assistantRowCropNode.maskNode = cropRectNode
        
        assistantRowCropNode.addChild(faceNode)
        addChild(assistantRowCropNode)
        
        buildStickers()
        colorizeAllStickers(with: color)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func coordinates(of sticker: Sticker) -> (row: Int, column: Int)? {
        
        if let index = stickers.index(of: sticker) {
           
            let row = index/3
            let column = index % 3
            
            return (row, column)
        } else {
            
            return nil
        }
    }
    
    public func row(at index: Int, copy: Bool = true) -> [Sticker] {
        
        return stickers(at: index, horizontal: true, copy: copy)
    }
    
    public func column(at index: Int, copy: Bool = true) -> [Sticker] {
        
        return stickers(at: index, horizontal: false, copy: copy)
    }
    
    public func stickers(at index: Int, horizontal: Bool, copy: Bool = true) -> [Sticker] {
        
        if case 0..<cubeDimension = index {
            
            var stickersCopy: [Sticker] = []
            for i in 0..<cubeDimension {
//
                let index = horizontal ? i + (index * cubeDimension) : (i * cubeDimension) + index
                
                if copy {
                 stickersCopy.append(stickers[index].copy() as! Sticker)
                } else {
                    stickersCopy.append(stickers[index])
                }
            }
            
            return stickersCopy
        } else {
            fatalError("row does not exist")
        }
    }
    
    public func buildStickers() {
        
        for i in 0..<cubeDimension {
            for j in 0..<cubeDimension {
                
                createSticker(inCoordX: j, coordY: i)
            }
        }
    }
    
    public func resetStickersPositions() {
        
        for i in 0..<cubeDimension {
            for j in 0..<cubeDimension {
                
                let sticker = stickers[j + (i * 3)]
                sticker.position = FaceNode.position(forStickerInCoordX: j, coordY: i)
            }
        }
        
    }
    
    private func createSticker(inCoordX coordX: Int, coordY: Int) {
        
        let stickerSize = FaceNode.stickerSize
        
        let cornerRadius = (coordY == coordX && coordY == 1) ? stickerSize.height/2 : 3.0
        let sticker = Sticker(size: stickerSize, cornerRadius: cornerRadius)
        
        stickers.append(sticker)
        faceNode.addChild(sticker)
        
        sticker.position = FaceNode.position(forStickerInCoordX: coordX, coordY: coordY)
    }
    
    public static func position(forStickerInCoordX x: Int, coordY y: Int) -> CGPoint {
        
        let xPos = (CGFloat(x - 1) * (stickerSize.width + stickerSpacing)) - stickerSize.width/2
        let yPos = (CGFloat(1 - y) * (stickerSize.height + stickerSpacing)) - stickerSize.height/2
        
        return CGPoint(x: xPos, y: yPos)
    }
    
    public func colorizeAllStickers(with color: UIColor) {
        for sticker in stickers {
            sticker.color = color
        }
    }
    
    public func colorizeSticker(with color: UIColor, inCornerPosition position: CornerPiece.Position, in face: Face) {
        
        let index = indexOfSticker(inCornerPosition: position, in: face)
        
        stickers[index].color = color
    }
    
    public func colorizeSticker(with color: UIColor, inEdgePosition position: EdgePiece.Position, in face: Face) {
        
        let index = indexOfSticker(inEdgePosition: position, in: face)
        
        stickers[index].color = color
    }
    
    public func indexOfSticker(inCornerPosition position: CornerPiece.Position, in face: Face) -> Int {
        
        let indexes = [0, 2, 6, 8]
        
        if let index = CornerPiece.Position.stickerOrder(in: face).index(of: position) {
            return indexes[index]
        } else {
            return -1
        }
    }
    
    public func indexOfSticker(inEdgePosition position: EdgePiece.Position, in face: Face) -> Int {
        
        let indexes = [1, 3, 5, 7]
        
        if let index = EdgePiece.Position.stickerOrder(in: face).index(of: position) {
            return indexes[index]
        } else {
            return -1
        }
    }
    
    public func rotate(with magnitude: Move.Magnitude, duration: Double, completionHandler: (() -> ())? = nil) {
        
        let actionDuration = duration * Double(abs(magnitude.rawValue))
        
        let rotate = SKAction.rotate(byAngle: CGFloat(M_PI/2) * CGFloat(-magnitude.rawValue), duration: actionDuration)
        rotate.timingMode = .easeInEaseOut
        
        assistantRowCropNode.maskNode = nil
        faceNode.run(rotate) {
            self.assistantRowCropNode.maskNode = self.cropRectNode
            completionHandler?()
        }
    }
    
    public func resetRotation() {
        faceNode.zRotation = 0
    }
}
