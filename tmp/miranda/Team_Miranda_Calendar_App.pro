QT += qml quick sql
TARGET = Team_Miranda_Calendar_App

include(src/src.pri)
include(shared/shared.pri)

OTHER_FILES += qml/main.qml

RESOURCES += resources.qrc

target.path = $$PWD
INSTALLS += target
