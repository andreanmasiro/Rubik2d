import Foundation

extension Move {
    
    public static func randomScramble(of length: Int) -> [Move] {
        
        var moves: [Move] = []
        for _ in 0..<length {
            
            guard let last = moves.last else {
                
                moves.append(Move.randomQuarter)
                continue
            }
            
            var newMove: Move
            repeat {
                
                guard let lastButOne = moves.lastButOne else {
                    
                    newMove = Move.randomQuarter
                    continue
                }
                
                repeat {
                    
                    newMove = Move.randomQuarter
                } while newMove.isRedundant(for: lastButOne)
            } while newMove.isRedundant(for: last)
            
            moves.append(newMove)
        }
        
        return moves
    }
    
    private func isRedundant(for move: Move) -> Bool {
        
        return self.face == move.face
    }
    
    private func cancelsOut(move: Move) -> Bool {
        
        return self.face == move.face && self.magnitude == !move.magnitude
    } 
}
