package main

import "fmt"

type Person struct {
	Age int
}

func (p *Person) GetAge() int {
	return p.Age
}

func ret42() int {
	return 42
}

func main() {
	num := ret42()

	p := Person{Age: 43}
	num2 := p.GetAge()

	ret42()
	p.GetAge()

	fmt.Println(num, num2)
}
