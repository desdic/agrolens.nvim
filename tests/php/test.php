<?php

class Person {
  private $age;
  function __construct($age) {
    $this->age = $age;
  }
  function getAge() {
    return $this->age;
  }
};

function newPerson($age) {
  return new Person($age);
}

$p = newPerson(42);

$num1 = $p->getAge();
$num2 = newPerson(43);

NewPerson(53);
$num2->getAge();

echo($num1);
print($num2->getAge());

?>
