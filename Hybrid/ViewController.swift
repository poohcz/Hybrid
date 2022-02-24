//
//  ViewController.swift
//  Hybrid
//
//  Created by 김동율 on 2022/02/24.
//

import UIKit
import WebKit

// 스토리보드로 객체생성해서 할려고 했으나 하루날잡아서 했는데 잘 안된다... 결국 구글링 및 삽질로 스토리 보드 없이 ...
class ViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    // 메모리 누수 방지로 lazy
    lazy var webView : WKWebView = {
        let webViewConfig = WKWebViewConfiguration()
        // no는 줌인 기능 안되게하고, yes는 되게 하는 기능. initial이랑 maximum scale 이 3가지가 줌인 줌아웃 기능
        let sourceInScript: String = "var meta = document.createElement('meta');" + "meta.name = 'viewport';" +
        "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
        "var head = document.getElementsByTagName('head')[0];" + "head.appendChild(meta);"
        // 공식문서에는 사용자가 원하는 스크립트 코드 넣는 곳이라고 나온다.
        let script: WKUserScript = WKUserScript(source: sourceInScript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        webViewConfig.userContentController.addUserScript(script)
        // 카메라를 전체풀화면 안나오게. 스토리보드에서는 체크 한번이면 되는데...
        webViewConfig.allowsInlineMediaPlayback = true
        let webView = WKWebView(frame: .zero, configuration: webViewConfig)
        // 웹뷰를 여기서 델리게이트로
        webView.navigationDelegate = self
        // WKUIDelegate는 웹 페이지 대신 네이티브 사용자 인터페이스 요소를 표시하는 메서드를 제공
        webView.uiDelegate = self
        
        return webView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetting()
    }
    
    func viewSetting() {
        // 제일 큰 부모뷰에 위에서 lazy로 만든 웹뷰 집어넣고, 오토레이아웃
        self.view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: self.view.topAnchor), webView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            webView.rightAnchor.constraint(equalTo: self.view.rightAnchor), webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        // 위에 코드를 배열로 넣어서 하면 아래 isActive = true를 할 필요가 없다.
//        webView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
//        webView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
//        webView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
//        webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        webView.load(URLRequest(url: URL(string: "https://cocopen.net")!))
    }


}

