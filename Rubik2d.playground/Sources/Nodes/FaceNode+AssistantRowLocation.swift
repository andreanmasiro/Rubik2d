import SpriteKit

extension FaceNode {
    
    public enum AssistantRowLocation: Int {
        
        case topLeft
        case topRight
        
        case bottomLeft
        case bottomRight
        
        case leftTop
        case leftBottom
        
        case rightTop
        case rightBottom
        
        static let top: [AssistantRowLocation] = [.topLeft, .topRight, .leftTop, .rightTop]
        static let bottom: [AssistantRowLocation] = [.bottomLeft, .bottomRight, .leftBottom, .rightBottom]
        static let left: [AssistantRowLocation] = [.leftTop, .leftBottom, .topLeft, .bottomLeft]
        static let right: [AssistantRowLocation] = [.rightTop, .rightBottom, .topRight, .bottomRight]
        
        public static let primarilyTop: [AssistantRowLocation] = [.topLeft, .topRight]
        public static let primarilyBottom: [AssistantRowLocation] = [.bottomRight, .bottomLeft]
        public static let primarilyRight: [AssistantRowLocation] = [.rightTop, .rightBottom]
        public static let primarilyLeft: [AssistantRowLocation] = [.leftTop, .leftBottom]
        
        public static let secondarilyTop: [AssistantRowLocation] = [.leftTop, .rightTop]
        public static let secondarilyBottom: [AssistantRowLocation] = [.leftBottom, .rightBottom]
        public static let secondarilyRight: [AssistantRowLocation] = [.topRight, .bottomRight]
        public static let secondarilyLeft: [AssistantRowLocation] = [.topLeft, .bottomLeft]
        
        
        public var isTop: Bool {
            
            return AssistantRowLocation.top.contains(self)
        }
        
        public var isBottom: Bool {
            
            return AssistantRowLocation.bottom.contains(self)
        }
        
        public var isLeft: Bool {
            
            return AssistantRowLocation.left.contains(self)
        }
        
        public var isRight: Bool {
            
            return AssistantRowLocation.right.contains(self)
        }
        
        public var isPrimarilyTop: Bool {
            
            return AssistantRowLocation.primarilyTop.contains(self)
        }
        
        public var isPrimarilyBottom: Bool {
            
            return AssistantRowLocation.primarilyBottom.contains(self)
        }
        
        public var isPrimarilyLeft: Bool {
            
            return AssistantRowLocation.primarilyLeft.contains(self)
        }
        
        public var isPrimarilyRight: Bool {
            
            return AssistantRowLocation.primarilyRight.contains(self)
        }
        
        public var isSecondarilyTop: Bool {
            
            return AssistantRowLocation.secondarilyTop.contains(self)
        }
        
        public var isSecondarilyBottom: Bool {
            
            return AssistantRowLocation.secondarilyBottom.contains(self)
        }
        
        public var isSecondarilyLeft: Bool {
            
            return AssistantRowLocation.secondarilyLeft.contains(self)
        }
        
        public var isSecondarilyRight: Bool {
            
            return AssistantRowLocation.secondarilyRight.contains(self)
        }
        
        public var associatedCoordinates: (row: Int, horizontal: Bool) {
            
            let coordinates: (Int, Bool)
            switch self {
            case .leftTop, .rightTop: coordinates = (0, true)
            case .leftBottom, .rightBottom: coordinates = (2, true)
            case .topLeft, .bottomLeft: coordinates = (0, false)
            case .topRight, .bottomRight: coordinates = (2, false)
            }
            
            return coordinates
        }
        
        public func associatedFace(in face: Face) -> Face {
            
            let associatedFace: Face
            switch self {
            case .topLeft, .topRight: associatedFace = face.top
            case .bottomLeft, .bottomRight: associatedFace = face.bottom
            case .leftTop, .leftBottom: associatedFace = face.left
            case .rightTop, .rightBottom: associatedFace = face.right
            }
            
            return associatedFace
        }
        
        public func destination(_ inverted: Bool) -> CGPoint {
            
            let coordY: Int
            if self.isPrimarilyTop {
                coordY = inverted ? 0 : 2
            } else if self.isPrimarilyBottom {
                coordY = inverted ? 2 : 0
            } else if self.isSecondarilyTop {
                coordY = 0
            } else {
                coordY = 2
            }
            
            let coordX: Int
            if self.isPrimarilyLeft {
                coordX = inverted ? 0 : 2
            } else if self.isPrimarilyRight {
                coordX = inverted ? 2 : 0
            } else if self.isSecondarilyLeft {
                coordX = 0
            } else {
                coordX = 2
            }
            
            return FaceNode.position(forStickerInCoordX: coordX, coordY: coordY)
        }
        
        public func position(for face: Face) -> (point: CGPoint, inverted: Bool) {
            
            let invertedPossibilities: [Bool]
            if self.isPrimarilyTop {
                
                invertedPossibilities = [true, true, false, false, false, true]
            } else if self.isPrimarilyLeft {
                
                invertedPossibilities = [true, true, false, true, true, true]
            } else if self.isPrimarilyRight {
                
                invertedPossibilities = [false, false, false, false, false, true]
            } else if self.isPrimarilyBottom {
                
                invertedPossibilities = [false, true, false, true, false, true]
            } else {
                invertedPossibilities = []
            }
            
            let inverted = invertedPossibilities[face.rawValue]
            
            let point: CGPoint
            if inverted {
                point = invertedPosition
            } else {
                point = normalPosition
            }
            
            return (point, inverted)
        }
        
        public var normalPosition: CGPoint {
            
            let stickerSize = FaceNode.stickerSize
            let stickerSpacing = Rubik2d.facesSpacing
            
            let yPositionDiff: (CGFloat, CGFloat) = (0, stickerSize.height + stickerSpacing)
            let xPositionDiff: (CGFloat, CGFloat) = (stickerSize.width + stickerSpacing, 0)
            
            let coordX = self.isLeft ? 0 : 2
            let coordY = self.isTop ? 0 : 2
            let offset = self.isPrimarilyTop || self.isPrimarilyBottom ? yPositionDiff : xPositionDiff
            
            let offsetMultiplier: CGFloat = self.isPrimarilyTop || self.isPrimarilyRight ? 1 : -1
            
            let position = FaceNode.position(forStickerInCoordX: coordX, coordY: coordY) + (offsetMultiplier * offset)
            
            return position
        }
        
        public var invertedPosition: CGPoint {
            
            let stickerSize = FaceNode.stickerSize
            let faceSpacing = Rubik2d.facesSpacing
            let stickerSpacing = FaceNode.stickerSpacing
            
            let position: CGPoint
            
            let invertedRatio: CGFloat = 3
            
            let yPositionDiff: (CGFloat, CGFloat) = (0, (invertedRatio * stickerSize.height) + faceSpacing + ((invertedRatio - 1) * stickerSpacing))
            let xPositionDiff: (CGFloat, CGFloat) = ((invertedRatio * stickerSize.width) + faceSpacing + ((invertedRatio - 1) * stickerSpacing), 0)
            
            switch self {
            case .topLeft:
                position = FaceNode.position(forStickerInCoordX: 0, coordY: 0) + yPositionDiff
            case .topRight:
                position = FaceNode.position(forStickerInCoordX: 2, coordY: 0) + yPositionDiff
            case .bottomLeft:
                position = FaceNode.position(forStickerInCoordX: 0, coordY: 2) - yPositionDiff
            case .bottomRight:
                position = FaceNode.position(forStickerInCoordX: 2, coordY: 2) - yPositionDiff
            case .leftTop:
                position = FaceNode.position(forStickerInCoordX: 0, coordY: 0) - xPositionDiff
            case .leftBottom:
                position = FaceNode.position(forStickerInCoordX: 0, coordY: 2) - xPositionDiff
            case .rightTop:
                position = FaceNode.position(forStickerInCoordX: 2, coordY: 0) + xPositionDiff
            case .rightBottom:
                position = FaceNode.position(forStickerInCoordX: 2, coordY: 2) + xPositionDiff
            }
            
            return position
        }
    }
    
}
