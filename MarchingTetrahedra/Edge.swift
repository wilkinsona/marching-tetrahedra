struct Edge: Hashable {

    let vertex1: Vertex

    let vertex2: Vertex

    init(vertex1: Vertex, vertex2: Vertex) {
        self.vertex1 = vertex1
        self.vertex2 = vertex2
    }

    var hashValue: Int {
        return vertex1.id.hashValue + vertex2.id.hashValue
    }
}

func == (lhs: Edge, rhs: Edge) -> Bool {
    return (lhs.vertex1 == rhs.vertex1 && lhs.vertex2 == rhs.vertex2) ||
        (lhs.vertex1 == rhs.vertex2 && lhs.vertex2 == rhs.vertex1)
}