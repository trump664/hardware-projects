//
//  LoginViewController.swift
//  KeepItSafe
//
//  Created by Mariah Jenkins on 6/20/16.
//  Copyright © 2016 TTU. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate
{


    //MARK: Properties
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        userEmailTextField.delegate = self
        userPasswordTextField.delegate = self
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {

        super.viewDidAppear(true)

    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if(segue.identifier == "historyView")
        {
            //pass data to next view
            print("works")
        }
    }

    // Alert Message Function
    func displayAlertMessage(userMessage: String)
    {
        let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)

        myAlert.addAction(okAction)

        self.presentViewController(myAlert, animated: true, completion: nil)
    }



    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {

        // Hide keyboard
        userEmailTextField.resignFirstResponder()
        userPasswordTextField.resignFirstResponder()
        return true
    }


    //MARK: Actions

    // Hide keyboard if user taps on background while editing text fields
    @IBAction func userTappedBackground(sender: AnyObject) {
        view.endEditing(true)
    }




    @IBAction func loginButtonTapped(sender: AnyObject)
    {

        //Hide keyboard
        userEmailTextField.resignFirstResponder()
        userPasswordTextField.resignFirstResponder()

        let userEmail = userEmailTextField.text
        let userPassword = userPasswordTextField.text

        // Check if Email OR Password is empty
        if(userEmail!.isEmpty || userPassword!.isEmpty)
        {
            //Check if ONLY Email is empty
            if(userEmail!.isEmpty && !userPassword!.isEmpty){
                displayAlertMessage("Email cannot be empty")
            }
            //Check if ONLY Password is empty
            if(userPassword!.isEmpty && !userEmail!.isEmpty)
            {
                displayAlertMessage("Password cannot be empty")
            }
            //Check if Email AND Password is empty
            if(userEmail!.isEmpty && userPassword!.isEmpty)
            {
                displayAlertMessage("All fields required")
            }

            return;
        }
        

        // Check DATABASE for user login credentials
        let myURL = NSURL(string: "http://xxx.xxx.xxx.xxx/scripts/userLogin.php")!
        let request = NSMutableURLRequest(URL: myURL)

        request.HTTPMethod = "POST"

        let postString = "email=\(userEmail!)&password=\(userPassword!)"

        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)

        let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
        {
            (data, response, error) in

            if error != nil {
                print("error=\(error)")
                return
            }


            do
            {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary

                if let parseJSON = json
                {
                    let resultValue = parseJSON["status"] as! String!

                    print("result: \(resultValue)")

                    if (resultValue == "Success")
                    {
                        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isUserLoggedIn")
                        NSUserDefaults.standardUserDefaults().synchronize()

                        dispatch_async(dispatch_get_main_queue(), {

                            self.performSegueWithIdentifier("historyView", sender: self)

                        })
                    }

                    if (resultValue == "error")
                    {
                        var messageToDisplay: String = parseJSON["message"] as! String!

                        messageToDisplay = parseJSON["message"] as! String!

                        dispatch_async(dispatch_get_main_queue(), {

                            let myAlert = UIAlertController(title: "Alert", message: messageToDisplay, preferredStyle: UIAlertControllerStyle.Alert)

                            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { action in

                            self.dismissViewControllerAnimated(true, completion: nil)
                        }

                            myAlert.addAction(okAction)

                            self.presentViewController(myAlert, animated: true, completion: nil)
                        })

                    }


                }
            }
            catch {
                print(error)
            }

        }
        task.resume()
    }
}
