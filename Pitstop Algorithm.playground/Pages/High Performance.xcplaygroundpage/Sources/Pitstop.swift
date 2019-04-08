import PlaygroundSupport
import SpriteKit
import Foundation
import AVFoundation

public class PitstopScene: SKScene, AVAudioPlayerDelegate {
    
    private var mechanics:SKSpriteNode!
    private var pitstopFrames: [SKTexture] = []
    
    private var player: AVAudioPlayer = AVAudioPlayer()
    private let background = SKSpriteNode(imageNamed: "background.png")
    
    private var didLoad: Bool = false
    
    private var timeLabel: SKLabelNode!
    private var time: Float = 0.00
    private var timeTimer: Timer!
    private var timeControl: Bool = false
    private var start: Bool = false
    
    
    required init?(coder aCoder:NSCoder) {
        super.init(coder: aCoder)
    }
    
    
    public override init(size: CGSize){
        super.init(size: size)
    }

    
    func buildPitstop(){
        
        for i in 0...45{
            let texture = SKTexture(imageNamed: "Mechanics3/Frame\(i).png")
            pitstopFrames.append(texture)
        }
        
        let firstFrameTexture = pitstopFrames[0]
        mechanics = SKSpriteNode(texture: firstFrameTexture)
        
        mechanics.position = CGPoint(x: frame.midX, y: frame.midY)
        mechanics.size = CGSize(width: 640, height: 480)
        
        resizeObjByWidth(obj: mechanics, new_width: size.width)
        
        mechanics.position.x = size.width/2
        mechanics.position.y = size.height/2
        
        addChild(mechanics)
        
    }


    func animatedPitstop(){
        mechanics.run(SKAction.animate(with: pitstopFrames, timePerFrame: 0.07, resize: false, restore: false))
        
    }
    
    
    public override func sceneDidLoad() {
        
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(background)
        
        do {
            try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "PitstopCompleto", ofType: "mp3")!))
        } catch {}
        
        buildPitstop()
        timeCount()
        didLoad = true
        
    }
    
    public override func didMove(to view: SKView) {
        
        animatedPitstop()
        player.volume = 1.0
        player.play()
    }
    
    
    public override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    
    public override func didChangeSize(_ oldSize:CGSize){
        
        if didLoad == true{
            
            if size.height > size.width{
                
                resizeObjByHeight(obj: background, new_height: size.height)
                background.position = CGPoint(x: size.width/2, y: size.height/2)
                
                mechanics.zRotation = 3.14 * 270.0 / 180.0
                
                resizeObjByWidth(obj: mechanics, new_width: background.size.width)
                mechanics.position.x = size.width/2
                mechanics.position.y = size.height/2
                
                timeLabel.position.x = frame.size.width / 2 + frame.size.width / 3.5
                timeLabel.position.y = frame.size.height / 2.2
                
            } else {
                
                resizeObjByWidth(obj: background, new_width: size.width)
                background.position = CGPoint(x: size.width/2, y: size.height/2)
                
                mechanics.zRotation = 0
                
                resizeObjByHeight(obj: mechanics, new_height: size.height)
                mechanics.position.x = size.width/2
                mechanics.position.y = size.height/2
                
                mechanics.zRotation = 0
                
                timeLabel.position.x = frame.size.width / 2 + frame.size.width / 3
                timeLabel.position.y = frame.size.height / 2 + frame.size.height / 3
                
            }
        }
    }
    
    
    func timeCount(){
        
        timeLabel = SKLabelNode(text: "\(time)")
        timeLabel.position.x = frame.size.width / 2 + frame.size.width / 3
        timeLabel.position.y = frame.size.height / 2 + frame.size.height / 3
        timeLabel.fontColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        timeLabel.fontName = "System-Bold"
        timeLabel.fontSize = 50
        timeLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        addChild(timeLabel)
        
        timeTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(pitTime), userInfo: nil, repeats: true)
    }
    
    @objc func pitTime() {
        
        if start == false{
            
            if String(format: "%.2f", time) == "0.77"{
                
                time = 0.00
                start = true
            }
        }
        
        time += 0.01
        print(time)
        
        if start == true{
            
            if String(format: "%.2f", time) <= "1.96"{
                    timeLabel.text = String(format: "%.2f", time)
            
            } else {
                timeTimer.invalidate()
                timeLabel.text = String(format: "%.2f", time)
                start = false
            }
        }
    }
    
    
    func resizeObjByWidth(obj:SKSpriteNode, new_width:CGFloat){
        let w_old = obj.size.width
        let h_old = obj.size.height
        let w_new = new_width
        let h_new = w_new * h_old/w_old
        obj.size = CGSize(width: w_new, height: h_new)
    }
    
    
    func resizeObjByHeight(obj:SKSpriteNode, new_height:CGFloat){
        let w_old = obj.size.width
        let h_old = obj.size.height
        let h_new = new_height
        let w_new = h_new * w_old/h_old
        obj.size = CGSize(width: w_new, height: h_new)
    }
}
