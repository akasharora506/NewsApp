//Source Response Model

struct SourceAPIResponse: Codable {
    let sources: Array<SourceDetail>
}

// SourceDetail Model
struct SourceDetail: Codable {
    let id: String
    let name: String
    let description: String?
}
