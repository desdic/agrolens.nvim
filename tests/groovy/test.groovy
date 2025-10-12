package tests.groovy

import java.time.*

/**
 * Groovy implementation of person
 */

class Person {
    protected final String name
    protected final String born

    /**
     * Constructor of Person
     *
     * @param name
     * @param born
     */
    Person(String name, String born) {
        this.name = name
        this.born = born
    }

    /**
     * Prints how old Person is
     *
     * @param p Person to format
     */
    void printPerson() {
        def now = LocalDate.now()
        def borndate = LocalDate.parse(this.born, java.time.format.DateTimeFormatter.ofPattern("dd-MM-yyyy"))

        def days = now - borndate

        println( "${this.name} is ${days} days old")
    }
}
// Create Donald
Person donald = new Person("Donald Duck", "07-09-1934")
donald.printPerson()
