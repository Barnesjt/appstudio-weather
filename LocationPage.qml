/* Copyright 2020 Esri
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */


// You can run your app in Qt Creator by pressing Alt+Shift+R.
// Alternatively, you can run apps through UI using Tools > External > AppStudio > Run.
// AppStudio users frequently use the Ctrl+A and Ctrl+I commands to
// automatically indent the entirety of the .qml file.


import QtQuick 2.13
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13
import QtGraphicalEffects 1.0
import QtPositioning 5.3
import QtSensors 5.3

import ArcGIS.AppFramework 1.0
import Esri.ArcGISRuntime 100.13

Page{
  id: locationview
  signal back()
  clip: true

  anchors.fill: parent

  header: ToolBar {
    RowLayout {
      anchors.fill: parent
      ToolButton {
        icon.source: "assets/outline_arrow_back_white_48dp.png"
        onClicked: back()
      }
    }
  }

  Rectangle {
    anchors.fill: parent
    color: app.primaryColor

    MapView{
      id: mapView
      anchors.fill: parent
      Map {
        BasemapImageryWithLabels{}
        initialViewpoint: currViewpoint
        onLoadStatusChanged: {
          mapView.locationDisplay.autoPanMode = Enums.LocationDisplayAutoPanModeRecenter;
          mapView.locationDisplay.start();
        }
      }
      locationDisplay {
          positionSource: PositionSource {
            id: src
            active: true
            updateInterval: 1000
          }
          compass: Compass {}
      }
      Component.onCompleted : {
        mapView.locationDisplay.autoPanMode = Enums.LocationDisplayAutoPanModeRecenter;
      }
    } 
  }
}

