#include <iostream>

class Person {
public:
  int age;

  Person(int age) : age(age) {}
  int getAge() { return age; }
  void setAge(int age);
};

void Person::setAge(int age) { this->age = age; }

int main() {
  Person p(42);

  std::cout << "Age: " << p.getAge() << std::endl;
  return 0;
}
