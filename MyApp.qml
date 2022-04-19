import QtQuick 2.13
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13
import QtGraphicalEffects 1.0
import QtPositioning 5.3
import QtSensors 5.3

import ArcGIS.AppFramework 1.0

App{
    id: app
    width: 421
    height: 750

    readonly property color primaryColor: "#3F51B5"
    readonly property color accentColor: Qt.lighter(primaryColor,1.2)
    readonly property color headerTextColor: "#ffffff"
    readonly property color buttonBackgroundColor: accentColor
    readonly property color buttonTextColor: "#ffffff"

    property real scaleFactor: AppFramework.displayScaleFactor
    readonly property real baseFontSize: app.width < 450*app.scaleFactor? 21 * scaleFactor:23 * scaleFactor
    readonly property real titleFontSize: app.baseFontSize
    readonly property real subtitleFontSize: 1.1 * app.baseFontSize

    PositionSource {
      id: locSrc
      active: true
      updateInterval: 60000
      property real longi: 0
      property real latit: 0

      onPositionChanged: {
        var coord = locSrc.position.coordinate;

        //EW or NS distance from prior loc is greater than ~.7 miles, then update weather
        //Otherwise, we'll disregard the change
        //This is to minimize Weather API calls, since I want to be kind to the public API
        if(Math.abs(coord.longitude-longi) > 0.01 || Math.abs(coord.latitude-latit) > 0.01){
          longi = coord.longitude.toPrecision(6);
          latit = coord.latitude.toPrecision(6);
          //replace page in place
          stack.replace(weather);
        }
      }
    }

    FontLoader {
      id: robotoReg
      source: app.folder.fileUrl("./fonts/Roboto-Regular.ttf")
    }

    StackView {
      id: stack
      initialItem: blank
      anchors.fill: parent

    }

    Component {
      id: blank
      Page {

      }
    }

    Component {
      id: weather
      WeatherPage {
        fontFace: robotoReg.name
        anchors.fill: parent
        latitude: locSrc.latit
        longitude: locSrc.longi
        onNext: {
          stack.push(location)
        }
      }
    }

    Component {
      id:location
      LocationPage {
        anchors.fill: parent

        onBack: {
          stack.pop();
        }
      }
    }

}






