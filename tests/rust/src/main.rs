use chrono::{DateTime, Utc};

struct Person {
    name: String,
    born: String,
}

impl Person {
    fn calc_age_in_days(&self) -> i64 {
        let today = Utc::now();
        let borndate = DateTime::<Utc>::from_utc(
            chrono::NaiveDate::parse_from_str(&self.born, "%d-%m-%Y")
                .unwrap()
                .and_hms_opt(0, 0, 0)
                .unwrap(),
            Utc,
        );

        return today.signed_duration_since(borndate).num_days();
    }

    fn print(&self, f: fn(&Person) -> String) {
        println!("{}", f(self));
    }
}

/*
Formatting of person
*/
fn format_person(p: &Person) -> String {
    let age = p.calc_age_in_days();

    return format!("{} is {} days old", p.name, age);
}

fn main() {
    // Create Donald
    let donald = Person {
        name: "Donald Duck".to_string(),
        born: "07-09-1934".to_string(),
    };

    donald.print(format_person);
}
