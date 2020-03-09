package main

import (
	"fmt"
	"sort"
	"strconv"
	"time"
)

//--------------------Greet() interface
type Interfaces interface {
	Greet() string
	Name() string
	Age() int
}

//----------------------Member class
type Member struct {
	name      string
	birthdate time.Time
}

func newMember(name string, birthdate time.Time) *Member {
	return &Member{name, birthdate}
} //생성자 함수

func (m *Member) Name() string {
	return m.name
}

func (m *Member) Age() int {
	t := time.Now()
	return t.Year() - m.birthdate.Year()
}

func (m Member) Greet() string {
	return "Name: " + m.Name() + ", Age: " + strconv.Itoa(m.Age())
} //greet() 구현

//----------------------Teacher class
type Teacher struct {
	lecture string
	Member  //Member class embedding
}

func newTeacher(name string, birthdate time.Time, teaches string) *Teacher {
	return &Teacher{Member: Member{name, birthdate}, lecture: teaches}
} //생성자 함수

func (t *Teacher) Teaches() string {
	return t.lecture
}

func (t Teacher) Greet() string {
	return t.Member.Greet() + ", Teaches: " + t.Teaches()
} //greet() 구현

//-----------------------Student class
type Student struct {
	id_no  int
	Member //Member class embedding
}

func newStudent(name string, birthdate time.Time, id_no int) *Student {
	return &Student{Member: Member{name, birthdate}, id_no: id_no}
} //생성자 함수

func (s *Student) ID_no() int {
	return s.id_no
}

func (s Student) Greet() string {
	return s.Member.Greet() + ", ID_no: " + strconv.Itoa(s.ID_no())
} //greet() 구현

//------------------------Visiting class
type Visiting struct {
	valid_thru time.Time
	Student
}

func newVisiting(name string, birthdate time.Time, id_no int, valid_thru time.Time) *Visiting {
	return &Visiting{Student: Student{Member: Member{name, birthdate}, id_no: id_no}, valid_thru: valid_thru}
} //생성자 함수

func (v *Visiting) Expired() bool {
	t := time.Now()
	return t.Year() >= v.valid_thru.Year()
}

func (v Visiting) Greet() string {
	return v.Student.Greet() + ", Valid_thru: " + v.valid_thru.Format("2001-01-12")
} //greet() 구현

func main() {
	t1 := newTeacher("MH", time.Date(1971, time.December, 7, 0, 0, 0, 0, time.UTC), "Programming Languages")
	t2 := newTeacher("JY", time.Date(1975, time.September, 21, 0, 0, 0, 0, time.UTC), "Forbidden Archeology")
	s1 := newStudent("YK", time.Date(1999, time.March, 16, 0, 0, 0, 0, time.UTC), 2051)
	s2 := newStudent("SH", time.Date(2000, time.October, 5, 0, 0, 0, 0, time.UTC), 4968)
	v1 := newVisiting("Alice", time.Date(1995, time.July, 14, 0, 0, 0, 0, time.UTC), 9595, time.Date(2019, time.December, 25, 0, 0, 0, 0, time.UTC))
	v2 := newVisiting("Vanessa", time.Date(1998, time.March, 27, 0, 0, 0, 0, time.UTC), 9598, time.Date(2019, time.February, 28, 0, 0, 0, 0, time.UTC))

	list := []Interfaces{t1, t2, s1, s2, v1, v2}

	fmt.Println("A few CAU members...")
	for _, i := range list {
		fmt.Println(i.Greet())
	}

	fmt.Println()
	fmt.Println("Members sorted on age...")
	sort.Slice(list, func(i, j int) bool {
		return list[i].Age() < list[j].Age()
	})
	for _, i := range list {
		fmt.Println(i.Greet())
	}

	fmt.Println()
	fmt.Println("Members reverse sorted on name...")
	sort.Slice(list, func(i, j int) bool {
		return list[i].Name() > list[j].Name()
	})
	for _, i := range list {
		fmt.Println(i.Greet())
	}
}
