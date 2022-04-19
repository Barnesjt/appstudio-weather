import QtQuick 2.13
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13
import QtPositioning 5.3
import QtSensors 5.3

import ArcGIS.AppFramework 1.0
import Esri.ArcGISRuntime 100.13

import ArcGIS.AppFramework.Sql 1.0

//DB use:
// declare a Database type, set the longitude and latitude from the position
//  It'll run once, if network response fails, it'll load the database.
//  If it succeeds, it'll refresh the db (dumping the old values)
//  Need to handle the db refreshing on location change (if desired), could redraw the parent page on location change I suppose?
// Will need to convert unix time to Day name, might need to include timezone offset in schema
//    Almost might need to parse out local timezone name via JS

Item {
    id: weatherDB

    signal done()

    property real longitude: 0
    property real latitude: 0
    property real time: 0
    property real currTemp
    property var allDays: []
    property string jsonString: "nothing yet"

    //allDays will be an array of Objects, each is a day forcast, time is the unix time, max and min are the forecasted temps, the current day is included

    
    FileFolder {
      id: dbFilePath
      path: "~/ArcGIS/Data/Sql"
    }

    SqlDatabase {
      id: db
      databaseName: dbFilePath.filePath("weather.sqlite")
    }

    function getDBRecent() {
      db.open();
      //get the current weather from DB, is stored in member vars
      var query = db.query("SELECT * FROM weather_cache;");
      if(query.first()) {
        weatherDB.longitude = query.values.longitude;
        weatherDB.latitude = query.values.latitude;
        weatherDB.currTemp = query.values.currTemp;
        weatherDB.time = query.values.time;
      };

      weatherDB.allDays = [];

      //Select all daily forecasts, starting with most recent (lowest timestamp)
      query = db.query("SELECT * FROM weather_days ORDER BY time ASC;");
      for(var ok = query.first(); ok; ok = query.next()){
        weatherDB.allDays.push({
          time: query.values.time,
          max: query.values.max,
          min: query.values.min
        });
      }

      db.close();
      done();
    }

    //puts the api response in the dbs, first we delete the records (purging old records), then add the curr info, an one for each day (will be 7 total, including today)
    function putDB(time, lat, lon, currTemp, days) {
      db.open();
      var query = db.query("DELETE FROM weather_cache");
      var query = db.query("DELETE FROM weather_days");
      var insertString = "INSERT INTO weather_cache (time, latitude, longitude, currTemp) VALUES ('"+time+"','"+lat+"','"+lon+"','"+currTemp+"')";
      db.query(insertString);
      for(var i = 0; i<days.length;i++){
        var insertString = "INSERT INTO weather_days (time, max, min) VALUES ('"+days[i].time+"','"+days[i].max+"','"+days[i].min+"')";
        db.query(insertString);
      }
      db.close();
    }

    //on loading the page, set the schemas (if needed), pull the cached data first, then try the network request if it's the first one, or if it's been a minute (60k ms)
    Component.onCompleted: {
      dbFilePath.makeFolder();
      db.open();
      db.query("CREATE TABLE IF NOT EXISTS weather_cache (id INTEGER PRIMARY KEY AUTOINCREMENT, time INTEGER NOT NULL, latitude FLOAT NOT NULL, longitude FLOAT NOT NULL, currTemp FLOAT NOT NULL)");
      db.query("CREATE TABLE IF NOT EXISTS weather_days (id INTEGER PRIMARY KEY AUTOINCREMENT, time INTEGER NOT NULL, max FLOAT NOT NULL, min FLOAT NOT NULL)");
      db.close();
      getDBRecent();
//      if(Date.now() - weatherDB.time > 60000){
        weatherRequest.send();
//      }
    }

    //generate the api query url from long/lat, no api key needed, thanks open-mateo
    function urlFromCoords(lon, lat) {
      return "https://api.open-meteo.com/v1/forecast?latitude=" + lat + "&longitude=" + lon + "&daily=temperature_2m_max,temperature_2m_min&current_weather=true&temperature_unit=fahrenheit&windspeed_unit=mph&timeformat=unixtime&timezone=America%2FLos_Angeles";
    }

    //Make a purpose build object array from the api response for the daily forecasts
    function compileDays(input) {
      var days = [];
      for(var i = 0; i < input.daily.time.length; i++){
        days.push({
          time: input.daily.time[i],
          max: input.daily.temperature_2m_max[i],
          min: input.daily.temperature_2m_min[i]
        });
      }
      return days;
    }

    //handle the network response, needs .send() to be called. The below handler will handle the json reponse, first case handles no good response  (offline)
    NetworkRequest {
      id: weatherRequest
      url: urlFromCoords(weatherDB.longitude, weatherDB.latitude)
      onReadyStateChanged: {
        console.log(response);
        if(readyState == NetworkRequest.DONE){
          if(errorCode !== 0) {
            getDBRecent();
          } else {
            var weatherReponse = JSON.parse(responseText)
            putDB(Date.now(), weatherDB.latitude, weatherDB.longitude, weatherReponse.current_weather.temperature, compileDays(weatherReponse));
            getDBRecent();
          }
        }
      }
    }
}
