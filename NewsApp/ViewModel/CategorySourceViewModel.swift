public class CategorySourceViewModel {
    let defaultText = "business"
    var sources = Box([SourceTableViewCellViewModel]())
    var onErrorHandling : ((Error) -> Void)?
    init() {
        fetchSources(title: self.defaultText)
    }

    func fetchSources(title: String,completion: ((Result<Bool, Error>) -> Void)? = nil) {
        APIservices.shared.getSources(for: title) { [weak self] result in
            switch result {
            case .success(let sources):
                self?.sources.value = sources.compactMap({
                    SourceTableViewCellViewModel(
                        id: $0.id,
                        title: $0.name,
                        description:  $0.description ?? "No Description"
                    )
                })
            case .failure(let error):
                print(error)
                self?.onErrorHandling?(error)
            }
        }
    }
}
