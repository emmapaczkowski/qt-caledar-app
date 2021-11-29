#ifndef CALENDARAPP_H
#define CALENDARAPP_H

#include <QList>
#include <QObject>

#include "sqleventmodel.h"

QList<Event> availableTimes(QList<Event> busyTimes, QTime blockTime, QString name);
bool splitTimes(QString name, QDateTime Startdate, QDateTime endDate, QDateTime amountOfTime);
bool addEventFromGUI(QString name, int startDate, int endDate, int time, bool disperse, QString eventtype );

#endif
