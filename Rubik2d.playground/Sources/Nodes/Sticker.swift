import SpriteKit

public class Sticker: SKNode {
    
    public var color: UIColor {
        didSet {
            setColors()
        }
    }
    private(set) var size: CGSize
    private(set) var cornerRadius: CGFloat
    private(set) var shapeNode: SKShapeNode! {
        didSet {
            oldValue?.removeFromParent()
            addChild(shapeNode)
        }
    }
    
    public init(color: UIColor = .clear, size: CGSize, cornerRadius: CGFloat) {
        self.color = color
        self.size = size
        self.cornerRadius = cornerRadius
        super.init()
        
        draw()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func draw() {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        shapeNode = SKShapeNode(rect: rect, cornerRadius: cornerRadius)
        
        setColors()
    }
    
    private func setColors() {
        shapeNode.fillColor = color
        shapeNode.strokeColor = color
    }
    
    public override func copy() -> Any {
        let copy = Sticker(color: color, size: size, cornerRadius: cornerRadius)
        
        return copy
    }
}
