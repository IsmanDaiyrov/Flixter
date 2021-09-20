//
//  MoviesViewController.swift
//  flixter
//
//  Created by Isman Daiyrov on 9/12/21.
//

import UIKit
import AlamofireImage

// STEP 1: add UITableViewDataSource and UITableViewDelegate
class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    // Creation of an array of dictionaries
    var movies = [[String:Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // STEP 3: add this
        tableView.dataSource = self
        tableView.delegate = self

        // Do any additional setup after loading the view.
        
        // Get the list of "Now playing" movies from the API key
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                // Access a particular key inside the dictionary
                // and cast as an array of dictionaries
                self.movies = dataDictionary["results"] as! [[String:Any]]
                self.tableView.reloadData()
                
                    // TODO: Get the array of movies
                    // TODO: Store the movies in a property to use elsewhere
                    // TODO: Reload your table view data
             }
        }
        task.resume()
    }
    
    // STEP 2: create these 2 functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let synopsis = movie["overview"] as! String
        
        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie ["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
    
        cell.posterView.af.setImage(withURL: posterUrl!)
        
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        // Find the selected movie
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        let movie = movies[indexPath.row]
        
        // Pass the selected movie to the details view controller
        let detailsViewController = segue.destination as! MovieDetailsViewController
        detailsViewController.movie = movie
        
        // To deselect the row that user is clicking
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
