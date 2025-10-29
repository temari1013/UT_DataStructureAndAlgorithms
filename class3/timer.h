#ifndef INCLUDE_GUARD_TIMER_H
#define INCLUDE_GUARD_TIMER_H

typedef struct timer {
    double seconds;
    double ref;
    void (*reset)(struct timer *this_timer);
    void (*start)(struct timer *this_timer);
    void (*stop)(struct timer *this_timer);
    void (*display)(struct timer *this_timer);
    double (*result)(struct timer *this_timer);
} Timer;

void timer_reset(Timer *this_timer);
void timer_start(Timer *this_timer);
void timer_stop(Timer *this_timer);
void timer_display(Timer *this_timer);
double timer_result(Timer *this_timer);
#endif // INCLUDE_GUARD_TIMER_H