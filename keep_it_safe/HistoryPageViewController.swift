//
//  HistoryPageViewController.swift
//  KeepItSafe
//
//  Created by Mariah Jenkins on 7/2/16.
//  Copyright © 2016 TTU. All rights reserved.
//

import UIKit
//import LocalAuthentication

class HistoryPageViewController: UIViewController,
                                 UITableViewDelegate,
                                 UITableViewDataSource,
                                 EventModelProtocol
{

    //MARK: Properties
    @IBOutlet weak var historyTableView: UITableView!

    var feedItems: NSArray = NSArray()
    var selectedEvent: EventModel = EventModel()


    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.historyTableView.delegate = self
        self.historyTableView.dataSource = self

        let getevent = GetEventModel()
        getevent.delegate = self

        getevent.downloadItems()

    }



    func itemsDownloaded(items: NSArray)
    {
        feedItems = items
        self.historyTableView.reloadData()
    }


    //MARK: historyTableView Properties

    // Create and populate Cells for historyTableView
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        // Retrieve cell
        //let cell: UITableViewCell = self.historyTableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell


        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")!


        // Get the location to be shown
        let item: EventModel = feedItems[indexPath.row] as! EventModel

        // Get references to labels of cell
        cell.textLabel?.text = "\(item.description): "

        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.darkGrayColor().CGColor
        border.frame = CGRect(x: 0, y: cell.frame.size.height - width, width:  cell.frame.size.width, height: cell.frame.size.height)

        border.borderWidth = width
        cell.layer.addSublayer(border)
        cell.layer.masksToBounds = true

        return cell
    }

    // Count number of rows for historyTableView in array
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return feedItems.count
    }


    @IBAction func viewImageButtonTapped(sender: UIBarButtonItem)
    {
        self.performSegueWithIdentifier("imageSegue", sender: self)
    }


    @IBAction func logoutButtonTapped(sender: UIBarButtonItem)
    {
        let loginPage = self.storyboard?.instantiateViewControllerWithIdentifier("loginVC") as! LoginViewController

        self.presentViewController(loginPage, animated: true, completion: nil)
    }




    /*func authenticateUser()
    {
        // Get local auth context
        let context: LAContext = LAContext()

        // Declare NSError variable
        var error: NSError?

        // Set the reason string that will appear on the authentication alert
        let reasonString = "Fingerprint needed to unlock safe"

        // Check if the device can evaluate the policy
        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error)
        {
            [context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: {(success: Bool, evalPolicyError: NSError?) -> Void in

                if success {

                }
                else{
                    // If authentication failed then show a message to the console with a short description.
                    // In case that the error is a user fallback, then show the password alert view.
                    print(evalPolicyError?.localizedDescription)

                    switch evalPolicyError!.code {

                    case LAError.SystemCancel.rawValue:
                        print("Authentication was cancelled by the system")

                    case LAError.UserCancel.rawValue:
                        print("Authentication was cancelled by the user")

                    case LAError.UserFallback.rawValue:
                        print("User selected to enter custom password")
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            //self.showPasswordAlert()
                        })

                    default:
                        print("Authentication failed")
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            //self.showPasswordAlert()
                        })
                    }
                }

            })]
        }
        else
        {
            // If the security policy cannot be evaluated then show a short message depending on the error.
            switch error!.code{

            case LAError.TouchIDNotEnrolled.rawValue:
                print("TouchID is not enrolled")

            case LAError.PasscodeNotSet.rawValue:
                print("A passcode has not been set")

            default:
                // The LAError.TouchIDNotAvailable case.
                print("TouchID not available")
            }

            // Optionally the error description can be displayed on the console.
            print(error?.localizedDescription)

            // Show the custom alert view to allow users to enter the password.
            //self.showPasswordAlert()
        }
    }
    */
}

protocol EventModelProtocol: class {

    func itemsDownloaded(items: NSArray)

}



class GetEventModel: NSObject,
                     NSURLSessionDataDelegate
{

    // Properties

    weak var delegate: EventModelProtocol!

    var data: NSMutableData = NSMutableData()

    let urlPath: String = "http://xxx.xxx.xxx.xxx/scripts/service.php"

    func downloadItems()
    {
        let url: NSURL = NSURL(string: urlPath)!
        var session: NSURLSession!
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()

        session = NSURLSession(configuration: configuration, delegate: self, delegateQueue: nil)

        let task = session.dataTaskWithURL(url)

        task.resume()
    }


    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData)
    {
        self.data.appendData(data)
    }


    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?)
    {
        if error != nil
        {
            print("Data failed to download data")
        }
        else
        {
            print("Data downloaded successfully")
            self.parseJSON()
        }
    }


    func parseJSON()
    {
        var jsonResult: NSMutableArray = NSMutableArray()

        do
        {
            jsonResult = try NSJSONSerialization.JSONObjectWithData(self.data, options: NSJSONReadingOptions.AllowFragments) as! NSMutableArray
        }
        catch let error as NSError
        {
            print(error)
        }

        var jsonElement: NSDictionary = NSDictionary()
        let events: NSMutableArray = NSMutableArray()

        for i in 0 ..< jsonResult.count
        {
            jsonElement = jsonResult[i] as! NSDictionary

            let event = EventModel()

            if let eventName = jsonElement["eventName"] as? String,
               let eventDate = jsonElement["eventDate"] as? String,
               let eventTime = jsonElement["eventTime"] as? String
                //let eventID = jsonElement["eventID"] as? String,
                //let userID = jsonElement["userID"] as? String,
            {
                //event.eventID = eventID
                //event.userID = userID
                event.eventName = eventName
                event.eventDate = eventDate
                event.eventTime = eventTime
            }

            events.addObject(event)
        }

        dispatch_async(dispatch_get_main_queue(), { () -> Void in

            self.delegate.itemsDownloaded(events)

        })
    }

}


// Structure Model for User Login Events
class EventModel: NSObject
{

    // Properties

    //var eventID: String?
    //var userID: String?
    var eventName: String?
    var eventDate: String?
    var eventTime: String?

    override init()
    {
    }


    init(eventID: String, userID: String, eventName: String, eventDate: String, eventTime: String)
    {
        //self.eventID = eventID
        //self.userID = userID
        self.eventName = eventName
        self.eventDate = eventDate
        self.eventTime = eventTime

    }

    override var description: String
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-mm-dd"
        let date = dateFormatter.dateFromString(self.eventDate!)

        dateFormatter.dateFormat = "mm-dd-YYYY"
        let event_Date = dateFormatter.stringFromDate(date!)

        //let timeFormatter = NSDateFormatter()
        //timeFormatter.dateFormat = "HH:mm:ss"

        //let time = timeFormatter.dateFromString(self.eventTime!)
        //timeFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        //timeFormatter.dateFormat = "h:mm:ss a"
        //let event_Time = timeFormatter.stringFromDate(time!)


        return "\(eventName!):          \(event_Date)                \(eventTime!)"
    }

}
