//
//  ViewController.swift
//  Practice-Adding-Plane-2
//
//  Created by Maher Bhavsar on 25/07/19.
//  Copyright © 2019 Seven Dots. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!

        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        UIApplication.shared.isIdleTimerDisabled = true
        self.sceneView.autoenablesDefaultLighting = false
        // Run the view's session
        sceneView.session.run(configuration)
        
         addGestures()
    }
    func addGestures () {
        let tapped = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
        
        sceneView.addGestureRecognizer(tapped)
        
        
    }
    
    
    @objc func tapGesture (sender: UITapGestureRecognizer) {
        let location = sender.location(in: sceneView)
        let hitTest = sceneView.hitTest(location, types: .existingPlaneUsingExtent)
        
        if hitTest.isEmpty {
            print("No Plane Detected")
        } else {
//            sceneView.scene.rootNode.enumerateChildNodes { (child, _) in
//                if child.name == "MeshNode" || child.name == "TextNode" {
//                    child.removeFromParentNode()
//                }
//            }
            let scene = SCNScene(named: "art.scnassets/ship.scn")!
            let node = scene.rootNode.childNode(withName: "shipMesh", recursively: true)
            //node?.geometry?.firstMaterial?.diffuse.contents = UIImage()
            
            let columns = hitTest.first?.worldTransform.columns.3
            
            node!.position = SCNVector3(x: columns!.x, y: columns!.y, z: columns!.z)
            
            sceneView.scene.rootNode.addChildNode(node!)
            
            
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
