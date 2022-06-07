struct SourceAPIResponse: Codable {
    let sources: [SourceDetail]
}

struct SourceDetail: Codable {
    let id: String
    let name: String
    let description: String?
}
