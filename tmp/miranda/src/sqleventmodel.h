#ifndef SQLEVENTMODEL_H
#define SQLEVENTMODEL_H

#include <QList>
#include <QObject>

#include "event.h"

class SqlEventModel : public QObject
{
    Q_OBJECT

public:
    SqlEventModel();

    Q_INVOKABLE QList<QObject*> eventsForDate(const QDate &date);

    // Used to find all events to help with dispersion method
    QList<Event*> eventsForDateER(const QDate &date);
    QList<Event*> eventsBetweenDates(const QDate &dateStart, const QDate &dateEnd);

    bool addEvent(Event &event);

private:
    static void createConnection();
};



#endif
