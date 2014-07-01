@final class Tetrahedron {

    let vertices: Vertex[]

    init(v1: Vertex, v2: Vertex, v3: Vertex, v4: Vertex) {
        self.vertices = [v1, v2, v3, v4]
    }

    func intersectionsWithThreshold(threshold: Float) -> Array<Intersection> {
        var intersections = Array<Intersection>()

        var intersectionType = 0
        var bit = 1
        for var i = 0; i < self.vertices.count; i++ {
            let vertex = self.vertices[i]
            if (vertex.fieldStrength >= threshold) {
                intersectionType |= bit
            }
            bit <<= 1
        }

        if (intersectionType == 1) {
            intersections.append(
                Intersection(
                     edge1: Edge(vertex1: self.vertices[0], vertex2: self.vertices[1]),
                     edge2: Edge(vertex1: self.vertices[0], vertex2: self.vertices[2]),
                     edge3: Edge(vertex1: self.vertices[0], vertex2: self.vertices[3])
               )
            )
        } else if (intersectionType == 2) {
            intersections.append(
                Intersection(
                     edge1: Edge(vertex1: self.vertices[1], vertex2: self.vertices[0]),
                     edge2: Edge(vertex1: self.vertices[1], vertex2: self.vertices[3]),
                     edge3: Edge(vertex1: self.vertices[1], vertex2: self.vertices[2])
               )
            )
        } else if (intersectionType == 3) {
            intersections.append(
                Intersection(
                     edge1: Edge(vertex1: self.vertices[1], vertex2: self.vertices[3]),
                     edge2: Edge(vertex1: self.vertices[0], vertex2: self.vertices[2]),
                     edge3: Edge(vertex1: self.vertices[0], vertex2: self.vertices[3])
               )
            )

            intersections.append(
                Intersection(
                     edge1: Edge(vertex1: self.vertices[1], vertex2: self.vertices[3]),
                     edge2: Edge(vertex1: self.vertices[1], vertex2: self.vertices[2]),
                     edge3: Edge(vertex1: self.vertices[0], vertex2: self.vertices[2])
               )
            )
        } else if (intersectionType == 4) {
            intersections.append(
                Intersection(
                     edge1: Edge(vertex1: self.vertices[2], vertex2: self.vertices[0]),
                     edge2: Edge(vertex1: self.vertices[2], vertex2: self.vertices[1]),
                     edge3: Edge(vertex1: self.vertices[2], vertex2: self.vertices[3])
               )
            )
        } else if (intersectionType == 5) {
            intersections.append(
                Intersection(
                     edge1: Edge(vertex1: self.vertices[0], vertex2: self.vertices[1]),
                     edge2: Edge(vertex1: self.vertices[2], vertex2: self.vertices[3]),
                     edge3: Edge(vertex1: self.vertices[0], vertex2: self.vertices[3])
               )
            )

            intersections.append(
                Intersection(
                     edge1: Edge(vertex1: self.vertices[0], vertex2: self.vertices[1]),
                     edge2: Edge(vertex1: self.vertices[1], vertex2: self.vertices[2]),
                     edge3: Edge(vertex1: self.vertices[2], vertex2: self.vertices[3])
               )
            )
        } else if (intersectionType == 6) {
            intersections.append(
                Intersection(
                     edge1: Edge(vertex1: self.vertices[0], vertex2: self.vertices[1]),
                     edge2: Edge(vertex1: self.vertices[1], vertex2: self.vertices[3]),
                     edge3: Edge(vertex1: self.vertices[2], vertex2: self.vertices[3])
               )
            )

            intersections.append(
                Intersection(
                     edge1: Edge(vertex1: self.vertices[2], vertex2: self.vertices[3]),
                     edge2: Edge(vertex1: self.vertices[0], vertex2: self.vertices[2]),
                     edge3: Edge(vertex1: self.vertices[0], vertex2: self.vertices[1])
               )
            )
        } else if (intersectionType == 7) {
            intersections.append(
                Intersection(
                     edge1: Edge(vertex1: self.vertices[3], vertex2: self.vertices[1]),
                     edge2: Edge(vertex1: self.vertices[3], vertex2: self.vertices[2]),
                     edge3: Edge(vertex1: self.vertices[3], vertex2: self.vertices[0])
               )
            )
        }  else if (intersectionType == 8) {
            intersections.append(
                Intersection(
                     edge1: Edge(vertex1: self.vertices[3], vertex2: self.vertices[0]),
                     edge2: Edge(vertex1: self.vertices[3], vertex2: self.vertices[2]),
                     edge3: Edge(vertex1: self.vertices[3], vertex2: self.vertices[1])
               )
            )
        } else if (intersectionType == 9) {
            intersections.append(
                Intersection(
                     edge1: Edge(vertex1: self.vertices[2], vertex2: self.vertices[3]),
                     edge2: Edge(vertex1: self.vertices[1], vertex2: self.vertices[3]),
                     edge3: Edge(vertex1: self.vertices[0], vertex2: self.vertices[1])
               )
            )

            intersections.append(
                Intersection(
                     edge1: Edge(vertex1: self.vertices[0], vertex2: self.vertices[1]),
                     edge2: Edge(vertex1: self.vertices[0], vertex2: self.vertices[2]),
                     edge3: Edge(vertex1: self.vertices[2], vertex2: self.vertices[3])
               )
            )
        } else if (intersectionType == 10) {
            intersections.append(
                Intersection(
                     edge1: Edge(vertex1: self.vertices[0], vertex2: self.vertices[3]),
                     edge2: Edge(vertex1: self.vertices[2], vertex2: self.vertices[3]),
                     edge3: Edge(vertex1: self.vertices[0], vertex2: self.vertices[1])
               )
            )

            intersections.append(
                Intersection(
                     edge1: Edge(vertex1: self.vertices[2], vertex2: self.vertices[3]),
                     edge2: Edge(vertex1: self.vertices[1], vertex2: self.vertices[2]),
                     edge3: Edge(vertex1: self.vertices[0], vertex2: self.vertices[1])
               )
            )
        } else if (intersectionType == 11) {
            intersections.append(
                Intersection(
                     edge1: Edge(vertex1: self.vertices[2], vertex2: self.vertices[3]),
                     edge2: Edge(vertex1: self.vertices[2], vertex2: self.vertices[1]),
                     edge3: Edge(vertex1: self.vertices[2], vertex2: self.vertices[0])
               )
            )
        } else if (intersectionType == 12) {
            intersections.append(
                Intersection(
                     edge1: Edge(vertex1: self.vertices[0], vertex2: self.vertices[3]),
                     edge2: Edge(vertex1: self.vertices[0], vertex2: self.vertices[2]),
                     edge3: Edge(vertex1: self.vertices[1], vertex2: self.vertices[3])
               )
            )

            intersections.append(
                Intersection(
                     edge1: Edge(vertex1: self.vertices[0], vertex2: self.vertices[2]),
                     edge2: Edge(vertex1: self.vertices[1], vertex2: self.vertices[2]),
                     edge3: Edge(vertex1: self.vertices[1], vertex2: self.vertices[3])
               )
            )
        } else if (intersectionType == 13) {
            intersections.append(
                Intersection(
                     edge1: Edge(vertex1: self.vertices[1], vertex2: self.vertices[2]),
                     edge2: Edge(vertex1: self.vertices[1], vertex2: self.vertices[3]),
                     edge3: Edge(vertex1: self.vertices[1], vertex2: self.vertices[0])
               )
            )
        } else if (intersectionType == 14) {
            intersections.append(
                Intersection(
                     edge1: Edge(vertex1: self.vertices[0], vertex2: self.vertices[3]),
                     edge2: Edge(vertex1: self.vertices[0], vertex2: self.vertices[2]),
                     edge3: Edge(vertex1: self.vertices[0], vertex2: self.vertices[1])
               )
            )
        }

        return intersections
    }
}
