
struct Person{
    age: u32,
}

impl Person{
    fn get_age(&self) -> String {
        return self.age.to_string();
    }
}

fn get_num(n: u32) -> String {
    return n.to_string();
}

fn main() {

    let p = Person{age: 43};

    println!("Hello World!");
    println!("{} or {}", get_num(42), p.get_age());
}
