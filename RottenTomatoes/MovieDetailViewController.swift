//
//  MovieDetailViewController.swift
//  RottenTomatoes
//
//  Created by Yeu-Shuan Tang on 2/5/15.
//  Copyright (c) 2015 Yeu-Shuan Tang. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var detailScrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var scrollerSubView: UIView!
   
    var movies: [NSDictionary]! = []
    var indexPath : NSIndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        var movie = movies[indexPath.row]
        titleLabel.text = movie["title"] as? String
        synopsisLabel.text = movie["synopsis"] as? String
        
        var url = movie.valueForKeyPath("posters.thumbnail") as String
        url = url.substringWithRange(Range<String.Index>(start: url.startIndex, end: advance(url.endIndex, -7))) + "ori.jpg"
 
        posterView.setImageWithURL(NSURL(string: url))
        
        navigationItem.title = movie["title"] as? String
        
        detailScrollView.addSubview(scrollerSubView)


    }

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
