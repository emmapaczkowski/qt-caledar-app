#include <QtQml>

#include "qtquickcontrolsapplication.h"
#include "sqleventmodel.h"

int main(int argc, char *argv[])
{
    QtQuickControlsApplication app(argc, argv);
    qmlRegisterType<SqlEventModel>("org.qtproject.examples.calendar", 1, 0, "SqlEventModel");
    QQmlApplicationEngine engine(QUrl("qrc:/qml/main.qml"));
    if (engine.rootObjects().isEmpty())
        return -1;
    return app.exec();
}
