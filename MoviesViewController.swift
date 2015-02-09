//
//  MoviesViewController.swift
//  RottenTomatoes
//
//  Created by Yeu-Shuan Tang on 2/4/15.
//  Copyright (c) 2015 Yeu-Shuan Tang. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSURLConnectionDelegate {
    
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorLabel: UILabel!
    
    var movies: [NSDictionary]! = []
    var color: UILabel! = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //page refresh controller
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)

        tableView.dataSource = self
        tableView.delegate = self
        
        //loading state
        SVProgressHUD.setRingThickness(5)
        SVProgressHUD.show()
        
        loadMovieData()
        SVProgressHUD.dismiss()
        
        navigationController?.navigationBar.barTintColor = UIColor.purpleColor()
        tableView.separatorColor = UIColor.purpleColor()
        
        errorLabel.text = "Network Error"

    }
    
    func loadMovieData(){
        
        var url = NSURL(string: "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=2yx7jatezfbyvb5nrxumexdx&&limit=30")
        
        var request = NSURLRequest(URL: url!)
        
        
        //usually don't use this
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            if(error == nil){
                var responseDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as NSDictionary
                
                self.movies = responseDictionary["movies"] as [NSDictionary]
                //run two tableView methods again
                self.tableView.reloadData()
                //            NSLog("Response : %@", responseDictionary)
                
                self.errorLabel.hidden = true
                self.tableView.hidden = false
                
            }
            else{
                self.tableView.hidden = true
                self.errorLabel.hidden = false
            }
        }
    }
    
    func onRefresh() {
        loadMovieData()
        refreshControl.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("MovieCell") as MovieCell
        var movie = movies[indexPath.row]
        cell.titleLabel.text = movie["title"] as? String
        cell.synopsisLabel.text = movie["synopsis"] as? String
        
        var year =  movie["year"] as? Int
        let y = year!
        var rating =  movie["mpaa_rating"] as? String
        cell.ratingLabel.text = String(y)+" "+rating!
        
        var url = movie.valueForKeyPath("posters.thumbnail") as String
        cell.posterView.setImageWithURL(NSURL(string: url))
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        var moviedetail = MovieDetailViewController()
//        navigationController?.presentViewController(moviedetail, animated: true, completion: nil)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        var vc = segue.destinationViewController as MovieDetailViewController
        
        var indexPath = tableView.indexPathForCell(sender as MovieCell)!
        
        vc.movies = self.movies
        vc.indexPath = indexPath
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

    

}
