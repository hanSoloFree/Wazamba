import UIKit
import WebKit

class HelpViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    lazy var helpView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsAirPlayForMediaPlayback = true
        webConfiguration.allowsInlineMediaPlayback = true
        
        let webView = WKWebView (frame: .zero , configuration: webConfiguration)
        webView.isOpaque = false
        webView.backgroundColor = .black
        webView.uiDelegate = self
        webView.navigationDelegate = self
//        webView.scrollView.bounces = false
        return webView
    }()
    
    lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.hidesWhenStopped = true
        indicator.color = .systemGray
        return indicator
    }()
    
    var url: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        
        view.addSubview(helpView)
        helpView.fillSuperView()
        
        helpView.addSubview(indicator)
        indicator.ancherToSuperviewsCenter()
        
        helpView.load(URLRequest(url: url))
        indicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        indicator.stopAnimating()
        hidePopUps()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicator.stopAnimating()
        hidePopUps()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        indicator.stopAnimating()
    }
    
    func hidePopUps() {
        guard let home = UserDefaultsManager.home?.absoluteString else { return }
        guard home.contains("level") else { return }
        
        let popupJs = "document.getElementsByClassName('cg-notify-message ng-scope access-by-country-policy cg-notify-message-center')[0].style.display = 'none'"
        helpView.evaluateJavaScript(popupJs) { (result, error) in
            if error == nil {
                print(result ?? "result is nil")
            }
        }
        
        let cookiesJs = "document.getElementsByClassName('access-by-country-policy__confirm ng-scope')[0].click()"
        helpView.evaluateJavaScript(cookiesJs) { (result, error) in
            if error == nil {
                print(result ?? "result is nil")
            }
        }
    }
    
}


//extension WKWebView {
//    override open var safeAreaInsets: UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//    }
//}
