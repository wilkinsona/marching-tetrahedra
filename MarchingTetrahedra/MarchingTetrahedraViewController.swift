import UIKit
import SceneKit

#if os(macOS)
    typealias SCNColor = NSColor
#else
    typealias SCNColor = UIColor
#endif

class MarchingTetrahedraViewController: UIViewController {

    @IBOutlet private var sceneView: SCNView!

    @IBOutlet private var polygonLabel: UILabel!

    override func viewDidLoad() {
        let surface = Surface(width: 20, height:20, depth:20, cubeSize: 0.5, sources: [
            PointSource(position: SCNVector3(x: -2.5, y: 2, z: 0), radius: 2),
            PointSource(position: SCNVector3(x: 2.5, y: 2, z: 0), radius: 2),
            PointSource(position: SCNVector3(x: -2.5, y: 2, z: 1), radius: -1),
            PointSource(position: SCNVector3(x: 2.5, y: 2, z: 1), radius: -1),
            PointSource(position: SCNVector3(x: 0, y: -1, z: 0), radius: 6),
            PointSource(position: SCNVector3(x: 0, y: -1, z: 3.25), radius: 1)
        ])

        let (geometry, triangleCount) = surface.createGeometry()
        let material = SCNMaterial()
        material.diffuse.contents = SCNColor.red
        material.specular.contents = SCNColor.red
        geometry.materials = [material]

        let surfaceNode = SCNNode(geometry: geometry)

        let scene = SCNScene()
        scene.rootNode.addChildNode(surfaceNode)

        let diffuseLight = SCNLight()
        diffuseLight.color = SCNColor.lightGray
        diffuseLight.type = SCNLight.LightType.omni
        let lightNode = SCNNode()
        lightNode.light = diffuseLight
        lightNode.position = SCNVector3(x: -30, y:30, z:30)
        scene.rootNode.addChildNode(lightNode)

        let ambientLight = SCNLight()
        ambientLight.type = SCNLight.LightType.ambient
        let ambientLightNode = SCNNode()
        ambientLight.color = UIColor(white: 0.3, alpha: 1)
        ambientLightNode.light = ambientLight
        scene.rootNode.addChildNode(ambientLightNode)

        let camera = SCNCamera()
        camera.xFov = 45
        camera.yFov = 45
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        scene.rootNode.addChildNode(cameraNode)

        self.sceneView.scene = scene
        self.polygonLabel.text = "\(triangleCount) triangles"
    }
}
