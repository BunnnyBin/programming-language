using System;
using System.Collections.Generic;

interface HasNameAge
{
    string Name { get; }   // Property
    int Age { get; }
}

interface CanGreet: HasNameAge
{
    string Greet();
}

class Member: CanGreet
{
    protected Member(string name, DateTime birthdate) {
        this.name = name;
        this.birthdate = birthdate;
    }

    public string Name {
        get { return this.name; }
    }

    public int Age {
        get { return DateTime.Now.Year - birthdate.Year; }
    }

    public virtual string Greet() {
        return "Name: " + this.Name + ", Age: " + this.Age;
    }

    private string name;
    private DateTime birthdate;
}

class Teacher: Member
{
    public Teacher(string name, DateTime birthdate, string teaches): base(name, birthdate) {
        this.lecture = teaches;
    }

    public string Teaches {
        get { return this.lecture; }
        set { this.lecture = value; }
    }

    public override string Greet() {
        return base.Greet() + ", Teaches: " + this.Teaches;
    }

    private string lecture;
}

class Student: Member
{
    public Student(string name, DateTime birthdate, int id_no): base(name, birthdate) {
        this.id_no = id_no;
    }

    public int ID_no {
        get { return this.id_no; }
    }

    public override string Greet() {
        return base.Greet() + ", ID_no: " + this.ID_no;
    }

    private int id_no;
}

class Visiting: Student
{
    public Visiting(string name, DateTime birthdate, int id_no, DateTime valid_thru):
            base(name, birthdate, id_no) {
        this.valid_thru = valid_thru;
    }

    public bool Expired() {
        return DateTime.Compare(DateTime.Now, this.valid_thru) > 0;
    }

    public override string Greet() {
        return base.Greet() + ", Valid thru " + valid_thru.ToString("yyyy-MM-dd");
    }

    private DateTime valid_thru;
}

class AgeSorter: IComparer<HasNameAge>
{
    public int Compare(HasNameAge m1, HasNameAge m2) {
        return m1.Age - m2.Age;
    }
}

class ReverseNameSorter: IComparer<HasNameAge>
{
    public int Compare(HasNameAge m1, HasNameAge m2) {
        return m2.Name.ToLower().CompareTo(m1.Name.ToLower());
    }
}

class school_member
{
    static void Main() {
        List<CanGreet> greeters = new List<CanGreet>();
        greeters.Add(new Teacher("MH", new DateTime(1971, 12,  7), "Programming Languages"));
        greeters.Add(new Teacher("JY", new DateTime(1975,  9, 21), "Forbidden Archeology"));
        greeters.Add(new Student("YK", new DateTime(1999,  3, 16), 2051));
        greeters.Add(new Student("SH", new DateTime(2000, 10,  5), 4968));

        CanGreet Alice = new Visiting("Alice", new DateTime(1995, 7, 14), 9595,
            new DateTime(2019, 12, 25));
        CanGreet Vanessa = new Visiting("Vanessa", new DateTime(1998, 3, 27), 9598,
            new DateTime(2019, 2, 28));
        greeters.Add(Alice);
        greeters.Add(Vanessa);

        Console.WriteLine("A few CAU members...");
        foreach (CanGreet greeter in greeters)
            Console.WriteLine(greeter.Greet());
        Console.WriteLine();

        greeters.Sort(new AgeSorter());
        Console.WriteLine("Members sorted on age...");
        foreach (CanGreet greeter in greeters)
            Console.WriteLine(greeter.Greet());
        Console.WriteLine();

        greeters.Sort(new ReverseNameSorter());
        Console.WriteLine("Members reverse sorted on name...");
        foreach (CanGreet greeter in greeters)
            Console.WriteLine(greeter.Greet());
    }
}
