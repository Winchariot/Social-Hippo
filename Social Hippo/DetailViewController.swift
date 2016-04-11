//
//  DetailViewController.swift
//  Social Hippo
//
//  Created by James Gillin on 2/15/16.
//  Copyright © 2016 James Gillin. All rights reserved.
//

import UIKit
import SafariServices
import Social
import Kingfisher
import Alamofire
import SwiftyJSON

class DetailViewController: UIViewController {
  
  @IBOutlet weak var eventTitle: UILabel!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var eventCategory: UILabel!
  @IBOutlet weak var eventImage: UIImageView!
  @IBOutlet weak var imageCaption: UILabel!
  @IBOutlet weak var longDescription: UITextView!
  @IBOutlet weak var hashtagLabel: UILabel!
  @IBOutlet weak var readMoreButton: SHButton!
  @IBAction func readMorePress(sender: SHButton) {
    guard let urlString = detailItem?.readMore else { return }
    guard let url = NSURL(string: urlString) else { return }
    let vc = SFSafariViewController(URL: url, entersReaderIfAvailable: true)
    presentViewController(vc, animated: true, completion: nil)
  }
  @IBOutlet weak var fbShareButton: SHButton!
  @IBAction func fbSharePress(sender: SHButton) { showSocialComposer(SLServiceTypeFacebook) }
  @IBOutlet weak var tweetButton: SHButton!
  @IBAction func tweetPress(sender: SHButton) { showSocialComposer(SLServiceTypeTwitter) }
  @IBOutlet weak var instagramButton: SHButton!
  @IBAction func instagramShare(sender: SHButton) { UIApplication.sharedApplication().openURL(Const.instaURL) }
  
  var detailItem: SHEvent?
  
  //MARK: - VC lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
    self.navigationItem.leftItemsSupplementBackButton = true
    
    //don't bother configuring until we have an event
    //relevant for iPad, where we start out on the DetailView
    if detailItem != nil {
      configureForEvent()
      showSocialMediaButtons()
      grabImageForEvent()
    }
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    //stick Social Hippo logo in navigation bar title
    let logo = UIImage(named: "logo-s")
    let imageView = UIImageView(image:logo)
    self.navigationItem.titleView = imageView
  }
  
  //MARK: - UI
  
  func configureForEvent() {
    //Updates the non-image aspects of this event in the UI
    guard let event = detailItem else {
      return
    }
    eventTitle.text = event.title
    eventCategory.text = event.category.textRep
    longDescription.text = event.eventDescription
    hashtagLabel.text = event.hashtags?.joinWithSeparator(", ")
    
    if let readMoreString = event.readMore where !readMoreString.isEmpty {
      readMoreButton.hidden = false
    }
    
    eventImage.hidden = true
    eventImage.alpha = 0.0
    imageCaption.text = ""
    view.setNeedsLayout()
  }
  
  func showSocialMediaButtons() {
    if UIApplication.sharedApplication().canOpenURL(Const.instaURL) {
      instagramButton?.hidden = false
    }
    if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
      print("available for FB")
      fbShareButton?.hidden = false
    }
    if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
      print("available for Twitter")
      tweetButton?.hidden = false
    }
  }
  
  //MARK: - Images
  
  func grabImageForEvent() {
    self.activityIndicator.startAnimating()
    
    guard let tags = detailItem?.hashtags where tags.count >= 1 else {
      setDefaultEventImage()
      return
    }
    //currently searching only the first tag.
    //if we want to search all tags later, use tags.joinWithSeparator(", ") then trim out hashtag
    let hashtag = NSCharacterSet(charactersInString: "#")
    let searchTags = tags[0].stringByTrimmingCharactersInSet(hashtag)
    
    let request = Flickr.Router.PhotoSearch(searchTags)
    Alamofire.request(request).responseJSON() { response in
      
      if response.result.isSuccess {
        if let value = response.result.value {
          let json = JSON(value)
          let photo = json["photos"]["photo"][0]
          //grab fields necessary for downloading image
          guard let farm = photo["farm"].int, let server = photo["server"].string, let id = photo["id"].string, let secret = photo["secret"].string else {
            self.setDefaultEventImage()
            return
          }
          self.detailItem?.caption = photo["ownername"].string
          let staticImageString = "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg"
          print("Grabbing image at: "+staticImageString)
          let imageURL = NSURL(string: staticImageString)!
          self.eventImage.kf_setImageWithURL(imageURL, placeholderImage: nil, optionsInfo: nil, completionHandler: self.imageFetchCompletion)
        }
      }
      else {
        print("Error searching Flickr for photos via Alamofire:")
        print(response.result.error?.localizedDescription)
        self.setDefaultEventImage()
      }
    }
  }
  
    func imageFetchCompletion(image: Image?, error: NSError?, cacheType: CacheType, imageURL: NSURL?) {
      guard error == nil else {
        print(error!.localizedDescription)
        self.setDefaultEventImage()
        return
      }
      //success! Fade in the image and set a caption
      self.activityIndicator.stopAnimating()
      self.eventImage.hidden = false
      UIView.animateWithDuration(0.5) {
        self.eventImage.alpha = 1
      }
      if let caption = detailItem?.caption {
        self.imageCaption.text = "Flickr: "+caption
      }
    }
  
  func setDefaultEventImage() {
    self.activityIndicator.stopAnimating()
    
    guard let filename = detailItem?.category.textRep.lowercaseString,
      let image = UIImage(named: filename) else {
        return
    }
    self.eventImage.image = image
    self.eventImage.hidden = false
    UIView.animateWithDuration(0.5) {
      self.eventImage.alpha = 1
    }
  }
  
  //MARK: - Helper functions
  
  func showSocialComposer(serviceType: String) {
    let composer: SLComposeViewController = SLComposeViewController(forServiceType: serviceType)
    self.presentViewController(composer, animated: true, completion: nil)
  }
}

