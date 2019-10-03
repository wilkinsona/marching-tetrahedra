struct Edge: Hashable {

    let vertex1: Vertex

    let vertex2: Vertex

    init(vertex1: Vertex, vertex2: Vertex) {
        self.vertex1 = vertex1
        self.vertex2 = vertex2
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.vertex1)
        hasher.combine(self.vertex2)
    }
}

func == (lhs: Edge, rhs: Edge) -> Bool {
    return (lhs.vertex1 == rhs.vertex1 && lhs.vertex2 == rhs.vertex2) ||
        (lhs.vertex1 == rhs.vertex2 && lhs.vertex2 == rhs.vertex1)
}
