/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.2
import QtQuick 2.12
import QtQuick 2.9
import QtQuick 2.2
import QtQuick.Controls 2.12
import QtQuick.Controls 1.4
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.1
import QtQuick.Controls.Styles 1.4
import org.qtproject.examples.calendar 1.0

ApplicationWindow {
    id: window
    visible: true
    visibility: "Windowed"
    width: 3000
    height: 1920
    title: qsTr("Miranda Scheduler")

    SystemPalette{
        id: systemPalette
    }

    SqlEventModel{
       id:eventModel
    }

    //Menu bar that contains settings
    //Within settings user can apply SOLUS calendar using API
    //Within settings user can Logout of the scheudler using exit(0) command
    menuBar: MenuBar{
        height: 60
        Menu{
            id: menu
            title:qsTr("Settings")
            width: 410


            MenuItem{
                text: qsTr("&Apply Calendar From Solus")
                onTriggered: console.log("Open action triggered");
            }

            MenuItem{
                text: qsTr("Logout")
                onTriggered: Qt.quit();
            }
        }
    }

   //Calendar display
   Flow{
        id: row
        anchors.fill: parent
        anchors.margins: 20
        spacing: 10

       Calendar{
            id:calendar
            frameVisible: true
            focus: true
            minimumDate: new Date(1900, 0, 1)
            maximumDate: new Date(2100, 0, 1)
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: 100
            anchors.leftMargin: 20

            width: 1000
            height: 800

            style: CalendarStyle {

                    dayDelegate: Item {
                        readonly property color sameMonthDateTextColor: "#444"
                        readonly property color selectedDateColor: Qt.platform.os === "osx" ? "#3778d0" : systemPalette.highlight
                        readonly property color selectedDateTextColor: "white"
                        readonly property color differentMonthDateTextColor: "#bbb"
                        readonly property color invalidDatecolor: "#dddddd"



                   Rectangle {
                        anchors.fill: parent
                        border.color: "transparent"
                        color: styleData.date !== undefined && styleData.selected ? selectedDateColor : "transparent"
                        anchors.margins: styleData.selected ? -1 : 0
                    }

                    Image {
                        visible: eventModel.eventsForDate(styleData.date).length > 0
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.margins: -1
                        width: 12
                        height: width
                        source: "qrc:/images/eventindicator.png"
                     }

                    Label {
                        id: dayDelegateText
                        text: styleData.date.getDate()
                        anchors.centerIn: parent
                        color: {
                            var color = invalidDatecolor;
                            if (styleData.valid) {
                                // Date is within the valid range.
                                color = styleData.visibleMonth ? sameMonthDateTextColor : differentMonthDateTextColor;
                                if (styleData.selected) {
                                    color = selectedDateTextColor;
                                }
                            }
                            color;
                        }
                    }
                }
            }
        }

       Component {
           id: eventListHeader

            Row {
                id: eventDateRow
                width: parent.width
                height: eventDayLabel.height
                spacing: 10


                Label {
                    id: eventDayLabel
                    text: calendar.selectedDate.getDate()
                    font.pointSize: 22
                }

                Column {
                    height: eventDayLabel.height

                    Label {
                        readonly property var options: { weekday: "long" }
                        text: Qt.locale().standaloneDayName(calendar.selectedDate.getDay(), Locale.LongFormat)
                        font.pointSize: 14
                    }

                    Label {
                        text: Qt.locale().standaloneMonthName(calendar.selectedDate.getMonth())
                                     + calendar.selectedDate.toLocaleDateString(Qt.locale(), " yyyy")
                        font.pointSize: 10
                    }
                }
            }
        }

       Rectangle {
             width: 1000
             height: 800
             border.color: Qt.darker(color, 1.2)
             anchors.top: parent.top
             anchors.left: parent.left
             anchors.topMargin: 965
             anchors.leftMargin: 20

             ListView {
                 id: eventsListView
                 spacing: 4
                 clip: true
                 header: eventListHeader
                 anchors.fill: parent
                 anchors.margins: 10
                 model: eventModel.eventsForDate(calendar.selectedDate)

                 delegate: Rectangle {
                     //width: eventsListView.width
                     height: eventItemColumn.height
                     //anchors.horizontalCenter: parent.horizontalCenter


                    Image {
                         //anchors.top: parent.top
                         //anchors.topMargin: 4
                         width: 12
                         height: width
                         source: "qrc:/images/eventindicator.png"
                         anchors.top: parent.top
                         anchors.topMargin: 75
                     }

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: "#eee"
                     }

                    Column {
                         id: eventItemColumn
                         anchors.left: parent.left
                         anchors.leftMargin: 20
                         height: timeLabel.height + nameLabel.height + 8
                         anchors.top: parent.top
                         anchors.topMargin: 65

                         Label {
                             id: nameLabel
                             width: 20
                             //wrapMode: Text.Wrap
                             text: modelData.name
                             anchors.left: parent.left
                             anchors.leftMargin: 5

                         }

                         Label {
                             id: timeLabel
                             width: 20
                             //wrapMode: Text.Wrap
                             text: modelData.startDate.toLocaleTimeString(calendar.locale, Locale.ShortFormat)
                             color: "#aaa"
                         }
                     }
                 }
             }
         }

    }

    //My Calendar label
    Label{
        text: qsTr("My Calender")
        font.pixelSize: 52
        font.weight: Font.Bold
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 385
        anchors.topMargin: 22

    }

//////////////////////////////////////////////////////NEW EVENT CODE//////////////////////////////////////////////////////////

    //New Event Label
    Label{
        text: "New Event"
        font.pixelSize: 52
        font.weight: Font.Bold
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 1300
        anchors.topMargin: 200
    }

    //Start date label
    Label{
        text: "Start Date:"
        font.pixelSize: 34
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 1300
        anchors.topMargin: 350
    }

    //Start date input box
    TextField{
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 1600
        anchors.topMargin: 340
        width: 350
        height: 70
        placeholderText: qsTr("yyyy/mm/dd")
    }

    //End date label
    Label{
        text: "End Date:"
        font.pixelSize: 34
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 1300
        anchors.topMargin: 500
    }

    //End date input box
    TextField{
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 1600
        anchors.topMargin: 490
        width:350
        height: 70
        placeholderText: qsTr("yyyy/mm/dd")
    }

    //Start time label
    Label{
        text: "Start Time:"
        font.pixelSize: 34
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 1300
        anchors.topMargin: 650
    }

    //Start time input box
    TextField{
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 1600
        anchors.topMargin: 640
        width: 350
        height: 70
        placeholderText: qsTr("-:-- am/pm")
    }


    //Estimated time input box
    Label{
        text: "Estimated Time:"
        font.pixelSize: 34
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 1300
        anchors.topMargin: 800
    }

    //Estimated time input box
    TextField{
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 1600
        anchors.topMargin: 790
        width: 350
        height: 70
        placeholderText: qsTr("-- hrs")
    }

    //Disperse time label
    Label{
        text: "Disperse Time:"
        font.pixelSize: 34
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 1300
        anchors.topMargin: 950
    }

    //Check box for disperse time
    CheckBox{
        checked: false
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 1590
        anchors.topMargin: 950
        indicator.height: 60
        indicator.width: 60
    }

    //Type of event label
    Label{
        text: "Type of Event:"
        font.pixelSize: 32
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 1300
        anchors.topMargin: 1100
    }

    //Drop down menu for type of event
    ComboBox{
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 1600
        anchors.topMargin: 1090
        width: 350
        height: 70
        font.pixelSize: 32
        currentIndex: -1
        displayText: currentIndex === -1 ? "Type" : currentText

        model: ["Study", "Exam", "Meeting", "Social", "Personal", "Other" ]
    }

    //Event name label
    Label{
        text: "Event Name:"
        font.pixelSize: 34
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 1300
        anchors.topMargin: 1250
    }

    //input bar for event name
    TextField{
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 1600
        anchors.topMargin: 1240
        width:350
        height: 70
    }

    //Button that applies the new event to the calendar
    Button{
        text: qsTr("Add Event")
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 1650
        anchors.topMargin: 1440
        height: 70
        width: 300
    }

 ////////////////////////////////////////////////////EDIT EVENT CODE//////////////////////////////////////////////////////////

    //Edit event label
    Label{
        text: "Edit Event"
        font.pixelSize: 52
        font.weight: Font.Bold
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 2200
        anchors.topMargin: 200

    }

    //Event date label
    Label{
        text: "Event Date:"
        font.pixelSize: 34
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 2200
        anchors.topMargin: 350
    }

    //Event date input bar
    TextField{
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 2500
        anchors.topMargin: 340
        width: 350
        height: 70
        placeholderText: qsTr("yyyy/mm/dd")
    }

    //Event name label
    Label{
        text: "Event Name:"
        font.pixelSize: 34
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 2200
        anchors.topMargin: 500
    }

    //Event name input bar
    TextField{
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 2500
        anchors.topMargin: 490
        width:350
        height: 70
    }

    //Action label
    Label{
        text: "Action"
        font.pixelSize: 52
        font.weight: Font.Bold
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 2200
        anchors.topMargin: 650
    }

    //Edit start time label
    Label{
        text: "Edit Start Time:"
        font.pixelSize: 34
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 2200
        anchors.topMargin: 800
    }

    //Edit start time input bar
    TextField{
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 2500
        anchors.topMargin: 790
        width:350
        height: 70
        placeholderText: qsTr("-:-- am/pm")
    }


    //Edit duration label
    Label{
        text: "Edit Duration:"
        font.pixelSize: 34
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 2200
        anchors.topMargin: 950
    }

    //Edit duration input bar
    TextField{
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 2500
        anchors.topMargin: 940
        width:350
        height: 70
        placeholderText: qsTr("-- hrs")
    }

    //Change date label
    Label{
        text: "Edit Date:"
        font.pixelSize: 34
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 2200
        anchors.topMargin: 1100
    }

    //Change date input bar
    TextField{
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 2500
        anchors.topMargin: 1090
        width:350
        height: 70
        placeholderText: qsTr("yyyy/mm/dd")
    }

    //Delete event label
    Label{
        text: "Delete Event:"
        font.pixelSize: 34
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 2200
        anchors.topMargin: 1250
    }

    //Check box for deleting an event
    CheckBox{
        checked: false
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 2490
        anchors.topMargin: 1250
        indicator.height: 60
        indicator.width: 60
    }

    //Button that applies the changes made in "edit event"
    Button{
        text: qsTr("Apply Changes")
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 2550
        anchors.topMargin: 1440
        height: 70
        width: 300
    }

}
