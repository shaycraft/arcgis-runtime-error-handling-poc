import UIKit

import ArcGIS

extension ViewController: AGSAuthenticationManagerDelegate {
    func authenticationManager(_ authenticationManager: AGSAuthenticationManager, didReceive challenge: AGSAuthenticationChallenge) {
        // NOTE: Never hardcode login information in a production application. This is done solely for the sake of the sample.
        printDebugMessage(message: "We been challenged!")
        // need to get token from token endpoint and paste here
        let credentials = AGSCredential(token: "YKXamjz1XW43-SsAlEh-clx3DvZtVkGx5s2NRzO-1QM.", referer: "http://localhost")
        challenge.continue(with: credentials)
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: AGSMapView!
    
    private func setupMap() throws -> AGSFeatureLayer {
        
        let map = AGSMap(
            basemapStyle: .arcGISModernAntique
        )
        
        AGSAuthenticationManager.shared().delegate = self
        
        let featureLayer: AGSFeatureLayer = {
            // Malform this URL to test errors
            //            let url = "https://foh1kgodaj.execute-api.us-west-2.amazonaws.com/arcgis/foo"
            //            let url = "https://xho1ow9dj5.execute-api.us-west-2.amazonaws.com/arcgis/foo"
            //             let url = "https://services3.arcgis.com/GVgbJbqm8hXASVYi/arcgis/rest/services/Trailheads/FeatureServer/0"
            
            // dev region url endpoint
            let url = "https://fjk1l1iw9b.execute-api.us-east-2.amazonaws.com/arcgis/rest/services/GFEE/Land/FeatureServer/0"
            let featureServiceURL = URL(string: url)!
            let featureTable = AGSServiceFeatureTable(url: featureServiceURL)
            return AGSFeatureLayer(featureTable: featureTable)
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
        
//        let featureLayerGasDistribution: AGSFeatureLayer = {
//            // let url = "https://fjk1l1iw9b.execute-api.us-east-2.amazonaws.com/arcgis/rest/services/GFEE/Gas_Distribution/FeatureServer/2" // casing
//            // let url = "https://fjk1l1iw9b.execute-api.us-east-2.amazonaws.com/arcgis/rest/services/GFEE/Gas_Distribution/FeatureServer/4" // control fitting
//            let url = "https://fjk1l1iw9b.execute-api.us-east-2.amazonaws.com/arcgis/rest/services/GFEE/Gas_Distribution/FeatureServer/17"
//
//            let featureTable = AGSServiceFeatureTable(url: URL(string: url)!)
//
//            return AGSFeatureLayer(featureTable: featureTable)
//        }()
//
//        featureLayerGasDistribution.load{ [weak self] (error: Error?) in
//            guard let self = self else { return }
//            if let error = error {
//                self.printDebugMessage(message: "Load callback ERROR: \(error)")
//                self.displayErrorAlert(error: "Error loading map image layer: \(error.localizedDescription)")
//            } else {
//                self.printDebugMessage(message: "No error happened")
//                map.operationalLayers.add(featureLayerGasDistribution)
//            }
//
//        }
        
                let featureLayerGasTransmission: AGSFeatureLayer = {
                    let url = "https://fjk1l1iw9b.execute-api.us-east-2.amazonaws.com/arcgis/rest/services/GFEE/Gas_Transmission/FeatureServer/28"
        
                    let featureTable = AGSServiceFeatureTable(url: URL(string: url)!)
                    
                    return AGSFeatureLayer(featureTable: featureTable)
                }()
        
        featureLayerGasTransmission.load{ [weak self] (error: Error?) in
                    guard let self = self else { return }
                    if let error = error {
                        self.printDebugMessage(message: "Load callback ERROR: \(error)")
                        self.displayErrorAlert(error: "Error loading map image layer: \(error.localizedDescription)")
                    } else {
                        self.printDebugMessage(message: "No error happened")
                        map.operationalLayers.add(featureLayerGasTransmission)
                    }
        
                }
        
//        let featureLayerLand: AGSFeatureLayer = {
//            let url = "https://fjk1l1iw9b.execute-api.us-east-2.amazonaws.com/arcgis/rest/services/GFEE/Land/FeatureServer/1" // lot centroid
//
//            let featureTable = AGSServiceFeatureTable(url: URL(string: url)!)
//
//            return AGSFeatureLayer(featureTable: featureTable)
//        }()
//
//        featureLayerLand.load{ [weak self] (error: Error?) in
//            guard let self = self else { return }
//            if let error = error {
//                self.printDebugMessage(message: "Load callback ERROR: \(error)")
//                self.displayErrorAlert(error: "Error loading map image layer: \(error.localizedDescription)")
//            } else {
//                self.printDebugMessage(message: "No error happened")
//                map.operationalLayers.add(featureLayerLand)
//            }
//
//        }
        
//        let featureLayerAnno: AGSFeatureLayer = {
//            let lotAnnoUrl = URL(string: "https://fjk1l1iw9b.execute-api.us-east-2.amazonaws.com/arcgis/rest/services/GFEE/Land/FeatureServer/1")!
//            let annoTable = AGSServiceFeatureTable(url: lotAnnoUrl)
//            return AGSFeatureLayer(featureTable: annoTable)
//        }()
        
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
        
        
        mapView.map = map
        
        let lat = 39.736943
        let long = -104.973093 // 13th & Downing, Denver
        
        mapView.setViewpoint(
            AGSViewpoint(
                latitude: lat,
                longitude: long,
                scale: 10_000
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
            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
//                self.printDebugMessage(message: "[AFTER TIME DELAY], loadError:   " + (mapResult.loadError?.localizedDescription ?? "[EMPTY]"))
//                self.printDebugMessage(message: "[AFTER TIME DELAY], loadStatus: " + String(mapResult.loadStatus.rawValue))
//            }
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
