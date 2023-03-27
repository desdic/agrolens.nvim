#include <iostream>
#include <sstream>

typedef int (*conv_func)(time_t, time_t);

class Person {
public:
  Person(std::string name, std::string born);
  friend std::ostream &operator<<(std::ostream &out, const Person &p);
  friend int days_since_birth(const Person &p, conv_func func);

private:
  std::string name;
  std::string born;
  int age_in_days;
};

Person::Person(std::string name, std::string born) {
  this->name = name;
  this->born = born;
}

/* basic seconds to days
*/
int sec_to_days(time_t now, time_t born) { 
  return (now - born) / (60 * 60 * 24); }

int days_since_birth(const Person &p, conv_func func) {

  std::istringstream is(p.born);

  int year, month, day;

  char delimiter;
  if (is >> day >> delimiter >> month >> delimiter >> year) {
    time_t now = time(0);
    struct tm *parsedDate;

    parsedDate = localtime(&now);
    parsedDate->tm_year = year - 1900;
    parsedDate->tm_mon = month - 1;
    parsedDate->tm_mday = day;

    time_t born = mktime(parsedDate);

    int age = (*func)(now, born);

    return age;
  }

  return 0;
}

std::ostream &operator<<(std::ostream &out, const Person &p) {

  out << p.name << " is " << days_since_birth(p, sec_to_days) << " days old";

  return out;
}

int main() {

  // Create Donald
  Person donald("Donald Duck", "07-09-1934");

  // Print Donald
  std::cout << donald << std::endl;

  return 0;
}
