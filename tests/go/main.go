package main

import (
	"fmt"
	"time"
)

type format_func func(p Person) string

type Person struct {
	Name string
	Born string
}

func (p *Person) GetName() string {
	return p.Name
}

func print_person(p Person, fn format_func) {
	fmt.Println(fn(p))
}

func main() {
	donald := Person{Name: "Donald Duck", Born: "07-09-1934"}

	/*
	   formatting function
	*/
	format_func := func(p Person) string {
		tt, err := time.Parse("01-02-2006", p.Born)
		if err != nil {
			return err.Error()
		}

		currentTime := time.Now()
		ageInDays := int(currentTime.Sub(tt).Hours() / 24)

		return fmt.Sprintf("%s is %d days old", p.GetName(), ageInDays)
	}

	// Print Donald
	print_person(donald, format_func)
}
