//#-hidden-code
import PlaygroundSupport
import SpriteKit
// PlaygroundSupport.PlaygroundPage.current.liveView = sceneView

var selectCarColor : String = "Blue"
var selectOldTires : String = "Hard"
var selectNewTires : String = "Medium"

//#-end-hidden-code
/*:
 # Box, box, box!
 
 Racing is a sport that it’s always on the limit, where any mistake can mean victory or fail. The right pitstop on the right time is crucial for a good result. A team of mechanics replace all four of its tires and release the car in less than 3 seconds. It’s not an easy task. It requires the execution of a series of steps with high precision and speed. It’s an algorithm that must be perfectly executed for everything to goes right.
 
 Now, you will change one of tires of our car following the algorithm:
 
1. Get the wheel gun
 
 ![Wheel gun Icon](WheelIcon1.png)
 
2. Loose the tire with the wheel gun by tapping the center of the tire
 
 ![Center of the tire](HTire.png)
 
3. Drop the wheel gun

 ![Wheel gun Icon](WheelIcon2.png)
 
4. Remove the old tire by dragging

 ![Drag the tire](HTire.png)
 
5. Put the old tire away

 ![Old tire Icon](OldIcon.png)
 
6. Get the new tire

 ![New tire Icon](NewIcon.png)
 
7. Fit in the new tire by dragging

 ![Drag the tire](MTire.png)

8. Get the wheel gun

 ![Wheel gun Icon](WheelIcon1.png)
 
9. Lock the tire with the wheel gun by tapping the center of the tire

 ![Center of the tire](MTire.png)
 
10. Drop the wheel gun

 ![Wheel gun Icon](WheelIcon2.png)
 
11. Raise your hand to finish

 ![Finish Icon](FinishIcon.png)
 
Use full screen mode for a better experience. Good luck!
*/

// The color of the car may be Blue, Orange or Pink

selectCarColor = /*#-editable-code color*/"Blue"/*#-end-editable-code*/

// The tires may be Hard, Medium or Soft

selectOldTires = /*#-editable-code color*/"Hard"/*#-end-editable-code*/

selectNewTires = /*#-editable-code color*/"Medium"/*#-end-editable-code*/

//#-hidden-code
let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 640, height: 480))
let scene = ChangeTire(size: sceneView.frame.size, cor: selectCarColor, pneu1: selectOldTires, pneu2: selectNewTires)

scene.scaleMode = .resizeFill
sceneView.presentScene(scene)

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
//#-end-hidden-code
