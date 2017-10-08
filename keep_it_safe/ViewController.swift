//
//  ViewController.swift
//
//  User Login and Registration
//  KeepItSafe
//
//  Created by Mariah Jenkins on 6/20/16.
//  Copyright © 2016 TTU. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: Properties

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if(segue.identifier == "loginView")
        {
            //pass data to next view
            print("works")
        }
    }

    //MARK: Action
    @IBAction func enterButtonTapped(sender: AnyObject)
    {
        
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isUserLoggedIn")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        /*let loginViewController = self.storyboard!.instantiateViewControllerWithIdentifier("loginView") as! LoginViewController
        
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appdelegate.window?.rootViewController = loginViewController
        appdelegate.window?.makeKeyAndVisible() */
        
        /*let loginvc = self.storyboard?.instantiateViewControllerWithIdentifier("loginVC") as! LoginViewController
        let navigationController = UINavigationController(rootViewController: loginvc)
        
        self.presentViewController(navigationController, animated: true, completion: nil) */
        
        self.performSegueWithIdentifier("loginView", sender: self)
        
    }
}

