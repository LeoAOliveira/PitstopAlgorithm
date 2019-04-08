//#-hidden-code
import PlaygroundSupport
import SpriteKit

var loop = 0

func raiseYourHand(){
    loop += 1
}

func getWheelGun(){}
func dropWheelGun(){}
func looseOldTire(){}
func lockNewTire(){}
func removeOldTire(){}
func putAwayOldTire(){}
func getNewTire(){}
func fitInNewTire(){}


//#-end-hidden-code
/*:
 # Fresh new tires
 
 You have already seen that changing one tire is a algorithm. But must be executed more than one time to complete four changes.
 
 A loop is a structure that repeats sequentially portion of code (an algorithm) for a set number of times. In Swift, one of the possible ways to do a loop is by using the method "for-in".
 
 The following code loops the algorithm seen before.
 
 ### WARNING: It may take some seconds to run the code, please wait until it loads!
 
*/

// The for loop may repeat 1, 2, 3 or 4 times

for tires in 1 ... /*#-editable-code number of repetitions*/4/*#-end-editable-code*/ {
    
    getWheelGun()
    looseOldTire()
    dropWheelGun()
    removeOldTire()
    putAwayOldTire()
    getNewTire()
    fitInNewTire()
    getWheelGun()
    lockNewTire()
    dropWheelGun()
    raiseYourHand()
    
}

//#-hidden-code
let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 640, height: 480))
let scene = LoopScene(size: sceneView.frame.size, loop: loop)

scene.scaleMode = .resizeFill
sceneView.presentScene(scene)

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
 
//#-end-hidden-code
