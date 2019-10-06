import UIKit
import UserNotifications
import MapKit
import CoreLocation

class PlacesTableViewController: UITableViewController, UISearchBarDelegate, CLLocationManagerDelegate {
  
  @IBOutlet weak var searchBar: UISearchBar!
  var searchActive : Bool = false
  var places:Places = Places()
  let locationManager = CLLocationManager() // create Location Manager object
  var latitude : Double?
  var longitude : Double?
  
  let rest = RestManager()
  override func viewDidLoad() {
    super.viewDidLoad()
    locationManager.requestAlwaysAuthorization()
    locationManager.requestWhenInUseAuthorization()
    if CLLocationManager.locationServicesEnabled() {
      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
      locationManager.startUpdatingLocation()
    }
    
    tableView.delegate = self
    tableView.dataSource = self
    searchBar.delegate = self
    
    getNearByPlaces()
  }
  
  //Becomes first responder
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    searchActive = true;
  }
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    searchActive = false;
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchActive = false;
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    getNearByPlaces()
    searchActive = false;
  }
  
  func getNearByPlaces() {
    print(self.latitude as Any, self.longitude as Any)
    guard let url = URL(string: "http://localhost:7000/search") else { return }
    rest.urlQueryParameters.add(value: "food", forKey: "input")
    rest.urlQueryParameters.add(value: "textquery", forKey: "inputtype")
    rest.urlQueryParameters.add(value: "photos,formatted_address,name,opening_hours,rating", forKey: "fields")
    
    rest.urlQueryParameters.add(value: "circle : \(self.latitude ?? 39.398037),\(self.longitude ?? -76.817085)", forKey: "locationbias")
    rest.urlQueryParameters.add(value: "\(self.latitude ?? 39.398037),\(self.longitude ?? -76.817085)", forKey: "location")
    
    //    rest.urlQueryParameters.add(value: "circle : 2000@39.398037,-76.817085", forKey: "locationbias")
    //    rest.urlQueryParameters.add(value: "39.398037,-76.817085", forKey: "location")
    rest.urlQueryParameters.add(value: "1000", forKey: "radius")
    rest.urlQueryParameters.add(value: "restaurant", forKey: "type")
    
    rest.makeRequest(toURL: url, withHttpMethod: .get) { (results) in
      if let data = results.data {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let placeData = try? decoder.decode(Places.self, from: data)
        self.places = placeData!
        //print("success")
      }
      
      self.tableView.isHidden = false
      self.tableView.dataSource = self
      self.tableView.delegate = self
      self.tableView.reloadData()
      
    }
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let rows = self.places.results?.count ?? 3
    return rows
    //return self.places.results?.count  ?? 1
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 110
  }
  
  // 1
  override func numberOfSections(in tableView: UITableView) -> Int {
    let rows = self.places.results?.count ?? 3
    return rows
  }
  
  // 3
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath)
    let name = self.places.results?[indexPath.row].name
    //var rating  = 1.0
    let rating = self.places.results?[indexPath.row].rating ?? 1.0
    cell.textLabel?.text = (name ?? "") + "    " + String(rating)
    return cell
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("section: \(indexPath.section)")
    print("row: \(indexPath.row)")
    print(self.places.results?[indexPath.row].placeId)
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
    print("locations = \(locValue.latitude) \(locValue.longitude)")
    self.longitude = locValue.longitude
    self.latitude = locValue.latitude
    getNearByPlaces()
  }
  
  
}
