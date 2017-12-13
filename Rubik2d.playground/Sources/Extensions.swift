import UIKit

extension CGPoint {
    
    public init(_ tuple: (CGFloat, CGFloat)) {
        self.init(x: tuple.0, y: tuple.1)
    }
    
    public var vector: CGVector {
        return CGVector(dx: x, dy: y)
    }
    
    public static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    public static func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    public static func +=(lhs: inout CGPoint, rhs: CGPoint) {
        lhs = lhs + rhs
    }
    
    public static func *(lhs: CGFloat, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs * rhs.x, y: lhs * rhs.y)
    }
    
    public static func +(lhs: CGPoint, rhs: (CGFloat, CGFloat)) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.0, y: lhs.y + rhs.1)
    }
    
    public static func -(lhs: CGPoint, rhs: (CGFloat, CGFloat)) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.0, y: lhs.y - rhs.1)
    }
}

public func *(lhs: CGFloat, rhs: (CGFloat, CGFloat)) -> (CGFloat, CGFloat) {
    
    return (rhs.0 * lhs, rhs.1 * lhs)
}

public func *(lhs: (CGFloat, CGFloat), rhs: (CGFloat, CGFloat)) -> (CGFloat, CGFloat) {
    
    return (rhs.0 * lhs.0, rhs.1 * lhs.1)
}

extension CGRect {
    
    public var mid: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
}

extension CGSize {
    
    public var mid: CGPoint {
        return CGPoint(x: width/2, y: height/2)
    }
    
    public static func /(lhs: CGSize, rhs: CGFloat) -> CGSize {
        return CGSize(width: lhs.width/rhs, height: lhs.height/rhs)
    }
}

extension UIColor {
    
    static let cubeFront: UIColor = .init(colorLiteralRed: 0, green: 170/255, blue: 0, alpha: 1)
    static let cubeRight: UIColor = .init(colorLiteralRed: 180/255, green: 0, blue: 0, alpha: 1)
    static let cubeTop: UIColor = .white
    static let cubeBack: UIColor = .init(colorLiteralRed: 30/255, green: 30/255, blue: 180/255, alpha: 1)
    static let cubeLeft: UIColor = .init(colorLiteralRed: 255/255, green: 140/255, blue: 0, alpha: 1)
    static let cubeBottom: UIColor = .init(colorLiteralRed: 255/255, green: 250/255, blue: 0, alpha: 1)
}

extension Array {
    
    public var lastButOne: Element? {
        
        if count >= 2 {
            
            return self[count - 2]
        } else {
            
            return nil
        }
    }
    
    public subscript(modular index: Int) -> Element {
        
        let index = index.mod(count)
        
        return self[index]
    }
    
    public func rotating(by positions: Int) -> [Element] {
        return (positions..<(self.count + positions)).map { self[modular: $0] }
    }
}

extension Int {
    
    public func mod(_ rhs: Int) -> Int {
        
        if self >= 0 {
            return self % rhs
        } else {
            return (self % rhs) + rhs
        }
    }
}

extension UInt {
    
    public static var random: UInt {
        return UInt(arc4random())
    }
}

public func pow(_ base: Int, _ exponent: Int) -> Int {
    
    return Int(pow(Double(base), Double(exponent)))
}
