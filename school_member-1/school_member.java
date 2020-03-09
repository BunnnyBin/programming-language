import java.lang.System;
import java.util.*;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

interface HasNameAge
{
    public String name();
    public int age();
}

interface CanGreet extends HasNameAge
{
    public String greet();
}

class Member implements CanGreet
{
    protected Member(String name, LocalDate birthdate) {
        this.name = name;
        this.birthdate = birthdate;
    }

    public final String name() {
        return this.name;
    }

    public int age() {
        return LocalDate.now().getYear() - birthdate.getYear();
    }

    public String greet() {
        return "Name: " + this.name() + ", Age: " + this.age();
    }

    private String name;
    private LocalDate birthdate;
}

class Teacher extends Member
{
    public Teacher(String name, LocalDate birthdate, String teaches) {
        super(name, birthdate);
        this.lecture = teaches;
    }

    public String teaches() {
        return this.lecture;
    }

    public String greet() {
        return super.greet() + ", Teaches: " + this.teaches();
    }

    private String lecture;
}

class Student extends Member
{
    public Student(String name, LocalDate birthdate, int id_no) {
        super(name, birthdate);
        this.id_no = id_no;
    }

    public int ID_no() {
        return this.id_no;
    }

    public String greet() {
        return super.greet() + ", ID_no: " + this.ID_no();
    }

    private int id_no;
}

class Visiting extends Student
{
    public Visiting(String name,
            LocalDate birthdate, int id_no, LocalDate valid_thru) {
        super(name, birthdate, id_no);
        this.valid_thru = valid_thru;
    }

    public boolean expired() {
        return LocalDate.now().isAfter(this.valid_thru);
    }

    public String greet() {
        return super.greet() + ", Valid thru " +
               valid_thru.format(DateTimeFormatter.ofPattern("YYYY-MM-dd"));
    }

    private LocalDate valid_thru;
}

class AgeSorter implements Comparator<HasNameAge>
{
    public int compare(HasNameAge m1, HasNameAge m2) {
        return m1.age() - m2.age();
    }
}

class ReverseNameSorter implements Comparator<HasNameAge>
{
    public int compare(HasNameAge m1, HasNameAge m2) {
        return m2.name().toLowerCase().compareTo(m1.name().toLowerCase());
    }
}

public class school_member
{
    public static void main(String[] args) {
        AbstractList<CanGreet> greeters = new LinkedList<CanGreet>();
        greeters.add(new Teacher("MH", LocalDate.of(1971, 12,  7), "Programming Languages"));
        greeters.add(new Teacher("JY", LocalDate.of(1975,  9, 21), "Forbidden Archeology"));
        greeters.add(new Student("YK", LocalDate.of(1999,  3, 16), 2051));
        greeters.add(new Student("SH", LocalDate.of(2000, 10,  5), 4968));

        CanGreet Alice = new Visiting("Alice", LocalDate.of(1995, 7, 14), 9595,
            LocalDate.of(2019, 12, 25));
        CanGreet Vanessa = new Visiting("Vanessa", LocalDate.of(1998, 3, 27), 9598,
            LocalDate.of(2019, 2, 28));
        greeters.add(Alice);
        greeters.add(Vanessa);

        System.out.println("A few CAU greeters...");
        for (CanGreet greeter: greeters)
            System.out.println(greeter.greet());
        System.out.println();

        Collections.sort(greeters, new AgeSorter());
        System.out.println("Members sorted on age...");
        for (CanGreet greeter: greeters)
            System.out.println(greeter.greet());
        System.out.println();

        Collections.sort(greeters, new ReverseNameSorter());
        System.out.println("Members reverse sorted on name...");
        for (CanGreet greeter: greeters)
            System.out.println(greeter.greet());
    }
}
