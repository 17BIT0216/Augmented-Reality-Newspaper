//
//  ViewController.swift
//  MagicPaper
//
//  Created by Angela Yu on 21/07/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!   //usually we use an UI View but here we are using ARSCN view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration() // to track the anchors
        
        if let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "NewsPaperImages", bundle: Bundle.main)
        { // tell what images are to be tracked where are they to be found
            
            configuration.trackingImages = trackedImages
            
            configuration.maximumNumberOfTrackedImages = 10  // how many images can be tracked at a single point
            
        }

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    
    
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        //1. Check We Have Detected An ARImageAnchor
        guard let validAnchor = anchor as? ARImageAnchor else { return }
        
        
        //2. Create A Video Player Node For Each Detected Target
        node.addChildNode(createdVideoPlayerNodeFor(validAnchor.referenceImage))
        
    }

    func createdVideoPlayerNodeFor(_ target: ARReferenceImage) -> SCNNode{
        
        //1. Create An SCNNode To Hold Our VideoPlayer
        let videoPlayerNode = SCNNode()
        
        //2. Create An SCNPlane & An AVPlayer
        let videoPlayerGeometry = SCNPlane(width: target.physicalSize.width, height: target.physicalSize.height)
        var videoPlayer = AVPlayer()
        
        //3. If We Have A Valid anchor Name & A Valid Video URL The Instanciate The AVPlayer
        if let targetName = target.name,
            let validURL = Bundle.main.url(forResource: targetName, withExtension: "mp4", subdirectory: "/art.scnassets") {
            videoPlayer = AVPlayer(url: validURL)
            videoPlayer.play()
        }
        
        //4. Assign The AVPlayer & The Geometry To The Video Player
        videoPlayerGeometry.firstMaterial?.diffuse.contents = videoPlayer
        videoPlayerNode.geometry = videoPlayerGeometry
        
        //5. Rotate It by 90 degrees
        videoPlayerNode.eulerAngles.x = -.pi / 2
        
        return videoPlayerNode
        
    }
    
}
    
    

