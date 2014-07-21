import SceneKit

final class Point {

    let position: SCNVector3
    var normals: Array<SCNVector3> = Array()

    init(position: SCNVector3) {
        self.position = position
    }
}
