import QtQuick 2.13
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13
import QtGraphicalEffects 1.0

import ArcGIS.AppFramework 1.0

Item{
  id:currWeather
  
  property real currTemp
  property real highTemp
  property real lowTemp
  property var fontFace

  property int availWidth
  property int availHeight

  property color fontColorNow
  property color fontColorHigh
  property color fontColorLow

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

    Text{
      anchors.left: parent.left
      anchors.right: highLowCol.left
      anchors.rightMargin: availWidth * .10
      horizontalAlignment: Text.AlignRight

      Layout.fillHeight: true
      Layout.preferredWidth: availWidth * .65
      style: Text.Raised
      styleColor: "#777777"
      text: currTemp + "°"
      font.family: fontFace
      color: fontColorNow
      font.pixelSize: availWidth * .3
    }
    
    ColumnLayout {
      id: highLowCol
      height: availHeight
      spacing: availHeight * .15
      anchors.right: parent.right
      anchors.rightMargin: availWidth * .15
      Text{
        anchors.top: currWeather.top
        style: Text.Raised
        styleColor: "#AAAAAA" 
        text: highTemp + "°"
        font.family: fontFace
        color: fontColorHigh
        font.pixelSize: availWidth * .1
      }
      Text{
        style: Text.Raised
        styleColor: "#AAAAAA" 
        anchors.bottom: currWeather.bottom
        text: lowTemp + "°"
        font.family: fontFace
        color: fontColorLow
        font.pixelSize: availWidth * .1
      }
    }
  }

}