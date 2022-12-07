// Copyright 2021 Esri
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


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Note: it is not best practice to store API keys in source code.
        // The API key is referenced here for the convenience of this tutorial.

        AGSArcGISRuntimeEnvironment.apiKey = "AAPKd11368d6043b48449ba076433fe99388yh45QIVrF0fZtWddTOBleOGz6b1vf2bsBYy8YwqB4RHtXXHtPaXiZRe56RAyNeVe"

        return true
    }

}


