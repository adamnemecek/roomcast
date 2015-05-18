//
//  LoginViewController.swift
//  RoomCast_iPad_webapp
//
//  Created by Matteo Palvarini on 16/05/15.
//  Copyright (c) 2015 Matteo Palvarini. All rights reserved.
//

import UIKit
import WebKit

class LoginViewController: UIViewController, UIWebViewDelegate {
    
    var webView: UIWebView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.webView = BasicWebView()
        self.webView.scrollView.bounces = false
        self.webView.scalesPageToFit = false
        self.webView.multipleTouchEnabled = false
        self.webView.delegate = self
        
        self.view = self.webView
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        //self.view = self.webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load main menu from local files
        var htmlFile: NSString? = NSBundle.mainBundle().pathForResource("index", ofType: "html", inDirectory: "./assets/login")
        var htmlString: NSString?
        
        if let htmlFile = htmlFile {
            htmlString = NSString(contentsOfFile: htmlFile as String, encoding: NSUTF8StringEncoding, error: nil)!
            if let htmlString = htmlString {
                var bundle: String = NSBundle.mainBundle().bundlePath
                webView.loadHTMLString(htmlString as String, baseURL: NSURL(fileURLWithPath: "\(bundle)/assets/login")!)
            } else {
                println("Bundle not found.")
            }
        } else {
            println("File not found.")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Hide the status bar
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
    
    // Controller for the web view
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        // These need to match the values defined in JavaScript: roomcast://playChannel
        var appScheme: NSString = "roomcast"
        
        // Ignore legit webview requests so they load normally
        if(request.URL!.scheme! != appScheme) {
            return true;
        }
        
        // Get the action from the path
        var actionType: NSString = request.URL!.host!
        
        // Deserialize the request JSON
        var jsonDictString: String? = request.URL!.fragment?.stringByReplacingPercentEscapesUsingEncoding(NSASCIIStringEncoding)
        
        var parameters = Dictionary<String, String>()
        // Deserialize JSON fragment string into Swift dictionary
        if let jsonDictString = jsonDictString {
            var error : NSError?
            let JSONData = jsonDictString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            
            if let JSONDictionary = NSJSONSerialization.JSONObjectWithData(JSONData!, options: nil, error: &error) as? NSDictionary {
                for (key, value) in JSONDictionary {
                    let keyName = key as! String
                    let keyValue: String = value as! String
                    parameters[keyName] = keyValue
                }
            }
            
        }
        
        // Act based on actionType
        switch actionType {
        case "storeLoginValues":
            storeLoginValues(parameters)
        default:
            return false
        }
        
        return false
    }
    
    func storeLoginValues(parameters: Dictionary<String, String>) {
        let broker = parameters["broker"] as String!
        let app_id = parameters["app_id"] as String!
        let run_id = parameters["run_id"] as String!
                
        if let storedBroker = LoginViewController.retrieveBroker() {
            let error1 = Locksmith.updateData(["broker": broker], forUserAccount: "roomcast_broker")
        } else {
            let error1 = Locksmith.saveData(["broker": broker], forUserAccount: "roomcast_broker")
        }
        
        if let storedAppId = LoginViewController.retrieveAppId() {
            let error2 = Locksmith.updateData(["app_id": app_id], forUserAccount: "roomcast_app_id")
        } else {
            let error2 = Locksmith.saveData(["app_id": app_id], forUserAccount: "roomcast_app_id")
        }
        
        if let storedRunId = LoginViewController.retrieveRunId() {
            let error3 = Locksmith.updateData(["run_id": run_id], forUserAccount: "roomcast_run_id")
        } else {
            let error3 = Locksmith.saveData(["run_id": run_id], forUserAccount: "roomcast_run_id")
        }
        
        self.login()
    }
    
    class func retrieveBroker() -> String? {
        let (dictionary, error) = Locksmith.loadDataForUserAccount("roomcast_broker")
        if let dictionary = dictionary {
            return dictionary.objectForKey("broker") as? String
        } else {
            return nil
        }
    }
    
    class func retrieveRunId() -> String? {
        let (dictionary, error) = Locksmith.loadDataForUserAccount("roomcast_run_id")
        if let dictionary = dictionary {
            return dictionary.objectForKey("run_id") as? String
        } else {
            return nil
        }
    }
    
    class func retrieveAppId() -> String? {
        let (dictionary, error) = Locksmith.loadDataForUserAccount("roomcast_app_id")
        if let dictionary = dictionary {
            return dictionary.objectForKey("app_id") as? String
        } else {
            return nil
        }
    }
    
    func login() {
        let broker = LoginViewController.retrieveBroker()
        if let broker = broker {
            self.performSegueWithIdentifier("loginSegue", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch (segue.identifier!) {
        case "loginSegue":
            // do nothing
            break
        default:
            // do nothing
            break
        }
        
    }
    
    //////////// REACT.js METHODS ////////////
    

    
    //////////////////////////////////////////
    
}

