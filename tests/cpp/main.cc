#include <iostream>

class Person {
public:
  int age;

  Person(int age) : age(age) {}
  int getAge() { return age; }
  void setAge(int age);
};

void Person::setAge(int age) { this->age = age; }

void someFunc() { std::cout << "ran function" << std::endl; }

int returnStuff() { return 42; }

int main() {
  Person p(42);

  std::cout << "Age: " << p.getAge() << std::endl;
  p.getAge();
  someFunc();
  int i = returnStuff();
  std::cout << i << std::endl;
  return 0;
}
