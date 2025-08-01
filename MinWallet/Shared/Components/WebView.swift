import SwiftUI
import WebKit
import Combine

class WebViewModel: ObservableObject {
    @Published var progress: Double = 0.0
    private var cancellable: AnyCancellable?
    
    /// Subscribes to the WKWebView's loading progress and updates the published progress property with debounced values.
    /// - Parameter webView: The WKWebView instance to observe.
    func observeWebView(_ webView: WKWebView) {
        cancellable = webView.publisher(for: \.estimatedProgress)
            .debounce(for: .milliseconds(200), scheduler: DispatchQueue.main)
            .receive(on: RunLoop.main)
            .sink { [weak self] progress in
                self?.progress = progress
            }
    }
}

struct WebView: UIViewRepresentable {
    let urlString: String
    @ObservedObject var viewModel: WebViewModel
    
    /// Creates and configures a WKWebView, sets up progress observation, and loads the specified URL if valid.
    /// - Returns: A WKWebView instance displaying the requested web content.
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        viewModel.observeWebView(webView)
        
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
        return webView
    }
    
    /// Updates the WKWebView instance when the SwiftUI view’s state changes.
///
/// This implementation is intentionally left empty as no dynamic updates are required after the initial creation.
func updateUIView(_ webView: WKWebView, context: Context) {}
}

struct PreloadWebViewPolicy: UIViewRepresentable {
    @ObservedObject var preloadWebVM: PreloadWebViewModel
    
    /// Creates and returns the preloaded WKWebView, resetting its scroll position to the top-left corner.
    /// - Returns: The WKWebView instance managed by the preload view model.
    func makeUIView(context: Context) -> WKWebView {
        preloadWebVM.webView.scrollView.contentOffset = .init(x: 0, y: 0)
        return preloadWebVM.webView
    }
    
    /// Updates the WKWebView instance when the SwiftUI view’s state changes.
///
/// This implementation is intentionally left empty as no dynamic updates are required after the initial creation.
func updateUIView(_ webView: WKWebView, context: Context) {}
}


class PreloadWebViewModel: ObservableObject {
    @Published var progress: Double = 0.0
    private var cancellables: Set<AnyCancellable> = []
    
    let webView = WKWebView()
    
    init() {
        webView.publisher(for: \.estimatedProgress)
            .debounce(for: .milliseconds(200), scheduler: DispatchQueue.main)
            .receive(on: RunLoop.main)
            .sink { [weak self] progress in
                self?.progress = progress
            }
            .store(in: &cancellables)
    }
    
    /// Loads web content into the internal WKWebView using the provided URL string.
    /// - Parameter urlString: The string representation of the URL to load. If the string is not a valid URL, no action is taken.
    func preloadContent(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
