import UIKit
import WebKit

class WebViewController: UIViewController {

    private let url: URL
    private let webView: WKWebView = {
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = preferences
        let webView = WKWebView(frame: .zero, configuration: configuration)
        return webView
    }()
    init(url: URL,title: String) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        view.backgroundColor = .systemBackground
        webView.load(URLRequest(url: url))
        webView.frame = view.bounds
        configureButtons()
    }
    private func configureButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Done", comment: "Done"), style: .done, target: self, action: #selector(didTapDone))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(didTapRefresh))
    }
    @objc func didTapDone() {
        navigationController?.popViewController(animated: true)
    }
    @objc func didTapRefresh() {
        webView.load(URLRequest(url: url))
    }
}
