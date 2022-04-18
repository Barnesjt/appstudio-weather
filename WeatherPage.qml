import QtQuick 2.13
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13
import QtGraphicalEffects 1.0

import ArcGIS.AppFramework 1.0

Page{
  anchors.fill: parent
  clip: true
  id: weatherpage

  property var fontFace

  signal next()

  function getDummyForecast() {
    var res = []
    res.push({
      day: "Saturday",
      high: 61.0,
      low: 41.0
    });
    res.push({
      day: "Sunday",
      high: 61.0,
      low: 41.0
    });
    res.push({
      day: "Monday",
      high: 61.0,
      low: 41.0
    });
    res.push({
      day: "Tuesday",
      high: 61.0,
      low: 41.0
    });
    res.push({
      day: "Wednesday",
      high: 61.0,
      low: 41.0
    });
    res.push({
      day: "Thursday",
      high: 61.0,
      low: 41.0
    });
    res.push({
      day: "Friday",
      high: 61.0,
      low: 41.0
    });
    return res;
  }

  function isWide(){
    if(weatherpage.width > weatherpage.height){
      return true;
    }
    return false;
  }

  function getBGImage(){
    return "assets/matthew-smith-rFBA42UFpLs-unsplash.jpg"
  }

  function goMap(){
    next();
  }

  Image {
    anchors.fill: parent
    id: bgImage
    source: getBGImage()
    fillMode: Image.PreserveAspectCrop
    z: -1
    mipmap: true
  }
  
  ColumnLayout{

    Item{
      id: titleText
      Layout.preferredHeight: weatherpage.height * .1
      width: weatherpage.width
      height: weatherpage.height * .1
      anchors.top: parent.top
      anchors.topMargin: weatherpage.height * .07
      
      Text{
        anchors.centerIn: parent
        text: "Weather"
        color: "#FFFFFF"
        style: Text.Raised
        styleColor: "#666666" 
        font.family: fontFace
        font.pixelSize: weatherpage.height * .065 + weatherpage.width * .065
      }
    }

    Item{
      id: currWeatherItem
      Layout.preferredHeight: weatherpage.height * .2
      anchors.top: titleText.bottom
      height: weatherpage.height * .2
      anchors.topMargin: weatherpage.height * .05
      CurrentWeather{
        currTemp: 60.0
        highTemp: 65.0
        lowTemp:  45.0
        fontFace: weatherpage.fontFace
        fontColorNow: "#FFFFFF"
        fontColorHigh: "#FFFFFF"
        fontColorLow: "#FFFFFF"
        availWidth: weatherpage.width
        availHeight: weatherpage.height * .1
      }
    }

    Item{
      id: currLocationItem
      anchors.top: currWeatherItem.bottom
      Layout.preferredHeight: weatherpage.height * .1
      height: weatherpage.height * .1
      CurrentLocation{
        longitude: -123.0
        latitude: 44.8
        fontFace: weatherpage.fontFace
        fontColorLabel: "#FFFFFF"
        fontColorLoc: "#FFFFFF"
        availWidth: weatherpage.width
        availHeight: weatherpage.height * .1
        onNext: {
          goMap()
        }
      }
    }

    Item{
      id: currForecastItem
      Layout.preferredHeight: weatherpage.height * .4
      anchors.top: currLocationItem.bottom
      height: weatherpage.height * .4
      anchors.topMargin: weatherpage.height * .05
      CurrentForecast{
        forecast: getDummyForecast()
        fontFace: weatherpage.fontFace
        fontColor: "#FFFFFF"
        availWidth: weatherpage.width
        availHeight: weatherpage.height * .4
      }
    }
  }
}

