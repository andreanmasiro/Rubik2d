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
  
    static let cubeFront: UIColor = #colorLiteral(red: 0, green: 0.6666666667, blue: 0, alpha: 1)
    static let cubeRight: UIColor = #colorLiteral(red: 0.7058823529, green: 0, blue: 0, alpha: 1)
    static let cubeTop: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    static let cubeBack: UIColor = #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.7058823529, alpha: 1)
    static let cubeLeft: UIColor = #colorLiteral(red: 1, green: 0.5490196078, blue: 0, alpha: 1)
    static let cubeBottom: UIColor = #colorLiteral(red: 1, green: 0.9803921569, blue: 0, alpha: 1)
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
