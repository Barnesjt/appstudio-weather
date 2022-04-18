import QtQuick 2.13
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13
import QtGraphicalEffects 1.0

import ArcGIS.AppFramework 1.0

Item{
  id: currForecast
  
  property var forecast
  property var fontFace
  property int availWidth
  property int availHeight
  property color fontColor

  width: availWidth

  signal next()

  function genMDTableFromForecast(){

    var res = "|   | High | Low | \n | :-: | :-: | :-: | "

    for(var i = 0; i < forecast.length; i++) {
      res = res + "\n|   " + forecast[i].day + "   | " + forecast[i].high + " | " + forecast[i].low + " |";
    }
    return res;
  }


  RowLayout {
    spacing: 0
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.leftMargin: availWidth * .175
    anchors.rightMargin: availWidth * .175

    Rectangle {
      anchors.fill: parent
      color: "#66181818"
      z: 0
      radius: availWidth * .15
    }

    Text {
      Layout.preferredWidth: availWidth
      Layout.preferredHeight: availHeight
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.top: parent.top
      anchors.leftMargin: availWidth * .08
      anchors.topMargin: availHeight * .08
      text: genMDTableFromForecast()
      font.family: fontFace
      color: fontColor
      font.pixelSize: availWidth * .05
      textFormat: Text.MarkdownText
    }

  }
}