import SpriteKit

public class SceneView: SKView {
    
    var rubikScene: RubikScene
    var scrambleButton: UIButton
    var solveButton: UIButton
    var guideLabel: UILabel
    
    public override init(frame: CGRect) {
        
        rubikScene = RubikScene(size: frame.size)
        
        scrambleButton = UIButton()
        solveButton = UIButton()
        guideLabel = UILabel()
        
        super.init(frame: frame)
        
        rubikScene.backgroundColor = UIColor(colorLiteralRed: 255/255, green: 220/255, blue: 220/255, alpha: 1)
        
        presentScene(rubikScene)
        setUpGestureRecognizers()
        setUpButtons()
        setUpLabel()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func swipeGestureRecognizerAction(_ swipeGestureRecognizer: UISwipeGestureRecognizer) {
        
        rubikScene.moveCube(with: swipeGestureRecognizer)
    }
    
    public func setUpGestureRecognizers() {
        
        (0...3).forEach {
            
            let gr = UISwipeGestureRecognizer(target: self, action: #selector(SceneView.swipeGestureRecognizerAction(_:)))
            
            let swipeDirections: [UISwipeGestureRecognizerDirection] = [.up, .left, .right, .down]
            
            gr.direction = swipeDirections[$0]
            
            self.addGestureRecognizer(gr)
        }
    }
    
    public func setUpLabel() {
        
        guideLabel.text = "Swipe on sides to move the cube"
        
        guideLabel.font = scrambleButton.titleLabel?.font
        guideLabel.textColor = .white
        
        guideLabel.sizeToFit()
        
        addSubview(guideLabel)
        
        guideLabel.translatesAutoresizingMaskIntoConstraints = false
        
        guideLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        guideLabel.centerYAnchor.constraint(equalTo: scrambleButton.centerYAnchor).isActive = true
        
        makeLabelBlink()
    }
    
    private func makeLabelBlink() {
        
        UIView.animate(withDuration: 1.5, delay: 0, options: .curveEaseIn, animations: {
            
            self.guideLabel.alpha = 0
        }) { (_) in
            
            if !self.rubikScene.cube.moving && !self.rubikScene.r2d.moving {
                self.makeLabelReappear()
            }
        }
    }
    
    private func makeLabelReappear() {
        
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut, animations: {
            
            self.guideLabel.alpha = 1
        }) { (_) in
            
            self.makeLabelBlink()
        }
    }
    
    public func setUpButtons() {
        scrambleButton.setTitle("Scramble!", for: .normal)
        solveButton.setTitle("Solve!", for: .normal)
        
        scrambleButton.sizeToFit()
        solveButton.sizeToFit()
        
        scrambleButton.layer.borderColor = UIColor.white.cgColor
        solveButton.layer.borderColor = UIColor.white.cgColor
        
        scrambleButton.layer.borderWidth = 3
        solveButton.layer.borderWidth = 3
        
        scrambleButton.layer.cornerRadius = 6
        solveButton.layer.cornerRadius = 6
        
        addSubview(scrambleButton)
        addSubview(solveButton)
        
        scrambleButton.translatesAutoresizingMaskIntoConstraints = false
        solveButton.translatesAutoresizingMaskIntoConstraints = false
        
        scrambleButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        scrambleButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        scrambleButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        
        solveButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        solveButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        solveButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        
        scrambleButton.addTarget(self, action: #selector(SceneView.scrambleAction(_:)), for: .touchUpInside)
        solveButton.addTarget(self, action: #selector(SceneView.solveAction(_:)), for: .touchUpInside)
    }
    
    public func scrambleAction(_ sender: UIButton) {
        
        rubikScene.scrambleCube() {
            DispatchQueue.main.async {
                sender.isEnabled = true
            }
            self.makeLabelReappear()
        }
        sender.isEnabled = false
    }
    
    public func solveAction(_ sender: UIButton) {
        
        rubikScene.solveCube() {
            DispatchQueue.main.async {
                sender.isEnabled = true
            }
            self.makeLabelReappear()
        }
        sender.isEnabled = false
    }
    
    private func hideLabel() {
        
        guideLabel.alpha = 0
    }
}
