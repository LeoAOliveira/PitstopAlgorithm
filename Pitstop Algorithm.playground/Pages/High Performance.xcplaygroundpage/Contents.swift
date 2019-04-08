//#-hidden-code
import PlaygroundSupport
import SpriteKit
let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 640, height: 480))
let scene = PitstopScene(size: CGSize(width: 640, height: 480))
scene.scaleMode = .resizeFill
sceneView.presentScene(scene)
PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
//#-end-hidden-code

/*:
 # High performance
 
 As presented, the loop method execute all four tires changes. On the other hand, it's not efficient once it tooks 11.90 seconds to complete the task.

 To achieve high performance problem solver, with precision and speed it's necessary more resources. In racing, a team needs around 12 mechanics to execute the pitstop, changing all tires simultaneously in few seconds.
 
 In computing terms, it's possible to achive this efficiency with paralell computing. This is a computing way where many tasks are executed simultaneously in high speed. One method is when larger tasks (changing four tires) are divided in smaller ones (changing one tire). Despite being more difficult to implement than sequecial methods, parallel computing has higher performance.
 
  ### WARNING: It may take some seconds to run the code, please wait until it loads!

*/
