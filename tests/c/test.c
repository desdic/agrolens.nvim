#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#define MAXNAME 31
#define MAXDATE 11
#define MAXFORMAT 50

struct Person {
  char born[MAXDATE + 1];
  char name[MAXNAME + 1];
  int age_in_days;
};

int days_since_birth(struct Person *p) {

  if (!p)
    return -1;

  int year, month, day;

  if (sscanf(p->born, "%d-%d-%d", &day, &month, &year) != EOF) {
    time_t now = 0;
    now = time(0);

    struct tm *parsedDate;

    parsedDate = localtime(&now);
    parsedDate->tm_year = year - 1900;
    parsedDate->tm_mon = month - 1;
    parsedDate->tm_mday = day;

    time_t born = mktime(parsedDate);

    int age = (now - born) / (60 * 60 * 24);
    return age;
  }

  return -1;
}

typedef int (*format_func)(struct Person *p);

int basic_calc(struct Person *p) {
  if (!p)
    return -1;

  return days_since_birth(p);
}

/*
  We want to be able to swap the function that calculates the days
*/
void print_person(struct Person *p, format_func func) {
  if (!p)
    return;

  // not used
  int age = (*func)(p);

  printf("%s is %d days old\n", p->name, (*func)(p));
}

char **do_nothing(char **argv) {
  return argv;
}

int main(int argc, char **argv) {

  // Create Donald
  struct Person donald;
  strncpy(donald.name, "Donald Duck", MAXNAME);
  strncpy(donald.born, "07-09-1934", MAXDATE);

  // Print Donald
  print_person(&donald, basic_calc);

  return 0;
}
