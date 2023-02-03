import UIKit

import ArcGIS

extension ViewController: AGSAuthenticationManagerDelegate {
    func authenticationManager(_ authenticationManager: AGSAuthenticationManager, didReceive challenge: AGSAuthenticationChallenge) {
        // NOTE: Never hardcode login information in a production application. This is done solely for the sake of the sample.
        printDebugMessage(message: "We been challenged!")
        // need to get token from token endpoint and paste here
        let credentials = AGSCredential(token: "YKXamjz1XW43-SsAlEh-cjiAvMiHrHf_6RCR8sFWfrs.", referer: "http://localhost")
        challenge.continue(with: credentials)
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: AGSMapView!
    
    private func setupMap() throws -> AGSFeatureLayer {
        
        let map = AGSMap(
            basemapStyle: .arcGISTopographic
        )
        
        AGSAuthenticationManager.shared().delegate = self
        
        let featureLayer: AGSFeatureLayer = {
            // Malform this URL to test errors
            //            let url = "https://foh1kgodaj.execute-api.us-west-2.amazonaws.com/arcgis/foo"
            //            let url = "https://xho1ow9dj5.execute-api.us-west-2.amazonaws.com/arcgis/foo"
            //             let url = "https://services3.arcgis.com/GVgbJbqm8hXASVYi/arcgis/rest/services/Trailheads/FeatureServer/0"
            
            // dev region url endpoint
            let url = "https://fjk1l1iw9b.execute-api.us-east-2.amazonaws.com/arcgis/rest/services/GFEE/Land/FeatureServer/6"
            let featureServiceURL = URL(string: url)!
            let trailheadsTable = AGSServiceFeatureTable(url: featureServiceURL)
            return AGSFeatureLayer(featureTable: trailheadsTable)
        }()
        
        
        featureLayer.load { [weak self] (error: Error?) in
            guard let self = self else { return }
            if let error = error {
                self.printDebugMessage(message:  "[LOAD CALLBACK], ERROR: \(error)")
                self.displayErrorAlert(error: "Error loading map image layer: \(error.localizedDescription)")
            } else {
                self.printDebugMessage(message: "[LOAD CALLBACK]: SUCCESS, no error")
                // no error, can do dependent processing here
                
                map.operationalLayers.add(featureLayer)
                
            }
        }
        
        let featureLayerAnno: AGSFeatureLayer = {
            let lotAnnoUrl = URL(string: "https://fjk1l1iw9b.execute-api.us-east-2.amazonaws.com/arcgis/rest/services/GFEE/Land/FeatureServer/1")!
            let annoTable = AGSServiceFeatureTable(url: lotAnnoUrl)
            return AGSFeatureLayer(featureTable: annoTable)
        }()
        
//        featureLayerAnno.load { [weak self] (error: Error?) in
//            guard let self = self else { return }
//            if let error = error {
//                self.printDebugMessage(message:  "[ANNO LOAD CALLBACK], ERROR: \(error)")
//                self.displayErrorAlert(error: "Error loading map image layer: \(error.localizedDescription)")
//            } else {
//                self.printDebugMessage(message: "[ANNO LOAD CALLBACK]: SUCCESS, no error")
//                // no error, can do dependent processing here
//
//                map.operationalLayers.add(featureLayerAnno)
//
//            }
//        }
        map.operationalLayers.add(featureLayerAnno)
        
        
        mapView.map = map
        
        mapView.setViewpoint(
            AGSViewpoint(
                latitude: 39.72700,
                longitude: -104.85511,
                scale: 30_000
            )
        )
        
        
        return featureLayer
    }
    
    private func printDebugMessage(message :String) -> Void {
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
            self.printDebugMessage(message: "[BEFORE TIME DELAY], loadStatus:  " + String(mapResult.loadStatus.rawValue))
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                self.printDebugMessage(message: "[AFTER TIME DELAY], loadError:   " + (mapResult.loadError?.localizedDescription ?? "[EMPTY]"))
                self.printDebugMessage(message: "[AFTER TIME DELAY], loadStatus: " + String(mapResult.loadStatus.rawValue))
            }
        } catch {
            self.printDebugMessage(message: "[ERROR]: Error thrown in main thread!")
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
