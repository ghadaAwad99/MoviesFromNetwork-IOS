

import Kingfisher
import UIKit

class ViewController: UIViewController {

      
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var grossLable: UILabel!
    @IBOutlet weak var weekendLable: UILabel!
    @IBOutlet weak var rankLable: UILabel!
    @IBOutlet weak var titleLable: UILabel!
    var movie : Item = Item()
       
       override func viewDidLoad() {
           super.viewDidLoad()
           // Do any additional setup after loading the view.
          titleLable.text = movie.title
          rankLable.text =  String(movie.rank ?? "")
          weekendLable.text =  String( movie.weekend ?? "")
          grossLable.text = movie.gross
          posterImage.kf.setImage(with: URL(string: movie.image ??  "picture.png"))
       }


}

