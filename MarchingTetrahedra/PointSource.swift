import SceneKit

final class PointSource: Source {

    private let position: SCNVector3

    private let radius: Float

    init(position: SCNVector3, radius: Float) {
        self.position = position
        self.radius = radius
    }

    func strengthAtPosition(position: SCNVector3) -> Float {
        let distance = (self.position - position).length()
        if (distance < abs(self.radius)) {
            let component1 = -0.444444 * (powf(distance, 6) / powf(self.radius, 6))
            let component2 = 1.888889 * (powf(distance, 4) / powf(self.radius, 4))
            let component3 = -2.444445 * (powf(distance, 2) / powf(self.radius, 2))
            let strength = component1 + component2 + component3 + 1.0
            if (self.radius < 0) {
                return -1 * strength;
            } else {
                return strength;
            }
        } else {
            return 0
        }
    }
}
