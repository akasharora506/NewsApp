import CoreLocation

public class MapViewModel {
    var cityName = Box("")
    var onErrorHandling : ((Error) -> Void)?
    func updateCity(currLocation: CLLocation,completion: ((Result<Bool, Error>) -> Void)? = nil) {
        CLGeocoder().reverseGeocodeLocation(currLocation, completionHandler: {(placemarks, error) -> Void in
            // swiftlint: disable force_unwrapping
                guard error == nil else {
                    self.onErrorHandling?(error!)
                    return
                }
                guard placemarks?.count ?? 0 > 0 else {
                    self.onErrorHandling?(error!)
                    return
                }
            let placeMark = placemarks?[0]
            self.cityName.value = placeMark?.locality ?? placeMark?.country ?? ""
            })
    }
}
