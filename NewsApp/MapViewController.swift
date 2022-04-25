import UIKit
import GoogleMaps
import CoreLocation

class MapViewController: UIViewController, UITableViewDelegate, CLLocationManagerDelegate {
    
    let header :UILabel = {
       let header = UILabel()
        header.text = "News by Location"
        header.textColor = .white
        header.backgroundColor = .purple
        header.textAlignment = .center
        header.font = .systemFont(ofSize: 24, weight: .bold)
        return header
    }()
    
    let modal = UITableView()
    let manager = CLLocationManager()
    let mapHolderView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(onGoBack))
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        GMSServices.provideAPIKey("AIzaSyAo8gjWdqT0YTRzSMqbuLT6inpE2nj9oeE")
        modal.register(MapTableViewCell.self, forCellReuseIdentifier: MapTableViewCell.identifier)
        modal.delegate = self
        modal.dataSource = self
        view.backgroundColor = .lightGray
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: view.frame, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.frame = CGRect(x: 0, y: 100, width: view.frame.width, height: view.frame.height - 100)
        view.addSubview(mapView)
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
        view.addSubview(header)
        view.addSubview(modal)
    }
    
    @objc func onGoBack(){
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        header.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
        modal.frame = CGRect(x: 10, y: view.frame.height - 310, width: view.frame.width - 20, height: 250)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        let coordinates = location.coordinate
        let camera = GMSCameraPosition.camera(withLatitude: coordinates.latitude, longitude: coordinates.longitude, zoom: 5.0)
        let mapView = GMSMapView.map(withFrame: view.frame, camera: camera)
        view.addSubview(mapView)
        mapView.frame = CGRect(x: 0, y: 100, width: view.frame.width, height: view.frame.height - 100)
        let marker = GMSMarker()
        marker.position = coordinates
        marker.map = mapView
    }
}

extension MapViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = modal.dequeueReusableCell(withIdentifier: MapTableViewCell.identifier, for: indexPath) as? MapTableViewCell else {
            return UITableViewCell()
        }
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: modal.frame.width, height: 50))

        let label = UILabel()
        label.text = "Results for New York"
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 21)
        headerView.addSubview(label)
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("Tap")
    }
}
