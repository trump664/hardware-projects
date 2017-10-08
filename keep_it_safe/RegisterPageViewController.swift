//
//  RegisterPageViewController.swift
//  KeepItSafe
//
//  Created by Mariah Jenkins on 6/20/16.
//  Copyright © 2016 TTU. All rights reserved.
//

import UIKit

class RegisterPageViewController: UIViewController,
                                  UITextFieldDelegate
{

//MARK: Properties
    @IBOutlet weak var userFirstNameTextField: UITextField!
    @IBOutlet weak var userLastNameTextField: UITextField!
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        userFirstNameTextField.delegate = self
        userLastNameTextField.delegate = self
        userEmailTextField.delegate = self
        userPasswordTextField.delegate = self
        repeatPasswordTextField.delegate = self
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
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
        userFirstNameTextField.resignFirstResponder()
        userLastNameTextField.resignFirstResponder()
        userEmailTextField.resignFirstResponder()
        userPasswordTextField.resignFirstResponder()
        repeatPasswordTextField.resignFirstResponder()
        return true
    }

// MARK: Navigation
@IBAction func cancel(sender: UIBarButtonItem)
{
    dismissViewControllerAnimated(true, completion: nil)
}


//MARK: Actions

    // Hide keyboard if user taps on background while editing text fields
    @IBAction func userTappedBackground(sender: AnyObject) {
        view.endEditing(true)
    }

@IBAction func registerButtonTapped(sender: AnyObject)
{
    // User inputted values from text fields
    let userFirstName = userFirstNameTextField.text
    let userLastName = userLastNameTextField.text
    let userEmail =  userEmailTextField.text
    let userPassword = userPasswordTextField.text
    let userRepeatPassword = repeatPasswordTextField.text

        // Check for any empty fields
        if(userFirstName!.isEmpty || userLastName!.isEmpty || userEmail!.isEmpty || userPassword!.isEmpty || userRepeatPassword!.isEmpty)
        {
            // Display alert message if any or all fields are empty
            displayAlertMessage("All fields are required")
            return
        }

        // Check if passwords don't match
        if(userPassword != userRepeatPassword)
        {
            // Display alert message if passwords do not match
            displayAlertMessage("Passwords do no match")
            return

        }

        // Store data entered by user
        let myURL = NSURL(string: "http://xxx.xxx.xxx.xxx/scripts/userRegister.php")!
        let request = NSMutableURLRequest(URL: myURL)

        request.HTTPMethod = "POST"

        let postString = "email=\(userEmail!)&password=\(userPassword!)&firstName=\(userFirstName!)&lastName=\(userLastName!)"

        print(postString)

        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)

        let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
        {

            (data, response, error) in

            if (error != nil) {
                print("error=\(error)")
                return
            }

            do
            {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary

                if let parseJSON = json
                {
                    let resultValue = parseJSON["status"] as! String!
                    print("result: \(resultValue)")

                    var isUserRegistered: Bool = false
                    if (resultValue == "Success")
                    {
                        isUserRegistered = true
                    }

                    var messageToDisplay: String = parseJSON["message"] as! String!
                    if (!isUserRegistered)
                    {
                        messageToDisplay = parseJSON["message"] as! String!
                    }

                    dispatch_async(dispatch_get_main_queue(), {
                        let myAlert = UIAlertController(title: "Alert", message: messageToDisplay, preferredStyle: UIAlertControllerStyle.Alert)

                        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default)
                        { action in
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }

                        myAlert.addAction(okAction)

                        self.presentViewController(myAlert, animated: true, completion: nil)

                    })
                }
            }
            catch
            {
                print(error)
            }
        }
        task.resume()
    }
}
