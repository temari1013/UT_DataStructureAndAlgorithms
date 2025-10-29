#include <time.h>
#include <stdio.h>
#include "timer.h"


void timer_reset(Timer *this_timer) {
    this_timer->seconds = 0.0;
    this_timer->ref = 0.0;
    printf("Timer reset\n");
    struct timespec ts;
    clock_getres(CLOCK_MONOTONIC, &ts);
    printf("Time precision:\t%ld.%09ld sec\n", (long)ts.tv_sec, ts.tv_nsec);
}

void timer_start(Timer *this_timer) {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    this_timer->ref = (double)(ts.tv_sec) + (double)ts.tv_nsec*1e-9;
}

void timer_stop(Timer *this_timer) {
    this_timer->seconds -= this_timer->ref;
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    this_timer->ref = (double)(ts.tv_sec) + (double)ts.tv_nsec*1e-9;
    this_timer->seconds += this_timer->ref;
}

void timer_display(Timer *this_timer) {
    printf("Elapsed time: \t%lf sec\n", this_timer->seconds);
}

double timer_result(Timer *this_timer) {
    return this_timer->seconds;
}

/*int main() {
    Timer stop_watch = {
        0.0,
        0.0,
        timer_reset,
        timer_start,
        timer_stop,
        timer_display,
        timer_result
    };

    stop_watch.reset(&stop_watch);
    stop_watch.start(&stop_watch);
    // ~~~~~ Do something ~~~~~
    stop_watch.stop(&stop_watch);
    stop_watch.display(&stop_watch);

   return 0;
}*/