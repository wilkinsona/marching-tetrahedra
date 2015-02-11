import SceneKit

final class Surface {

    private let accuracy: Float = 0.00001

    private let threshold: Float = 0.5

    private let sources: Array<Source>

    private let width: Int

    private let height: Int

    private let depth: Int

    private let cubeSize: Float

    private var pointIndexByEdge: Dictionary<Edge, Int32> = Dictionary(minimumCapacity: 4096)

    private var points: Array<Point> = Array()

    private var indexes: Array<Int32> = Array()

    init(width: Int, height: Int, depth: Int, cubeSize: Float, sources:Array<Source>) {
        self.width = width
        self.height = height
        self.depth = depth

        self.cubeSize = cubeSize
        
        self.sources = sources
    }

    func createGeometry() -> (SCNGeometry, Int) {
        self.points.removeAll(keepCapacity: true)
        self.pointIndexByEdge.removeAll(keepCapacity: true)
        self.indexes.removeAll(keepCapacity: true)

        for cube in createCubes() {
            if (cube.isIntersected(self.threshold)) {
                for tetrahedron in cube.subdivide() {
                    for intersection in tetrahedron.intersectionsWithThreshold(self.threshold) {
                        self.addPolygonForIntersection(intersection)
                    }
                }
            }
        }

        let pointVectors: Array<Float> = self.points.reduce([]) {
            return $0 + [$1.position.x, $1.position.y, $1.position.z]
        }

        let vertexData = NSData(bytes: pointVectors, length: pointVectors.count * sizeof(Float))

        let geometrySource = SCNGeometrySource(data: vertexData, semantic: SCNGeometrySourceSemanticVertex, vectorCount: self.points.count, floatComponents: true, componentsPerVector: 3, bytesPerComponent: sizeof(Float), dataOffset: 0, dataStride: sizeof(Float) * 3)

        let triangleCount = indexes.count / 3

        let normalData = NSData(bytes: indexes, length: sizeof(Int32) * indexes.count)
        let geometryElement = SCNGeometryElement(data: normalData, primitiveType: SCNGeometryPrimitiveType.Triangles, primitiveCount: triangleCount, bytesPerIndex: sizeof(Int32))

        let normalSource = createNormalSource()

        return (SCNGeometry(sources: [geometrySource, normalSource], elements: [geometryElement]), triangleCount)
    }

    func triangles() -> Int {
        return self.indexes.count / 3
    }

    private func createCubes() -> Array<Cube> {
        let originX: Float = -((self.cubeSize * Float(self.width)) / 2)
        let originY: Float = -((self.cubeSize * Float(self.height)) / 2)
        let originZ: Float = -((self.cubeSize * Float(self.depth)) / 2)

        var vertices = Array<Vertex>()

        var idCounter = 0

        for var y = 0; y <= self.height; y++ {
            let yPos: Float = originY + (Float(y) * self.cubeSize)
            for var z = 0; z <= self.depth; z++ {
                let zPos: Float = originZ + (Float(z) * self.cubeSize)
                for var x = 0; x <= self.width; x++ {
                    let xPos: Float = originX + (Float(x) * self.cubeSize)
                    let position = SCNVector3(x:xPos, y:yPos, z:zPos)
                    let strength = fieldStrengthAtPosition(position)
                    vertices.append(Vertex(position: position, fieldStrength:strength, id: idCounter++))
                }
            }
        }

        var cubes: Array<Cube> = []

        for var y = 0; y < height; y++ {
            for var z = 0; z < depth; z++ {
                for var x = 0; x < width; x++ {
                    let xLow = x
                    let xHigh = x + 1
                    let yLow = y * (width + 1) * (height + 1)
                    let yHigh = (y + 1) * (width + 1) * (height + 1)
                    let zLow = z * (width + 1)
                    let zHigh = (z + 1) * (width + 1)

                    cubes.append(Cube(
                        v1: vertices[xLow + yLow + zLow],
                        v2: vertices[xHigh + yLow + zLow],
                        v3: vertices[xHigh + yLow + zHigh],
                        v4: vertices[xLow + yLow + zHigh],
                        v5: vertices[xLow + yHigh + zLow],
                        v6: vertices[xHigh + yHigh + zLow],
                        v7: vertices[xHigh + yHigh + zHigh],
                        v8: vertices[xLow + yHigh + zHigh]))
                }
            }
        }
        
        return cubes;
    }

    private func addPolygonForIntersection(intersection: Intersection) {
        let index1 = pointForIntersectedEdge(intersection.edge3)
        let index2 = pointForIntersectedEdge(intersection.edge2)
        let index3 = pointForIntersectedEdge(intersection.edge1)

        indexes.append(index1)
        indexes.append(index2)
        indexes.append(index3)
    }

    private func pointForIntersectedEdge(edge: Edge) -> Int32 {
        var pointIndex = pointIndexByEdge[edge];
        if (pointIndex == nil) {
            let pointForEdge = pointAtThresholdOnEdge(edge)
            points.append(Point(position: pointForEdge))
            let index = Int32(points.count - 1)
            pointIndexByEdge[edge] = index

            return index
        } else {
            return pointIndex!
        }
    }

    private func pointAtThresholdOnEdge(edge: Edge) -> SCNVector3 {

        var low: SCNVector3
        var high: SCNVector3

        if (edge.vertex1.fieldStrength < edge.vertex2.fieldStrength) {
            low = edge.vertex1.position
            high = edge.vertex2.position
        } else {
            low = edge.vertex2.position
            high = edge.vertex1.position
        }

        return pointAtThresholdBetween(vertex1: low, vertex2: high)
    }

    private func pointAtThresholdBetween(#vertex1: SCNVector3, vertex2: SCNVector3) -> SCNVector3 {
        let midpoint = vertex1 + ((vertex2 - vertex1) / 2)

        let delta = fieldStrengthAtPosition(midpoint) - self.threshold

        if (abs(delta) < self.accuracy) {
            return midpoint
        } else {
            if (delta < 0) {
                return pointAtThresholdBetween(vertex1: midpoint, vertex2: vertex2)
            } else {
                return pointAtThresholdBetween(vertex1: vertex1, vertex2: midpoint)
            }
        }
    }

    private func fieldStrengthAtPosition(position: SCNVector3) -> Float {
        var strength = Float(0.0)
        for source in self.sources {
            strength += source.strengthAtPosition(position)
        }
        return strength
    }

    private func createNormalSource() -> SCNGeometrySource {
        var normals = Array<Float>()

        for (var i: Int = 0; i < indexes.count - 2; i+=3) {
            let point1 = points[Int(indexes[i])]
            let point2 = points[Int(indexes[i + 1])]
            let point3 = points[Int(indexes[i + 2])]

            let edge1 = point1.position - point2.position
            let edge2 = point1.position - point3.position

            var normal = edge1.crossProduct(edge2)
            normal.normalize()

            point1.normals.append(normal)
            point2.normals.append(normal)
            point3.normals.append(normal)
        }

        for (var i = 0; i < points.count; i++) {
            var combined = SCNVector3(x: 0, y: 0, z: 0)
            var normalsForPoint: Array<SCNVector3> = points[i].normals
            for normal in normalsForPoint {
                combined += normal
            }
            let averaged = combined / Float(normalsForPoint.count)
            normals += [averaged.x, averaged.y, averaged.z]
        }

        let normalData = NSData(bytes: normals, length: normals.count * sizeof(Float))

        return SCNGeometrySource(data: normalData, semantic: SCNGeometrySourceSemanticNormal, vectorCount: normals.count / 3, floatComponents: true, componentsPerVector: 3, bytesPerComponent: sizeof(Float), dataOffset: 0, dataStride: sizeof(Float) * 3)
    }
}