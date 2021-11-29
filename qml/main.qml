import QtQuick 2.12
import QtQuick 2.9
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls 1.4
import QtQuick.Controls 2.5

Window {
    width: 1000
    height: 520
    visible: true
    visibility: "Windowed"
    title: qsTr("Login")

    Loader { id: pageLoader }

    Rectangle
    {
        anchors.fill: parent
        gradient: Gradient
        {
            GradientStop {position: 0.000;color: "#889695";}
            GradientStop {position: 0.08;color: "#CED6D5";}
            GradientStop {position: 0.92;color: "#CED6D5";}
            GradientStop {position: 1.000;color: "#889695";}
        }
    }



    //Sign-in Label:
    Label{
        text: qsTr("Sign in to continue")
        font.pixelSize: 45
        font.bold: true
        font.family: "Bahnschrift"
        color: "#6C8B80"
        style: Text.Raised
        styleColor: "black"
        x: 465
        y: 100
    }
    Image{
        id: logo
        source: "logopic.png"
        x: 35
        anchors.verticalCenter: parent.verticalCenter
        width: 340
        height: 130
    }

    //Line
    Rectangle {
        height: 180
        width: 2
        color: "#9FBBB1"
        x: 395
        anchors.verticalCenter: parent.verticalCenter
    }

    Rectangle {
        width: 450
        height: 200
        color: "white"
        radius: 10
        x:430
        anchors.verticalCenter: parent.verticalCenter

    }
    //Email Label
    Label{
        text: qsTr("NetID: ")
        font.pixelSize: 16
        font.family: "Bahnschrift"
        color: "#6C8B80"
        x: 440
        y: 185
    }

    //Email Input
    TextField {
        font.family: "Bahnschrift"
        x: 440
        y: 210
        width: 400
        height: 25
    }

    //Password Label
    Label{
        text: qsTr("Password: ")
        font.pixelSize: 16
        font.family: "Bahnschrift"
        color: "#6C8B80"
        x: 440
        y: 265
    }

    //Password Input
    TextField {
        font.family: "Bahnschrift"
        x: 440
        y: 290
        width: 400
        height: 25

    }

    //login Button
        Button {
                text: "LOGIN"
                onClicked: pageLoader.source = "mainView.qml"
                x: 620
                y: 325
                width: 70
                height: 30

            }

}
