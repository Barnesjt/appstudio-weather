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
  property real latitude
  property real longitude
  property var allDays
  property real currTemp

  signal next()

  function isWide(){
    if(weatherpage.width > weatherpage.height){
      return true;
    }
    return false;
  }

  function goMap(){
    next();
  }

  Database {
    id: db
    longitude: weatherpage.longitude
    latitude: weatherpage.latitude

    onDone: {
      weatherpage.allDays = db.allDays;
      weatherpage.currTemp = db.currTemp;
    }
  }

  Image {
    anchors.fill: parent
    id: bgImage
    source: "assets/matthew-smith-rFBA42UFpLs-unsplash.jpg"
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
        currTemp: Math.round(weatherpage.currTemp)
        highTemp: Math.round(weatherpage.allDays[0].max)
        lowTemp:  Math.round(weatherpage.allDays[0].min)
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
        longitude: weatherpage.longitude.toPrecision(5)
        latitude: weatherpage.latitude.toPrecision(5)
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
        forecast: weatherpage.allDays.splice(1,weatherpage.allDays.length-1) //drop the first day
        fontFace: weatherpage.fontFace
        fontColor: "#FFFFFF"
        availWidth: weatherpage.width
        availHeight: weatherpage.height * .4
      }
    }
  }
}

