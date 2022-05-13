import UIKit
import GoogleMaps
import CoreLocation

class MapViewController: UIViewController, UITableViewDelegate, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    let viewModel = MapViewModel()
    let manager = CLLocationManager()
    let marker = GMSMarker()
    var cityName = ""

    let tableView :UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        title = "News by Location"
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        viewModel.cityName.bind { [weak self] cityName in
            self?.cityName = cityName
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
          }
        viewModel.updateCity(currLocation: manager.location ?? CLLocation(latitude: 0, longitude: 0))
        tableView.register(MapTableViewCell.self, forCellReuseIdentifier: MapTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.isScrollEnabled = false
        addConstraints()
    }

    func addConstraints(){
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -20))
        constraints.append(tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10))
        constraints.append(tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10))
        constraints.append(tableView.heightAnchor.constraint(equalToConstant: 250))
        
        NSLayoutConstraint.activate(constraints)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        let coordinates = location.coordinate
        let camera = GMSCameraPosition.camera(withLatitude: coordinates.latitude, longitude: coordinates.longitude, zoom: 5.0)
        let mapView = GMSMapView.map(withFrame: view.frame, camera: camera)
        mapView.settings.zoomGestures = false
        mapView.delegate = self
        view.addSubview(mapView)
        view.addSubview(tableView)
        mapView.frame = CGRect(x: 0, y: 100, width: view.frame.width, height: view.frame.height - 100)
        marker.position = coordinates
        marker.map = mapView
        manager.stopUpdatingLocation()
    }
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        viewModel.updateCity(currLocation: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude))
        marker.position = coordinate
        marker.map = mapView
    }
}

extension MapViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height - 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MapTableViewCell.identifier, for: indexPath) as? MapTableViewCell else {
            return UITableViewCell()
        }
        cell.cityName = self.cityName
        cell.parent = self
        DispatchQueue.main.async {
            cell.viewModel.fetchData(cityName: self.cityName)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))

        let label = UILabel()
        label.text = self.cityName != "" ? "Results for \(self.cityName)" : "No Results"
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 24, weight: .bold)
        headerView.addSubview(label)
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}
