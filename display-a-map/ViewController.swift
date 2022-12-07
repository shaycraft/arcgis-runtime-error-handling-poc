// Copyright 2020 Esri
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.


import UIKit

import ArcGIS

class ViewController: UIViewController {

    @IBOutlet weak var mapView: AGSMapView!

    private func setupMap() throws -> AGSFeatureLayer {

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

        print("status = ")
        print(featureLayer.debugDescription)
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

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            print("Lez do this!")
            let foo = try setupMap()
            print(foo.loadStatus.rawValue)
            print(foo.loadError?.localizedDescription)
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                print("After the timer, it be...")
                print(foo.loadError?.localizedDescription)
                print(foo.loadStatus.rawValue)
            }
            
//        setupMap()
        } catch {
            print("Oh noes")
        }
    }

}


