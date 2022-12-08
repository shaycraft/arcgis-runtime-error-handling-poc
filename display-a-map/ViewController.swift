import UIKit

import ArcGIS

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: AGSMapView!
    
    private func   setupMap() throws -> AGSFeatureLayer {
        
        let map = AGSMap(
            basemapStyle: .arcGISTopographic
        )
        
        let featureLayer: AGSFeatureLayer = {
            // Malform this URL to test errors
            let featureServiceURL = URL(string: "https://services3.arcgis.com/GVgbJbqm8hXASVYi/arcgis/rest/services/Trailheads/FeatureServer/0")!
            let trailheadsTable = AGSServiceFeatureTable(url: featureServiceURL)
            return AGSFeatureLayer(featureTable: trailheadsTable)
        }()
        
        map.operationalLayers.add(featureLayer)
        
        featureLayer.load { [weak self] (error: Error?) in
            guard let self = self else { return }
            if let error = error {
                self.printeDebugMessage(message:  "[LOAD CALLBACK], ERROR: \(error)")
                self.displayErrorAlert(error: "Error loading map image layer: \(error.localizedDescription)")
            } else {
                self.printeDebugMessage(message: "[LOAD CALLBACK]: SUCCESS, no error")
                // no error, can do dependent processing here
            }
        }
        mapView.map = map
        
        mapView.setViewpoint(
            AGSViewpoint(
                latitude: 34.02700,
                longitude: -118.71511,
                scale: 200_000
            )
        )
        
        
        return featureLayer
    }
    
    private func printeDebugMessage(message :String) -> Void {
        print("========================== DEBUG PRINT ===========================")
        print(message)
        print("========================== END DEBUG =============================")
        print("")
        print("")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let mapResult = try setupMap()
            self.printeDebugMessage(message: "[BEFORE TIME DELAY], loadStatus:  " + String(mapResult.loadStatus.rawValue))
           
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                self.printeDebugMessage(message: "[AFTER TIME DELAY], loadError:   " + (mapResult.loadError?.localizedDescription ?? "[EMPTY]"))
                self.printeDebugMessage(message: "[AFTER TIME DELAY], loadStatus: " + String(mapResult.loadStatus.rawValue))
            }
        } catch {
            self.printeDebugMessage(message: "[ERROR]: Error thrown in main thread!")
        }
    }
    
    @IBAction func displayErrorAlert(error: String) {
        // Create the action buttons for the alert.
        let defaultAction = UIAlertAction(title: "Lorem Ipsum",
                                          style: .default) { (action) in
            // Respond to user selection of the action.
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel) { (action) in
            // Respond to user selection of the action.
        }
        
        // Create and configure the alert controller.
        let alert = UIAlertController(title: "ERROR ERROR ERROR",
                                      message: error,
                                      preferredStyle: .alert)
        alert.addAction(defaultAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true) {
            // The alert was presented
        }
    }
    
}
