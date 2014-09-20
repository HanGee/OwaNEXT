import QtQuick 2.0
import QtQuick.LocalStorage 2.0 as Sql

Item {
    property var db

    Component.onCompleted: {
        db = Sql.LocalStorage.openDatabaseSync("Hangee", "1.0",
                                               "Database for Hangee", 100000)
        db.transaction(function (tx) {
            var query = "CREATE TABLE IF NOT EXISTS Position(AppID TEXT, DesktopID INTEGER, PositionID INTEGER)"
            tx.executeSql(query)
        })
    }

    function appInfo(AppID, DesktopID, PositionID) {
        this.AppID = AppID
        this.DesktopID = DesktopID
        this.PositionID = PositionID
    }

    function insert(AppID, DesktopID, PositionID) {
        db.transaction(function (tx) {
            var query = "INSERT INTO Position VALUES(?, ?, ?)"
            tx.executeSql(query, [AppID, DesktopID, PositionID])
        })
    }

    function select(AppID) {
        var jsondata
        db.transaction(function (tx) {
            var rs = tx.executeSql("SELECT * FROM Position WHERE AppID = ?",
                                   [AppID])

            for (var i = 0; i < rs.rows.length; i++) {
                jsondata = "{\"AppID\":\"" + rs.rows.item(
                            i).AppID + "\", \"DesktopID\":\"" + rs.rows.item(
                            i).DesktopID + "\", \"PositionID\":\"" + rs.rows.item(
                            i).PositionID + "\"}"
            }
        })
        return jsondata
    }
}
