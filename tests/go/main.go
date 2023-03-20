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
	fmt.Println(ret42())
}
