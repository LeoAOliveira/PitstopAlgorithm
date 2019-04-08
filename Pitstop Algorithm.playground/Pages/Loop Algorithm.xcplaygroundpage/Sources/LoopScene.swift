import PlaygroundSupport
import SpriteKit
import Foundation
import AVFoundation

public class LoopScene: SKScene, AVAudioPlayerDelegate {
    
    private var mechanics:SKSpriteNode!
    private var pitstopFrames: [SKTexture] = []
    
    private var forLoop: Int!

    private var player: AVAudioPlayer = AVAudioPlayer()
    private let background = SKSpriteNode(imageNamed: "background.png")

    private var didLoad: Bool = false
    
    private var timeLabel: SKLabelNode!
    private var time: Float = 0.00
    private var timeTimer: Timer!
    private var timeControl: Bool = false
    private var start: Bool = false


    required init?(coder aCoder:NSCoder) {
        self.forLoop = 4
        super.init(coder: aCoder)
    }
    
    
    public override init(size: CGSize){
        self.forLoop = 4
        super.init(size: size)
    }
    
    public init(size: CGSize, loop : Int = 4){
        
        self.forLoop = loop
        
        super.init(size: size)
    }


    func buildPitstop(){

        let firstFrameTexture = SKTexture(imageNamed: "Mechanics2/Frame0.png")
        
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
    
    
    func forLoop1(){
        
        for i in 0...40{
            let texture = SKTexture(imageNamed: "Mechanics2/Frame\(i).png")
            pitstopFrames.append(texture)
        }
        
        for i in 188...194{
            let texture = SKTexture(imageNamed: "Mechanics2/Frame\(i).png")
            pitstopFrames.append(texture)
        }
    }
    
    
    func forLoop2(){
        
        for i in 0...85{
            let texture = SKTexture(imageNamed: "Mechanics2/Frame\(i).png")
            pitstopFrames.append(texture)
        }
        
        for i in 195...201{
            let texture = SKTexture(imageNamed: "Mechanics2/Frame\(i).png")
            pitstopFrames.append(texture)
        }
    }
    
    
    func forLoop3(){
        
        for i in 0...133{
            let texture = SKTexture(imageNamed: "Mechanics2/Frame\(i).png")
            pitstopFrames.append(texture)
        }
        
        for i in 202...208{
            let texture = SKTexture(imageNamed: "Mechanics2/Frame\(i).png")
            pitstopFrames.append(texture)
        }
    }
    
    func forLoop4(){
        
        for i in 0...187{
            let texture = SKTexture(imageNamed: "Mechanics2/Frame\(i).png")
            pitstopFrames.append(texture)
        }
    }
    
    func audio(loop: Int) {
        
        if loop >= 1 && loop <= 4{
            
            do {
                try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "PitstopLoop\(loop)", ofType: "mp3")!))
            } catch {}
        
        } else{
            
            do {
                try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "PitstopLoop\(4)", ofType: "mp3")!))
            } catch {}
        }
    }


    public override func sceneDidLoad() {
        
        if forLoop == 1{
            forLoop1()
            
        } else if forLoop == 2{
            forLoop2()
            
        } else if forLoop == 3{
            forLoop3()
            
        } else if forLoop == 4{
            forLoop4()
            
        } else{
            forLoop4()
        }

        background.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(background)
        
        audio(loop: forLoop)

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
            
            if forLoop == 1{
                
                if String(format: "%.2f", time) <= "2.10"{
                    timeLabel.text = String(format: "%.2f", time)
                } else{
                    timeTimer.invalidate()
                    timeLabel.text = String(format: "%.2f", time)
                    start = false
                }
                
            } else if forLoop == 2{
                
                if String(format: "%.2f", time) <= "5.25"{
                    timeLabel.text = String(format: "%.2f", time)
                } else{
                    timeTimer.invalidate()
                    timeLabel.text = String(format: "%.2f", time)
                    start = false
                }
                
            } else if forLoop == 3{
                
                if String(format: "%.2f", time) <= "8.61"{
                    timeLabel.text = String(format: "%.2f", time)
                } else{
                    timeTimer.invalidate()
                    timeLabel.text = String(format: "%.2f", time)
                    start = false
                }
                
            } else if forLoop == 4{
                
                if time <= 11.90{
                    timeLabel.text = String(format: "%.2f", time)
                } else{
                    
                    print("ok")
                    timeTimer.invalidate()
                    timeLabel.text = String(format: "%.2f", time)
                    start = false
                }
                
            } else {
                
                if time <= 11.90{
                    timeLabel.text = String(format: "%.2f", time)
                } else{
                    timeTimer.invalidate()
                    timeLabel.text = String(format: "%.2f", time)
                    start = false
                }
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

