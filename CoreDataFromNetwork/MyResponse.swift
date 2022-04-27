

import Foundation

class Item : Decodable {
    var id : String?
    var rank : String?
    var title : String?
    var image : String?
    var weekend : String?
    var gross : String?
    var weeks : String?
}

class MyResponse : Decodable {
    var items : [Item]
    var errorMessage : String?
}
