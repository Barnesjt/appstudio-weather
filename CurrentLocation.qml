import QtQuick 2.13
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13
import QtGraphicalEffects 1.0

import ArcGIS.AppFramework 1.0

Item{
  id: currLocation
  signal next()
  
  property real latitude
  property real longitude
  property var fontFace
  property int availWidth
  property int availHeight
  property color fontColorLabel
  property color fontColorLoc
  
  width: availWidth

  RowLayout {
    spacing: availWidth * .2
    anchors.left: parent.left
    anchors.right: parent.right

    Rectangle {
      anchors.fill: parent
      anchors.rightMargin: availWidth * .05
      anchors.leftMargin: availWidth * .05
      anchors.topMargin: availHeight * .05
      anchors.bottomMargin: availHeight * .05
      color: "#66181818"
      z: 0
      radius: availWidth * .15
    }

    ColumnLayout {
      id: locLabels
      height: availHeight
      spacing: availHeight * .15
      anchors.left: parent.left
      anchors.leftMargin: availWidth * .15
      Text{
        anchors.top: currLocation.top
        horizontalAlignment: Text.AlignRight
        text: "Latitude:"
        font.family: fontFace
        color: fontColorLabel
        font.pixelSize: availWidth * .075
      }
      Text{
        anchors.bottom: currLocation.bottom
        horizontalAlignment: Text.AlignRight
        text: "Longitude:"
        font.family: fontFace
        color: fontColorLabel
        font.pixelSize: availWidth * .075
      }
    }

    ColumnLayout {
      id: locValues
      height: availHeight
      spacing: availHeight * .15
      anchors.left: locLabels.right
      anchors.rightMargin: availWidth * .05
      Text{
        horizontalAlignment: Text.AlignLeft
        anchors.top: currLocation.top
        text: latitude
        font.family: fontFace
        color: fontColorLoc
        font.pixelSize: availWidth * .075
      }
      Text{
        horizontalAlignment: Text.AlignLeft
        anchors.bottom: currLocation.bottom
        text: longitude
        font.family: fontFace
        color: fontColorLoc
        font.pixelSize: availWidth * .075
      }
    }

    Image {
      anchors.left: locValues.right
      height: availHeight * .85
      width: availHeight * .85
      id: bgImage
      source: "assets/outline_location_on_white_48dp.png"
      fillMode: Image.PreserveAspectFit
      mipmap: true

      MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked:{
          next();
        }
      }
      
    }
  }
}