//
//  ImageViewController.swift
//  KeepItSafe
//
//  Created by Mariah Jenkins on 7/18/16.
//  Copyright © 2016 TTU. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController,
                           UICollectionViewDelegate,
                           UICollectionViewDataSource
{

    //MARK: Properties
    @IBOutlet weak var imageView: UICollectionView!


    var images: [String] = []


    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)

        loadImages()
    }


    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return images.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell1: ImageCollectionCell = collectionView.dequeueReusableCellWithReuseIdentifier("cell1", forIndexPath: indexPath) as! ImageCollectionCell


        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {

            let imageString = self.images[indexPath.row]
            let imageURL = NSURL(string: imageString)
            let imageData = NSData(contentsOfURL: imageURL!)


            dispatch_async(dispatch_get_main_queue(), {

                if (imageData != nil)
                {
                    cell1.ImageOne.image = UIImage(data: imageData!)
                }

            })

        })



        return cell1
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        // Debugging
        print("User tapped on # \(indexPath.row)")


        let selectedImagePage: ImageSelectedViewController = self.storyboard?.instantiateViewControllerWithIdentifier("imageSelectedVC") as! ImageSelectedViewController

        // pass the selected image that user tapped on to Image Selected View Controller
        selectedImagePage.selectedImage = self.images[indexPath.row]

        // present Image Selected View Controller
        self.navigationController?.pushViewController(selectedImagePage, animated: true)

    }

    func loadImages()
    {
        let pageURL = "http://xxx.xxx.xxx.xxx/scripts/display.php"

        let myURL = NSURL(string: pageURL)

        let request = NSMutableURLRequest(URL: myURL!)

        //request.HTTPMethod = "GET"

        let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
        {
            (data, response, error) in

            if error != nil
            {
                let myAlert = UIAlertController(title: "Alert", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)

                let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)

                myAlert.addAction(okAction)

                self.presentViewController(myAlert, animated: true, completion: nil)

                return
            }

            do
            {
                let jsonArray = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSArray

                if let parseJSONArray = jsonArray
                {
                    self.images = parseJSONArray as! [String]

                    dispatch_async(dispatch_get_main_queue(), {

                        self.imageView.reloadData()

                    })
                }
            }
            catch let error as NSError
            {
                print(error.localizedDescription)
            }
        }

        task.resume()
    }


    //MARK: Actions

    @IBAction func loginEventsButtonTapped(sender: UIBarButtonItem)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
