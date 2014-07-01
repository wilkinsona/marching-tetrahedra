import SceneKit

extension SCNVector3 {

    mutating func normalize() {
        self = self / length()
    }

    func length() -> Float {
        return sqrtf((self.x * self.x) + (self.y * self.y) + (self.z * self.z))
    }

    func crossProduct(other: SCNVector3) -> SCNVector3 {
        return SCNVector3(
            x: (self.y * other.z) - (self.z * other.y),
            y: (self.z * other.x) - (self.x * other.z),
            z: (self.x * other.y) - (self.y * other.x))
    }
}

@infix func - (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3(x: left.x - right.x, y: left.y - right.y, z: left.z - right.z)
}

@infix func + (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3(x: left.x + right.x, y: left.y + right.y, z: left.z + right.z)
}

@assignment func += (inout left: SCNVector3, right: SCNVector3) {
    left = left + right
}

@infix func / (left: SCNVector3, right: Float) -> SCNVector3 {
    return SCNVector3(x: left.x / right, y: left.y / right, z: left.z / right)
}