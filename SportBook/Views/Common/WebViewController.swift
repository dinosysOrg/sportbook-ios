//
//  WebViewController.swift
//  SportBook
//
//  Created by Bui Minh Duc on 6/26/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    var url: String?
    
    var htmlString: String?
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let webViewUrl = url {
            webView.loadRequest(URLRequest(url: URL(string: webViewUrl)!))
        } else if let htmlData = htmlString {
            webView.loadHTMLString(htmlData, baseURL: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
