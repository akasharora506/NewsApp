import CoreLocation

public class MapViewModel {
    var cityName = Box("")
    
    func updateCity(currLocation: CLLocation){
        
        CLGeocoder().reverseGeocodeLocation(currLocation, completionHandler: {(placemarks, error) -> Void in
                guard error == nil else {
                    fatalError()
                }
                guard placemarks?.count ?? 0 > 0 else {
                        fatalError()
                    }
            let placeMark = placemarks?[0]
            self.cityName.value = placeMark?.locality as? String ?? placeMark?.country as? String ?? ""
            })
 
    }
    
}
