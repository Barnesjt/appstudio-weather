import QtQuick 2.13
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13
import QtGraphicalEffects 1.0

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

    FontLoader {
      id: robotoReg
      source: app.folder.fileUrl("./fonts/Roboto-Regular.ttf")
    }

    StackView {
      id: stack
      initialItem: weather
      anchors.fill: parent

    }

    Component {
      id: weather
      WeatherPage {
        fontFace: robotoReg.name
        anchors.fill: parent
        onNext: {
          stack.push(location)
        }
      }
    }

    Component {
      id:location
      LocationPage {
        fontFace: app.robotoReg.name
        anchors.fill: parent

        onBack: {
          stack.pop();
        }
      }
    }

}






