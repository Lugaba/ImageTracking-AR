//
//  ViewController.swift
//  AulaAR
//
//  Created by Luca Hummel on 30/05/22.
//

import UIKit
import RealityKit
import ARKit

class ViewController: UIViewController, ARSessionDelegate {
    
    @IBOutlet var arView: ARView!
    var objetos = [Entity]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARImageTrackingConfiguration()
        
        if let imagesToTrack = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: Bundle.main) {
            configuration.trackingImages = imagesToTrack
            configuration.maximumNumberOfTrackedImages = 2
        }
        
        arView.session.run(configuration)
        arView.session.delegate = self
    }
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors {
            guard let imageAnchor = anchor as? ARImageAnchor else { return }
            
            // veririficar se tem nome a ancora e se é o nome que queremos
            if let imageName = imageAnchor.name {
                var cartaObjeto = ""
                let entity = AnchorEntity(anchor: imageAnchor)
                
                if imageName == "carta" {
                    cartaObjeto = "donuts"
                } else if imageName == "carta1" {
                    cartaObjeto = "burger"
                }
                
                if let scene = try? Experience.loadBox() {
                    if let obj = scene.findEntity(named: cartaObjeto) {
                        obj.position.x = 0
                        objetos.append(obj)
                        entity.addChild(obj)
                        arView.scene.addAnchor(entity)
                    }
                }
            }
        }
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for objeto in objetos {
            objeto.transform.rotation *= simd_quatf(angle: 0.005, axis: SIMD3<Float>(0,1,0))
        }
    }
}
