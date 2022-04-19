import QtQuick 2.13
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13
import QtGraphicalEffects 1.0
import QtQml 2.15

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

    for(var i = 0; i < currForecast.forecast.length; i++) {
      var dateVar = new Date((currForecast.forecast[i].time + 3600 * 22) * 1000);
      var dayName = dateVar.toLocaleDateString(Qt.locale("en-US"), "dddd");
      res = res + "\n|   " + dayName + "   | " + Math.round(currForecast.forecast[i].max) + " | " + Math.round(currForecast.forecast[i].min) + " |";
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
      radius: availWidth * .05
    }

    Text {
      Layout.preferredWidth: availWidth
      Layout.preferredHeight: availHeight
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.top: parent.top
      anchors.leftMargin: availWidth * .04
      anchors.topMargin: availHeight * .08
      text: genMDTableFromForecast()
      font.family: fontFace
      color: fontColor
      font.pixelSize: availWidth * .06
      textFormat: Text.MarkdownText
    }

  }
}
