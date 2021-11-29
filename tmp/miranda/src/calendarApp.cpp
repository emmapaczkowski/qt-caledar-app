#include <QSqlError>

#include "event.h"
#include "sqleventmodel.h"
#include "calendarApp.h"


bool addEventFromGUI(QString name, QDateTime startDate, QDateTime endDate, QDateTime time, bool disperse, QString eventtype ){
    if (startDate>endDate){
        printf("Invalid start and end date");
    }else{
        if (disperse) {
            if (!splitTimes(name, startDate, endDate, time)) {
                //Have an error that we were unable to find a time

                qFatal("Unable to find time.");
                return false;
            }
           else {
           // create a new event and add it to the calender and the data base

           }
        }
    }
    return true;
}

/*
 * Disperse an event in a givin time frame
 * parameter: QString name, name of event to split
 * parameter: QDateTime Startdate, start time of time frame events will be split between
 * parameter: QDateTime endDate, end time of time frame event will be split between
 * parameter: QDateTime amountOfTime, amount of time to allocate to event
 * returns: bool, represents if there was room to add the events
 */
bool splitTimes(QString name, QDateTime Startdate, QDateTime endDate, QDateTime amountOfTime) {
    QTime blockTime;
    int blockQuantity,totaltime, hour, minute, second;
    bool unavailable = true;
    blockQuantity = (endDate.date().year() - Startdate.date().year())*365 + (endDate.date().month()-Startdate.date().month())*30 + (endDate.date().day()-Startdate.date().day());
    totaltime = amountOfTime.time().hour()/blockQuantity;

    hour = floor (totaltime);
    minute = floor ((totaltime-hour)*60);
    second = floor((((totaltime-hour)*60) - minute)*60);
    blockTime.setHMS(hour,minute,second);

    QList<QDateTime> busyTimes = eventsBetweenDates(Startdate, endDate);
    //freeTimes is a list of all available times
    QList<Event> freeTimes = availableTimes(busyTimes, blockTime, name);

    int z=0;
    while (unavailable == true && z <2){
        if(freeTimes.size() < blockQuantity) {
            blockQuantity = ceil(blockQuantity/2);

            totaltime = amountOfTime.time().hour()/blockQuantity;

            hour = floor (totaltime);
            minute = floor ((totaltime-hour)*60);
            second = floor((((totaltime-hour)*60) - minute)*60);

            blockTime.setHMS(hour,minute,second);
            z++;
        } else {
            unavailable = false;
            int interval = freeTimes.size()/blockQuantity;
            for(int i=0 ; i<blockQuantity; i++) {
                int index = interval*i;
                Event eventToBeAdded(freeTimes[index]);
            }
            return true;
        }
        z++;
    }
    if (unavailable == false){
        printf("No time slots available");
    }
}

/*
 * Find all available time slots
 * parameter: QList<Event> busyTimes, a list of all unavaiable times, including nonworking hours, and the start and end time of the time interval
 * parameter: QTime blockTime, the size of the time interval that avaiableTimes() searched for.
 * parameter: QString name, the name of the type of event you are adding
 * returns: QList<Events>, the availableTimes that were able to be fit into the given time frame
 */
QList<Event> availableTimes(QList<Event> busyTimes, QTime blockTime, QString name) {
    QList<Event> available;
    int neededTime = blockTime.hour()*3600 + blockTime.minute()*60 + blockTime.second();
    QList<Event>::iterator i;
    for(i = busyTimes.begin(); i !=busyTimes.end()-1; i++) {

        Event curEvent = *i;
        QDateTime cur = curEvent.endDate();

        Event nextEvent = *(i+1);
        QDateTime next = nextEvent.startDate();

        while (cur.secsTo(next) >= neededTime) {
            QDateTime endOfEvent = cur.addSecs(blockTime.hour()*3600 + blockTime.minute()*60 + blockTime.second());
            Event eventToAdd(cur, endOfEvent, name);
            available.append(eventToAdd);
                   if( next > next.addSecs(blockTime.hour()*3600 + blockTime.minute()*60 + blockTime.second()) ) {
                cur = next;
            }
        }
    }
    return(available);
}
