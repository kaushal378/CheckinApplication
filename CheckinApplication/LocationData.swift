import Foundation

var defString = String(stringLiteral: "")
var defInt = -1

struct PlaceData: Codable, CustomStringConvertible {
  var data: Places?
  
  var description: String {
    var desc = """
    Places:
    
    """
    if let places = data {
      desc+=places.status ?? "closed"
//      for place in places.results {
//        desc += place.id
//      }
    }
    
    return desc
  }
}

struct Places: Codable {
  var results: [results]?
  var htmlAttributions: [String]?
  var status: String?
  init(){
    
  }
}

struct results: Codable{
  var icon: String?
  var id: String?
  var name: String?
  var priceLevel: Int?
  var openingHours: OpeningHours?
  var photos: [photos]?
  var placeId: String?
  var plusCode: PlusCode?
  var rating: Double?
  var reference: String?
  var scope: String?
  var types: [String]?
  var userRatingsTotal: Double?
  var vicinity: String?
  
  
}

struct OpeningHours: Codable{
  var openNow: Bool?
}

struct photos: Codable{
  var height: Double?
  var width: Double?
  var photoReference: String?
}

struct PlusCode: Codable{
  var compoundCode: String?
  var globalCode: String?
}
