//
//  ViewController.swift
//  API-Sandbox
//
//  Created by Dion Larson on 6/24/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import AlamofireImage
import AlamofireNetworkActivityIndicator

class ViewController: UIViewController {

    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var rightsOwnerLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    var linkToMovie: String!
    
    @IBAction func newMovieButton(sender: AnyObject) {
        viewDidLoad() 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //exerciseOne()
        //exerciseTwo()
        //exerciseThree()
        
        let apiToContact = "https://itunes.apple.com/us/rss/topmovies/limit=25/json"
        // This code will call the iTunes top 25 movies endpoint listed above
        // Creates a GET request to apiToContact, Validates the request to ensure it worked
        // Passes the JSON response to a closure
        Alamofire.request(.GET, apiToContact).validate().responseJSON() { response in
            // In the closure handle success and failure with a switch statement
            switch response.result {
            // If successful, create a JSON object from the response.result's value
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    // let topMoviesData is an array from the JSON object
                    let topMoviesData = json["feed"]["entry"].arrayValue
                    // array of Movie structs
                    var allMovies: [Movie] = []
                    
                    for movie in topMoviesData {
                        //each currentMovie equals Movie struct
                        let currentMovie = Movie(json: movie)
                        //add/append each struct into allMovies array of structs
                        allMovies.append(currentMovie)
                        
                    }
                    
                    //stackoverflow.com/questions/24003191/pick-a-random-element-from-an-array
                    let randomIndex = Int(arc4random_uniform(UInt32(allMovies.count)))
                    print(allMovies[randomIndex])
                    
                    self.movieTitleLabel.text = allMovies[randomIndex].name
                    
                    self.rightsOwnerLabel.text = allMovies[randomIndex].rightsOwner
                    
                    self.releaseDateLabel.text = allMovies[randomIndex].releaseDate
                    
                    //stackoverflow.com/questions/25339936/swift-double-to-string
                    self.priceLabel.text = String(format:"%.2f", allMovies[randomIndex].price)
                    
                    self.posterImageView.image = UIImage(contentsOfFile: allMovies[randomIndex].moviePoster)
                    
                    self.loadPoster(allMovies[randomIndex].moviePoster)
                    
                    self.linkToMovie = allMovies[randomIndex].link
                    
                    
                    // Do what you need to with JSON here!
                    // The rest is all boiler plate code you'll use for API requests
                    
                    
                }
            case .Failure(let error):
                print(error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Updates the image view when passed a url string
    func loadPoster(urlString: String) {
        posterImageView.af_setImageWithURL(NSURL(string: urlString)!)
    }
    
    @IBAction func viewOniTunesPressed(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: linkToMovie)!)

    }
    
}

