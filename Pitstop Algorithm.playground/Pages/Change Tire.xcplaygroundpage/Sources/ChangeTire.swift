import Foundation
import AVFoundation
import SpriteKit
import PlaygroundSupport

public class ChangeTire: SKScene, AVAudioPlayerDelegate {
    
    private var didLoad: Bool = false
    
    private var car: SKSpriteNode!
    private var tire1: SKSpriteNode!
    private var tire2: SKSpriteNode!
    private var newIcon: SKSpriteNode!
    private var oldIcon: SKSpriteNode!
    private var wheelIcon: SKSpriteNode!
    private var finishIcon: SKSpriteNode!
    
    private var airGunZone: SKSpriteNode!
    
    public var selectTires: (String, String)
    public var selectCar: String
    
    private var tiresFrames1: [SKTexture] = []
    private var tiresFrames2: [SKTexture] = []
    private var tiresFrames3: [SKTexture] = []
    
    private var player1: AVAudioPlayer = AVAudioPlayer()
    private var player2: AVAudioPlayer = AVAudioPlayer()
    private var player3: AVAudioPlayer = AVAudioPlayer()
    
    private var didUseAirGun: Int!
    private var checkTire1: Int!
    private var checkTire2: Int!
    private var isTire2inPosition: Bool = false
    
    private var touchEnable: Bool = false
    private var wheelGunInHands: Bool = false
    
    private var counterLabel: SKLabelNode!
    private var counter = ["3", "2", "1", "GO!"]
    private var counterIndex = 0
    private var counterTimer: Timer!
    
    private var timeLabel: SKLabelNode!
    private var time: Float = 0.00
    private var timeTimer: Timer!
    private var timeControl: Bool = false
    
    private var done: Bool = false

    
    required init?(coder aCoder:NSCoder) {
        self.selectCar = "Blue"
        self.selectTires = ("Hard", "Medium")
        super.init(coder: aCoder)
    }
    
    
    public override init(size: CGSize){
        self.selectCar = "Blue"
        self.selectTires = ("Hard", "Medium")
        super.init(size: size)
    }
    
    public init(size: CGSize, cor : String = "Blue", pneu1: String = "Hard", pneu2: String = "Medium"){
        
        self.selectCar = cor
        
//        self.selectTires.0 = pneu1
//        self.selectTires.1 = pneu2
        self.selectTires = (pneu1, pneu2)
        
        super.init(size: size)
    }
    
    
    // MARK: - OVERRIDE FUNCS
    
    public override func sceneDidLoad() {
            backgroundColor = #colorLiteral(red: 0.8439578485, green: 0.8523138668, blue: 0.8523138668, alpha: 1)
            buildCar()
            buildIcons()
            buildCT()
            buildAirGunZone()
            loadAudios()
            countdown()
            
            didLoad = true
            didChangeSize(size)
            
            checkTire1 = 1
            checkTire2 = 0
    }
    
    public override func didMove(to view: SKView) {
        
//        print("x: \(tire1.position.x), y: \(tire1.position.y)")
    }
    
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if touchEnable == true{
            
            for touch in touches{
                
                let loc = touch.location(in: self)
                let nodesAtLoc = self.nodes(at: loc)
                
                if nodesAtLoc.contains(wheelIcon){
                    
                    if wheelIcon.name == "W1"{
                        
                        wheelIcon.texture = SKTexture(imageNamed: "CarsAndTires/WheelIcon2.png")
                        wheelIcon.name = "W2"
                        wheelGunInHands = true
                        
                    } else{
                        
                        wheelIcon.texture = SKTexture(imageNamed: "CarsAndTires/WheelIcon1.png")
                        wheelIcon.name = "W1"
                        wheelGunInHands = false
                    }
                }
                
                if wheelGunInHands == true{
                    
                    if nodesAtLoc.contains(airGunZone){
                        
                        player1.play()
                        
                        checkTire1 = 0
                        
                        if isTire2inPosition == true{
                            
                            done = true
                        }
                        
                    }
                    
                } else{
                    
                    if tire1.isHidden == true{
                        
                        if nodesAtLoc.contains(newIcon){
                            tire2.isHidden = false
                        }
                        
                    }
                    
                    if nodesAtLoc.contains(finishIcon){
                        
                        touchEnable = false
                        
                        counterLabel.fontSize = 25
                        counterLabel.horizontalAlignmentMode = .center                        
                        
                        if done == true{
                            if time <= 4.0{
                                counterLabel.text = "GREAT PITSTOP"
                            } else if time > 4.0 && time < 6.0{
                                counterLabel.text = "GOOD JOB"
                            } else if time > 6.0 && time < 8.0{
                                counterLabel.text = "YOU CAN DO IT BETTER"
                            } else if time > 8.0{
                                counterLabel.text = "TOO SLOW"
                            }
                        
                        } else {
                            counterLabel.numberOfLines = 2
                            counterLabel.text = "FAILED PITSTOP!\nYou need to do all steps"
                        }
                    }
                }
            }
        }
    }
    
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        if touchEnable == true{
            
            for touch in touches{
                
                let loc = touch.location(in: self)
                let nodesAtLoc = self.nodes(at: loc)
                
                if wheelGunInHands == false{
                
                    if checkTire1 == 0{
                        
                        if nodesAtLoc.contains(tire1){
                            tire1.position = loc
                        }
                    }
                    
                    if checkTire2 == 0{
                        
                        if nodesAtLoc.contains(tire2){
                            tire2.position = loc
                        }
                    }
                }
            }
        }
    }
    
    
    public override func update(_ currentTime: TimeInterval) {
        
        if checkTire2 == 0{
            
            if tire2.intersects(airGunZone){
                tire2.position = CGPoint(x: 0.60720268 * frame.width, y: 0.3956834532 * car.size.height)
                player2.play()
                checkTire2 = 1
                
                isTire2inPosition = true
            }
        }
        
        if checkTire1 == 0{
            
            if tire1.intersects(oldIcon){
                tire1.isHidden = true
                checkTire1 = 1
            }
        }
    }
    
    
    public override func didChangeSize(_ oldSize:CGSize){
        
        if didLoad == true{
            
            if size.height > size.width{
                
                if oldSize.width > size.width{
                    // FULL SCREEN
                    
                    resizeObjByWidth(obj: newIcon, new_width: 0.10 * size.width)
                    newIcon.position = CGPoint(x: 0.1608040201 * car.size.width, y: 1.0647482014 * car.size.height)
                    
                    resizeObjByWidth(obj: oldIcon, new_width: 0.10 * size.width)
                    oldIcon.position = CGPoint(x: 0.3869346734 * car.size.width, y: 1.0647482014 * car.size.height)
                    
                    resizeObjByWidth(obj: wheelIcon, new_width: 0.10 * size.width)
                    wheelIcon.position = CGPoint(x: 0.6130653266 * car.size.width, y: 1.0647482014 * car.size.height)
                    
                    resizeObjByWidth(obj: finishIcon, new_width: 0.10 * size.width)
                    finishIcon.position = CGPoint(x: 0.8391959799 * car.size.width, y: 1.0647482014 * car.size.height)
                    
                } else{
                
                    resizeObjByWidth(obj: newIcon, new_width: 0.09212730318 * size.width)
                    newIcon.position = CGPoint(x: 0.1608040201 * car.size.width, y: 1.0647482014 * car.size.height)
                    
                    resizeObjByWidth(obj: oldIcon, new_width: 0.09212730318 * size.width)
                    oldIcon.position = CGPoint(x: 0.3869346734 * car.size.width, y: 1.0647482014 * car.size.height)
                    
                    resizeObjByWidth(obj: wheelIcon, new_width: 0.09212730318 * size.width)
                    wheelIcon.position = CGPoint(x: 0.6130653266 * car.size.width, y: 1.0647482014 * car.size.height)
                    
                    resizeObjByWidth(obj: finishIcon, new_width: 0.09212730318 * size.width)
                    finishIcon.position = CGPoint(x: 0.8391959799 * car.size.width, y: 1.0647482014 * car.size.height)
                }
                
                counterLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 + size.height / 3)
                
                if timeControl == true{
                    timeLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 + size.height / 3)
                }
                
            } else {

                resizeObjByWidth(obj: newIcon, new_width: 0.10 * size.width)
                newIcon.position = CGPoint(x: 0.05695142379 * car.size.width, y: 0.09352517986 * car.size.height)

                resizeObjByWidth(obj: oldIcon, new_width: 0.10 * size.width)
                oldIcon.position = CGPoint(x: 0.1733668342 * car.size.width, y: 0.09352517986 * car.size.height)

                resizeObjByWidth(obj: wheelIcon, new_width: 0.10 * size.width)
                wheelIcon.position = CGPoint(x: 0.2889447236 * car.size.width, y: 0.09352517986 * car.size.height)

                resizeObjByWidth(obj: finishIcon, new_width: 0.10 * size.width)
                finishIcon.position = CGPoint(x: 0.4045226131 * car.size.width, y: 0.09352517986 * car.size.height)
                
                counterLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 + size.height / 3)
                
                if timeControl == true{
                    timeLabel.position = CGPoint(x: size.width / 2 + size.width / 3, y: size.height / 2 + size.height / 3)
                }
                    
            }
            
            resizeObjByWidth(obj: car, new_width: size.width)
            car.position = CGPoint(x: frame.midX, y: car.size.height - car.size.height/2)
            
            resizeObjByWidth(obj: airGunZone, new_width: 0.1 * size.width)
            resizeObjByHeight(obj: airGunZone, new_height: 0.1 * size.height)
            airGunZone.position = CGPoint(x: 0.60720268 * frame.width, y: 0.3956834532 * car.size.height)
            
            resizeObjByWidth(obj: tire1, new_width: 0.21273032 * size.width)
            tire1.position = CGPoint(x: 0.60720268 * frame.width, y: 0.3956834532 * car.size.height)
            
            resizeObjByWidth(obj: tire2, new_width: 0.21273032 * size.width)
            tire2.position = newIcon.position
            
        }
    }
    
    
//    func horizontal(){
//
//        if newSize
//    }
    
    
// BUILD OBJECTS (car, tires, wheel gun zone and icons)
    
    func buildCT(){
        
        print(selectTires)
        
        // selectTires = ("Hard","Medium")
        
        if selectTires.0 == "Hard"{
            tire1 = SKSpriteNode(imageNamed: "CarsAndTires/HTire.png")
        }
        
        if selectTires.1 == "Hard"{
            tire2 = SKSpriteNode(imageNamed: "CarsAndTires/HTire.png")
        }
        
        if selectTires.0 == "Medium"{
            tire1 = SKSpriteNode(imageNamed: "CarsAndTires/MTire.png")
        }
        
        if selectTires.1 == "Medium"{
            tire2 = SKSpriteNode(imageNamed: "CarsAndTires/MTire.png")
        }
        
        if selectTires.0 == "Soft"{
            tire1 = SKSpriteNode(imageNamed: "CarsAndTires/STire.png")
        }
        
        if selectTires.1 == "Soft"{
            tire2 = SKSpriteNode(imageNamed: "CarsAndTires/STire.png")
        }
        
        
        resizeObjByWidth(obj: tire1, new_width: 0.21273032 * size.width)
        resizeObjByWidth(obj: tire2, new_width: 0.21273032 * size.width)
        
        tire1.position = CGPoint(x: 0.60720268 * frame.width, y: 0.3956834532 * car.size.height)
        tire2.position = CGPoint(x: 0.27554439 * frame.width, y: 0.3956834532 * car.size.height)
        
        addChild(tire1)
        addChild(tire2)
        
        tire1.isHidden = false
        tire2.isHidden = true
    }
    
    
    func buildAirGunZone(){
        
        airGunZone = SKSpriteNode()
        airGunZone.size = CGSize(width: 100, height: 100)
        resizeObjByWidth(obj: airGunZone, new_width: 0.1 * size.width)
        resizeObjByHeight(obj: airGunZone, new_height: 0.1 * size.height)
        airGunZone.position = CGPoint(x: 0.60720268 * frame.width, y: 0.3956834532 * car.size.height)
        addChild(airGunZone)
    }
    
    
    func buildCar(){
        
        // selectCar = "Orange"
        
        if selectCar == "Blue" || selectCar == "blue"{
            car = SKSpriteNode(imageNamed: "CarsAndTires/Blue.png")
            
        } else if selectCar == "Orange" || selectCar == "orange"{
            car = SKSpriteNode(imageNamed: "CarsAndTires/Orange.png")
            
        } else if selectCar == "Pink" || selectCar == "pink"{
            car = SKSpriteNode(imageNamed: "CarsAndTires/Pink.png")
            
        } else if selectCar == "Senna" || selectCar == "senna"{
            car = SKSpriteNode(imageNamed: "CarsAndTires/Senna.png")

        } else{
            car = SKSpriteNode(imageNamed: "CarsAndTires/Blue.png")
        }
        
        resizeObjByWidth(obj: car, new_width: size.width)
        car.position = CGPoint(x: frame.midX, y: car.size.height - car.size.height/2)
        
        addChild(car)
    }
    
    
    func buildIcons(){
        
        newIcon = SKSpriteNode(imageNamed: "CarsAndTires/NewIcon.png")
        oldIcon = SKSpriteNode(imageNamed: "CarsAndTires/OldIcon.png")
        wheelIcon = SKSpriteNode(imageNamed: "CarsAndTires/WheelIcon1.png")
        wheelIcon.name = "W1"
        finishIcon = SKSpriteNode(imageNamed: "CarsAndTires/FinishIcon.png")
        
        resizeObjByWidth(obj: newIcon, new_width: 0.12562814 * size.width)
        newIcon.position = CGPoint(x: 0.44053601 * car.size.width, y: 0.87889688 * car.size.height)
        
        resizeObjByWidth(obj: oldIcon, new_width: 0.12562814 * size.width)
        oldIcon.position = CGPoint(x: 0.59966499 * car.size.width, y: 0.87889688 * car.size.height)
        
        resizeObjByWidth(obj: wheelIcon, new_width: 0.12562814 * size.width)
        wheelIcon.position = CGPoint(x: 0.75879397 * car.size.width, y: 0.87889688 * car.size.height)
        
        resizeObjByWidth(obj: finishIcon, new_width: 0.12562814 * size.width)
        finishIcon.position = CGPoint(x: 0.91792295 * car.size.width, y: 0.87889688 * car.size.height)
        
        addChild(newIcon)
        addChild(oldIcon)
        addChild(wheelIcon)
        addChild(finishIcon)
    }
    
    
    func countdown(){
        
        counterLabel = SKLabelNode(text: counter[counterIndex])
        counterLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 + size.height / 3)
        
        counterLabel.fontColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        counterLabel.fontName = "System-Bold"
        counterLabel.fontSize = 70
        addChild(counterLabel)
        
        counterTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(count), userInfo: nil, repeats: true)
        
        player3.play()
    }
    
    @objc func count() {
       
        counterLabel.text = counter[counterIndex]
        
        if counterIndex < counter.count - 1 {
            counterIndex += 1
            
        } else {
            counterTimer.invalidate()
            counterLabel.text = ""
            touchEnable = true
            timeCount()
            player3.stop()
        }
    }
    
    
    func timeCount(){
        
        timeLabel = SKLabelNode(text: "\(time)")
        timeLabel.position.x = size.width / 2 + size.width / 3
        timeLabel.position.y = size.height / 2 + size.height / 3
        timeLabel.fontColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        timeLabel.fontName = "System-Bold"
        timeLabel.fontSize = 25
        timeLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        addChild(timeLabel)
        
        timeTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(pitTime), userInfo: nil, repeats: true)
    }
    
    @objc func pitTime() {
        
        timeControl = true
        
        if touchEnable == true{
            timeLabel.text = String(format: "%.2f", time)
            time += 0.01
            
        } else{
            timeTimer.invalidate()
            timeLabel.text = String(format: "%.2f", time)
        }
    }
    

// AUDIOS
    
    func loadAudios(){
        
        do {
            try player1 = AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "Audios/PitstopParte1", ofType: "mp3")!))
        } catch {}
        
        do {
            try player2 = AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "Audios/PitstopParte2", ofType: "mp3")!))
        } catch {}
        
        do {
            try player3 = AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "Audios/Box", ofType: "mp3")!))
        } catch {}
    }
    
    
// RESIZE
    
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
