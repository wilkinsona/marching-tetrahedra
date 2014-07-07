import SceneKit

@final class Cube {

    let vertices: Array<Vertex>

    init(v1: Vertex, v2: Vertex, v3: Vertex, v4: Vertex, v5: Vertex, v6: Vertex, v7: Vertex, v8: Vertex) {
        self.vertices = [v1, v2, v3, v4, v5, v6, v7, v8]
    }

    func isIntersected(threshold: Float) -> Bool {
        var overThreshold = 0
        for var i = 0; i < self.vertices.count; i++ {
            let vertex = self.vertices[i]
            if vertex.fieldStrength > threshold {
                overThreshold++
            }
            if (overThreshold > 0 && overThreshold <= i) {
                return true
            }
        }
        return false
    }

    func subdivide() -> [Tetrahedron] {
        return [
            Tetrahedron(v1: self.vertices[7], v2: self.vertices[3], v3: self.vertices[2], v4: self.vertices[0]),
            Tetrahedron(v1: self.vertices[0], v2: self.vertices[7], v3: self.vertices[6], v4: self.vertices[2]),
            Tetrahedron(v1: self.vertices[7], v2: self.vertices[0], v3: self.vertices[6], v4: self.vertices[4]),
            Tetrahedron(v1: self.vertices[0], v2: self.vertices[1], v3: self.vertices[2], v4: self.vertices[6]),
            Tetrahedron(v1: self.vertices[4], v2: self.vertices[1], v3: self.vertices[0], v4: self.vertices[6]),
            Tetrahedron(v1: self.vertices[5], v2: self.vertices[1], v3: self.vertices[4], v4: self.vertices[6])
        ]
    }
}
