//
//  ImageSelectedViewController.swift
//  KeepItSafe
//
//  Created by Mariah Jenkins on 7/21/16.
//  Copyright © 2016 TTU. All rights reserved.
//

import UIKit

class ImageSelectedViewController: UIViewController
{
    
    //MARK: Properties
    @IBOutlet weak var imageEventView: UIImageView!
    
    //MARK: Variables
    var selectedImage: String!
    
    
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            
            // Setup variables to display selected image
            let imageURL = NSURL(string: self.selectedImage)
            let imageData = NSData(contentsOfURL: imageURL!)
        
            // Check if image came back as 'nil'
            dispatch_async(dispatch_get_main_queue(), {
                
                if (imageData != nil)
                {
                    self.imageEventView.image = UIImage(data: imageData!)
                }
            })
            
        })

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
