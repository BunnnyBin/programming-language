#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#define max(a, b) ((a) > (b)? (a) : (b))
#define min(a, b) ((a) < (b)? (a) : (b))

typedef struct {
    int year;
    int month;
    int day;
} Date;

Date newDate(int yr, int mn, int dy)
{
    Date date;
    static int length[] = { 0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };
    int year, month, day;

    month = max(1, mn);
    month = min(month, 12);

    day = max(1, dy);
    day = min(day, length[month]);

    year = max(1, yr);

    date.year = year;
    date.month = month;
    date.day = day;

    return date;
}

Date Now()
{
    time_t theTime = time(NULL);
    struct tm *aTime = localtime(&theTime);
    Date now;

    now.year = aTime->tm_year + 1900;
    now.month =  aTime->tm_mon + 1;
    now.day = aTime->tm_mday;
    return now;
}

char *Date_String(Date date)
{
    char *buf = (char *)malloc(11);
    sprintf(buf, "%.4d-%.2d-%.2d", date.year, date.month, date.day);
    return buf;
}

#import <Foundation/Foundation.h>

@interface Member: NSObject
{
   char *name;
   Date birthdate;
}
- (id) name: (char *) n birthdate: (Date) d;
- (char *) name;
- (int) age;
- (char *) greet;
@end

@implementation Member
- (id) name: (char *) n birthdate: (Date) b
  {
    name = n;
    birthdate = b;
    return self;
  }

- (char *) name
  {
    return name;
  }
  
- (int) age;
  {
    return Now().year - birthdate.year;
  }

- (char *) greet
  {
    char *buf = (char *)malloc(BUFSIZ);
    sprintf(buf, "Name: %s, Age: %d", [self name], [self age]);
    return buf;
  }
@end

@interface Teacher: Member
{
   char *lecture;
}
- (id) name: (char *) n birthdate: (Date) d teaches: (char *) t;
- (char *) teaches;
- (char *) greet;
@end

@implementation Teacher
- (id) name: (char *) n birthdate: (Date) d teaches: (char *) t
  {
    [super name: n birthdate: d];
    lecture = t;
    return self;
  }

- (char *) teaches
  {
    return lecture;
  }

- (char *) greet
  {
    char *buf = (char *)malloc(BUFSIZ);
    char *etc = (char *)malloc(BUFSIZ/4);
    strcpy(buf, [super greet]);
    sprintf(etc, ", Teaches: %s", [self teaches]);
    strcat(buf, etc);
    free(etc);
    return buf;
  }
@end

@interface Student: Member
{
   int id_no;
}
- (id) name: (char *) n birthdate: (Date) d id_no: (int) i;
- (int) id_no;
- (char *) greet;
@end

@implementation Student
- (id) name: (char *) n birthdate: (Date) d id_no: (int) i
  {
    [super name: n birthdate: d];
    id_no = i;
    return self;
  }

- (int) id_no
  {
    return id_no;
  }

- (char *) greet
  {
    char *buf = (char *)malloc(BUFSIZ);
    char *etc = (char *)malloc(BUFSIZ/4);
    strcpy(buf, [super greet]);
    sprintf(etc, ", ID_no: %d", [self id_no]);
    strcat(buf, etc);
    free(etc);
    return buf;
  }
@end

@interface Visiting: Student
{
   Date valid_thru; 
}
- (id) name: (char *) n birthdate: (Date) d id_no: (int) i validThru: (Date) v;
- (bool) expired;
- (char *) greet;
@end

@implementation Visiting
- (id) name: (char *) n birthdate: (Date) d id_no: (int) i validThru: (Date) v
  {
    [super name: n birthdate: d id_no: i];
    valid_thru = v;
    return self;
  }

- (bool) expired
  {
    Date now = Now();
    return now.year >= valid_thru.year;
  }

- (char *) greet
  {
    char *buf = (char *)malloc(BUFSIZ);
    char *etc = (char *)malloc(BUFSIZ/4);
    strcpy(buf, [super greet]);
    sprintf(etc, ", Valid_thru: %s", Date_String(valid_thru));
    strcat(buf, etc);
    free(etc);
    return buf;
  }
@end

int ageComp(const void *e1, const void *e2)
{
    id m1 = *((id*)e1);
    id m2 = *((id*)e2);
    return [m1 age] - [m2 age];
}

int reverseNameComp(const void *e1, const void *e2)
{
    id m1 = *((id*)e1);
    id m2 = *((id*)e2);
    return strcmp((char *)[m2 name], (char *)[m1 name]);
}

int main(int argc, char *argv[])
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    id members[10];
    int m_count = 0;
    members[m_count++] = [[[Teacher alloc] init] name: "MH" birthdate: newDate(1971, 12, 7) teaches: "Programming Languages"];
    members[m_count++] = [[[Teacher alloc] init] name: "JY" birthdate: newDate(1975, 9, 21) teaches: "Forbidden Archeology"];
    members[m_count++] = [[[Student alloc] init] name: "YK" birthdate: newDate(1999, 3, 16) id_no: 2051];
    members[m_count++] = [[[Student alloc] init] name: "SH" birthdate: newDate(2000, 10, 5) id_no: 4968];
    members[m_count++] = [[[Visiting alloc] init] name: "Alice" birthdate: newDate(2000, 10, 5) id_no: 9595 validThru: newDate(2019, 12, 25)];
    members[m_count++] = [[[Visiting alloc] init] name: "Vanessa" birthdate: newDate(1999, 3, 27) id_no: 9598 validThru: newDate(2019, 2, 28)];

    int i;
    printf("A few CAU members...\n");
    for (i = 0; i < m_count; i++) {
        char *string_rep = [members[i] greet];
        printf("%s\n", string_rep);
        free(string_rep);
    }
    printf("\n");

    qsort(members, m_count, sizeof(members[0]), ageComp);
    printf("Members sorted on age...\n");
    for (i = 0; i < m_count; i++) {
        char *string_rep = [members[i] greet];
        printf("%s\n", string_rep);
        free(string_rep);
    }
    printf("\n");

    qsort(members, m_count, sizeof(members[0]), reverseNameComp);
    printf("Members reverse sorted on name...\n");
    for (i = 0; i < m_count; i++) {
        char *string_rep = [members[i] greet];
        printf("%s\n", string_rep);
        free(string_rep);
    }
    printf("\n");

    [pool drain];
    return 0;
}
