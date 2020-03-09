#define _CRT_SECURE_NO_WARNINGS
#include <iostream>
#include <time.h>
#include <list>
#include <sstream>
#include <iomanip>
#include <iterator>

using namespace std;

// Class Date
inline int max(int a, int b)
{
    if (a > b) return(a); else return (b);
}

inline int min(int a, int b)
{
    if (a > b) return(b); else return (a);
}

class Date
{
public:
    Date();
    Date(int yr, int mn, int dy);
    int Year();
    int Month();
    int Day();
    ~Date();
    string Greet();
    friend Date Now();
private:
    int month, day, year;
    int DaysSoFar();
};

Date::Date()
{
   month = day = year = 1;
}

Date::Date(int yr, int mn, int dy)
{
   static int length[] = { 0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };

   month = max(1, mn);
   month = min(month,12);

   day = max(1,dy);
   day = min(day, length[month]);

   year = max(1, yr);
}

Date Now()
{
    time_t theTime = time(NULL);
    struct tm *aTime = localtime(&theTime);
    return Date(aTime->tm_year + 1900, aTime->tm_mon + 1, aTime->tm_mday);
}

Date::~Date()
{
}

int Date::Year()
{
   return year;
}

int Date::Month()
{
   return month;
}

int Date::Day()
{
    return day;
}

string Date::Greet()
{
    stringstream buf;
    buf << to_string(this->Year()) << "-" << setw(2) << setfill('0')
        << to_string(this->Month()) << "-"
        << to_string(this->Day());
    return buf.str();
}
// End of Class Date

class Member
{
public:
    string Name();
    int Age();
    virtual string Greet();
protected:
    Member(string name, Date birthdate);
private:
    string name;
    Date birthdate;
};

Member::Member(string name, Date birthdate)
{
    this->name = name;
    this->birthdate = birthdate;
}

string Member::Name()
{
    return this->name;
}

int Member::Age()
{
    return Now().Year() - this->birthdate.Year();
}

string Member::Greet()
{
    return "Name: " + this->Name() + ", Age: " + std::to_string(this->Age());
}

class Teacher: public Member
{
public:
    Teacher(string name, Date birthdate, string teaches);
    string Teaches();
    string Greet();
private:
    string lecture;
};

Teacher::Teacher(string name, Date birthdate, string teaches): Member(name, birthdate)
{
    this->lecture = teaches;
}

string Teacher::Teaches()
{
    return this->lecture;
}

string Teacher::Greet()
{
    return Member::Greet() + ", Teaches: " + this->Teaches();
}

class Student: public Member
{
public:
    Student(string name, Date birthdate, int id_no);
    int ID_no();
    string Greet();
private:
    int id_no;
};

Student::Student(string name, Date birthdate, int id_no): Member(name, birthdate)
{
    this->id_no = id_no;
}

int Student::ID_no()
{
    return this->id_no;
}

string Student::Greet()
{
    return Member::Greet() + ", ID_no: " + std::to_string(this->ID_no());
}

class Visiting: public Student
{
public:
    Visiting(string name, Date birthdate, int id_no, Date valid_thru);
    bool Expired();
    string Greet();
private:
    Date valid_thru;
    bool expired;
};

Visiting::Visiting(string name, Date birthdate, int id_no, Date valid_thru): Student(name, birthdate, id_no)
{
    this->valid_thru = valid_thru;
}

bool Visiting::Expired() // Buggy...
{
    Date now = Now();
    return now.Year() >= valid_thru.Year();
}

string Visiting::Greet()
{
    return Student::Greet() + ", Valid_thru: " + valid_thru.Greet();
}

// Sorters
bool ageComp(Member *m1, Member *m2)
{
    return m1->Age() < m2->Age();
}

bool reverseNameComp(Member *m1, Member *m2)
{
    return m1->Name().compare(m2->Name()) > 0;
}

int main(int argc, char *argv[])
{
    list<Member*> members;
    members.push_back(new Teacher("MH", Date(1971, 12,  7), "Programming Languages"));
    members.push_back(new Teacher("JY", Date(1975,  9, 21), "Forbidden Archeology"));
    members.push_back(new Student("YK", Date(1999,  3, 16), 2051));
    members.push_back(new Student("SH", Date(2000, 10,  5), 4968));
    members.push_back(new Visiting("Alice", Date(1995, 7, 14), 9595, Date(2019, 12, 25)));
    members.push_back(new Visiting("Vanessa", Date(1998, 3, 27), 9598, Date(2019, 2, 28)));

    cout << "A few CAU members..." << endl;
    list<Member*>::iterator it;
    for (it = members.begin(); it != members.end(); ++it) {
        Member *member = *it;
        cout << member->Greet() << endl;
    }
    cout << endl;

    members.sort(ageComp);
    cout << "Members sorted on age..." << endl;
    for (it = members.begin(); it != members.end(); ++it) {
        Member *member = *it;
        cout << member->Greet() << endl;
    }
    cout << endl;

    members.sort(reverseNameComp);
    cout << "Members reverse sorted on name..." << endl;
    for (it = members.begin(); it != members.end(); ++it) {
        Member *member = *it;
        cout << member->Greet() << endl;
    }

    return 0;
}
