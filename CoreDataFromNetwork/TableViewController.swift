

import Kingfisher
import UIKit
import Network
import CoreData


class TableViewController: UITableViewController {
    var moviesList : [Item] = []
    let monitor = NWPathMonitor()
    var moviesManagedObjects : [NSManagedObject] = []
    var viewContext : NSManagedObjectContext!
    var fetch: NSFetchRequest<NSManagedObject> = NSFetchRequest<NSManagedObject>()
    
    @IBOutlet var myTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTable.delegate = self
        myTable.dataSource = self
        
        let appDelegat = UIApplication.shared.delegate as! AppDelegate
        viewContext = appDelegat.persistentContainer.viewContext
        
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        indicator.startAnimating()
        
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("You are Online!")
                
                NetworkManager.fetchResult { [weak self] (result) in
                    DispatchQueue.main.async{
                        self?.moviesList = result?.items ?? []
                        self?.tableView.reloadData()
                        indicator.stopAnimating()
                        
                        //insert in core data
                        let entity = NSEntityDescription.entity(forEntityName: "Movies", in: self!.viewContext)
                        
                        self!.moviesList.forEach { (movie) in
                            let newMovie = NSManagedObject(entity: entity!, insertInto: self!.viewContext)
                            print(movie.title ?? "")
                            newMovie.setValue(movie.title, forKey: "title")
                            newMovie.setValue(movie.rank, forKey: "rank")
                            newMovie.setValue(movie.weekend, forKey: "weekend")
                            newMovie.setValue(movie.image, forKey: "image")
                            self!.myTable.reloadData()
                        }
                        do{
                            
                            try self!.viewContext.save()
                            
                            print("inserted in core data")
                        }catch let error{
                            print(error.localizedDescription)
                        }
                    }
                }
            } else {
                
                print("You Are Offline.")
                //fetch from core data
                self.fetch = NSFetchRequest<NSManagedObject>(entityName: "Movies")
                DispatchQueue.main.async{
                    indicator.stopAnimating()
                }
                
                do{
                    
                    
                    self.moviesManagedObjects = try self.viewContext.fetch(self.fetch)
                    self.moviesList.removeAll()
                    
                    for movieItem in self.moviesManagedObjects{
                        
                        let movie = Item()
                        movie.title = (movieItem.value(forKey: "title") as! String)
                        movie.rank =  (movieItem.value(forKey: "rank") as! String)
                        movie.weekend =  (movieItem.value(forKey: "weekend") as! String)
                        movie.image =  (movieItem.value(forKey: "image") as! String)
                        print(movie.title ?? "movie name")
                        self.moviesList.append(movie)
                    }
                }catch{
                    print("Couldn't fetch!")
                }
            }
            print(path.isExpensive)
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(moviesList.count)
        return moviesList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = moviesList[indexPath.row].title
        
        cell.imageView?.kf.setImage(with: URL(string: moviesList[indexPath.row].image ??  "picture.png"))
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let secondVC = self.storyboard?.instantiateViewController(identifier: "details") as! ViewController
        secondVC.movie = moviesList[indexPath.row]
        self.navigationController?.pushViewController(secondVC, animated: true)
    }
    
}
