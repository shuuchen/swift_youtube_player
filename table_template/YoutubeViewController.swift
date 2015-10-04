//
//  YoutubeViewController.swift
//  table_template
//
//  Created by Shuchen Du on 2015/09/26.
//  Copyright (c) 2015年 Shuchen Du. All rights reserved.
//

import UIKit

class YoutubeViewController: UIViewController, NSURLSessionDelegate,
    NSURLSessionDownloadDelegate, NSURLSessionTaskDelegate {

    let myCell = "cell_id"
    
    var session: NSURLSession!
    var url: NSURL!
    
    var selectedVideoIndex: Int!
    var apiKey = "AIzaSyDqxwQmV1UcawuR6C4hWP5iBlZY7WqqHAI"
    var videosArray: Array<Dictionary<NSObject, AnyObject>> = []
    
    // youtube text field
    @IBOutlet weak var yttf: UITextField!
    
    @IBAction func touchDown(sender: AnyObject) {
/*
        let str = yttf.text
        if str == "enter URL here..." {
            self.yttf.text = ""
        }
*/
    }
    @IBOutlet weak var videoTable: UITableView!
    
    @IBAction func editDidEnd(sender: AnyObject) {
        /*
        let str = yttf.text
        
        if str == "" {
            displayAlertWithTitle("please enter a url", message: "")
            return
        }

        /* Now attempt to download the contents of the URL */
        url = NSURL(string: str)
        let task = session.downloadTaskWithURL(url!)
        /* Our own extension on the task adds the start method */
        task.resume()
*/
    }
    
     // perform request task
    func performGetRequest(targetURL: NSURL!, completion: (data: NSData?, HTTPStatusCode: Int, error: NSError?) -> Void) {
        
        let request = NSMutableURLRequest(URL: targetURL)
        request.HTTPMethod = "GET"
        
        let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: sessionConfiguration)
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(data: data, HTTPStatusCode: (response as! NSHTTPURLResponse).statusCode, error: error)
            })
        })
        
        task.resume()
    }
    
    /* Just a little method to help us display alert dialogs to the user */
    func displayAlertWithTitle(title: String, message: String) {
        
        let controller = UIAlertController(title: title,
            message: message, preferredStyle: .Alert)
        
        controller.addAction(UIAlertAction(title: "OK",
            style: .Default, handler: {
                (alert: UIAlertAction!) in
                dispatch_async(dispatch_get_main_queue()) {
                    self.yttf.text = ""
                }
        }))
        
        presentViewController(controller,
            animated: true, completion: nil)
    }
    
    /* We now get to know that the download procedure finished */
    func URLSession(session: NSURLSession, task: NSURLSessionTask,
        didCompleteWithError error: NSError?) {
        
        print("Finished ")
        
        // error occurs
        if let err = error {
            println("with an error = \(err)")
            self.displayAlertWithTitle("download error occurs", message: "\(err)")
        }
        /* Release the delegate */
        session.finishTasksAndInvalidate()
    }
    
    // download finished, save the data to file system
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        
        // file manager
        let manager = NSFileManager()
        
        // path to Document folder
        var error: NSError?
        var destinationPath = manager.URLForDirectory(.DocumentDirectory,
            inDomain: .UserDomainMask,
            appropriateForURL: url,
            create: true,
            error: &error)!
        
        // downloaded file name
        let componentsOfUrl = url.absoluteString!.componentsSeparatedByString("/")
        let fileNameFromUrl = componentsOfUrl[componentsOfUrl.count - 1]
        
        // append file name to Document folder
        destinationPath =
            destinationPath.URLByAppendingPathComponent(fileNameFromUrl)
        
        // move the file
        manager.moveItemAtURL(url, toURL: destinationPath, error: nil)
        
        // alert success message
        let message = "Saved the downloaded data to = \(destinationPath)"
        self.displayAlertWithTitle("Success", message: message)
    }
    
    // identifier for session configuration
    var configurationIdentifier: String {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        let key = "configurationIdentifier"
        let previousValue = userDefaults.stringForKey(key) as String?
        
        if let thePreviousValue = previousValue {
            return previousValue!
        } else {
            let newValue = NSDate().description
            userDefaults.setObject(newValue, forKey: key)
            userDefaults.synchronize()
            return newValue
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        /* Create our configuration first */
        let configuration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier(
            configurationIdentifier)
        configuration.timeoutIntervalForRequest = 15.0
        /* Now create a session that allows us to create the tasks */
        session = NSURLSession(configuration: configuration, delegate: self,
            delegateQueue: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    /*
        //Looks for single or multiple taps.
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
      */  
    }
/*
    //Calls this function when the tap is recognized.
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
  */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension YoutubeViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.videosArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
            
        let cell = self.videoTable.dequeueReusableCellWithIdentifier(myCell,
            forIndexPath: indexPath) as! MyCell
            
        let videoDetails = videosArray[indexPath.row]
        cell.vidTitleLabel.text = videoDetails["title"] as? String
        cell.imgView.image = UIImage(data: NSData(contentsOfURL: NSURL(string: (videoDetails["thumbnail"] as? String)!)!)!)
            
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if let id = segue.identifier {
            switch id {
                case "seg_music":
                    
                    let nvc = segue.destinationViewController as! UINavigationController
                    let dvc = nvc.childViewControllers[0] as! MusicViewController
                    let id = self.videoTable.indexPathForCell(sender as! MyCell)!
                    dvc.videoID = videosArray[id.row]["videoID"] as! String
                
                default:
                    break
            }
        }
    }
}

extension YoutubeViewController: UITextFieldDelegate {
    
    // called when return is typed
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        self.yttf.resignFirstResponder()

        var type = "video"
        
        // Form the request URL string.
        var urlString = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(textField.text)&type=\(type)&key=\(apiKey)"
        urlString = urlString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        // Create a NSURL object based on the above string.
        let targetURL = NSURL(string: urlString)
        
        // Get the results.
        performGetRequest(targetURL, completion: { (data, HTTPStatusCode, error) -> Void in
            
            if HTTPStatusCode == 200 && error == nil {
                
                // Convert the JSON data to a dictionary object.
                let resultsDict = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as! Dictionary<NSObject, AnyObject>
                
                // Get all search result items ("items" array).
                let items: Array<Dictionary<NSObject, AnyObject>> = resultsDict["items"] as! Array<Dictionary<NSObject, AnyObject>>
                
                // remove old data
                self.videosArray.removeAll(keepCapacity: false)
                
                // Loop through all search results and keep just the necessary data.
                for var i=0; i<items.count; ++i {
                    let snippetDict = items[i]["snippet"] as! Dictionary<NSObject, AnyObject>

                    // Create a new dictionary to store the video details.
                    var videoDetailsDict = Dictionary<NSObject, AnyObject>()
                    videoDetailsDict["title"] = snippetDict["title"]
                    videoDetailsDict["thumbnail"] = ((snippetDict["thumbnails"] as! Dictionary<NSObject, AnyObject>)["default"] as! Dictionary<NSObject, AnyObject>)["url"]
                    videoDetailsDict["videoID"] = (items[i]["id"] as! Dictionary<NSObject, AnyObject>)["videoId"]
                    
                    // Append the desiredPlaylistItemDataDict dictionary to the videos array.
                    self.videosArray.append(videoDetailsDict)
                    
                    // Reload the tableview.
                    self.videoTable.reloadData()
                }
            } else {
                println("HTTP Status Code = \(HTTPStatusCode)")
                println("Error while loading channel videos: \(error)")
            }
        })
        
        return true
    }
}