#include "sqleventmodel.h"

#include <QDebug>
#include <QFileInfo>
#include <QSqlError>
#include <QSqlQuery>
#include <string>

SqlEventModel::SqlEventModel()
{
    createConnection();
}

QList<QObject*> SqlEventModel::eventsForDate(const QDate &date)
{
    const QString queryStr = QString::fromLatin1("SELECT * FROM Event WHERE '%1' >= startDate AND '%1' <= endDate").arg(date.toString("yyyy-MM-dd"));
    QSqlQuery query(queryStr);
    if (!query.exec())
        qFatal("Query failed");

    QList<QObject*> events;
    while (query.next()) {
        Event *event = new Event(this);
        event->setName(query.value("name").toString());

        QDateTime startDate;
        startDate.setDate(query.value("startDate").toDate());
        startDate.setTime(QTime(0, 0).addSecs(query.value("startTime").toInt()));
        event->setStartDate(startDate);

        QDateTime endDate;
        endDate.setDate(query.value("endDate").toDate());
        endDate.setTime(QTime(0, 0).addSecs(query.value("endTime").toInt()));
        event->setEndDate(endDate);

        events.append(event);
    }

    return events;
}

QList<Event*> SqlEventModel::eventsForDateER(const QDate &date)
{
    const QString queryStr = QString::fromLatin1("SELECT * FROM Event WHERE '%1' >= startDate AND '%1' <= endDate").arg(date.toString("yyyy-MM-dd"));
    QSqlQuery query(queryStr);
    if (!query.exec())
        qFatal("Query failed");

    QList<Event*> events;
    while (query.next()) {
        Event *event = new Event(this);
        event->setName(query.value("name").toString());

        QDateTime startDate;
        startDate.setDate(query.value("startDate").toDate());
        startDate.setTime(QTime(0, 0).addSecs(query.value("startTime").toInt()));
        event->setStartDate(startDate);

        QDateTime endDate;
        endDate.setDate(query.value("endDate").toDate());
        endDate.setTime(QTime(0, 0).addSecs(query.value("endTime").toInt()));
        event->setEndDate(endDate);

        events.append(event);
    }

    return events;
}

QList<Event*> SqlEventModel::eventsBetweenDates(const QDate &dateStart, const QDate &dateEnd)
{
    // NOTE: This implementation does not handle events that span multiple days

    if (dateEnd < dateStart)
    {
        qFatal("End date cannot occur before start date.");
    }

    int hour{3600};

    //Hardcoding nighttime being between 10pm and 7am
    int tEarly{7 * hour};
    int tLate{22 * hour};
    //int tDay{tEarly - tLate};

    QDateTime start(dateStart, QTime(0,0));
    QDateTime startEarly(dateStart, QTime(0,0).addSecs(tEarly));
    QDateTime endLate(dateEnd, QTime(0,0).addSecs(tLate));
    QDateTime end(dateEnd, QTime(0,0).addSecs(24*hour - 1));

    QList<Event*> busy;

    int span = dateStart.daysTo(dateEnd);

    // set events for morning and evening unavailabilities for first and last date respectively
    Event *early = new Event(this);
    Event *late = new Event(this);

    early->setName("Morning busy time for " + dateStart.toString("yyyy-MM-dd"));
    early->setStartDate(start);
    early->setEndDate(startEarly);

    late->setName("Evening busy time for " + dateStart.toString("yyyy-MM-dd"));
    late->setStartDate(endLate);
    late->setEndDate(end);

    // if start and end date are the same
    if (0 == span)
    {
        busy.append(early);
        QList<Event*> busytemp = eventsForDateER(dateStart);

        if (busytemp.isEmpty())
        {
            busy.append(late);

            return busy;
        }

        QList<Event*>::iterator i;

        for (i = busytemp.begin(); i != busytemp.end(); ++i)
        {
            Event* temp = *i;
            // check for overlap between event times
            if (temp->startDate() <= busy.last()->endDate())
            {
                if (temp->endDate() <= busy.last()->endDate())
                {
                    continue;       // ignore events if they overlap completely with existing event in list
                }
                else if (temp->endDate() >= busy.last()->endDate())
                {
                    // set entire 24hr day to unavailable if event spans all available daytime
                    busy.last()->setEndDate(QDateTime(temp->endDate().date(),QTime(0,0).addSecs(24 *  hour - 1)));
                    return busy;
                 }
                 // extend last busy time if start time of current event overlaps but not end time
                 busy.last()->setEndDate(temp->endDate());
                 if ((temp->startDate() > busy.last()->startDate()) && (temp->endDate() <= busy.last()->endDate()))
                 {
                     busy.append(temp);
                 }
              }
          }

        if (busy.last()->endDate() >= late->startDate())
        {
            if (busy.last()->startDate() >= late->startDate())
            {
                busy.removeLast();
                busy.append(late);

                return busy;
            }

            busy.last()->setEndDate(late->endDate());
            return busy;
        }
        else
        {
            busy.append(late);
            return busy;
        }
    }

    // boundary dates span multiple days
    for (int i{0}; i < span; i++)
    {
        QList<Event*> busytemp = eventsForDateER(dateStart.addDays(i));

        QDate current = dateStart.addDays(i);

        Event* earlyTime = new Event(this);
        earlyTime->setName("Morning busy time for " + current.toString("yyyy-MM-dd"));
        earlyTime->setStartDate(start.addDays(i));
        earlyTime->setEndDate(startEarly.addDays(i));

        Event* lateTime = new Event(this);
        late->setName("Evening busy time for " + current.toString("yyyy-MM-dd"));
        late->setStartDate(QDateTime(current, QTime(0,0).addSecs(tLate)));
        late->setEndDate(QDateTime(current, QTime(0,0).addSecs(24 * hour -1)));

        busy.append(earlyTime);

        if (busytemp.isEmpty())
        {
            busy.append(lateTime);

            continue;
        }

        QList<Event*>::iterator j;

        for (j = busytemp.begin(); j != busytemp.end(); ++i)
        {
            Event* temp = *j;
            // check for overlap between event times
            if (temp->startDate() <= busy.last()->endDate())
            {
                if (temp->endDate() <= busy.last()->endDate())
                {
                    continue;       // ignore events if they overlap completely with existing event in list
                }
                else if (temp->endDate() >= busy.last()->endDate())
                {
                    // set entire 24hr day to unavailable if event spans all available daytime
                    busy.last()->setEndDate(QDateTime(temp->endDate().date(),QTime(0,0).addSecs(24 *  hour - 1)));

                    return busy;

                }
                // extend last busy time if start time of current event overlaps but not end time
                busy.last()->setEndDate(temp->endDate());

                if ((temp->startDate() > busy.last()->startDate()) && (temp->endDate() <= busy.last()->endDate()))
                {
                    busy.append(temp);
                }
            }
        }

        if (busy.last()->endDate() >= lateTime->startDate())
        {
            if (busy.last()->startDate() >= lateTime->startDate())
            {
                busy.removeLast();
                busy.append(lateTime);
            }

            busy.last()->setEndDate(lateTime->endDate());
        }
        else
        {
            busy.append(lateTime);
        }
    }

    return busy;
}



/*
    Defines a helper function to open a connection to an
    in-memory SQLITE database and to create a test table.
*/
void SqlEventModel::createConnection()
{
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName(":memory:");
    if (!db.open()) {
        qFatal("Cannot open database");
        return;
    }

    QSqlQuery query;
    // We store the time as seconds because it's easier to query.
    query.exec("create table Event (name TEXT, startDate DATE, startTime INT, endDate DATE, endTime INT)");
    query.exec("insert into Event values('Grocery shopping', '2014-01-01', 36000, '2014-01-01', 39600)");
    query.exec("insert into Event values('Ice skating', '2014-01-01', 57600, '2014-01-01', 61200)");
    query.exec("insert into Event values('Doctor''s appointment', '2020-11-16', 57600, '2020-11-16', 63000)");
    query.exec("insert into Event values('Conference', '2014-01-24', 32400, '2014-01-28', 61200)");
    query.exec("insert into Event values('Conference', '2020-11-16', 32400, '2020-11-16', 61200)");

    return;
}

bool SqlEventModel::addEvent(Event &addEvent){
    QSqlQuery query;

    QString eventName = addEvent.name();
    std::string eventNameStr = eventName.toUtf8().constData();

    QDate eventStartDate = addEvent.startDate().date();
    QString StartDateQString = eventStartDate.toString("yyyy.MM.dd");
    std::string startDateStr = StartDateQString.toUtf8().constData();

    QTime eventStartTime = addEvent.startDate().time();
    int startTimeInt = eventStartTime.hour()*3600+eventStartTime.minute()*60 + eventStartTime.second();

    QDate eventEndDate = addEvent.endDate().date();
    QString endDateQString = eventEndDate.toString("yyyy.MM.dd");
    std::string endDateStr = endDateQString.toUtf8().constData();


    QTime eventEndTime = addEvent.endDate().time();
    int endTimeInt = eventEndTime.hour()*3600+eventStartTime.minute()*60 + eventStartTime.second();

    std::string querryStr =
            "insert into Event values('"
            + eventNameStr
            +"', '"
            +startDateStr
            +"', '"
            +std::to_string(startTimeInt)
            +"', '"
            +endDateStr
            +"', '"
            +std::to_string(endTimeInt)
            +")";

    QString qstr = QString::fromStdString(querryStr);
    query.exec(qstr);

}
