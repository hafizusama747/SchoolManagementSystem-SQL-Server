create database SchoolManagementSystem
use SchoolManagementSystem
drop database SchoolManagementSystem
create database test
use test
go




select distinct StudentAdress.address,Students.std_id from StudentAdress,Students where StudentAdress.std_id= Students.std_id order by std_id

select* from  Students
select * from StudentAdress



select*from marks
create procedure myproc
@marks int =null,
@std_id int=null
as 
begin
set nocount on
select students.std_id, marks.obtained_marks from students,marks 
where std_id=@std_id and obtained_marks=@marks and students.std_id=marks.student_id

end

exec myproc
@std_id=1,
@marks=66

/*Table creation*/

--1. Table Department*/
create table Department(dep_id int Primary Key, dep_name varchar(20) UNIQUE, HOD_name varchar(20) NOT NULL )
 select * from Department

--creating procedure for insertion in Department table
CREATE PROCEDURE dbo.departmentinsert 
       @dep_id						 int  = NULL   , 
       @dep_name					 varchar(20)      = NULL  
AS 
BEGIN 
     SET NOCOUNT ON 
     INSERT INTO dbo.department
          (                    
            dep_id                     ,
            dep_name     
          ) 
     VALUES 
          ( 
             @dep_id,
             @dep_name    
          ) 
END 
GO
--Now passing values in procedure to create a record with these values
exec dbo.departmentinsert
    @dep_id    = '9'               ,
    @dep_name   = 'hafiz'      


--Trigger to maintain Department table history
--1.Department 
create table Department_history(dep_id int Primary Key, dep_name varchar(20) UNIQUE,audit_action varchar(20),
modified_date datetime)

/* create insert after  trigger and capture information on department history table */
create trigger tr_insert_department_audit on department
for insert
as
declare @dep_id int
declare @dep_name varchar(20)
declare @audit_action varchar(20)

select @dep_id = i.dep_id from inserted i;
select @dep_name = i.dep_name from inserted i;
set @audit_action = 'Insert Record'
insert into Department_history values (@dep_id,@dep_name,@audit_action,getdate())

/* trigger for updation of record in department table */
create trigger tr_update_department_audit on department
for update
as
declare @dep_id int
declare @dep_name varchar(20)
declare @audit_action varchar(20)
/* variables declaration for deleted records */
declare @d_dep_id int
declare @d_dep_name varchar(20)
declare @d_audit_action varchar(20)

select @dep_id = case when (d.dep_id = i.dep_id) then  i.dep_id end from inserted i inner join deleted d on i.dep_id = d.dep_id;
select @dep_name = case when (d.dep_name = i.dep_name) then  i.dep_name end from inserted i inner join deleted d on i.dep_id = d.dep_id;
set @audit_action = 'Updated Record'
insert into Department_history values (@dep_id,@dep_name,@audit_action,getdate())


--2. Table Class*/
create table Class(class_id int Primary Key, class_name varchar(20) NOT NULL,  dep_id int foreign key  references department(dep_id))
 select * from Class

 --creating procedure for insertion in Class table
CREATE PROCEDURE dbo.classinsert 
       @class_id						 int  = NULL   , 
       @class_name					 varchar(20)      = NULL,
	   @dep_id			 int=NULL
AS 
BEGIN 
     SET NOCOUNT ON 
     INSERT INTO dbo.Class
          (                    
            class_id                    ,
            class_name,
			dep_id
			
          ) 
     VALUES 
          ( 
             @class_id,
            @class_name,
			 @dep_id
			
          ) 
END 
GO
--Now passing values in procedure to create a record with these values
exec dbo.classinsert
    @class_id    = '6'               ,
    @class_name   = 'myclass'    ,
	@dep_id	=	'10'

	select *from class
	insert into department(dep_id,dep_name)
	values(10,'scienec')

--Class triggers for history
create table Class_history(class_id int Primary Key, class_name varchar(20) NOT NULL,  dep_id int foreign key  references department(dep_id),audit_action varchar(20),
modified_date datetime)


/* create insert after  trigger and capture information on class history table */
create trigger tr_insert_class_audit on class
for insert
as
declare @class_id int
declare @class_name varchar(20)
declare @dep_id int
declare @audit_action varchar(20)

select @class_id = i.class_id from inserted i;
select @class_name = i.class_name from inserted i;
select @dep_id = i.dep_id from inserted i;

set @audit_action = 'Insert Record'
insert into class_history values (@class_id,@class_name,@dep_id,@audit_action,getdate())

/* trigger for updation of record in class history table */
create trigger tr_update_class_audit on class
for update
as
declare @class_id int
declare @class_name varchar(20)
declare @dep_id int
declare @audit_action varchar(20)
/* variables declaration for deleted records */
declare @d_class_id int
declare @d_class_name varchar(20)
declare @d_dep_id varchar(20)
declare @d_audit_action varchar(20)

select @class_id = case when (d.class_id = i.class_id) then  i.class_id end from inserted i inner join deleted d on i.class_id = d.class_id;
select @class_name = case when (d.class_name = i.class_name) then  i.class_name end from inserted i inner join deleted d on i.class_id = d.class_id;
select @dep_id = case when (d.dep_id = i.dep_id) then  i.dep_id end from inserted i inner join deleted d on i.dep_id = d.dep_id;

set @audit_action = 'Updated Record'
insert into Class_history values (@class_id,@class_name,@dep_id,@audit_action,getdate())		

--3. Table section
create table Section(sec_id int Primary Key, sec_title varchar(10) NOT NULL, class_id int foreign key references Class(class_id))
select * from Section

--creating procedure for insertion in section table
CREATE PROCEDURE dbo.sectioninsert 
       @sec_id						 int  = NULL   , 
       @sec_title					 varchar(10)      = NULL,
	   @class_id			 int=NULL
AS 
BEGIN 
     SET NOCOUNT ON 
     INSERT INTO dbo.section
          (                    
            sec_id                    ,
            sec_title,
			class_id
			
          ) 
     VALUES 
          ( 
             @sec_id,
            @sec_title,
			 @class_id
			
          ) 
END 
GO
--Now passing values in procedure to create a record with these values
exec dbo.sectioninsert
    @sec_id    = '5'               ,
    @sec_title   = 'mysection'    ,
	@class_id =	'6' 
	
	select * from Section

--4. Table student
create table Students( std_id int Primary Key, fname varchar(20) NOT NULL,lname varchar(20) NOT NULL,
fathername varchar(30) NOT NULL, mobile_no varchar(255) UNIQUE, address nvarchar(50) NOT NULL,city varchar(20),zipcode varchar(20),
age int NOT NULL ,email nvarchar(50) UNIQUE,class_id int foreign key references Class(class_id), section_id int foreign key references Section(sec_id),dep_id int foreign key references department(dep_id))
select * from Students

--creating procedure for insertion in student table
CREATE PROCEDURE dbo.studentinsert 
       @std_id						 int  = NULL   , 
       @fname					 varchar(20)      = NULL,
	   @lname			          varchar(20)      = NULL,
       @fathername                 varchar(30)      = NULL,
	   @mob_no                      varchar(255)      = NULL,
	   @age                         int      = NULL,
	   @email                        varchar(50)      = NULL,
	   @class_id                     int=NULL,
	   @sec_id                      int  = NULL,
	   @dep_id                      int=NULL

AS 
BEGIN 
     SET NOCOUNT ON 
     INSERT INTO dbo.student
          (                    
            std_id,
			fname,
			lname,
            fathername, 
			mob_no,
			age,  
			email, 
			class_id,
			sec_id,
			dep_id  
          ) 
     VALUES 
          ( 
            @std_id,
			@fname,
			@lname,
            @fathername, 
			@mob_no,
			@age,  
			@email, 
			@class_id,
			@sec_id,
			@dep_id  
          ) 
END 
GO
--Now passing values in procedure to create a record with these values
exec dbo.studentinsert
            @std_id = '7',
			@fname = 'Usman',
			@lname = 'Ali',
            @fathername ='Ahsan',
			@mob_no = '12345',
			@age ='20',
			@email= '1234gmail.com', 
			@class_id ='6',
			@sec_id='5',
			@dep_id ='10'
	select * from Student

--5. Table subjects
create table Subjects(sub_id int Primary Key, name varchar(20) NOT NULL UNIQUE, 
class_id int foreign key references Class(class_id),
section_id int references Section(sec_id), department_id int references Department(dep_id))
select * from Subjects

--creating procedure for insertion in subjects table
CREATE PROCEDURE dbo.subjecstinsert
       @sub_id						 int  = NULL   , 
       @name					 varchar(20)      = NULL,
	   @class_id			 int=NULL,
	   @section_id            int =NULL,
	   @department_id           int=NULL
AS 
BEGIN 
     SET NOCOUNT ON 
     INSERT INTO dbo.subjects
          (                    
            sub_id                    ,
            name,
			class_id,
			section_id,      
	      department_id
          ) 
     VALUES 
          ( 
          @sub_id                    ,
            @name,
			@class_id,
			@section_id,      
	      @department_id
          ) 
END 
GO
--Now passing values in procedure to create a record with these values
exec dbo.subjecstinsert
             sub_id = '12'           ,
            name = 'Discrete Structures',
			class_id = '6',
			section_id='5',      
	      department_id='10'
	select *from Subjects


--6. Table faculty
create table Faculty (fac_id int Primary Key, fac_name varchar(20) NOT NULL, phone_no varchar(20) NOT NULL, 
email nvarchar(50) UNIQUE NOT NULL, address nvarchar(30) NOT NULL,city varchar(20),zipcode varchar(20), age int NOT NULL CHECK (age >= 20),
department_id int foreign key references Department(dep_id),subject_id int foreign key references Subjects(sub_id), section_id int references section(sec_id))
select * from Faculty

--creating procedure for insertion in Faculty table
CREATE PROCEDURE dbo.facultyinsert 
       @fac_id						 int  = NULL   , 
       @fac_name					 varchar(20)      = NULL,
	   @phone_no		              varchar(20)      = NULL,
	   @email            varchar(50)      = NULL,
	   @age                   int = NULL,
	   @department_id          int = NULL,
	   @subject_id             int = NULL,
	   @section_id              int = NULL
AS 
BEGIN 
     SET NOCOUNT ON 
     INSERT INTO dbo.faculty
          (                    
            fac_id,						 
       fac_name,					 
	   phone_no,		 
	   email,            
	   age,
	   department_id,
	   subject_id,
	   section_id
          ) 
     VALUES 
          ( 
             @fac_id,						 
       @fac_name,					 
	   @phone_no,		 
	   @email,            
	   @age,
	   @department_id,
	   @subject_id,
	   @section_id
          ) 
END 
GO
--Now passing values in procedure to create a record with these values
exec dbo.facultyinsert

       fac_id = '8',						 
       fac_name = 'Hassan Ahmad',					 
	   phone_no = '021877',		 
	   email = '223226gmail',            
	   age = '27',
	   department_id ='10',
	   subject_id ='12',
	   section_id ='5'
   
	select *from faculty
--7. Table Attendance
create table Attendance(att_id int Primary Key, student_id int foreign key references Students(std_id),
subject_id  int foreign key references Subjects(sub_id),status char NOT NULL, date date NOT NULL, 
section_id int foreign key references Section(sec_id))
select * from Attendance

--creating procedure for insertion in Attendence table
CREATE PROCEDURE dbo.attendanceinsert 
       @att_id						 int  = NULL   , 
       @student_id					 int      = NULL,
	   @subject_id			 int=NULL,
	   @status               char = NULL,
	   @date                 date = NULL,
	   @section_id           int = NULL
AS 
BEGIN 
     SET NOCOUNT ON 
     INSERT INTO dbo.attendance
          (                    
            att_id					, 
       student_id	,				 
	   subject_id,			 
	   status,
	   date,
	   section_id
          ) 
     VALUES 
          ( 
             @att_id,						
       @student_id	,			
	   @subject_id	,	
	   @status,
	   @date,
	   @section_id
            
          
          ) 
END 
GO
--Now passing values in procedure to create a record with these values
exec dbo.attendanceinsert
    @att_id	='1',					
       @student_id	='2',				
	   @subject_id	='12',		 
	   @status ='p',
	   @date ='13',
	   @section_id ='5'

	select *from attendance
--8. Table Examinations
create table Examinations (ex_id int Primary Key, type varchar(20) NOT NULL, date date NOT NULL, 
subject_id int foreign key references Subjects(sub_id), class_id int foreign key references Class(class_id),
section_id int foreign key references Section(sec_id),
department_id int foreign key references Department(dep_id))
select * from Examinations

--creating procedure for insertion in examinations table
CREATE PROCEDURE dbo.examinationsinsert 
       @ex_id						 int  = NULL   , 
       @type					 varchar(20)      = NULL,
	   @date			 date=NULL,
	   @subject_id             int = NULL,
	   @class_id                int = NULL,
	   @section_id              int = NULL,
	   @department_id             int = NULL
AS 
BEGIN 
     SET NOCOUNT ON 
     INSERT INTO dbo.examinations
          (                    
             ex_id,						
       type,					
	   date,			 
	   subject_id,
	   class_id,
	   section_id,
	   department_id
          ) 
     VALUES 
          ( 
             @ex_id,						
       @type,					
	   @date,			
	   @subject_id,
	   @class_id,
	   @section_id,
	   @department_id
			
          ) 
END 
GO
--Now passing values in procedure to create a record with these values
exec dbo.examinationsinsert
  @ex_id ='14', 
       @type  ='theory'					
	   @date ='12/06/2022',
	   @subject_id = '12' ,
	   @class_id ='6',
	   @section_id= '5',
	   @department_id ='10'
	select *from Examinations

--9. Marks 
create table Marks(
marks_id int Primary Key,
total_marks int check (total_marks<=100 AND total_marks >0),
obtained_marks int check (obtained_marks<=100 AND obtained_marks >=0),
subject_id int foreign key references Subjects(sub_id),
student_id int foreign key references Students(std_id),
ex_id int foreign Key references Examinations(ex_id)
)
select * from Marks
--creating procedure for insertion in marks table
CREATE PROCEDURE dbo.marksinsert 
       @marks_id						 int  = NULL   , 
       @total_marks					,
	   @obtained_marks			 ,
	   @subject_id    int = NULL,
	   @student_id    int= NULL,
	   @ex_id            int = NULL

AS 
BEGIN 
     SET NOCOUNT ON 
     INSERT INTO dbo.marks
          (                    
           marks_id,				
       total_marks,					
	   obtained_marks,			 
	   subject_id,
	   student_id,
	   ex_id

          ) 
     VALUES 
          ( 
       @marks_id,						
         @total_marks,					
	   @obtained_marks,		
	   @subject_id,
	   @student_id,
	   @ex_id
          ) 
END 
GO
--Now passing values in procedure to create a record with these values
exec dbo.marksinsert
     @marks_id	= '9',					 
       @total_marks	='100',				 
	   @obtained_marks= '90',			 
	   @subject_id= '5',
	   @student_id='4',
	   @ex_id ='14'


	select *from marks
--10. Table Accounts
create table Accounts (acc_id int Primary Key, voucher_no int NOT NULL,total_fee int NOT NULL,issue_date date not null, due_date date NOT NULL, 
status varchar(20) NOT NULL, student_id int references students(std_id))
select * from accounts

 --creating procedure for insertion in Class table
CREATE PROCEDURE dbo.accountsinsert 
       @acc_id						 int  = NULL   , 
       @voucher_no					 int   = NULL,
	   @total_fee			 int=NULL,
	   @issue_date           date=NULL,
	   @due_date             date=NULL,
	   @status                varchar(20)= NULL,
	   @student_id             int = NULL
AS 
BEGIN 
     SET NOCOUNT ON 
     INSERT INTO dbo.accounts
          (                    
           acc_id,					
       voucher_no,				
	   total_fee,		
	   issue_date,
	   due_date,
	   status,
	   student_id
			
          ) 
     VALUES 
          ( 
             @acc_id,			
       @voucher_no,	
	   @total_fee,	
	   @issue_date,
	   @due_date,
	   @status,
	   @student_id,
			
          ) 
END 
GO
--Now passing values in procedure to create a record with these values
exec dbo.accountsinsert
   @acc_id	= '15',				
       @voucher_no ='111',			
	   @total_fee	='100',	
	   @issue_date ='12/06/21',
	   @due_date ='22/06/22',
	   @status= 'clear',
	   @student_id='21'
	 

	select *from Accounts


--11. Table Computer Labs
create table ComputerLab(lab_id int Primary Key, lab_name varchar(20) NOT NULL,
 lab_attendant varchar(20) UNIQUE NOT NULL, total_pc int NOT NULL)
select * from ComputerLab


 --creating procedure for insertion in Computer Labs table
CREATE PROCEDURE dbo.ComputerLabinsert 
       @lab_id						 int  = NULL   , 
       @lab_name					 varchar(20)      = NULL,
	   @lab_attendant			 varchar(20)      = NULL,
	   @total_pc                      int = NULL
AS 
BEGIN 
     SET NOCOUNT ON 
     INSERT INTO dbo.ComputerLab
          (                    
             lab_id,						
       lab_name,				
	   lab_attendant,			 
	   total_pc    
          ) 
     VALUES 
          ( 
		     @lab_id,		
       @lab_name,					
	   @lab_attendant,		
	   @total_pc    
             
          ) 
END 
GO
--Now passing values in procedure to create a record with these values
exec dbo.ComputerLabinsert
    @lab_id ='30',						
       @lab_name ='my comp lab',				
	   @lab_attendant	='Nasir',
	   @total_pc ='30'   

	select *from ComputerLab

--12. Table Library
create table Library(lib_id int Primary Key, admin varchar(20) NOT NULL, lab_attendant varchar(20) UNIQUE)
select * from Library

 --creating procedure for insertion in library table
CREATE PROCEDURE dbo.libraryinsert 
       @lib_id						 int  = NULL   , 
       @admin					 varchar(20)      = NULL,
	   @lab_attendant			 varchar(20)      = NULL,
	  
AS 
BEGIN 
     SET NOCOUNT ON 
     INSERT INTO dbo.library
          (                    
             lib_id,						
       admin,				
	   lab_attendant			 
	  
          ) 
     VALUES 
          ( 
		     @lib_id,		
       @admin,					
	   @lab_attendant
             
          ) 
END 
GO
--Now passing values in procedure to create a record with these values
exec dbo.libraryinsert
    @lib_id ='32',						
       @admin ='Kashif',				
	   @lab_attendant	='Qaiser',
	   @total_pc ='30'   

	select *from Library

Create Table Book(
book_id int primary key,
book_name varchar(25),
borrowed_at datetime,
returned_at datetime,
status varchar(10),
std_id int foreign key references students(std_id),
lib_id int foreign key references Library(lib_id)
)


--dropping all tables
drop table Department
drop table Class
drop table Section
drop table Students
drop table Faculty
drop table Subjects
drop table Attendance
drop table Examinations
drop table Marks
drop table ComputerLab
drop table Library




--Nomalizing the database

--Department
 --1NF
 --The table is already in 1NF since there is a primary key attribute and there are no repeating groups and the data is in reduced form

 --2NF
 --HOD is not fully functional dependant on department id so we drop it and create a new table for it and relink it to department table
 Alter table Department
 drop column HOD_name

 create table HOD(
 HOD_id int primary key,
 HOD_name varchar(20) not null,
 dep_id int foreign key references Department(dep_id)
 )

 --3NF
 --The table is already in 3NF since it meets requirements of 2NF and all columns are dependant on the primary key attribute only

 --Class
 --1NF
 --The table is already in 1NF since there is a primary key attribute and there are no repeating groups and the data is in reduced form

 --2NF
 --The table is already in 2NF since it meets the requirements of 1NF and 
 --all non key attributes are functionally dependant on the primary key attribute only

  --3NF
 --The table is already in 3NF since it meets requirements of 2NF and all columns are dependant on the primary key attribute only
 

 
 --Section
 --1NF
 --The table is already in 1NF since there is a primary key attribute and there are no repeating groups and the data is in reduced form

 --2NF
 --The table is already in 2NF since it meets the requirements of 1NF and 
 --all non key attributes are functionally dependant on the primary key attribute only

  --3NF
 --The table is already in 3NF since it meets requirements of 2NF and all columns are dependant on the primary key attribute only

 --Student

--1NF 
--The table is already in 1NF since there is a primary key attribute and there are no repeating groups and the data is in reduced form

--2NF
--Address is not fully functional dependant on primary key of student table 
--So we remove it from abale and create a separate table for it

Alter table Students
drop column address
Alter table Students
drop column city
Alter table Students
drop column zipcode

create table StudentAdress(
address_id int primary key,
address nvarchar(50) NOT NULL,
city varchar(50),
zipcode varchar(20),
std_id int foreign key references Students(std_id)
)

  --3NF
 --The table is already in 3NF since it meets requirements of 2NF and all columns are dependant on the primary key attribute only


--Subject

--1NF
 --The table is already in 1NF since there is a primary key attribute and there are no repeating groups and the data is in reduced form

 --2NF
 --The table is already in 2NF since it meets the requirements of 1NF and 
 --all non key attributes are functionally dependant on the primary key attribute only

  --3NF
 --The table is already in 3NF since it meets requirements of 2NF and all columns are dependant on the primary key attribute only

 --Student



--Faculty
--1NF
 --The table is already in 1NF since there is a primary key attribute and there are no repeating groups and the data is in reduced form
 --2NF
Alter table Faculty
drop column address
Alter table Faculty
drop column city
Alter table Faculty
drop column zipcode

create table FacultyAddress(
address_id int primary key,
address nvarchar(50) NOT NULL,
city varchar(50),
zipcode varchar(20),
fac_id int foreign key references Faculty(fac_id)
)


 --3NF
 --The table is already in 3NF since it meets requirements of 2NF and all columns are dependant on the primary key attribute only


--Attendance
--1NF
--The table is already in 1NF since there is a primary key attribute and there are no repeating groups and the data is in reduced form

 --2NF
 --The table is already in 2NF since it meets the requirements of 1NF and 
 --all non key attributes are functionally dependant on the primary key attribute only

 --3NF
 --The table is already in 3NF since it meets requirements of 2NF and all columns are dependant on the primary key attribute only


--Examination
--8. Table Examinations
--1NF
--The table is already in 1NF since there is a primary key attribute and there are no repeating groups and the data is in reduced form

 --2NF
 --The table is already in 2NF since it meets the requirements of 1NF and 
 --all non key attributes are functionally dependant on the primary key attribute only

 --3NF
 --The table is already in 3NF since it meets requirements of 2NF and all columns are dependant on the primary key attribute only


 --Marks 

--1NF
--The table is already in 1NF since there is a primary key attribute and there are no repeating groups and the data is in reduced form

 --2NF
 --The table is already in 2NF since it meets the requirements of 1NF and 
 --all non key attributes are functionally dependant on the primary key attribute only

 --3NF
 --The table is already in 3NF since it meets requirements of 2NF and all columns are dependant on the primary key attribute only


 
--Accounts
--1NF
--The table is already in 1NF since there is a primary key attribute and there are no repeating groups and the data is in reduced form

 --2NF
 --The table is already in 2NF since it meets the requirements of 1NF and 
 --all non key attributes are functionally dependant on the primary key attribute only

 --3NF
 --The table is already in 3NF since it meets requirements of 2NF and all columns are dependant on the primary key attribute only


 --Computer Lab
--1NF
--The table is already in 1NF since there is a primary key attribute and there are no repeating groups and the data is in reduced form

 --2NF
 --The table is already in 2NF since it meets the requirements of 1NF and 
 --all non key attributes are functionally dependant on the primary key attribute only

 --3NF
 --The table is already in 3NF since it meets requirements of 2NF and all columns are dependant on the primary key attribute only




 --Library
--1NF
--The table is already in 1NF since there is a primary key attribute and there are no repeating groups and the data is in reduced form

 --2NF
 --The table is already in 2NF since it meets the requirements of 1NF and 
 --all non key attributes are functionally dependant on the primary key attribute only

 --3NF
 --The table is already in 3NF since it meets requirements of 2NF and all columns are dependant on the primary key attribute only


 --data insertion
 --Departments
 INSERT INTO Department (dep_id,dep_name)
VALUES
  (1,'Science'),
  (2,'Biology'),
  (3,'Computer'),
  (4,'Arts'),
  (5,'Primary-8th')

--HOD
 INSERT INTO HOD (HOD_id,HOD_name,dep_id)
VALUES
  (1,'Dr.Abid Sohail',1),
  (2,'M.Shahid Bhatti',2),
  (3,'M.Waqas Anwar',3),
  (4,'Rao Adeel',4),
  (5,'Ahmad',5)


  --Class
  INSERT INTO Class (class_id,class_name,dep_id)
VALUES
  (1,'Primary',5),
  (2,'PlayGroup',5),
  (3,'KG',5),
  (4,'1',5),
  (5,'2',5),
  (6,'3',5),
  (7,'4',5),
  (8,'5',5),
  (9,'6',5),
  (10,'7',5),
  (11,'8',5),
  (12,'9',1),
  (13,'10',1),
  (14,'9',2),
  (15,'10',2),
  (16,'9',3),
  (17,'10',3),
  (18,'9',4),
  (19,'10',4)



--Sections
 INSERT INTO Section (sec_id,sec_title,class_id)
VALUES
  (1,'A',5),
  (2,'B',5),
  (3,'C',5),
  (4,'D',5),
  (5,'E',5),
  (6,'F',5),
  (7,'G',5),
  (8,'H',5),
  (9,'I',5),
  (10,'j',5),
  (11,'K',5),
  (12,'L',4),
  (13,'M',4),
  (14,'N',3),
  (15,'O',3),
  (16,'P',2),
  (17,'Q',2),
  (18,'R',1),
  (19,'S',1)


--selecting all tables
select * from Department
select * from Class
select * from Section
select * from Students
select * from Faculty
select * from Subjects
select * from Attendance
select * from Examinations
select * from Marks
select * from Accounts
select * from ComputerLab
select * from Library
select * from StudentAdress
select * from FacultyAddress
select * from HOD


--Students

INSERT INTO [Students] (std_id,fname,lname,fathername,mobile_no,age,email,class_id,section_id,dep_id)
VALUES
  (1,'Jin Lindsey','Ariel Benson','Cheyenne Roman','(271) 711-8669',5,'sed@icloud.couk',1,1,5),
  (2,'Shad Schmidt','Seth Townsend','Elmo Benton','(376) 368-3887',5,'est.nunc@yahoo.edu',1,1,5),
  (3,'Adrienne Vinson','Leah Blackburn','Herman Jackson','1-822-306-8638',5,'tellus.imperdiet.non@yahoo.org',1,1,5),
  (4,'Harriet Cruz','Ulysses Logan','Magee Vasquez','(233) 532-3658',5,'vitae.orci.phasellus@google.org',1,1,5),
  (5,'Lesley Joyner','Sydnee Whitfield','Armand Montgomery','(838) 141-5625',5,'ipsum.nunc@google.couk',1,1,5),
  (6,'Irma Gilbert','Pearl Leach','Shaeleigh Hopper','1-837-873-8433',5,'nisl.elementum.purus@aol.ca',1,1,5),
  (7,'Tallulah Leach','Blythe Cooke','Omar Ewing','(284) 578-7381',5,'velit@hotmail.edu',1,1,5),
  (8,'Denton Crane','Wynne Kirby','Ariel Hardy','(873) 752-1173',5,'ultrices.posuere@outlook.ca',1,1,5),
  (9,'Nicole Norman','Rajah Ayala','Samantha Hoover','(245) 981-7664',5,'mauris@icloud.org',1,1,5),
  (10,'Jarrod Clay','Hamilton Carpenter','Sigourney Rivas','1-334-656-7832',5,'tortor.at@outlook.com',1,1,5);
INSERT INTO [Students] (std_id,fname,lname,fathername,mobile_no,age,email,class_id,section_id,dep_id)
VALUES
  (11,'Nehru Lane','Ali Randolph','Blythe Wilcox','1-641-311-9374',5,'risus.duis@google.edu',1,1,5),
  (12,'Robert Estes','Pascale Hurley','Yoko Foreman','1-232-652-6269',5,'mi.felis@yahoo.ca',1,1,5),
  (13,'Abraham Parker','Jonas Wilson','Tyler Barrera','1-737-311-4649',5,'augue.malesuada@hotmail.couk',1,1,5),
  (14,'Martha Harris','Stuart Armstrong','Mohammad Duke','(362) 724-6822',5,'justo.sit@google.edu',1,1,5),
  (15,'Susan Mcconnell','Octavius Faulkner','Alma Rivas','1-653-310-3427',5,'dolor.sit@hotmail.org',1,1,5),
  (16,'Gemma Hensley','Nehru Chambers','Timothy Macdonald','(478) 554-6310',5,'ut.pellentesque@google.couk',1,1,5),
  (17,'Shaine Wiley','Nina Collier','Teegan Maddox','(241) 685-5110',5,'suscipit.nonummy.fusce@outlook.org',1,1,5),
  (18,'Carter Clayton','Marshall Tyson','Arden Nicholson','(818) 755-3141',5,'ac.feugiat.non@protonmail.edu',1,1,5),
  (19,'Bianca Chambers','MacKensie Conway','Jordan Odom','(457) 939-0036',5,'tempus.lorem@aol.couk',1,1,5),
  (20,'Shay Larsen','Malcolm Rice','Cameron Chase','(449) 332-8861',5,'cras.vehicula.aliquet@hotmail.net',1,1,5);
INSERT INTO [Students] (std_id,fname,lname,fathername,mobile_no,age,email,class_id,section_id,dep_id)
VALUES
  (21,'Nolan Leblanc','Lucius Jackson','Clark Bridges','1-536-134-3329',5,'consectetuer.adipiscing@icloud.net',2,2,5),
  (22,'Driscoll Russo','Halla Oliver','Tyrone Mcintyre','1-177-323-4153',5,'vehicula.et@hotmail.ca',2,2,5),
  (23,'Angela Dickson','Unity Bennett','Julie Bullock','1-477-324-7031',5,'fermentum.convallis@icloud.edu',2,2,5),
  (24,'Zephania Carver','Olivia Pickett','Quintessa Gill','1-871-457-7848',5,'nascetur.ridiculus@hotmail.ca',2,2,5),
  (25,'Macy Jacobson','Juliet Roach','Fredericka Glenn','1-915-426-8581',5,'ornare.sagittis@hotmail.couk',2,2,5),
  (26,'Veda Barnett','Lars Key','Kennedy Graham','(346) 325-2036',5,'neque.pellentesque.massa@protonmail.edu',2,2,5),
  (27,'Darius Hewitt','Amaya Good','Leslie Hess','(725) 583-3799',5,'per.conubia@google.couk',2,2,5),
  (28,'Simon Mcneil','Oren Flores','Rosalyn Espinoza','1-236-365-4325',5,'ac@aol.couk',2,2,5),
  (29,'Renee Mack','Candice Atkinson','Sonya Lester','1-726-188-4490',5,'lorem.ut.aliquam@protonmail.edu',2,2,5),
  (30,'Keiko Schroeder','Quail Gibbs','Yolanda Craft','(725) 299-1029',5,'aliquet@protonmail.org',2,2,5);
INSERT INTO [Students] (std_id,fname,lname,fathername,mobile_no,age,email,class_id,section_id,dep_id)
VALUES
  (31,'Nolan Beach','Steven Joyner','Ashton Herrera','1-106-831-8958',6,'aenean@hotmail.couk',2,2,5),
  (32,'Ross Espinoza','Axel Lara','Madaline Baird','(376) 812-6572',6,'pellentesque.habitant.morbi@google.edu',2,2,5),
  (33,'Chandler Hardin','Porter Horn','Whilemina Boyle','(567) 792-8423',6,'suspendisse.aliquet.molestie@hotmail.edu',2,2,5),
  (34,'Kiara Hebert','Tyler Morrison','Serina Cantrell','(583) 646-2812',6,'elit.erat@icloud.net',2,2,5),
  (35,'Alec Allison','Paul Hobbs','Debra Molina','1-433-946-8552',6,'volutpat@google.ca',2,2,5),
  (36,'Jessamine Burnett','Sybil Mcclure','Martin Walsh','(438) 181-9868',6,'diam@hotmail.edu',2,2,5),
  (37,'Kessie Flynn','Candice Faulkner','Kristen Walter','1-693-483-1821',6,'pharetra@google.org',2,2,5),
  (38,'Cooper Goff','Moses Cherry','Pascale Bridges','(853) 461-6236',6,'in.ornare@google.ca',2,2,5),
  (39,'Helen Mejia','Orson Hess','Shana Ball','1-964-215-2185',6,'suspendisse.ac@aol.edu',2,2,5),
  (40,'Steven Atkins','Quyn Newton','Mohammad Cummings','(374) 862-5294',6,'porttitor.tellus@yahoo.org',2,2,5);
INSERT INTO [Students] (std_id,fname,lname,fathername,mobile_no,age,email,class_id,section_id,dep_id)
VALUES
  (41,'Hedy Dennis','Regina Witt','Bree Alston','(282) 723-6720',6,'orci@hotmail.org',3,3,5),
  (42,'Savannah Workman','Clark Montgomery','Kiara Butler','1-246-611-0578',6,'rhoncus.id@outlook.org',3,3,5),
  (43,'Callum Burt','Lars Mcmillan','Jelani Brewer','(281) 585-1816',6,'lacus.aliquam.rutrum@protonmail.edu',3,3,5),
  (44,'Wynne Farmer','Indira Greene','Simone Norman','(560) 816-7110',6,'in.hendrerit@yahoo.org',3,3,5),
  (45,'Maris Franklin','Abigail Mckay','Gemma Dorsey','1-934-602-8435',6,'ligula.nullam.enim@google.net',3,3,5),
  (46,'Anthony Santana','Bianca Guerrero','Adena Wood','1-263-934-7613',6,'mauris.eu@outlook.org',3,3,5),
  (47,'Unity Reeves','Lisandra Mcdowell','Ali Spears','1-658-253-6828',6,'ridiculus.mus@hotmail.couk',3,3,5),
  (48,'Mason Marsh','Tanek Blanchard','Judah Cameron','(243) 188-8522',6,'arcu.vestibulum@hotmail.net',3,3,5),
  (49,'Bianca Craig','Zena Boyd','Julie Murray','(959) 383-6964',6,'gravida.sagittis@yahoo.org',3,3,5),
  (50,'Simone Gonzales','Valentine Holden','Malcolm Pugh','1-428-575-4949',6,'purus.accumsan.interdum@protonmail.edu',3,3,5);
INSERT INTO [Students] (std_id,fname,lname,fathername,mobile_no,age,email,class_id,section_id,dep_id)
VALUES
  (51,'Dale Mejia','Yolanda Barry','Kibo Maddox','1-535-793-8897',6,'mattis.cras@icloud.org',3,3,5),
  (52,'Sasha Murray','Hyatt Warner','Armando Hardy','1-789-523-8625',6,'sapien@outlook.com',3,3,5),
  (53,'Benedict Pennington','Fallon Nieves','Kelsey Small','1-169-865-2874',6,'maecenas.iaculis@yahoo.com',3,3,5),
  (54,'Anika Donaldson','Jesse Mendez','Dante Williamson','(757) 253-2515',6,'vestibulum.accumsan@yahoo.net',3,3,5),
  (55,'Yuli Lloyd','Ishmael Fernandez','Ursa Kemp','1-414-634-3132',6,'et@hotmail.ca',3,3,5),
  (56,'Winifred Craig','Tasha Ramsey','Oscar Vaughan','(373) 302-1713',6,'scelerisque.lorem@google.edu',3,3,5),
  (57,'Freya Hernandez','Giselle Trevino','Kimberley Simpson','1-441-757-7811',6,'nullam.nisl@aol.com',3,3,5),
  (58,'Gregory Hodge','Anika Alexander','Audrey Soto','(424) 276-0716',6,'et.risus.quisque@aol.com',3,3,5),
  (59,'Maile Hull','Magee Sullivan','Libby Gordon','1-552-891-8337',6,'cursus.nunc.mauris@outlook.ca',3,3,5),
  (60,'Noah Cunningham','Robin Boyle','Channing Martin','(523) 598-9384',6,'cum.sociis@hotmail.org',3,3,5);
INSERT INTO [Students] (std_id,fname,lname,fathername,mobile_no,age,email,class_id,section_id,dep_id)
VALUES
  (61,'Kiara Baldwin','Stacey Rogers','Georgia Graham','(888) 612-9979',7,'rutrum.eu.ultrices@aol.ca',4,4,5),
  (62,'Margaret Lott','Arden Hayden','Logan Andrews','(610) 127-8517',7,'at.libero@yahoo.org',4,4,5),
  (63,'Zachery Jenkins','Hiroko Rios','Ralph Rutledge','(631) 863-1931',7,'id@aol.com',4,4,5),
  (64,'Kieran Copeland','Emma Travis','Dane Hurst','(557) 707-2341',7,'amet.orci@aol.org',4,4,5),
  (65,'Stone Boyer','Lydia Reyes','Quamar Lamb','(236) 348-1263',7,'curabitur.massa@google.couk',4,4,5),
  (66,'Venus Larson','Clare Riley','Pandora Pennington','(488) 518-0181',7,'imperdiet@yahoo.com',4,4,5),
  (67,'Nehru Hess','Berk Davis','Susan Morin','1-549-190-5135',7,'lorem.ipsum@google.couk',4,4,5),
  (68,'Amity Nunez','Otto Gaines','Dai Joyce','(341) 281-4577',7,'ipsum@outlook.com',4,4,5),
  (69,'Maisie Arnold','Patrick Bryan','Flavia Mejia','1-453-158-0373',7,'quis.arcu.vel@yahoo.org',4,4,5),
  (70,'Faith Dillon','Yeo Morgan','Jakeem Yang','1-264-652-9813',7,'nec@aol.com',4,4,5);
INSERT INTO [Students] (std_id,fname,lname,fathername,mobile_no,age,email,class_id,section_id,dep_id)
VALUES
  (71,'Kyle Luna','Martha Sweeney','Keith Barron','(791) 446-2165',7,'integer.mollis.integer@protonmail.com',4,4,5),
  (72,'Willa Solis','Darius Carson','Wynter Gentry','(266) 619-2827',7,'tellus.imperdiet.non@aol.edu',4,4,5),
  (73,'Deacon Crawford','Scott Strickland','Owen Kerr','(545) 721-8816',7,'diam.proin@hotmail.edu',4,4,5),
  (74,'Kaseem Prince','Velma Cox','John Raymond','1-800-191-4355',7,'quisque.ornare@icloud.org',4,4,5),
  (75,'Abdul Sanford','Kylie Chandler','Kevin O''donnell','(721) 230-9492',7,'nunc.lectus@aol.edu',4,4,5),
  (76,'Yasir Brown','Jorden Prince','Briar Moses','1-749-396-1620',7,'sed.dui@outlook.org',4,4,5),
  (77,'Caldwell Moran','Hamilton Franco','April Barrera','(967) 799-8944',7,'ut.semper.pretium@outlook.ca',4,4,5),
  (78,'Hanna Mcgowan','Hakeem Joyce','Bradley Phelps','(261) 612-6427',7,'lectus.cum.sociis@google.net',4,4,5),
  (79,'TaShya Smith','Destiny Clarke','Hop Farrell','1-311-855-8132',7,'vestibulum@google.edu',4,4,5),
  (80,'Cruz Maddox','Owen Johnston','Libby Steele','1-288-286-7711',7,'ac.nulla@aol.ca',4,4,5);
INSERT INTO [Students] (std_id,fname,lname,fathername,mobile_no,age,email,class_id,section_id,dep_id)
VALUES
  (81,'Danielle Mullins','Alyssa Garner','Lucian Wyatt','(290) 322-1937',7,'non.sapien@protonmail.ca',5,5,5),
  (82,'Darius Craig','Darius Mcgee','Ainsley Ellison','1-683-761-3034',7,'amet@protonmail.couk',5,5,5),
  (83,'Colleen Erickson','Lucy Underwood','Xanthus Kinney','(622) 736-2320',7,'non.egestas.a@google.com',5,5,5),
  (84,'Ian Murphy','Alfreda Bass','Ria Sims','(687) 887-4884',7,'neque@aol.org',5,5,5),
  (85,'Jackson Henry','Martina Summers','Angela Wise','1-763-331-2972',7,'suspendisse.sagittis.nullam@icloud.com',5,5,5),
  (86,'Kessie Pierce','Bell Gross','Wade Gaines','(606) 910-6000',7,'in.magna@hotmail.org',5,5,5),
  (87,'Tanek Doyle','Guinevere Olson','Stuart Yates','1-457-573-6556',7,'dolor.nulla@icloud.com',5,5,5),
  (88,'Joel Miller','Emmanuel Bowers','Myra Perkins','(624) 456-2178',7,'ipsum.dolor.sit@protonmail.couk',5,5,5),
  (89,'Montana Sheppard','Cameron Mitchell','Deacon Cochran','(213) 547-1627',7,'nullam@aol.couk',5,5,5),
  (90,'Ginger Vega','Tatiana Petty','Hope Harrington','(478) 984-3143',7,'nunc.lectus@aol.org',5,5,5);
INSERT INTO [Students] (std_id,fname,lname,fathername,mobile_no,age,email,class_id,section_id,dep_id)
VALUES
  (91,'Hadley Fischer','Aretha Wells','Madonna Guerrero','(565) 218-8288',8,'libero@icloud.com',5,5,5),
  (92,'Maggy Solomon','Mari Hammond','Emerald James','1-297-235-9535',8,'tristique.senectus@outlook.com',5,5,5),
  (93,'Galvin Mcdowell','Castor Crosby','Emerald Mullen','1-201-552-3831',8,'ut.dolor@aol.couk',5,5,5),
  (94,'Hunter Franks','Lyle Petersen','Chase Cox','(344) 412-6844',8,'accumsan.neque@aol.edu',5,5,5),
  (95,'Marvin Payne','Amery Randolph','Bo Jennings','(445) 741-9225',8,'sed@hotmail.com',5,5,5),
  (96,'Orson Hunt','Kaye Benjamin','Harrison Hutchinson','(234) 235-1593',8,'justo.eu@aol.org',5,5,5),
  (97,'Alan Bradford','Vanna Holt','Imogene Gregory','1-437-850-5973',8,'dolor.dolor@protonmail.edu',5,5,5),
  (98,'Salvador Chapman','Zephania Goodman','Malachi Morton','1-796-996-4743',8,'phasellus.fermentum.convallis@protonmail.ca',5,5,5),
  (99,'Shafira Martin','Neve Freeman','Stone Floyd','(503) 698-0745',8,'donec.nibh.quisque@outlook.org',5,5,5),
  (100,'Jillian Mason','Ira Davenport','Alan Richmond','(973) 553-8848',8,'dui.fusce.aliquam@hotmail.org',5,5,5);
INSERT INTO [Students] (std_id,fname,lname,fathername,mobile_no,age,email,class_id,section_id,dep_id)
VALUES
  (101,'Samuel Terry','Yuli Camacho','Nevada Padilla','(775) 826-7346',8,'vel.convallis@yahoo.org',6,6,5),
  (102,'Robert Hughes','Kirsten Hopper','Zenia Duran','1-227-981-3276',8,'quis@protonmail.couk',6,6,5),
  (103,'Maxwell Silva','Kamal Keller','Berk Noble','1-949-648-8443',8,'phasellus@protonmail.org',6,6,5),
  (104,'Randall Gould','Kylynn Leonard','Aimee Bridges','1-721-265-6854',8,'id.mollis@hotmail.org',6,6,5),
  (105,'Prescott Green','Rajah Perez','Blaze Booker','(231) 866-2743',8,'facilisis.vitae@google.ca',6,6,5),
  (106,'Cade Erickson','Jonas Howell','Perry Roach','1-213-575-9816',8,'nisl.sem.consequat@protonmail.org',6,6,5),
  (107,'Keefe Bradley','Diana Rutledge','Hayden Parrish','1-262-167-2170',8,'risus.morbi.metus@google.com',6,6,5),
  (108,'Jordan Pratt','Eliana Acevedo','Ursa Velazquez','(244) 362-1491',8,'fusce.diam@hotmail.couk',6,6,5),
  (109,'Chantale Mcdaniel','Cheyenne Bond','Raphael Ross','1-473-970-7651',8,'convallis@aol.couk',6,6,5),
  (110,'Ivana Madden','Cruz Wilkinson','Hoyt Jarvis','1-296-704-9909',8,'pede.blandit@aol.com',6,6,5);
INSERT INTO [Students] (std_id,fname,lname,fathername,mobile_no,age,email,class_id,section_id,dep_id)
VALUES
  (111,'Xyla Knowles','Unity Wells','Blythe Newman','(933) 568-4576',8,'in@icloud.com',6,6,5),
  (112,'Maxwell Conway','Palmer Hale','Chaney Rios','1-328-608-9775',8,'cras.pellentesque@hotmail.org',6,6,5),
  (113,'Suki Gutierrez','Ivy Noel','Chandler Grimes','1-348-463-2760',8,'a.felis@protonmail.ca',6,6,5),
  (114,'Jada Langley','Caryn Hurley','Marny Willis','(274) 336-3522',8,'aliquet.sem.ut@protonmail.com',6,6,5),
  (115,'Dana Blake','Xandra Chapman','Rhea Hansen','1-717-548-6702',8,'quisque.ac@icloud.net',6,6,5),
  (116,'Carter Santiago','Keefe Vance','Angelica Stephenson','1-396-718-4210',8,'vel.quam.dignissim@google.couk',6,6,5),
  (117,'Lance Lloyd','Rooney Bell','Norman Coffey','1-945-297-8888',8,'malesuada.vel.venenatis@icloud.ca',6,6,5),
  (118,'Micah Barnes','Hermione Dorsey','Patrick Scott','1-863-353-4664',8,'lobortis@outlook.net',6,6,5),
  (119,'Brent Cameron','Nathan Mcdonald','Stewart Bennett','(283) 265-8258',8,'arcu.aliquam.ultrices@hotmail.ca',6,6,5),
  (120,'Neil Vang','Sasha Parrish','Nero Sexton','1-793-725-6482',8,'sit.amet.nulla@hotmail.com',6,6,5);
INSERT INTO [Students] (std_id,fname,lname,fathername,mobile_no,age,email,class_id,section_id,dep_id)
VALUES
  (121,'Shannon Moore','Joan Payne','Bradley Roy','1-751-631-8857',9,'pellentesque@aol.net',7,7,5),
  (122,'Theodore Hendricks','Justine Chan','Tanek Wright','1-741-274-2623',9,'non.massa.non@outlook.edu',7,7,5),
  (123,'Abigail Whitaker','Daquan Cortez','Cadman Bentley','1-286-443-6288',9,'amet@aol.org',7,7,5),
  (124,'Lee Holder','Lester Day','Shelley Mejia','1-116-851-5256',9,'in@aol.com',7,7,5),
  (125,'Iris Hutchinson','Honorato Guy','Claudia Blanchard','1-919-728-2326',9,'venenatis.vel.faucibus@icloud.couk',7,7,5),
  (126,'Dorian Baird','Avram Schwartz','Brian Cooley','(363) 878-7014',9,'quis.pede.praesent@protonmail.org',7,7,5),
  (127,'Dustin Hopper','Amena Pratt','Kaseem May','(213) 324-2896',9,'malesuada@protonmail.couk',7,7,5),
  (128,'Cain Hicks','Dana Mendoza','Germane Parker','(281) 688-6177',9,'aliquam.rutrum.lorem@hotmail.net',7,7,5),
  (129,'Bernard Mathis','Leila Simmons','Mason Robertson','(559) 478-2234',9,'est.vitae@yahoo.ca',7,7,5),
  (130,'Caesar Short','Adena Franklin','Rafael Rutledge','(655) 683-2887',9,'nunc.pulvinar@outlook.org',7,7,5);
INSERT INTO [Students] (std_id,fname,lname,fathername,mobile_no,age,email,class_id,section_id,dep_id)
VALUES
  (131,'Brody Abbott','Patrick Carter','Victoria Middleton','1-276-512-2583',9,'neque.in@protonmail.couk',7,7,5),
  (132,'Jared Contreras','Alice Clemons','Tanisha Moon','1-680-301-5087',9,'diam.nunc.ullamcorper@aol.com',7,7,5),
  (133,'Francesca Alford','Rudyard Bradshaw','Brenden Barnes','(371) 866-5701',9,'mauris.ut@yahoo.org',7,7,5),
  (134,'Ryan Lucas','Nell Cole','Otto Blair','1-732-563-1523',9,'quam.a@google.ca',7,7,5),
  (135,'Kim Winters','Irma Blanchard','Colette Schultz','(289) 614-2542',9,'ac@aol.edu',7,7,5),
  (136,'Oprah Wooten','Brody Mercado','Ross Delgado','(725) 442-2380',9,'interdum@yahoo.ca',7,7,5),
  (137,'Christine Nichols','Brynne Rich','Griffith Stout','(403) 985-2577',9,'nec.imperdiet@google.edu',7,7,5),
  (138,'Laura Willis','Jenna Stewart','Gretchen Stuart','1-724-833-7753',9,'sapien.cursus@yahoo.net',7,7,5),
  (139,'Stewart Sandoval','Odysseus Reed','Charlotte Hewitt','1-390-588-4747',9,'eu.erat@outlook.org',7,7,5),
  (140,'Tamekah Acevedo','Myles Pierce','Sydnee Kinney','(140) 878-8571',9,'porttitor.tellus@aol.com',7,7,5);
INSERT INTO [Students] (std_id,fname,lname,fathername,mobile_no,age,email,class_id,section_id,dep_id)
VALUES
  (141,'Ulysses Rosa','Malachi Strickland','Reed Ferguson','(793) 803-3317',9,'et.tristique.pellentesque@hotmail.org',8,8,5),
  (142,'Laith Livingston','Clayton Dunlap','Raymond Mcguire','1-246-265-5017',9,'nunc.quis.arcu@icloud.edu',8,8,5),
  (143,'Violet Fernandez','Isaiah Osborne','Marsden Allen','1-691-714-8104',9,'natoque.penatibus@google.org',8,8,5),
  (144,'Marvin Martin','Phillip Mcbride','Derek Small','(458) 316-2632',9,'vivamus.nibh@protonmail.edu',8,8,5),
  (145,'Britanni Navarro','Zenia Curtis','Elaine Garrett','(454) 709-1675',9,'sem.pellentesque.ut@aol.org',8,8,5),
  (146,'Clinton Long','Mason Higgins','Kirsten Hahn','1-646-903-4573',9,'nunc.sollicitudin.commodo@outlook.net',8,8,5),
  (147,'Tara Campos','Flavia Atkinson','Jennifer Britt','(161) 448-5944',9,'praesent.interdum.ligula@hotmail.com',8,8,5),
  (148,'Miranda Hansen','Aurelia Gordon','Barry Hendrix','1-543-135-1098',9,'sollicitudin@aol.edu',8,8,5),
  (149,'Nina Cooper','Amber Walker','Allegra Roth','1-421-644-7529',9,'quam.pellentesque@yahoo.org',8,8,5),
  (150,'Nadine Chase','Bernard Barrett','Graham Tucker','(529) 456-6910',9,'adipiscing.lacus.ut@aol.com',8,8,5);
INSERT INTO [Students] (std_id,fname,lname,fathername,mobile_no,age,email,class_id,section_id,dep_id)
VALUES
  (151,'Conan Green','Prescott Benjamin','Brendan Wiggins','(630) 427-7805',10,'cras.interdum.nunc@google.com',8,8,5),
  (152,'Cara Page','Jermaine Wise','Davis Berry','(947) 255-0844',10,'ut@aol.edu',8,8,5),
  (153,'Zia Mcleod','Ava Marsh','Sarah Harmon','1-527-706-8414',10,'nonummy.ut.molestie@aol.couk',8,8,5),
  (154,'Ezra Lara','Sylvester Morales','Sasha Key','1-673-482-7117',10,'et@google.edu',8,8,5),
  (155,'Ray Walters','Paki Mcdaniel','Kerry Vasquez','1-684-372-1644',10,'eros.turpis.non@google.edu',8,8,5),
  (156,'Alexander Burch','Derek Warren','Abbot Mccarthy','(131) 641-3305',10,'id.risus@protonmail.edu',8,8,5),
  (157,'Ethan Lewis','Chloe Chen','Lydia Hanson','(423) 427-3144',10,'fringilla.cursus@icloud.net',8,8,5),
  (158,'Hannah Miller','Dai George','Bianca Shepherd','1-475-162-2292',10,'tincidunt.congue@google.net',8,8,5),
  (159,'Emi Cotton','Leandra Sykes','Serina Wynn','(889) 622-6836',10,'erat.volutpat@icloud.couk',8,8,5),
  (160,'Rhiannon Velez','Yoshi Cervantes','Shoshana Mason','1-661-622-0453',10,'in1@icloud.com',8,8,5);
INSERT INTO [Students] (std_id,fname,lname,fathername,mobile_no,age,email,class_id,section_id,dep_id)
VALUES
  (161,'George Mccoy','Maite Leon','Carlos Callahan','(161) 494-0865',10,'nam@aol.org',9,9,5),
  (162,'Keelie Parker','Craig Roth','Cheryl Kline','(227) 278-1451',10,'ligula@google.couk',9,9,5),
  (163,'Karleigh Beach','Britanni Ross','Neil Elliott','1-965-463-2115',10,'sapien@outlook.ca',9,9,5),
  (164,'Malcolm Sutton','Nasim Shaw','Brock Kelley','(124) 554-5758',10,'malesuada.id@protonmail.org',9,9,5),
  (165,'Brenna Rivas','Melyssa Collier','Glenna James','(471) 399-5843',10,'facilisi.sed.neque@aol.net',9,9,5),
  (166,'Debra Mccray','Nasim Henry','Justin Bass','1-356-946-9083',10,'sagittis.nullam@protonmail.net',9,9,5),
  (167,'Ruth Dean','Abel Henson','Abbot Moreno','1-763-485-9636',10,'posuere.vulputate@google.org',9,9,5),
  (168,'Aurelia Coleman','Kamal Gentry','Clare Gross','1-558-762-7789',10,'nec.euismod@icloud.org',9,9,5),
  (169,'Phelan Lee','Alan Perez','Garth Ware','1-702-523-9452',10,'metus.urna.convallis@icloud.org',9,9,5),
  (170,'Asher Mosley','Dominique Becker','Dacey Vaughan','1-839-129-6225',10,'posuere@hotmail.ca',9,9,5);
INSERT INTO [Students] (std_id,fname,lname,fathername,mobile_no,age,email,class_id,section_id,dep_id)
VALUES
  (171,'Dorothy Wells','Indigo Hahn','Brendan Goodwin','1-411-824-6564',10,'lorem.ut@aol.ca',9,9,5),
  (172,'Marcia Randall','Iliana Ballard','Heidi Briggs','(634) 772-2486',10,'curabitur@protonmail.com',9,9,5),
  (173,'Kenyon Wilder','Lois Rivas','Illiana Mcdaniel','1-510-540-7233',10,'mi@outlook.ca',9,9,5),
  (174,'Serina Lambert','Sybill Doyle','Merrill Maynard','(371) 527-7591',10,'iaculis.odio.nam@outlook.ca',9,9,5),
  (175,'Claudia Lott','Paki Davidson','Alan Smith','(831) 133-4597',10,'sem@aol.net',9,9,5),
  (176,'Lucy Estes','Fuller Vasquez','Simon Anderson','(567) 595-3752',10,'nibh@outlook.net',9,9,5),
  (177,'Dolan Raymond','Shana Solis','Evan Baker','1-888-486-7813',10,'et.malesuada@aol.org',9,9,5),
  (178,'Kaye Lang','Emily Marks','Merrill Hahn','(276) 536-9237',10,'vitae.velit@icloud.org',9,9,5),
  (179,'Malachi Hurley','Megan Carr','Alisa Summers','1-515-521-2239',10,'enim@icloud.net',9,9,5),
  (180,'Abraham Moore','Devin Moss','Ali Terry','(285) 717-9832',10,'tincidunt.dui@aol.couk',9,9,5);
INSERT INTO [Students] (std_id,fname,lname,fathername,mobile_no,age,email,class_id,section_id,dep_id)
VALUES
  (181,'Nigel Pruitt','Hayden Hoover','Stella Cole','(672) 814-3244',11,'hendrerit.a.arcu@protonmail.couk',10,10,5),
  (182,'Jessica Sweet','Sacha Leblanc','Piper Randall','(839) 326-0235',11,'dolor.sit@google.edu',10,10,5),
  (183,'Medge Huber','Lacota Donaldson','Aidan Santos','(658) 466-0231',11,'malesuada.fames@outlook.com',10,10,5),
  (184,'Chiquita William','Gary Valencia','Tatiana Fitzpatrick','1-646-437-4133',11,'quis.urna@aol.com',10,10,5),
  (185,'Marvin Bowers','Ivory Osborne','Whoopi Avila','(345) 932-5787',11,'elit.aliquam.auctor@hotmail.couk',10,10,5),
  (186,'Uriel Mills','Chaim Palmer','Illiana Villarreal','(679) 546-9275',11,'nonummy@icloud.edu',10,10,5),
  (187,'Ashton Dyer','Howard Velasquez','Salvador Knox','1-419-340-8969',11,'risus.donec@google.net',10,10,5),
  (188,'Laura Gross','Nadine Sawyer','Cyrus Mccullough','1-421-944-4733',11,'aenean@protonmail.org',10,10,5),
  (189,'Iona Morse','Barrett Kramer','Porter Bell','(888) 723-3845',11,'urna.nunc@hotmail.couk',10,10,5),
  (190,'Brynne Baker','Odysseus Branch','Keegan Bender','1-578-764-6564',11,'odio.etiam@aol.couk',10,10,5);
INSERT INTO [Students] (std_id,fname,lname,fathername,mobile_no,age,email,class_id,section_id,dep_id)
VALUES
  (191,'Carla Wolfe','Stone Hays','Wyatt Figueroa','(422) 348-7336',11,'metus.urna@yahoo.net',10,10,5),
  (192,'Amal Massey','Rhea Brennan','Mia Good','(715) 381-2381',11,'est.arcu@outlook.net',10,10,5),
  (193,'Kelly Guerrero','Keiko Witt','Selma Mooney','1-444-682-1751',11,'vitae.semper@hotmail.couk',10,10,5),
  (194,'Ingrid Snow','Rigel Marks','Dylan Rodriquez','1-377-361-2914',11,'magna.suspendisse@outlook.edu',10,10,5),
  (195,'Palmer Bailey','Hanae Savage','Driscoll Rivas','1-563-851-6654',11,'sagittis.felis.donec@icloud.net',10,10,5),
  (196,'Mari Kramer','Germaine Ray','Madison Case','(447) 333-7809',11,'elementum@outlook.net',10,10,5),
  (197,'Bell Mcintosh','Jin Mclean','Whoopi Morrow','1-119-466-6741',11,'duis.ac.arcu@icloud.org',10,10,5),
  (198,'Jillian Doyle','Lillith Cohen','Brett Shaw','(250) 624-3223',11,'nam@google.com',10,10,5),
  (199,'Amelia Weaver','Lesley Gutierrez','Richard Blackwell','(204) 813-7421',11,'eget@aol.couk',10,10,5),
  (200,'Tad Palmer','Stella Whitley','Isabelle Nicholson','(782) 712-6526',11,'molestie.orci@hotmail.edu',10,10,5);
INSERT INTO [Students] (std_id,fname,lname,fathername,mobile_no,age,email,class_id,section_id,dep_id)
VALUES
  (201,'Charlotte Tate','Brent Slater','Talon Rice','1-811-984-7752',11,'libero.nec@icloud.ca',11,11,5),
  (202,'Craig Sandoval','Whitney Knapp','Callum Meyer','1-732-379-1391',11,'in.molestie@hotmail.net',11,11,5),
  (203,'Ariel Mcpherson','Shelby Guerra','Leroy Burnett','1-710-116-6192',11,'cursus.et.eros@hotmail.couk',11,11,5),
  (204,'Arden Gould','Jocelyn Mitchell','Ahmed Stein','1-473-712-6465',11,'ac.turpis.egestas@icloud.net',11,11,5),
  (205,'Lane Conner','Ella Lamb','Miranda Hatfield','1-332-754-7508',11,'justo.eu.arcu@yahoo.couk',11,11,5),
  (206,'Yvonne Simon','Yvonne Hinton','Lester Le','(232) 779-7792',11,'et.ultrices@google.couk',11,11,5),
  (207,'Leo Gould','Athena Battle','Vivien Joyce','1-672-264-4242',11,'adipiscing@google.net',11,11,5),
  (208,'Quon Merrill','Hayley Hoover','Quin Brewer','1-665-452-4373',11,'nullam.nisl@google.net',11,11,5),
  (209,'Ifeoma Anthony','Shellie Rutledge','Jessamine Justice','1-349-556-7426',11,'non.dapibus@icloud.com',11,11,5),
  (210,'Kieran Greene','Sarah Cooley','Dacey Hess','1-421-770-8430',11,'vehicula.et@hotmail.com',11,11,5);
INSERT INTO [Students] (std_id,fname,lname,fathername,mobile_no,age,email,class_id,section_id,dep_id)
VALUES
  (211,'Veronica Vang','Debra Nieves','Carolyn Salas','1-914-608-6837',12,'quis.diam@icloud.couk',11,11,5),
  (212,'Rigel Cash','Lael Mueller','Wilma Valenzuela','(663) 476-2361',12,'arcu@aol.org',11,11,5),
  (213,'Shellie Higgins','Vaughan Ramsey','Troy Hicks','1-240-678-9173',12,'orci6@google.edu',11,11,5),
  (214,'Fuller Gilliam','Rooney Meyers','Phillip Henson','1-447-375-4610',12,'diam@aol.net',11,11,5),
  (215,'Isabella Lewis','Lesley Gallagher','Xavier Conley','1-687-791-1632',12,'cursus.nunc.mauris@aol.com',11,11,5),
  (216,'Dylan Fisher','Hadassah Emerson','Autumn Salas','1-325-991-2178',12,'odio.sagittis@yahoo.com',11,11,5),
  (217,'Isaiah Puckett','Anastasia Austin','Sigourney Moody','1-416-286-6813',12,'egestas@protonmail.org',11,11,5),
  (218,'Nell Bennett','Amela West','Leo Cameron','1-145-477-5123',12,'fusce.feugiat@outlook.edu',11,11,5),
  (219,'Demetrius Allison','Aaron Paul','Thaddeus Pugh','1-530-317-3490',12,'fringilla.est@aol.net',11,11,5),
  (220,'Cullen Greene','Carson Fry','Ronan Chandler','(377) 613-7962',12,'non.lacinia.at@icloud.org',11,11,5);
INSERT INTO [Students] (std_id,fname,lname,fathername,mobile_no,age,email,class_id,section_id,dep_id)
VALUES
  (221,'Drake Mcneil','Kyra Mann','Kasimir Terry','(415) 510-6278',12,'accumsan.sed@outlook.com',12,12,4),
  (222,'Avram Knox','Haley Dennis','Pascale Horton','(270) 777-8147',12,'felis@aol.net',12,12,4),
  (223,'Henry Payne','Unity Alford','Randall Montoya','1-706-585-1875',12,'faucibus.morbi@outlook.edu',12,12,4),
  (224,'Zahir Sharp','Madonna Craig','Tanya Gonzales','(312) 673-0566',12,'vel@aol.ca',12,12,4),
  (225,'Brendan Burch','Brock Welch','Gisela Solis','(206) 906-3869',12,'eros.nec@protonmail.ca',12,12,4),
  (226,'Hillary Riddle','Timothy Head','Giacomo Marshall','1-247-854-7880',12,'ornare.lectus.ante@icloud.couk',12,12,4),
  (227,'Serena Meadows','Delilah Booth','Reece Bray','1-470-255-6657',12,'proin.sed.turpis@hotmail.org',12,12,4),
  (228,'Armando Lopez','Glenna Chaney','Kirk Leach','(498) 406-8110',12,'id@protonmail.net',12,12,4),
  (229,'Daniel Potter','Francesca Mejia','Lance Small','1-307-663-4232',12,'odio.auctor@aol.org',12,12,4),
  (230,'Katell Jimenez','Tashya Leon','Drake Leach','(551) 640-8214',12,'quisque.nonummy@icloud.ca',12,12,4);
INSERT INTO [Students] (std_id,fname,lname,fathername,mobile_no,age,email,class_id,section_id,dep_id)
VALUES
  (231,'Vielka Richmond','Fiona Sloan','Mason Allen','(724) 770-7777',12,'dolor@outlook.com',12,12,4),
  (232,'Ryan Ratliff','Blake Mercer','Shelby Price','1-895-417-0553',12,'vitae.sodales@yahoo.ca',12,12,4),
  (233,'Ivan Mcbride','Noelani Rosario','Gavin Valdez','1-923-197-7718',12,'ipsum.primis@protonmail.org',12,12,4),
  (234,'Paloma Fitzgerald','Cedric Gonzales','Zia Workman','(753) 243-1021',12,'velit.pellentesque@aol.edu',12,12,4),
  (235,'Hiroko Dorsey','Brianna Fowler','Ronan Spears','1-538-281-4862',12,'erat.vel.pede@protonmail.com',12,12,4),
  (236,'Hasad Robles','Celeste Branch','Jamalia Silva','(632) 821-2775',12,'donec.nibh@icloud.org',12,12,4),
  (237,'Jessamine Wiley','Aidan Hill','Steel Stark','1-862-263-6473',12,'massa.lobortis@yahoo.com',12,12,4),
  (238,'Raven Estes','Elaine Morris','Xena Medina','1-174-947-8312',12,'ligula.nullam.feugiat@outlook.edu',12,12,4),
  (239,'Kyla Elliott','Jacqueline Pearson','Deborah Gregory','(218) 382-3954',12,'nonummy@yahoo.edu',12,12,4),
  (240,'Brynne Williamson','Flavia White','Carolyn Meyer','1-116-853-1271',12,'ornare.placerat@aol.couk',12,12,4);
INSERT INTO [Students] (std_id,fname,lname,fathername,mobile_no,age,email,class_id,section_id,dep_id)
VALUES
  (241,'Peter Serrano','Amethyst Aguirre','Carson Graves','(466) 613-4242',13,'et@hotmail.couk',19,13,4),
  (242,'Omar Vasquez','Rhona Saunders','Deanna Kerr','(593) 781-5874',13,'phasellus.nulla@aol.net',19,13,4),
  (243,'Felicia Quinn','Nicholas Ratliff','Kadeem Baxter','1-425-341-7786',13,'nascetur.ridiculus@outlook.com',19,13,4),
  (244,'Rhona Peters','Juliet Navarro','Tanisha Larsen','(781) 569-8880',13,'nisl.arcu.iaculis@protonmail.couk',19,13,4),
  (245,'Orlando Norris','Kennedy Jarvis','Basil Cash','1-746-747-7418',13,'fermentum.vel@yahoo.ca',19,13,4),
  (246,'Dale Moody','Henry Lowery','Britanni Frazier','(872) 814-2781',13,'ligula.elit@yahoo.ca',19,13,4),
  (247,'Seth Riley','Ali Ray','Gloria Valentine','1-779-430-5220',13,'tincidunt@google.org',19,13,4),
  (248,'Kyra Farley','Emmanuel George','Kennan Whitney','(938) 415-7546',13,'elit.nulla.facilisi@google.com',19,13,4),
  (249,'Caleb Haynes','Griffith Byrd','Marvin Eaton','(667) 632-5585',13,'suspendisse.ac@outlook.ca',19,13,4),
  (250,'Chancellor Lawrence','Wynne Dodson','Leandra Ramsey','1-585-588-7666',13,'amet.dapibus@icloud.ca',19,13,4);
INSERT INTO [Students] (std_id,fname,lname,fathername,mobile_no,age,email,class_id,section_id,dep_id)
VALUES
  (251,'Remedios Romero','Urielle Hammond','Nathan David','(928) 797-5369',13,'cras.sed.leo@yahoo.ca',19,13,4),
  (252,'Merritt Salas','Ivan Cameron','Avye Burch','1-818-458-1351',13,'consectetuer@hotmail.org',19,13,4),
  (253,'Kiona Flynn','Justin Haley','Sonia Cameron','1-250-252-8017',13,'dictum.eleifend@protonmail.edu',19,13,4),
  (254,'Montana Silva','Josephine Hughes','Tallulah Summers','1-625-827-8628',13,'vel@icloud.net',19,13,4),
  (255,'Charles Sargent','Georgia Duran','Hanna Stein','1-806-953-8522',13,'nec.ante.maecenas@hotmail.couk',19,13,4),
  (256,'Hilda Rutledge','Gannon Cruz','William Woods','1-728-664-8105',13,'elit.elit@aol.couk',19,13,4),
  (257,'Desirae Pace','Illana Gentry','Patricia Monroe','1-836-742-2152',13,'ut.tincidunt@yahoo.org',19,13,4),
  (258,'Calista Guerra','Joy Cote','Caryn Morris','1-323-796-8237',13,'nam.consequat@hotmail.org',19,13,4),
  (259,'Wilma Mcgowan','Nicole Page','Martina Gutierrez','(454) 872-3868',13,'malesuada.fringilla@protonmail.com',19,13,4),
  (260,'Xandra Williams','Jelani Knight','Hashim Lynn','(832) 261-4389',13,'ligula.eu@google.net',19,13,4);
INSERT INTO [Students] (std_id,fname,lname,fathername,mobile_no,age,email,class_id,section_id,dep_id)
VALUES
  (261,'Josephine Key','Emma Hoffman','Nehru Wolfe','(218) 703-4629',13,'integer.eu@google.com',14,14,3),
  (262,'Remedios Cochran','Joelle Strickland','Kaseem Schultz','(722) 718-7654',13,'augue.scelerisque.mollis@protonmail.com',14,14,3),
  (263,'Kyle Daugherty','Raja Whitaker','Isaac Rose','(396) 818-4582',13,'sed.leo@hotmail.com',14,14,3),
  (264,'Indira Hansen','Judith Morse','Juliet Potter','(597) 702-2896',13,'dignissim.maecenas@google.com',14,14,3),
  (265,'Dora Adams','Shannon Chaney','Amena Douglas','(861) 222-5682',13,'tempus.lorem@hotmail.org',14,14,3),
  (266,'Elizabeth Santos','Maite Dickerson','Hannah Colon','1-548-263-7016',13,'tristique.pharetra.quisque@google.couk',14,14,3),
  (267,'Emery Bradford','Jaquelyn Sanchez','Abdul Gordon','(258) 423-3130',13,'arcu.vestibulum@outlook.edu',14,14,3),
  (268,'Oren Chase','Seth Hardy','Donovan Mcleod','(784) 229-5266',13,'suspendisse.non.leo@hotmail.couk',14,14,3),
  (269,'Justine Fisher','Amaya Peters','Joelle Lawrence','(193) 556-7226',13,'tellus@protonmail.org',14,14,3),
  (270,'Felicia Griffin','Lucas Kerr','Ross Glass','(646) 232-4252',13,'primis.in@google.couk',14,14,3);
INSERT INTO [Students] (std_id,fname,lname,fathername,mobile_no,age,email,class_id,section_id,dep_id)
VALUES
  (271,'Clark Hardy','Roth Roman','Bryar Slater','(636) 422-6815',14,'mauris.erat@icloud.org',14,14,3),
  (272,'Xander Moon','Burton Parsons','Jackson Hays','1-328-714-6164',14,'magna.nec@google.net',14,14,3),
  (273,'Hunter Landry','Libby Everett','Liberty Chen','1-748-755-1447',14,'mauris.ut.quam@outlook.couk',14,14,3),
  (274,'Quon Ramirez','Stone Dyer','Graham Cameron','(734) 188-1053',14,'porttitor.scelerisque.neque@google.couk',14,14,3),
  (275,'Edan Gomez','Odette Nichols','Kiayada Ortega','(753) 758-3103',14,'sollicitudin@aol.ca',14,14,3),
  (276,'Azalia Higgins','Kiona Mcfarland','Blake Mclean','1-469-674-8337',14,'commodo@yahoo.net',14,14,3),
  (277,'Avram Jenkins','Lucian Stark','Breanna Woodard','(880) 631-6338',14,'vestibulum.lorem@yahoo.com',14,14,3),
  (278,'Honorato Holden','Alfonso Levine','Echo Alford','1-796-524-3183',14,'phasellus.in@protonmail.org',14,14,3),
  (279,'Otto Fowler','Griffith Nolan','Priscilla Gill','1-215-234-4085',14,'erat.eget.tincidunt@aol.net',14,14,3),
  (280,'Pascale Vance','Gannon Galloway','Armand Spears','1-854-932-2466',14,'consectetuer@aol.com',14,14,3);
INSERT INTO [Students] (std_id,fname,lname,fathername,mobile_no,age,email,class_id,section_id,dep_id)
VALUES
  (281,'Shea Dennis','Skyler Key','Daryl Duffy','(839) 768-6116',14,'interdum.curabitur@aol.edu',15,15,3),
  (282,'Rigel Reese','Marsden Andrews','Madeson Carter','(804) 543-2647',14,'pede.suspendisse@protonmail.couk',15,15,3),
  (283,'Felicia Campbell','Kadeem Mccray','Winter Dunn','(457) 431-4658',14,'fames.ac@yahoo.net',15,15,3),
  (284,'Phyllis French','Gareth Bush','Iola Mccoy','(124) 791-6925',14,'lacinia@hotmail.edu',15,15,3),
  (285,'Gay Espinoza','Ann Andrews','Vance Mullen','1-234-248-3446',14,'nullam.feugiat@hotmail.edu',15,15,3),
  (286,'Yoko Daniels','Bo Chan','Cecilia Tyler','1-355-131-4811',14,'accumsan.laoreet.ipsum@icloud.net',15,15,3),
  (287,'Violet Morris','Finn Rowe','Vincent Berg','1-348-371-2144',14,'ultrices.sit@google.com',15,15,3),
  (288,'Flynn Mcintosh','Emerson Le','Margaret Dotson','(489) 650-3866',14,'ante@protonmail.org',15,15,3),
  (289,'Griffin Delaney','Melodie Lucas','Lee Craft','1-887-511-2948',14,'magna.sed@yahoo.org',15,15,3),
  (290,'Robert Hensley','Jonah Kennedy','Gay Haynes','(726) 494-8222',14,'phasellus.in@hotmail.couk',15,15,3);
INSERT INTO [Students] (std_id,fname,lname,fathername,mobile_no,age,email,class_id,section_id,dep_id)
VALUES
  (291,'Petra Berry','Emily Anthony','Irma Leblanc','1-170-974-5624',14,'neque.tellus@google.org',15,15,3),
  (292,'Felicia Hull','Leila Luna','Inez Bird','1-502-747-4933',14,'eget.nisi.dictum@aol.ca',15,15,3),
  (293,'Paki Mcconnell','Alisa Fischer','Wanda Williams','(689) 914-5816',14,'class@icloud.ca',15,15,3),
  (294,'Maite Vazquez','Yolanda Owens','Rinah Mathews','1-546-307-3562',14,'eget.ipsum@icloud.com',15,15,3),
  (295,'Lacy Carpenter','Montana Patterson','Rashad Hill','(504) 240-7291',14,'malesuada.vel@icloud.couk',15,15,3),
  (296,'Portia Bray','Brynne Palmer','Jaquelyn Mills','1-377-145-2681',14,'vitae.orci2@google.edu',15,15,4),
  (297,'Cyrus Maxwell','Kerry Solomon','Athena Maynard','1-414-337-2451',14,'convallis.convallis.dolor@google.org',15,15,3),
  (298,'Nichole Baldwin','Kirestin Nelson','Cally Hopper','(287) 476-7714',14,'egestas.rhoncus@protonmail.com',15,15,3),
  (299,'Jasmine Edwards','Geoffrey Gallagher','Camille Cantrell','1-411-814-3259',14,'mattis.velit@protonmail.org',15,15,3),
  (300,'Walker Mckinney','Sonya Holmes','Laura Lott','1-128-828-1014',14,'donec.porttitor@aol.com',15,15,3);
INSERT INTO [Students] (std_id,fname,lname,fathername,mobile_no,age,email,class_id,section_id,dep_id)
VALUES
  (301,'Amir Mcmillan','Vincent Russo','Risa Phillips','1-348-287-3161',15,'nec@hotmail.org',16,16,2),
  (302,'Celeste Rodgers','Elijah Jones','Alma Woodard','(282) 544-8763',15,'amet.lorem@yahoo.edu',16,16,2),
  (303,'Darius Patel','Hashim Anthony','Zachary Rocha','1-434-868-1255',15,'tincidunt.nunc@outlook.couk',16,16,2),
  (304,'Vaughan York','Anastasia Perkins','Victor Espinoza','(466) 952-3375',15,'per.conubia@icloud.com',16,16,2),
  (305,'Jael Bender','Jordan Rush','Mannix Rodgers','1-488-587-6243',15,'donec.tempor@outlook.ca',16,16,4),
  (306,'Nomlanga Good','Chantale Crawford','Alma Noble','(581) 383-1127',15,'scelerisque.scelerisque.dui@protonmail.com',16,16,2),
  (307,'Thane Rowe','Stacy Bishop','Dominique Harrison','(911) 633-6963',15,'lorem@google.org',16,16,2),
  (308,'Richard Hopkins','Kennedy Powers','Basil Gould','1-538-818-1232',15,'augue.id@yahoo.org',16,16,2),
  (309,'Chelsea O''donnell','Lucas Booker','Owen Farley','(547) 346-2013',15,'adipiscing.lacus.ut@hotmail.edu',16,16,2),
  (310,'Nicholas Sloan','Travis Jackson','Lesley English','(839) 427-6257',15,'in@hotmail.edu',16,16,2);
INSERT INTO [Students] (std_id,fname,lname,fathername,mobile_no,age,email,class_id,section_id,dep_id)
VALUES
  (311,'Savannah Mayo','Tanya York','Brett Walton','1-981-458-7024',15,'porttitor.eros@icloud.net',16,16,2),
  (312,'Xena Gonzalez','Beverly Fitzgerald','Abraham Trujillo','1-717-425-5624',15,'dui@icloud.edu',16,16,2),
  (313,'Carissa Rivas','Lyle Farrell','Tasha Henry','1-627-442-2288',15,'varius@google.org',16,16,2),
  (314,'Forrest Morris','Macaulay Davenport','Deirdre Mccarthy','1-933-554-5737',15,'lacus.ut.nec@protonmail.net',16,16,2),
  (315,'Garrett Wood','Barry Hewitt','Wyoming Rios','(633) 467-2691',15,'bibendum.ullamcorper@hotmail.edu',16,16,2),
  (316,'Hasad Frost','Ronan Sherman','Jana Ferrell','(385) 341-6883',15,'lacus.vestibulum@aol.org',16,16,2),
  (317,'Alexandra Mcpherson','Kermit Page','Roary Bruce','1-837-152-8395',15,'urna@protonmail.edu',16,16,2),
  (318,'Gray Sosa','Shay Barr','Haviva Skinner','1-850-614-8874',15,'risus.morbi@hotmail.net',16,16,2),
  (319,'Mohammad Eaton','Alice Vaughan','Miriam Stevenson','(588) 720-6884',15,'in.condimentum.donec@protonmail.couk',16,16,2),
  (320,'Brenden Love','Reese Henry','Rahim Pitts','(932) 625-7315',15,'semper.erat@aol.edu',16,16,2);
INSERT INTO [Students] (std_id,fname,lname,fathername,mobile_no,age,email,class_id,section_id,dep_id)
VALUES
  (321,'Shea Burris','Louis Payne','Olivia Briggs','(518) 698-1318',15,'sed@icloud.com',17,17,2),
  (322,'Rina Holder','Renee Dunlap','Reuben Mcmahon','(567) 972-6461',15,'ipsum.non@hotmail.edu',17,17,2),
  (323,'Rashad Weeks','Adele Mckenzie','Quinn Gamble','(972) 967-0540',15,'consequat@outlook.couk',17,17,2),
  (324,'Xander Buckner','Jameson Bowman','Phelan Herring','(528) 358-6523',15,'cursus.nunc@hotmail.com',17,17,2),
  (325,'Kalia Hamilton','Igor Blackburn','Aline Guerrero','(727) 479-6817',15,'et.libero@hotmail.org',17,17,2),
  (326,'Neville Aguirre','Tasha Conley','Shea Meadows','1-974-949-6962',15,'phasellus@hotmail.net',17,17,2),
  (327,'Signe Yates','Rafael Leblanc','Jonas West','(231) 638-1666',15,'vel.mauris.integer@icloud.edu',17,17,2),
  (328,'Robin Mclaughlin','Kevyn Carson','Ivy Young','(577) 524-7732',15,'a.nunc@icloud.com',17,17,2),
  (329,'Forrest Huber','Rahim Sawyer','Brianna Mccoy','(636) 875-5624',15,'amet.diam@google.org',17,17,2),
  (330,'Todd Estrada','Angela Flowers','Nero Mcdaniel','1-327-668-1358',15,'mollis.non.cursus@aol.org',17,17,2);
INSERT INTO [Students] (std_id,fname,lname,fathername,mobile_no,age,email,class_id,section_id,dep_id)
VALUES
  (331,'Cairo Tyler','Libby Burris','Fitzgerald Pennington','(356) 281-0141',16,'volutpat@aol.com',17,17,2),
  (332,'Kibo George','Boris Peterson','Jerry Lindsey','1-640-670-4396',16,'feugiat.non.lobortis@protonmail.net',17,17,2),
  (333,'Dalton Duran','Joseph Riley','Vivien Cohen','1-745-681-0495',16,'cursus.in.hendrerit@protonmail.edu',17,17,2),
  (334,'Hiroko Rivers','Xenos Johns','Galvin Mclean','1-347-812-7975',16,'dolor.sit@google.net',17,17,2),
  (335,'Kimberly Love','Veronica Sanchez','Tatum Walker','(908) 536-4826',16,'morbi.accumsan.laoreet@outlook.couk',17,17,2),
  (336,'Zahir Hill','Hayley Burris','Kareem Walker','(212) 564-0563',16,'sed.dictum@yahoo.edu',17,17,2),
  (337,'Veronica Harmon','Ariel Powers','Chantale Mcgee','1-287-547-1124',16,'sed.nunc@yahoo.com',17,17,2),
  (338,'Keely Stokes','Emily Nelson','Galvin Wilkinson','1-358-416-3044',16,'erat@yahoo.edu',17,17,2),
  (339,'Abbot Roy','Alec Schultz','Warren Fulton','(563) 418-1780',16,'mattis.semper@google.org',17,17,2),
  (340,'Rudyard Flowers','Victor Vance','Jason Tucker','(713) 744-8884',16,'tortor.integer@yahoo.edu',17,17,2);
INSERT INTO [Students] (std_id,fname,lname,fathername,mobile_no,age,email,class_id,section_id,dep_id)
VALUES
  (341,'Colin Stafford','Deanna Gilmore','Keiko Strickland','1-446-855-3483',16,'ac.ipsum@icloud.ca',18,18,1),
  (342,'Craig Snow','William Acevedo','Daniel Tillman','1-321-231-9167',16,'sed.leo@aol.org',18,18,1),
  (343,'Amanda Osborne','Ezra Hurley','Mohammad Barber','1-226-475-6246',16,'dictum@yahoo.com',18,18,1),
  (344,'Ignacia Bowers','Cara Ayala','Philip Puckett','(533) 835-5736',16,'id@aol.couk',18,18,1),
  (345,'Callie Bentley','Mallory Norton','Melinda Meyers','1-324-387-5878',16,'aliquet.lobortis.nisi@yahoo.com',18,18,1),
  (346,'Jolene Strong','Guinevere Payne','Zena Charles','1-371-806-3384',16,'nibh.enim.gravida@yahoo.org',18,18,1),
  (347,'Holly O''connor','Wyatt Schwartz','Megan Boyle','1-876-778-5285',16,'ipsum@aol.couk',18,18,1),
  (348,'Vanna O''donnell','Daphne Gentry','Garrison Allen','(227) 419-6634',16,'mauris.eu@yahoo.net',18,18,1),
  (349,'Tiger Boyd','Tatyana Wilkins','Tara Cervantes','1-827-665-3506',16,'est.ac@google.org',18,18,1),
  (350,'Travis Mercer','Martin Hays','Sheila Gonzales','1-783-563-5831',16,'condimentum.eget.volutpat@icloud.edu',18,18,1);
INSERT INTO [Students] (std_id,fname,lname,fathername,mobile_no,age,email,class_id,section_id,dep_id)
VALUES
  (351,'Maite Leon','Perry Taylor','Jennifer Roach','1-823-346-2781',16,'faucibus.ut@protonmail.couk',18,18,1),
  (352,'Maggie Roy','Astra Rush','Andrew Tyler','1-930-645-1145',16,'ac.mi@yahoo.com',18,18,1),
  (353,'Baxter Shepard','Ori Guzman','Zia Hubbard','1-718-530-5840',16,'vestibulum@protonmail.edu',18,18,1),
  (354,'Preston England','Dennis Wolf','Larissa Flores','1-748-440-5156',16,'dapibus.rutrum@outlook.couk',18,18,1),
  (355,'Debra Reese','Vance Rojas','Kaseem Ross','(840) 157-6137',16,'nunc@hotmail.org',18,18,1),
  (356,'Holly Knight','Sybil Schultz','Oscar Reyes','(216) 583-2731',16,'libero@icloud.org',18,18,1),
  (357,'Rebecca Dunlap','Orson Mooney','Jessamine Downs','(171) 673-7212',16,'a@yahoo.edu',18,18,1),
  (358,'Jerome Guerra','Melvin Delaney','Nayda Dominguez','1-142-707-9838',16,'aliquam@icloud.com',18,18,1),
  (359,'Cecilia Delacruz','Harlan Shannon','Abel Brewer','(837) 333-5164',16,'id.risus@icloud.net',18,18,1),
  (360,'Plato Farrell','Andrew Pierce','Madeson O''connor','1-648-758-6127',16,'orci1@google.edu',18,18,1);
INSERT INTO [Students] (std_id,fname,lname,fathername,mobile_no,age,email,class_id,section_id,dep_id)
VALUES
  (361,'Brody Finley','Valentine Morton','Nyssa Rowe','(695) 550-9621',17,'montes.nascetur.ridiculus@yahoo.org',19,19,1),
  (362,'Paloma Soto','Channing Baxter','Charde Burke','(667) 257-7513',17,'eget.metus@icloud.edu',19,19,1),
  (363,'Whilemina Terrell','Pamela Bennett','Gloria Klein','(456) 461-3365',17,'curabitur.dictum@aol.com',19,19,1),
  (364,'Nyssa Wright','Sophia Wright','Alexis Sherman','1-267-877-6737',17,'lectus.pede.et@outlook.edu',19,19,1),
  (365,'Akeem Holder','Melodie Johns','Angela Hebert','1-888-526-8474',17,'nunc@hotmail.ca',19,19,1),
  (366,'Warren Key','Randall Kirk','Kenyon Bowers','(191) 350-4330',17,'mi@aol.com',19,19,1),
  (367,'Justine Herrera','Idona Goff','Halee Bradshaw','(633) 256-0143',17,'morbi@google.com',19,19,1),
  (368,'Chase Medina','Bree Mcmahon','Leandra Bernard','(833) 456-6828',17,'pharetra.ut@google.ca',19,19,1),
  (369,'Kameko Tate','Julian Evans','Graham Wright','(725) 677-2241',17,'neque.vitae@hotmail.ca',19,19,1),
  (370,'Brody Banks','Jenna Harding','Montana Mcdaniel','(656) 854-3275',17,'interdum.curabitur@hotmail.edu',19,19,1);
INSERT INTO [Students] (std_id,fname,lname,fathername,mobile_no,age,email,class_id,section_id,dep_id)
VALUES
  (371,'Samantha Castro','Lionel Schwartz','Stuart Nieves','(885) 454-6635',17,'ultrices.posuere@outlook.edu',19,19,1),
  (372,'Urielle Lowe','Lilah Eaton','Echo Murphy','1-770-648-1700',17,'sollicitudin.orci@google.net',19,19,1),
  (373,'Yvonne Osborne','Daria Stafford','Beck Rodriguez','1-283-685-4924',17,'enim.etiam@yahoo.net',19,19,1),
  (374,'Vera Floyd','Norman Jarvis','Dora Wade','(201) 319-8706',17,'ut.erat.sed@hotmail.com',19,19,1),
  (375,'Linda Kirby','Kaitlin Mcfarland','Kevyn Castro','1-214-525-8293',17,'a.dui@protonmail.net',19,19,1),
  (376,'Dacey Browning','Anika Floyd','Carl Hansen','(297) 323-7133',17,'imperdiet.non@aol.net',19,19,1),
  (377,'Hyatt Bishop','Blake Sanchez','Lynn Meyer','1-491-218-1967',17,'ut.nec.urna@hotmail.edu',19,19,1),
  (378,'Kai Cunningham','Tatum Cannon','Brynne Hogan','1-558-833-7353',17,'dolor.donec.fringilla@protonmail.net',19,19,1),
  (379,'Forrest Drake','Dorothy Ramirez','Giselle Warren','(220) 663-5789',17,'quis.diam.luctus@google.org',19,19,1),
  (380,'Drew Dillard','Stone Haney','Stephanie Garrett','1-455-299-3032',17,'augue.id.ante@hotmail.couk',19,19,1);



  --StudentAdress
  INSERT INTO [StudentAdress] (address_id,address,city,zipcode,std_id)
VALUES
  (1,'Ap #301-4972 Pretium St.','Istmina','600010',1),
  (2,'P.O. Box 561, 7651 Neque Avenue','Enna','19056',2),
  (3,'511-3057 Sed Rd.','Kuşadası','687389',3),
  (4,'583-9220 Amet Avenue','Keumiee','372421',4),
  (5,'Ap #607-405 Vel Avenue','Cork','316948',5),
  (6,'5549 Amet, Av.','Geraldton-Greenough','663170',6),
  (7,'Ap #665-9229 Magnis St.','Vladimir','577858',7),
  (8,'Ap #386-4606 Nulla St.','Melton','424237',8),
  (9,'Ap #992-7110 Ipsum Street','Bastia','7792',9),
  (10,'P.O. Box 525, 5122 Dictum. Road','Aurillac','13764-823',10);
INSERT INTO [StudentAdress] (address_id,address,city,zipcode,std_id)
VALUES
  (11,'769 Lectus Rd.','Fort William','22833',11),
  (12,'522-7082 Phasellus Ave','Canberra','20365',12),
  (13,'461-4892 Quam, Rd.','Guápiles','344382',13),
  (14,'667-5027 Ullamcorper. Street','Yogyakarta','3792',14),
  (15,'438-8991 Egestas Rd.','North Shore','S8P 1Y8',15),
  (16,'9568 Enim. St.','Belfast','98-48',16),
  (17,'Ap #604-6784 Metus. Rd.','Baguio','573112',17),
  (18,'1806 Imperdiet St.','Hubei','38166',18),
  (19,'397-3393 Fames St.','Jönköping','51512',19),
  (20,'9654 Molestie St.','Ceuta','436833',20);
INSERT INTO [StudentAdress] (address_id,address,city,zipcode,std_id)
VALUES
  (21,'Ap #942-4915 Fusce Street','Yurimaguas','LJ8J 3RJ',21),
  (22,'788-3981 Sed, Ave','Ergani','76227',22),
  (23,'Ap #717-3810 Neque. Road','Juiz de Fora','399724',23),
  (24,'Ap #592-7202 Lorem St.','Lumaco','7549',24),
  (25,'P.O. Box 227, 7870 Odio. St.','Ciudad Victoria','309162',25),
  (26,'125-2820 Tellus. Avenue','El Salvador','5945-9964',26),
  (27,'932-1964 Senectus Rd.','San Damiano al Colle','13366',27),
  (28,'4304 Nec, Avenue','Elmshorn','2801',28),
  (29,'Ap #995-6419 Ornare. Rd.','Macklin','58386-758',29),
  (30,'Ap #222-6002 Nisl. Av.','Ferrandina','41512',30);
INSERT INTO [StudentAdress] (address_id,address,city,zipcode,std_id)
VALUES
  (31,'651-117 Penatibus Ave','Ghizer','6436-2938',31),
  (32,'Ap #308-7498 Metus. St.','Whitehaven','96556',32),
  (33,'Ap #716-3285 Tortor. Rd.','Mielec','639088',33),
  (34,'Ap #202-4188 Libero Ave','Lleida','24639',34),
  (35,'Ap #124-6713 Ridiculus Street','Lambayeque','81323-79568',35),
  (36,'739-7000 Sit St.','Hamilton','15483',36),
  (37,'1908 Nec Street','Darwin','766264',37),
  (38,'Ap #688-293 Cras Avenue','Namsos','9317',38),
  (39,'361-631 Vel St.','Jilin','565478',39),
  (40,'1998 Proin Road','Galway','51308',40);
INSERT INTO [StudentAdress] (address_id,address,city,zipcode,std_id)
VALUES
  (41,'Ap #176-9023 Dolor Road','Ørsta','12-905',41),
  (42,'593-7920 Quis Road','Galway','68655',42),
  (43,'P.O. Box 686, 3418 Neque Av.','Beijing','83776',43),
  (44,'Ap #777-5495 Pellentesque Street','Limón (Puerto Limón]','427746',44),
  (45,'P.O. Box 137, 3458 Proin Rd.','Gaziantep','2326-4621',45),
  (46,'Ap #409-5721 Cursus Street','Sembawang','935726',46),
  (47,'Ap #191-2816 At St.','Belfast','52-324',47),
  (48,'Ap #923-4957 Montes, Street','Punggol','381308',48),
  (49,'150-5519 Vestibulum St.','Lebowakgomo','4662-3940',49),
  (50,'906-794 Mauris St.','Cochrane','G9X 0L3',50);
INSERT INTO [StudentAdress] (address_id,address,city,zipcode,std_id)
VALUES
  (51,'501-2712 Eu, Street','Mjölby','4454',51),
  (52,'7285 Mollis. Rd.','Kapfenberg','9147',52),
  (53,'398-607 Sem Avenue','Cassano Spinola','51265-79731',53),
  (54,'337-3077 Mauris Street','Liaoning','732631',54),
  (55,'4480 Sed Rd.','Idar-Oberstei','58828',55),
  (56,'684-6499 Integer Av.','Cork','431856',56),
  (57,'4150 Pellentesque Av.','Barranquilla','W0L 3C7',57),
  (58,'424-4065 Lorem, St.','Guizhou','W7U 5LY',58),
  (59,'P.O. Box 642, 517 Cum Street','Laoag','46802',59),
  (60,'800-9738 Sagittis Rd.','Berlin','1311',60);
INSERT INTO [StudentAdress] (address_id,address,city,zipcode,std_id)
VALUES
  (61,'3586 Urna. Road','Quesada','449550',61),
  (62,'352-9171 Dolor. Av.','Hạ Long','8627',62),
  (63,'Ap #297-5548 Lacinia Ave','Hattian Bala','D38 0JG',63),
  (64,'P.O. Box 261, 6693 Lectus. Rd.','Gwadar','727426',64),
  (65,'Ap #172-6230 Mi Rd.','Borongan','4291',65),
  (66,'P.O. Box 735, 9002 Varius Av.','Opole','6758',66),
  (67,'9078 Tellus Avenue','Liberia','12604',67),
  (68,'9049 Duis St.','Belfast','5718 RD',68),
  (69,'378-6181 Et Road','Manaure','7778',69),
  (70,'P.O. Box 202, 9692 Amet Ave','Kalush','498308',70);
INSERT INTO [StudentAdress] (address_id,address,city,zipcode,std_id)
VALUES
  (71,'Ap #975-9947 Quis, Street','Skardu','36764',71),
  (72,'4424 Primis St.','Shimla','2570 QZ',72),
  (73,'6080 Malesuada St.','Ang Mo Kio','41734-65413',73),
  (74,'109-9615 At Av.','Sibasa','797585',74),
  (75,'615-5357 Luctus Ave','Yurimaguas','6908 DY',75),
  (76,'716-3842 Erat Rd.','Landeck','28246-57446',76),
  (77,'543-5062 Aliquam, Rd.','Lutsk','61618',77),
  (78,'945-4835 Sagittis Av.','Castelló','727557',78),
  (79,'Ap #660-4712 Urna, Avenue','Nghĩa Lộ','7537',79),
  (80,'Ap #963-5121 Cras Ave','Pangkalpinang','3727',80);
INSERT INTO [StudentAdress] (address_id,address,city,zipcode,std_id)
VALUES
  (81,'Ap #349-2081 Nascetur Rd.','Nova Kakhovka','4645',81),
  (82,'9561 In Avenue','Apartadó','287281',82),
  (83,'Ap #609-4942 Ultricies Av.','Volda','70295',83),
  (84,'P.O. Box 445, 5656 Taciti Ave','Redruth','665023',84),
  (85,'P.O. Box 137, 8229 Cras Av.','Palembang','17291',85),
  (86,'336-513 Adipiscing Rd.','Ligao','4763',86),
  (87,'P.O. Box 796, 7996 Magna Street','Cork','17-854',87),
  (88,'Ap #477-9204 Elit. Street','Barrow-in-Furness','862448',88),
  (89,'Ap #649-5922 Arcu St.','Canberra','156981',89),
  (90,'161-4105 Ante. Av.','Vĩnh Tường','84445',90);
INSERT INTO [StudentAdress] (address_id,address,city,zipcode,std_id)
VALUES
  (91,'518-3543 Vel Ave','Opole','16636-17835',91),
  (92,'453-4004 Integer Street','Castelseprio','59-76',92),
  (93,'Ap #968-9904 Aliquet Rd.','Mérida','544846',93),
  (94,'302-9514 Auctor St.','Đồng Hới','1555',94),
  (95,'178-9972 Mi, Ave','Bad Ischl','103657',95),
  (96,'496 Eget, Rd.','Bauchi','663289',96),
  (97,'P.O. Box 377, 3205 Nisi St.','Falun','575992',97),
  (98,'Ap #379-6989 Non Rd.','Słupsk','457947',98),
  (99,'144 Facilisis Street','Oaxaca','972355',99),
  (100,'3533 Amet, Ave','Mộc Châu','641243',100);
INSERT INTO [StudentAdress] (address_id,address,city,zipcode,std_id)
VALUES
  (101,'P.O. Box 892, 776 Dictum. Ave','Linköping','72792-90901',101),
  (102,'P.O. Box 801, 5356 Pede, Road','Đông Hà','7536',102),
  (103,'9872 Ultricies Street','Kemerovo','46985',103),
  (104,'375-7432 Sed Avenue','Detroit','682179',104),
  (105,'9370 Massa Av.','Hallein','29-75',105),
  (106,'Ap #589-2918 Sapien St.','Klagenfurt','30403',106),
  (107,'P.O. Box 356, 6731 Amet, St.','Hoorn','435867',107),
  (108,'P.O. Box 324, 7594 Dictum St.','Creil','25-95',108),
  (109,'Ap #735-9275 Dictum. Rd.','Colombes','W2H 8C1',109),
  (110,'Ap #536-8033 Tristique Rd.','Chimbote','28809-76623',110);
INSERT INTO [StudentAdress] (address_id,address,city,zipcode,std_id)
VALUES
  (111,'Ap #117-7244 Magna St.','San Diego','G1 8UN',111),
  (112,'Ap #478-3320 Non Av.','Curitiba','804807',112),
  (113,'8070 Scelerisque Rd.','Mglin','2336-4565',113),
  (114,'5830 Metus. Ave','Chongqing','5835',114),
  (115,'399-8910 Tortor Rd.','Lochranza','08724',115),
  (116,'280-9830 Ipsum. Ave','Timaru','65306',116),
  (117,'810-5771 Mauris Ave','Itajaí','476156',117),
  (118,'192-3595 Erat Ave','Springfield','3426',118),
  (119,'P.O. Box 724, 1806 Ac Av.','Odendaalsrus','21442',119),
  (120,'Ap #227-6111 Cras St.','Río Bueno','62381',120);
INSERT INTO [StudentAdress] (address_id,address,city,zipcode,std_id)
VALUES
  (121,'1068 In St.','Talcahuano','183887',121),
  (122,'Ap #742-2666 Eget, Avenue','Elsene','352496',122),
  (123,'663-1433 Dui Ave','Ilhéus','225754',123),
  (124,'1701 Dictum Street','Sint-Pieters-Woluwe','288737',124),
  (125,'7928 Quis Ave','Gagliato','86689-34546',125),
  (126,'530-9379 Quisque St.','Chungju','484805',126),
  (127,'Ap #488-8575 Vehicula Street','Canberra','38345',127),
  (128,'Ap #465-4966 Tellus Street','Lanco','674536',128),
  (129,'834-7417 Massa. Street','Christchurch','7548-5516',129),
  (130,'499-6090 Tristique Rd.','Shanxi','6606 MV',130);
INSERT INTO [StudentAdress] (address_id,address,city,zipcode,std_id)
VALUES
  (131,'510-9199 Auctor Ave','Palu','373963',131),
  (132,'P.O. Box 450, 3722 Venenatis Road','Emmen','656209',132),
  (133,'316-9965 Nulla. Road','Saint-Étienne-du-Rouvray','2288',133),
  (134,'827-3041 Nam Rd.','Marawi','221715',134),
  (135,'7478 Tellus Av.','Bauchi','33961',135),
  (136,'P.O. Box 335, 3082 Sed St.','Cà Mau','7430-5527',136),
  (137,'573-3452 Orci Av.','Borlänge','O2E 5T7',137),
  (138,'538-136 Ultrices, Street','Beijing','58-353',138),
  (139,'Ap #296-3217 Felis, Rd.','Söderhamn','48-701',139),
  (140,'367 Ornare. St.','Pachuca','674703',140);
INSERT INTO [StudentAdress] (address_id,address,city,zipcode,std_id)
VALUES
  (141,'Ap #849-5863 In Street','Istanbul','553753',141),
  (142,'4388 Ullamcorper. Street','Belfast','1652',142),
  (143,'589-4844 Non, Rd.','Bạc Liêu','9675',143),
  (144,'Ap #557-5053 Cursus Rd.','Camarones','77-890',144),
  (145,'Ap #279-8919 Eu St.','San Diego','13984',145),
  (146,'P.O. Box 772, 3263 Sit Rd.','Sambreville','8906',146),
  (147,'Ap #153-7929 Donec Road','Khmelnytskyi','90653',147),
  (148,'Ap #287-8019 Dui. Ave','Ternopil','473062',148),
  (149,'917-1399 Nec St.','Chuncheon','77049',149),
  (150,'P.O. Box 295, 5771 Felis, Road','Sortland','551638',150);
INSERT INTO [StudentAdress] (address_id,address,city,zipcode,std_id)
VALUES
  (151,'9247 Erat. Rd.','Izmail','53788-33775',151),
  (152,'721-8973 Sit Av.','Frutillar','73524',152),
  (153,'934-2872 Auctor Road','Khmelnytskyi','32489',153),
  (154,'530-3799 Vulputate Rd.','Istanbul','983672',154),
  (155,'Ap #326-7383 Maecenas Street','Cusco','66619',155),
  (156,'Ap #758-4553 Et Ave','Girona','23428',156),
  (157,'Ap #409-6428 Mi. Av.','Guangxi','663710',157),
  (158,'316-393 Nulla Rd.','Frederick','41383',158),
  (159,'Ap #928-4403 Congue. Avenue','Khairpur','327486',159),
  (160,'1446 Adipiscing Ave','Whittlesey','552385',160);
INSERT INTO [StudentAdress] (address_id,address,city,zipcode,std_id)
VALUES
  (161,'363-9048 Justo St.','Oss','E0T 5X1',161),
  (162,'Ap #988-2999 Odio, Street','Mỹ Hào','638623',162),
  (163,'Ap #896-3367 Proin St.','Frederick','3682',163),
  (164,'Ap #734-7612 Faucibus Rd.','Bislig','797835',164),
  (165,'P.O. Box 957, 6872 Dui St.','Pekanbaru','7263',165),
  (166,'455 Sed Road','Tuguegarao','7793',166),
  (167,'120-8120 Posuere Rd.','Saratov','4473',167),
  (168,'455-1614 Phasellus Av.','Goulburn','3644',168),
  (169,'Ap #544-328 Sed Rd.','Glenrothes','22945',169),
  (170,'8916 Consectetuer, St.','Mérida','8828',170);
INSERT INTO [StudentAdress] (address_id,address,city,zipcode,std_id)
VALUES
  (171,'448-7503 Lectus. St.','Camarones','34215',171),
  (172,'Ap #244-3476 Elit. St.','Anseong','38279',172),
  (173,'P.O. Box 591, 3361 Magnis Ave','Gravataí','8755',173),
  (174,'307-7742 Pede Road','San José de Alajuela','15263',174),
  (175,'Ap #642-2509 Varius Rd.','Teralfene','532731',175),
  (176,'Ap #527-4986 Ad St.','El Quisco','73-075',176),
  (177,'8450 Dis St.','Catacaos','1585',177),
  (178,'P.O. Box 887, 6998 Consectetuer Ave','Itabuna','77533',178),
  (179,'6228 Integer Street','Bogo','9865',179),
  (180,'P.O. Box 698, 6053 Curae Rd.','Nurallao','72961',180);
INSERT INTO [StudentAdress] (address_id,address,city,zipcode,std_id)
VALUES
  (181,'Ap #443-8790 Fringilla St.','Fundación','96746',181),
  (182,'Ap #361-5521 Faucibus Av.','Medemblik','64536',182),
  (183,'777 Molestie Av.','Berlin','79645',183),
  (184,'688-9187 Eu, Av.','Tywyn','VR43 6NM',184),
  (185,'2140 Nulla. Road','Loupoigne','1783',185),
  (186,'831-2787 Vivamus Rd.','Norrköping','279484',186),
  (187,'516-808 Nisi Ave','Delft','61-34',187),
  (188,'P.O. Box 962, 8307 Iaculis Av.','Mandai','6247',188),
  (189,'P.O. Box 450, 281 Ut Av.','Villahermosa','599958',189),
  (190,'P.O. Box 689, 8141 Orci. Avenue','Bon Accord','72633',190);
INSERT INTO [StudentAdress] (address_id,address,city,zipcode,std_id)
VALUES
  (191,'807-4026 Sed, Rd.','Vallentuna','12985',191),
  (192,'875-8769 Quis, St.','Whakatane','25567',192),
  (193,'875-1029 Montes, Street','Borås','73-62',193),
  (194,'437-5628 Aliquet Rd.','Tanjung Pinang','6748',194),
  (195,'Ap #123-7069 Quam Street','Milnathort','44660',195),
  (196,'277-3153 Sed, St.','Trollhättan','12906',196),
  (197,'Ap #115-3702 Nec Rd.','Launceston','89861',197),
  (198,'Ap #414-8929 Aliquam Av.','Kurram Agency','208248',198),
  (199,'Ap #185-4094 Adipiscing Ave','Ghanche','1713',199),
  (200,'P.O. Box 839, 8399 Ut Ave','Tomsk','51711',200);
INSERT INTO [StudentAdress] (address_id,address,city,zipcode,std_id)
VALUES
  (201,'P.O. Box 873, 9359 Diam. Rd.','Bastia','22598',201),
  (202,'Ap #710-985 Inceptos Street','Bengkulu','33683',202),
  (203,'Ap #403-3394 Varius St.','Kırıkhan','568689',203),
  (204,'Ap #914-7647 Penatibus St.','Levin','2168 RH',204),
  (205,'Ap #309-4927 Eleifend Rd.','Berlin','1671',205),
  (206,'818-5233 Nec St.','Pınarbaşı','51408',206),
  (207,'645-8649 Tincidunt Street','Limón (Puerto Limón]','23771',207),
  (208,'843-1514 Lobortis Ave','Awka','3066',208),
  (209,'6297 Enim. Street','Caxias do Sul','489861',209),
  (210,'Ap #255-6977 Et Avenue','Cork','77-37',210);
INSERT INTO [StudentAdress] (address_id,address,city,zipcode,std_id)
VALUES
  (211,'3309 Pellentesque Street','Daman','ND03 1WD',211),
  (212,'6814 Torquent Rd.','Sluis','53-705',212),
  (213,'Ap #728-7822 Augue St.','Broxburn','2231',213),
  (214,'P.O. Box 702, 2809 Amet Ave','Suncheon','19716',214),
  (215,'235-8332 Pede, St.','Dovzhansk','9110',215),
  (216,'Ap #431-6628 Arcu. St.','Cairns','06-428',216),
  (217,'Ap #699-5174 Vitae Road','Soledad de Graciano Sánchez','46-487',217),
  (218,'P.O. Box 169, 2765 Dui Rd.','Jørpeland','76-44',218),
  (219,'Ap #275-3402 Magna Ave','Belfast','102731',219),
  (220,'Ap #771-3179 Massa Rd.','Motueka','61353-27266',220);
INSERT INTO [StudentAdress] (address_id,address,city,zipcode,std_id)
VALUES
  (221,'951-226 Urna. St.','Polino','325958',221),
  (222,'Ap #285-4499 Commodo St.','Sembawang','4471',222),
  (223,'589-8403 Sed Avenue','Thanh Hóa','8541',223),
  (224,'Ap #110-1837 Urna. Rd.','Odda','6777',224),
  (225,'818-5291 Sollicitudin Rd.','Jeju','564718',225),
  (226,'4062 Interdum. St.','Macau','24154',226),
  (227,'P.O. Box 324, 6880 Non, Ave','Ghizer','51205',227),
  (228,'545-3036 Est Ave','Cañas','12-233',228),
  (229,'P.O. Box 986, 4338 Odio, Street','Deventer','327158',229),
  (230,'730 Neque Av.','Sechura','28358',230);
INSERT INTO [StudentAdress] (address_id,address,city,zipcode,std_id)
VALUES
  (231,'933-7752 Feugiat. Av.','Oleksandriia','3855',231),
  (232,'Ap #527-2222 Sem. Av.','Heusden','152899',232),
  (233,'Ap #935-287 Pretium St.','Quảng Ngãi','4179-0923',233),
  (234,'Ap #908-8132 Tellus. St.','Banda Aceh','04651',234),
  (235,'424-4900 Dis Road','Quibdó','74720-641',235),
  (236,'237-2910 Et Ave','Tangub','612166',236),
  (237,'5532 Tortor, Ave','Orenburg','717733',237),
  (238,'P.O. Box 138, 6557 Nisi Ave','Yunnan','634791',238),
  (239,'Ap #718-9029 Proin St.','Niterói','69309',239),
  (240,'Ap #164-6341 Sed Street','Recife','09-861',240);
INSERT INTO [StudentAdress] (address_id,address,city,zipcode,std_id)
VALUES
  (241,'Ap #389-2894 Et Rd.','Sherani','1774',241),
  (242,'3357 Semper St.','Monte Vidon Corrado','43734',242),
  (243,'Ap #690-3594 Libero. Road','Palu','44390',243),
  (244,'807-1317 Velit St.','Alès','3374',244),
  (245,'733-7756 Vitae Av.','Yurimaguas','21313-57689',245),
  (246,'Ap #361-2154 Dictum St.','Gorzów Wielkopolski','79593',246),
  (247,'P.O. Box 375, 8507 Mauris, Road','Gimcheon','73698',247),
  (248,'672-3826 Cras Rd.','Alta','779757',248),
  (249,'Ap #234-4432 Arcu Rd.','Pekanbaru','6658',249),
  (250,'P.O. Box 234, 9373 Ac Rd.','Palma de Mallorca','68-62',250);
INSERT INTO [StudentAdress] (address_id,address,city,zipcode,std_id)
VALUES
  (251,'Ap #352-3702 Et, Street','Muradiye','97865',251),
  (252,'Ap #817-8970 Orci Avenue','Gorontalo','54314-80768',252),
  (253,'247-3525 Sollicitudin Road','Cañas','50-022',253),
  (254,'Ap #735-5393 Vestibulum St.','Konin','513654',254),
  (255,'Ap #770-6430 Arcu. Rd.','Sunderland','58186',255),
  (256,'953-4405 Commodo Street','Pinetown','67487-123',256),
  (257,'916-6239 Interdum. St.','Jayapura','91717',257),
  (258,'761-7965 Molestie Road','Arica','37-834',258),
  (259,'7509 Blandit Ave','Sandviken','11447',259),
  (260,'P.O. Box 825, 7886 Nisl. Street','Aguacaliente (San Francisco]','811166',260);
INSERT INTO [StudentAdress] (address_id,address,city,zipcode,std_id)
VALUES
  (261,'Ap #756-519 Diam Avenue','Bergen','540364',261),
  (262,'Ap #459-1688 Ligula. Road','Barranca','6593',262),
  (263,'Ap #809-6252 Phasellus Ave','Schaarbeek','YK8P 2NK',263),
  (264,'Ap #151-5050 Dictum Av.','Mjölby','56-14',264),
  (265,'Ap #321-6980 Mauris Ave','Bạc Liêu','Q2 5WR',265),
  (266,'9096 Gravida Rd.','Phú Yên','NN98 3IG',266),
  (267,'210-4490 Magna. St.','Galway','6383',267),
  (268,'526-1206 Vel Rd.','Holywell','11755-54765',268),
  (269,'903-6556 Justo Rd.','Queanbeyan','73-63',269),
  (270,'8172 Libero Av.','Narvik','3633',270);
INSERT INTO [StudentAdress] (address_id,address,city,zipcode,std_id)
VALUES
  (271,'P.O. Box 146, 4694 Ac Road','Bridge of Allan','787331',271),
  (272,'P.O. Box 157, 5363 Fermentum Ave','Gasteiz','6285',272),
  (273,'288-6890 Velit St.','Napier','3181',273),
  (274,'527-8819 Metus Avenue','Huaraz','462645',274),
  (275,'601-4743 Neque Ave','Secunda','VF19 2IL',275),
  (276,'P.O. Box 819, 7368 Amet, Av.','Alassio','40385',276),
  (277,'P.O. Box 555, 4397 Amet St.','Cleveland','459586',277),
  (278,'5890 Enim. Rd.','Annapolis','7647 OT',278),
  (279,'656-4980 Commodo Rd.','Belfast','735035',279),
  (280,'602-8220 Eget Avenue','Huancayo','733465',280);
INSERT INTO [StudentAdress] (address_id,address,city,zipcode,std_id)
VALUES
  (281,'7294 Tincidunt Road','Lidköping','3545',281),
  (282,'668-6923 Curabitur Road','Uddevalla','10049',282),
  (283,'P.O. Box 543, 8575 Ullamcorper Ave','Bolano','3776',283),
  (284,'6334 Nulla Road','Mendonk','43918',284),
  (285,'Ap #376-1298 Euismod Rd.','Tomsk','21587',285),
  (286,'Ap #695-8828 Id Road','Vashkivtsi','97176',286),
  (287,'729-5917 Nunc Av.','Leeds','46-738',287),
  (288,'845-1981 Neque St.','Corral','574826',288),
  (289,'6909 Sit Av.','Río Bueno','57-71',289),
  (290,'485-5878 A, Ave','Poltava','31125',290);
INSERT INTO [StudentAdress] (address_id,address,city,zipcode,std_id)
VALUES
  (291,'Ap #780-6035 Vestibulum, St.','Dutse','21264',291),
  (292,'P.O. Box 987, 1059 Nisi Ave','Alhué','932482',292),
  (293,'P.O. Box 747, 2903 Lobortis Rd.','Palombaro','234651',293),
  (294,'342-1179 Tristique Rd.','Lawton','3255',294),
  (295,'9731 Fusce Road','Berwick','2574',295),
  (296,'4510 Vel Avenue','Istanbul','57-98',296),
  (297,'126-7573 Pellentesque St.','Toruń','922810',297),
  (298,'P.O. Box 308, 3194 Sit Avenue','Kortrijk','8072-3998',298),
  (299,'P.O. Box 853, 3046 Etiam Road','Konin','33423',299),
  (300,'548-4500 Turpis. Ave','Chungju','4190',300);
INSERT INTO [StudentAdress] (address_id,address,city,zipcode,std_id)
VALUES
  (301,'327-9406 Nisl Rd.','San Cristóbal de la Laguna','9672',301),
  (302,'232-4537 Semper Rd.','Saint-Laurent','871624',302),
  (303,'840-9174 Sed Rd.','San Antonio','37676',303),
  (304,'808-2225 Elit Street','Shaanxi','16808',304),
  (305,'P.O. Box 825, 7268 Sed, Rd.','Hunan','48444',305),
  (306,'781-1225 A Av.','Kon Tum','28862',306),
  (307,'896-3653 Nunc St.','Feldkirchen in Kärnten','719766',307),
  (308,'Ap #486-7148 Feugiat Avenue','Columbus','D2 4HO',308),
  (309,'Ap #789-689 Eu, Rd.','Khushab','0523',309),
  (310,'Ap #140-4266 Sit Road','Anamur','548822',310);
INSERT INTO [StudentAdress] (address_id,address,city,zipcode,std_id)
VALUES
  (311,'Ap #274-9189 Sociis Av.','Makassar','22945',311),
  (312,'607-1851 Dui. Rd.','Gangneung','3783 BG',312),
  (313,'P.O. Box 329, 7510 Nulla St.','Balıkesir','94416',313),
  (314,'P.O. Box 565, 4823 Felis Ave','Lublin','43-011',314),
  (315,'8367 Senectus Street','Galway','21412',315),
  (316,'Ap #197-3344 Non, St.','Changi Bay','7157',316),
  (317,'681-2500 Vel Av.','Siquirres','868283',317),
  (318,'Ap #801-5900 Mauris St.','Máfil','15867',318),
  (319,'825-9210 Donec Rd.','Picton','7382',319),
  (320,'5382 Ac, Av.','Breda','26481',320);
INSERT INTO [StudentAdress] (address_id,address,city,zipcode,std_id)
VALUES
  (321,'435-5668 Dui. Rd.','Tampa','431572',321),
  (322,'6480 Tincidunt. Avenue','Naarden','0421-1273',322),
  (323,'Ap #680-5558 Elit Rd.','Santander','19255',323),
  (324,'896-4952 At, St.','Voronezh','08231',324),
  (325,'456-2874 Eget, Avenue','Western Water Catchment','88028-600',325),
  (326,'5230 Ipsum. Avenue','Bishan','14710',326),
  (327,'112-4855 Et, Av.','Anzio','544543',327),
  (328,'6525 Sapien. St.','Kirkwall','6762',328),
  (329,'P.O. Box 394, 3967 Donec Avenue','Mexicali','06242',329),
  (330,'3173 Magna. Rd.','Almere','723965',330);
INSERT INTO [StudentAdress] (address_id,address,city,zipcode,std_id)
VALUES
  (331,'Ap #776-5612 Hymenaeos. Rd.','Sokoto','57-565',331),
  (332,'Ap #923-4637 Dignissim Avenue','Aizwal','6777-6017',332),
  (333,'Ap #446-984 Dapibus Rd.','Bama','7974',333),
  (334,'8434 Mattis. Rd.','Vigo','62332',334),
  (335,'P.O. Box 561, 5204 Risus. Street','Chernihiv','539717',335),
  (336,'P.O. Box 196, 5943 Magna Road','Graz','86713',336),
  (337,'Ap #150-5458 Pede. Rd.','Rotello','829772',337),
  (338,'445-609 Integer Street','Pamplona','81-42',338),
  (339,'Ap #239-7809 Eu St.','Yên Ninh','4884',339),
  (340,'Ap #429-8229 Vitae, St.','Tomohon','331787',340);
INSERT INTO [StudentAdress] (address_id,address,city,zipcode,std_id)
VALUES
  (341,'Ap #837-1831 Vulputate, St.','Suncheon','3691-9077',341),
  (342,'Ap #798-8881 Quis St.','Chiquinquirá','4186',342),
  (343,'Ap #300-2797 Mauris St.','Bhilai','27-15',343),
  (344,'389-8799 Sodales Avenue','Vienna','3788',344),
  (345,'Ap #514-9878 Malesuada. Street','San Polo d''Enza','43938',345),
  (346,'2744 Aliquam Rd.','Secunda','46288',346),
  (347,'Ap #335-1394 Arcu. St.','Banjarbaru','914264',347),
  (348,'3557 Mauris Avenue','Sale','83846-10394',348),
  (349,'490-3008 Sit Rd.','Belfast','4036 PI',349),
  (350,'895-4630 Diam Street','Dubbo','380351',350);
INSERT INTO [StudentAdress] (address_id,address,city,zipcode,std_id)
VALUES
  (351,'Ap #406-6303 Adipiscing. Rd.','Whyalla','487486',351),
  (352,'947-9363 Ipsum. Street','Canberra','35501-16947',352),
  (353,'9506 Egestas. St.','Đà Nẵng','TU46 4TI',353),
  (354,'Ap #109-3480 Justo. Street','Kovel','AE3 7SC',354),
  (355,'P.O. Box 374, 5189 Ac Avenue','Dublin','1679',355),
  (356,'P.O. Box 994, 6518 Pretium Rd.','Levin','24642',356),
  (357,'191-8687 Mollis St.','Galway','n1B 0Y6',357),
  (358,'Ap #868-2696 Eu St.','Wels','2215 SF',358),
  (359,'P.O. Box 811, 711 Commodo Avenue','Finkenstein am Faaker See','A6G 8A6',359),
  (360,'Ap #700-2973 Ac Rd.','Rodez','10-874',360);
INSERT INTO [StudentAdress] (address_id,address,city,zipcode,std_id)
VALUES
  (361,'8596 Cras Ave','Lower Hutt','596034',361),
  (362,'P.O. Box 770, 8923 Phasellus Road','Wiener Neustadt','327361',362),
  (363,'593-1776 Vitae Rd.','Guápiles','683234',363),
  (364,'P.O. Box 803, 7036 Neque Street','Ningxia','97668-94685',364),
  (365,'P.O. Box 284, 4338 Sagittis Road','Acapulco','35238',365),
  (366,'P.O. Box 786, 9818 Dapibus Avenue','Nova Kakhovka','873032',366),
  (367,'7956 Ac Road','Galway','63528',367),
  (368,'Ap #403-2311 Ultrices. Avenue','Lexington','636636',368),
  (369,'759-7417 Consectetuer Rd.','Semarang','J3 5EG',369),
  (370,'350-2568 Suspendisse St.','Logroño','736486',370);
INSERT INTO [StudentAdress] (address_id,address,city,zipcode,std_id)
VALUES
  (371,'Ap #246-1578 Sit Av.','Cork','16237',371),
  (372,'P.O. Box 920, 4724 Ornare, Rd.','Canberra','875428',372),
  (373,'247-9839 Quam, Rd.','Sangju','06198',373),
  (374,'P.O. Box 238, 3933 Risus Rd.','Sint-Jans-Molenbeek','888629',374),
  (375,'Ap #855-6543 Libero. Ave','Hérouville-Saint-Clair','95852',375),
  (376,'232-9421 Eget, Rd.','Çeşme','9711',376),
  (377,'8044 Sagittis Avenue','Bogor','5927',377),
  (378,'P.O. Box 616, 8718 Integer St.','Bucaramanga','722588',378),
  (379,'971-3722 Cursus Rd.','South Portland','3182',379),
  (380,'P.O. Box 613, 2645 A Rd.','Ostrowiec Świętokrzyski','859766',380);



  --Subjects
  INSERT INTO [Subjects] (sub_id,name,class_id,section_id,department_id)
VALUES
  (1,'Jerry Johnson',1,1,5),
  (2,'Jared Sargent',1,1,5),
  (3,'Quyn Wallace',1,1,5),
  (4,'Upton Schwartz',2,2,5),
  (5,'Glenna Huff',2,2,5),
  (6,'Chase Larson',2,2,5),
  (7,'Deacon Little',3,3,5),
  (8,'Cherokee Hewitt',3,3,5),
  (9,'Idola Tran',3,3,5),
  (10,'Candace Fowler',4,4,5);
INSERT INTO [Subjects] (sub_id,name,class_id,section_id,department_id)
VALUES
  (11,'Hillary Noble',4,4,5),
  (12,'Lynn Blankenship',4,4,5),
  (13,'Trevor Woods',5,5,5),
  (14,'Adrian Trevino',5,5,5),
  (15,'Chaney Mullins',5,5,5),
  (16,'Oscar King',6,6,5),
  (17,'Leandra Gentry',6,6,5),
  (18,'Armando Olsen',6,6,5),
  (19,'Ariana Knowles',7,7,5),
  (20,'Mark Santana',7,7,5);
INSERT INTO [Subjects] (sub_id,name,class_id,section_id,department_id)
VALUES
  (21,'Irma Riley',7,7,5),
  (22,'Rae Howard',8,8,5),
  (23,'Jasmine Carey',8,8,5),
  (24,'Mark Leblanc',8,8,5),
  (25,'Teegan Goodwin',9,9,5),
  (26,'Lucian Huff',9,9,5),
  (27,'Lester Suarez',9,9,5),
  (28,'Clinton Anderson',10,10,5),
  (29,'Cathleen Beck',10,10,5),
  (30,'Conan Bowman',10,10,5);
INSERT INTO [Subjects] (sub_id,name,class_id,section_id,department_id)
VALUES
  (31,'Ralph Calhoun',11,11,5),
  (32,'Miranda Patel',11,11,5),
  (33,'Emmanuel Padilla',11,11,5),
  (34,'Maryam Hines',12,12,4),
  (35,'Ariel Chan',12,12,4),
  (36,'Robin Willis',12,12,4),
  (37,'Chadwick Juarez',13,13,4),
  (38,'Amos Christian',13,13,4),
  (39,'Kaye Whitaker',13,13,4),
  (40,'Paula Castaneda',14,14,3);
INSERT INTO [Subjects] (sub_id,name,class_id,section_id,department_id)
VALUES
  (41,'Kareem Payne',14,14,3),
  (42,'Kelly Oliver',14,14,3),
  (43,'Merrill Decker',15,15,3),
  (44,'Xavier Collier',15,15,3),
  (45,'Aidan Hooper',15,15,3),
  (46,'Yoshio Randall',16,16,2),
  (47,'Wesley Wilcox',16,16,2),
  (48,'Emery West',16,16,2),
  (49,'Amber Howard',17,17,2),
  (50,'Nehru Fischer',17,17,2);
INSERT INTO [Subjects] (sub_id,name,class_id,section_id,department_id)
VALUES
  (51,'Warren Warren',17,17,2),
  (52,'Chelsea Schwartz',18,18,1),
  (53,'Davis Solis',18,18,1),
  (54,'Daquan Bass',18,18,1),
  (55,'Shana Ellis',19,19,1),
  (56,'Eleanor Kane',19,19,1),
  (57,'Erich Curry',19,19,1);


  --Faculty
  INSERT INTO [Faculty] (fac_id,fac_name,phone_no,email,age,department_id,subject_id,section_id)
VALUES
  (1,'Nichole Singleton','(715) 611-5758','non.vestibulum@protonmail.org',25,5,1,1),
  (2,'Elijah Keith','1-703-137-5397','est.congue@yahoo.couk',25,5,2,1),
  (3,'Dylan Nash','1-651-228-3691','taciti.sociosqu@protonmail.org',25,5,3,1),
  (4,'Samson Talley','(752) 473-8357','inceptos.hymenaeos.mauris@protonmail.edu',26,5,4,2),
  (5,'Charity York','(639) 304-3518','nulla.at@icloud.org',26,5,5,2),
  (6,'Wyatt Vang','1-848-817-7567','nec.tempus@hotmail.com',26,5,6,2),
  (7,'Debra Blackburn','(910) 641-0777','libero.lacus.varius@protonmail.couk',27,5,7,3),
  (8,'Clare Conner','1-728-221-6874','arcu.nunc@google.net',27,5,8,3),
  (9,'Raven Faulkner','1-615-760-5748','sit.amet@icloud.net',27,5,9,3),
  (10,'Reagan Reeves','(314) 424-4335','felis.adipiscing@google.edu',25,5,10,4);
INSERT INTO [Faculty] (fac_id,fac_name,phone_no,email,age,department_id,subject_id,section_id)
VALUES
  (11,'Laura Sampson','1-490-435-4742','semper.egestas.urna@hotmail.org',25,5,11,4),
  (12,'Lars Levy','1-427-721-0880','erat.vel@aol.edu',25,5,12,4),
  (13,'Athena Beard','1-139-289-6355','metus.in@hotmail.com',26,5,13,5),
  (14,'Nell King','(392) 681-5595','orci.ut.sagittis@hotmail.edu',26,5,14,5),
  (15,'Josephine Moody','(211) 832-2652','nec.euismod@google.ca',26,5,15,5),
  (16,'Fritz Weiss','(387) 524-8865','nulla.donec.non@protonmail.couk',27,5,16,6),
  (17,'Alyssa Gordon','1-451-756-6811','tempus.scelerisque@google.net',27,5,17,6),
  (18,'Kimberly Baker','1-388-215-0776','odio.tristique.pharetra@yahoo.net',27,5,18,6),
  (19,'Kitra Flynn','1-615-661-0525','aliquam.nec@icloud.couk',25,5,19,7),
  (20,'Randall Wallace','1-387-325-0227','molestie.arcu@outlook.ca',25,5,20,7);
INSERT INTO [Faculty] (fac_id,fac_name,phone_no,email,age,department_id,subject_id,section_id)
VALUES
  (21,'Keegan Roberson','(425) 772-8778','augue.porttitor@icloud.couk',25,5,21,7),
  (22,'Ingrid Jacobson','(411) 826-5138','fermentum.vel@protonmail.edu',26,5,22,8),
  (23,'Rina Schultz','(709) 242-1783','non@aol.org',26,5,23,8),
  (24,'Shannon Salinas','1-975-448-6811','velit@aol.ca',26,5,24,8),
  (25,'Wayne Stevenson','1-656-253-6245','dapibus.gravida.aliquam@icloud.couk',27,5,25,9),
  (26,'Nero Foley','1-125-235-5953','integer.urna@aol.org',27,5,26,9),
  (27,'Bethany Ortega','1-351-453-2314','in.sodales@hotmail.ca',27,5,27,9),
  (28,'Savannah Sampson','(436) 211-9848','dapibus@icloud.ca',25,5,28,10),
  (29,'Jolene Rice','(662) 745-8238','sed.nulla.ante@outlook.couk',25,5,29,10),
  (30,'Brandon Stanton','1-375-142-1188','mollis.vitae@icloud.com',25,5,30,10);
INSERT INTO [Faculty] (fac_id,fac_name,phone_no,email,age,department_id,subject_id,section_id)
VALUES
  (31,'Kay Nguyen','1-355-499-5325','suscipit.est.ac@aol.com',26,5,31,11),
  (32,'Scarlett Santana','(985) 597-2326','mi@outlook.com',26,5,32,11),
  (33,'Patrick Miles','(501) 233-9334','bibendum@google.org',26,5,33,11),
  (34,'Griffith O''Neill','1-834-283-4584','sed@icloud.couk',27,4,34,12),
  (35,'Paula Farley','1-447-282-5542','vehicula.et@hotmail.net',27,4,35,12),
  (36,'Jermaine Gillespie','1-144-360-4767','ac.sem.ut@icloud.net',27,4,36,12),
  (37,'Portia Whitehead','1-356-466-1776','adipiscing.ligula@google.ca',25,4,37,13),
  (38,'Avram Glass','1-625-638-2190','per.inceptos@protonmail.couk',25,4,38,13),
  (39,'Anika Hess','(569) 783-7412','duis.elementum@yahoo.org',25,4,39,13),
  (40,'Barbara Black','(541) 631-2127','adipiscing.mauris@protonmail.couk',26,3,40,14);
INSERT INTO [Faculty] (fac_id,fac_name,phone_no,email,age,department_id,subject_id,section_id)
VALUES
  (41,'Bryar Baird','(704) 552-8725','imperdiet.non.vestibulum@outlook.couk',26,3,41,14),
  (42,'Leonard Vargas','(868) 537-3964','placerat@protonmail.org',26,3,42,14),
  (43,'Venus Brooks','1-655-665-9162','vulputate.velit@icloud.net',27,3,43,15),
  (44,'Josiah Benton','1-386-796-7562','enim.condimentum.eget@yahoo.com',27,3,44,15),
  (45,'Colorado Castillo','(614) 688-5386','auctor.odio@yahoo.couk',27,3,45,15),
  (46,'Shaine Pruitt','(514) 719-8754','nibh@yahoo.org',25,2,46,16),
  (47,'Chloe Stanton','(771) 261-7112','euismod.est@google.couk',25,2,47,16),
  (48,'Jael Ortiz','1-414-233-5341','adipiscing.mauris@aol.com',25,2,48,16),
  (49,'Imani Blake','1-883-255-9336','lectus.convallis@icloud.couk',26,2,49,17),
  (50,'Belle Wright','(988) 875-1677','egestas.urna.justo@icloud.org',26,2,50,17);
INSERT INTO [Faculty] (fac_id,fac_name,phone_no,email,age,department_id,subject_id,section_id)
VALUES
  (51,'Forrest Workman','1-777-379-9776','mollis.vitae@hotmail.org',26,2,51,17),
  (52,'Gray Chambers','(794) 552-0184','auctor@hotmail.couk',27,1,52,18),
  (53,'Belle Meyer','1-182-437-2833','ipsum.primis@google.org',27,1,53,18),
  (54,'Demetria Doyle','1-543-844-5622','neque.nullam@yahoo.org',27,1,54,18),
  (55,'Shellie Byers','1-304-377-1315','vitae.odio.sagittis@icloud.couk',25,1,55,19),
  (56,'Michelle O''connor','1-945-619-0331','sed.diam@protonmail.ca',25,1,56,19),
  (57,'Keiko Moreno','1-771-537-5734','ligula.eu@hotmail.ca',25,1,57,19);

  --Faculty Address
  
INSERT INTO [FacultyAddress] (address_id,address,city,zipcode,fac_id)
VALUES
  (1,'862-3525 Egestas Ave','Shikarpur','432855',1),
  (2,'Ap #745-9363 Dui, Ave','Sengkang','13676',2),
  (3,'Ap #775-8966 Mollis. Rd.','Oleksandriia','17439',3),
  (4,'Ap #529-7417 Vitae Ave','Sankt Johann im Pongau','97-86',4),
  (5,'2144 Vel, Street','Galway','91757',5),
  (6,'P.O. Box 680, 473 Interdum Ave','Ebenthal in Kärnten','31082',6),
  (7,'P.O. Box 694, 7663 Libero Street','Millesimo','62095',7),
  (8,'Ap #906-1809 Purus Rd.','Tây Ninh','38086-52501',8),
  (9,'Ap #376-864 Sociis Av.','Pictou','2855',9),
  (10,'Ap #569-3098 Mauris St.','Hay-on-Wye','2281',10);
INSERT INTO [FacultyAddress] (address_id,address,city,zipcode,fac_id)
VALUES
  (11,'297-4300 Tellus. Street','Daly','482326',11),
  (12,'8888 A Street','Hà Tĩnh','28-998',12),
  (13,'P.O. Box 769, 3951 Quisque Ave','Hougang','21337',13),
  (14,'452-1919 Ut Road','Nellore','5336 BE',14),
  (15,'4572 Enim Street','Juárez','8136',15),
  (16,'Ap #811-3078 Erat. St.','Zamboanga City','17277',16),
  (17,'P.O. Box 778, 7980 Eget, Street','Melilla','3490',17),
  (18,'Ap #933-7769 Mauris Av.','San Luis Potosí','81892-72901',18),
  (19,'Ap #720-9480 Vel St.','Hamburg','59615',19),
  (20,'3399 Nec, Ave','Iksan','3843',20);
INSERT INTO [FacultyAddress] (address_id,address,city,zipcode,fac_id)
VALUES
  (21,'Ap #861-2628 Quam Avenue','Stockerau','997454',21),
  (22,'P.O. Box 786, 4392 Consequat Road','Picton','2896',22),
  (23,'4008 Eget Rd.','Zaragoza','54401',23),
  (24,'6560 Et St.','Nghĩa Lộ','54250',24),
  (25,'6203 Ornare Av.','Phan Rang–Tháp Chàm','L7S 4P6',25),
  (26,'111-2234 Laoreet Rd.','Charters Towers','785713',26),
  (27,'Ap #917-3566 Integer St.','Maria','61532-748',27),
  (28,'P.O. Box 750, 8904 Felis. Ave','Peshawar','893116',28),
  (29,'3337 Purus. Street','Uppingham. Cottesmore','14216-94341',29),
  (30,'551-9407 Enim Rd.','Loreto','35047',30);
INSERT INTO [FacultyAddress] (address_id,address,city,zipcode,fac_id)
VALUES
  (31,'P.O. Box 517, 2814 Consectetuer Street','Turrialba','38647',31),
  (32,'Ap #949-6178 Magna, Av.','Lochranza','43128',32),
  (33,'978-7532 Mauris Ave','Johannesburg','42230',33),
  (34,'2764 Erat St.','Anhui','76590-37878',34),
  (35,'4744 Mi Avenue','Inverurie','VQ1 7NB',35),
  (36,'1751 Convallis St.','Nantes','12527',36),
  (37,'Ap #836-9246 Metus Av.','Woodlands','966466',37),
  (38,'Ap #902-9371 Lorem St.','Pöttsching','50917',38),
  (39,'P.O. Box 789, 8644 Placerat, Street','Khmelnytskyi','43022',39),
  (40,'P.O. Box 674, 7690 Ante St.','Mustafakemalpaşa','644211',40);
INSERT INTO [FacultyAddress] (address_id,address,city,zipcode,fac_id)
VALUES
  (41,'5267 Purus Rd.','Dortmund','149556',41),
  (42,'258-6104 Ante Avenue','Altach','9838',42),
  (43,'7019 Odio St.','Charlottetown','11812',43),
  (44,'713-8857 Suscipit, St.','Pontypridd','65871',44),
  (45,'524-9032 Sed St.','Cork','47236-385',45),
  (46,'Ap #450-3362 Mi, St.','Wałbrzych','16134',46),
  (47,'Ap #983-133 Duis St.','Gävle','1856',47),
  (48,'631-3073 Quis, Street','Stonewall','68737',48),
  (49,'P.O. Box 737, 9445 Tincidunt Ave','Provo','46577-85401',49),
  (50,'6957 Montes, Ave','Tarnów','51592',50);
INSERT INTO [FacultyAddress] (address_id,address,city,zipcode,fac_id)
VALUES
  (51,'9751 Nec Av.','Christchurch','6544',51),
  (52,'2541 Nec Street','Valencia','G5 4LT',52),
  (53,'Ap #476-1420 Leo, St.','Kotamobagu','8701',53),
  (54,'9182 Blandit St.','Thirimont','170803',54),
  (55,'712-821 Lobortis St.','Westport','525128',55),
  (56,'516-1043 Ipsum Rd.','Marawi','1913 CX',56),
  (57,'Ap #909-3439 Dolor Ave','Açailândia','344769',57);




  --Attendance
  INSERT INTO [Attendance] (att_id,student_id,subject_id,status,date,section_id)
VALUES
  (1,1,1,'P','1-04-19',1),
  (2,2,1,'P','1-04-19',1),
  (3,3,1,'P','1-04-19',1),
  (4,4,1,'P','1-04-19',1),
  (5,5,1,'P','1-04-19',1),
  (6,6,1,'P','1-04-19',1),
  (7,7,1,'P','1-04-19',1),
  (8,8,1,'P','1-04-19',1),
  (9,9,1,'P','1-04-19',1),
  (10,10,1,'P','1-04-19',1);
  

INSERT INTO [Attendance] (att_id,student_id,subject_id,status,date,section_id)
VALUES
  (11,11,1,'P','1-04-19',1),
  (12,12,1,'P','1-04-19',1),
  (13,13,1,'P','1-04-19',1),
  (14,14,1,'P','1-04-19',1),
  (15,15,1,'P','1-04-19',1),
  (16,16,1,'P','1-04-19',1),
  (17,17,1,'P','1-04-19',1),
  (18,18,1,'P','1-04-19',1),
  (19,19,1,'P','1-04-19',1),
  (20,20,1,'P','1-04-19',1);
  INSERT INTO [Attendance] (att_id,student_id,subject_id,status,date,section_id)
VALUES
  (21,21,4,'P','1-04-19',2),
  (22,22,4,'P','1-04-19',2),
  (23,23,4,'P','1-04-19',2),
  (24,24,4,'P','1-04-19',2),
  (25,25,4,'P','1-04-19',2),
  (26,26,4,'P','1-04-19',2),
  (27,27,4,'P','1-04-19',2),
  (28,28,4,'P','1-04-19',2),
  (29,29,4,'P','1-04-19',2),
  (30,30,4,'P','1-04-19',2);
INSERT INTO [Attendance] (att_id,student_id,subject_id,status,date,section_id)
VALUES
  (31,31,4,'P','1-04-19',2),
  (32,32,4,'P','1-04-19',2),
  (33,33,4,'P','1-04-19',2),
  (34,34,4,'P','1-04-19',2),
  (35,35,4,'P','1-04-19',2),
  (36,36,4,'P','1-04-19',2),
  (37,37,4,'P','1-04-19',2),
  (38,38,4,'P','1-04-19',2),
  (39,39,4,'P','1-04-19',2),
  (40,40,4,'P','1-04-19',2);
INSERT INTO [Attendance] (att_id,student_id,subject_id,status,date,section_id)
VALUES
  (41,41,7,'P','1-04-19',3),
  (42,42,7,'P','1-04-19',3),
  (43,43,7,'P','1-04-19',3),
  (44,44,7,'P','1-04-19',3),
  (45,45,7,'P','1-04-19',3),
  (46,46,7,'P','1-04-19',3),
  (47,47,7,'P','1-04-19',3),
  (48,48,7,'P','1-04-19',3),
  (49,49,7,'P','1-04-19',3),
  (50,50,7,'P','1-04-19',3);
INSERT INTO [Attendance] (att_id,student_id,subject_id,status,date,section_id)
VALUES
  (51,51,7,'P','1-04-19',3),
  (52,52,7,'P','1-04-19',3),
  (53,53,7,'P','1-04-19',3),
  (54,54,7,'P','1-04-19',3),
  (55,55,7,'P','1-04-19',3),
  (56,56,7,'P','1-04-19',3),
  (57,57,7,'P','1-04-19',3),
  (58,58,7,'P','1-04-19',3),
  (59,59,7,'P','1-04-19',3),
  (60,60,7,'P','1-04-19',3);
INSERT INTO [Attendance] (att_id,student_id,subject_id,status,date,section_id)
VALUES
  (61,61,10,'P','1-04-19',4),
  (62,62,10,'P','1-04-19',4),
  (63,63,10,'P','1-04-19',4),
  (64,64,10,'P','1-04-19',4),
  (65,65,10,'P','1-04-19',4),
  (66,66,10,'P','1-04-19',4),
  (67,67,10,'P','1-04-19',4),
  (68,68,10,'P','1-04-19',4),
  (69,69,10,'P','1-04-19',4),
  (70,70,10,'P','1-04-19',4);
INSERT INTO [Attendance] (att_id,student_id,subject_id,status,date,section_id)
VALUES
  (71,71,10,'P','1-04-19',4),
  (72,72,10,'P','1-04-19',4),
  (73,73,10,'P','1-04-19',4),
  (74,74,10,'P','1-04-19',4),
  (75,75,10,'P','1-04-19',4),
  (76,76,10,'P','1-04-19',4),
  (77,77,10,'P','1-04-19',4),
  (78,78,10,'P','1-04-19',4),
  (79,79,10,'P','1-04-19',4),
  (80,80,10,'P','1-04-19',4);
INSERT INTO [Attendance] (att_id,student_id,subject_id,status,date,section_id)
VALUES
  (81,81,13,'A','1-04-19',5),
  (82,82,13,'A','1-04-19',5),
  (83,83,13,'A','1-04-19',5),
  (84,84,13,'A','1-04-19',5),
  (85,85,13,'A','1-04-19',5),
  (86,86,13,'A','1-04-19',5),
  (87,87,13,'A','1-04-19',5),
  (88,88,13,'A','1-04-19',5),
  (89,89,13,'A','1-04-19',5),
  (90,90,13,'A','1-04-19',5);
INSERT INTO [Attendance] (att_id,student_id,subject_id,status,date,section_id)
VALUES
  (91,91,13,'A','1-04-19',5),
  (92,92,13,'A','1-04-19',5),
  (93,93,13,'A','1-04-19',5),
  (94,94,13,'A','1-04-19',5),
  (95,95,13,'A','1-04-19',5),
  (96,96,13,'A','1-04-19',5),
  (97,97,13,'A','1-04-19',5),
  (98,98,13,'A','1-04-19',5),
  (99,99,13,'A','1-04-19',5),
  (100,100,13,'A','1-04-19',5);
  INSERT INTO [Attendance] (att_id,student_id,subject_id,status,date,section_id)
VALUES
  (101,101,16,'p','1-04-19',6),
  (102,102,16,'p','1-04-19',6),
  (103,103,16,'p','1-04-19',6),
  (104,104,16,'p','1-04-19',6),
  (105,105,16,'p','1-04-19',6),
  (106,106,16,'p','1-04-19',6),
  (107,107,16,'p','1-04-19',6),
  (108,108,16,'p','1-04-19',6),
  (109,109,16,'p','1-04-19',6),
  (110,110,16,'p','1-04-19',6);
INSERT INTO [Attendance] (att_id,student_id,subject_id,status,date,section_id)
VALUES
  (111,111,16,'p','1-04-19',6),
  (112,112,16,'p','1-04-19',6),
  (113,113,16,'p','1-04-19',6),
  (114,114,16,'p','1-04-19',6),
  (115,115,16,'p','1-04-19',6),
  (116,116,16,'p','1-04-19',6),
  (117,117,16,'p','1-04-19',6),
  (118,118,16,'p','1-04-19',6),
  (119,119,16,'p','1-04-19',6),
  (120,120,16,'p','1-04-19',6);
INSERT INTO [Attendance] (att_id,student_id,subject_id,status,date,section_id)
VALUES
  (121,121,19,'p','1-04-19',7),
  (122,122,19,'p','1-04-19',7),
  (123,123,19,'p','1-04-19',7),
  (124,124,19,'p','1-04-19',7),
  (125,125,19,'p','1-04-19',7),
  (126,126,19,'p','1-04-19',7),
  (127,127,19,'p','1-04-19',7),
  (128,128,19,'p','1-04-19',7),
  (129,129,19,'p','1-04-19',7),
  (130,130,19,'p','1-04-19',7);
INSERT INTO [Attendance] (att_id,student_id,subject_id,status,date,section_id)
VALUES
  (131,131,19,'p','1-04-19',7),
  (132,132,19,'p','1-04-19',7),
  (133,133,19,'p','1-04-19',7),
  (134,134,19,'p','1-04-19',7),
  (135,135,19,'p','1-04-19',7),
  (136,136,19,'p','1-04-19',7),
  (137,137,19,'p','1-04-19',7),
  (138,138,19,'p','1-04-19',7),
  (139,139,19,'p','1-04-19',7),
  (140,140,19,'p','1-04-19',7);
INSERT INTO [Attendance] (att_id,student_id,subject_id,status,date,section_id)
VALUES
  (141,141,22,'p','1-04-19',8),
  (142,142,22,'p','1-04-19',8),
  (143,143,22,'p','1-04-19',8),
  (144,144,22,'p','1-04-19',8),
  (145,145,22,'p','1-04-19',8),
  (146,146,22,'p','1-04-19',8),
  (147,147,22,'p','1-04-19',8),
  (148,148,22,'p','1-04-19',8),
  (149,149,22,'p','1-04-19',8),
  (150,150,22,'p','1-04-19',8);
INSERT INTO [Attendance] (att_id,student_id,subject_id,status,date,section_id)
VALUES
  (151,151,22,'p','1-04-19',8),
  (152,152,22,'p','1-04-19',8),
  (153,153,22,'p','1-04-19',8),
  (154,154,22,'p','1-04-19',8),
  (155,155,22,'p','1-04-19',8),
  (156,156,22,'p','1-04-19',8),
  (157,157,22,'p','1-04-19',8),
  (158,158,22,'p','1-04-19',8),
  (159,159,22,'p','1-04-19',8),
  (160,160,22,'p','1-04-19',8);
INSERT INTO [Attendance] (att_id,student_id,subject_id,status,date,section_id)
VALUES
  (161,161,25,'p','1-04-19',9),
  (162,162,25,'p','1-04-19',9),
  (163,163,25,'p','1-04-19',9),
  (164,164,25,'p','1-04-19',9),
  (165,165,25,'p','1-04-19',9),
  (166,166,25,'p','1-04-19',9),
  (167,167,25,'p','1-04-19',9),
  (168,168,25,'p','1-04-19',9),
  (169,169,25,'p','1-04-19',9),
  (170,170,25,'p','1-04-19',9);
INSERT INTO [Attendance] (att_id,student_id,subject_id,status,date,section_id)
VALUES
  (171,171,25,'p','1-04-19',9),
  (172,172,25,'p','1-04-19',9),
  (173,173,25,'p','1-04-19',9),
  (174,174,25,'p','1-04-19',9),
  (175,175,25,'p','1-04-19',9),
  (176,176,25,'p','1-04-19',9),
  (177,177,25,'p','1-04-19',9),
  (178,178,25,'p','1-04-19',9),
  (179,179,25,'p','1-04-19',9),
  (180,180,25,'p','1-04-19',9);
  INSERT INTO [Attendance] (att_id,student_id,subject_id,status,date,section_id)
VALUES
  (181,181,28,'p','1-04-19',10),
  (182,182,28,'p','1-04-19',10),
  (183,183,28,'p','1-04-19',10),
  (184,184,28,'p','1-04-19',10),
  (185,185,28,'p','1-04-19',10),
  (186,186,28,'p','1-04-19',10),
  (187,187,28,'p','1-04-19',10),
  (188,188,28,'p','1-04-19',10),
  (189,189,28,'p','1-04-19',10),
  (190,190,28,'p','1-04-19',10);
INSERT INTO [Attendance] (att_id,student_id,subject_id,status,date,section_id)
VALUES
  (191,191,28,'p','1-04-19',10),
  (192,192,28,'p','1-04-19',10),
  (193,193,28,'p','1-04-19',10),
  (194,194,28,'p','1-04-19',10),
  (195,195,28,'p','1-04-19',10),
  (196,196,28,'p','1-04-19',10),
  (197,197,28,'p','1-04-19',10),
  (198,198,28,'p','1-04-19',10),
  (199,199,28,'p','1-04-19',10),
  (200,200,28,'p','1-04-19',10);
INSERT INTO [Attendance] (att_id,student_id,subject_id,status,date,section_id)
VALUES
  (201,201,31,'p','1-04-19',11),
  (202,202,31,'p','1-04-19',11),
  (203,203,31,'p','1-04-19',11),
  (204,204,31,'p','1-04-19',11),
  (205,205,31,'p','1-04-19',11),
  (206,206,31,'p','1-04-19',11),
  (207,207,31,'p','1-04-19',11),
  (208,208,31,'p','1-04-19',11),
  (209,209,31,'p','1-04-19',11),
  (210,210,31,'p','1-04-19',11);
INSERT INTO [Attendance] (att_id,student_id,subject_id,status,date,section_id)
VALUES
  (211,211,31,'p','1-04-19',11),
  (212,212,31,'p','1-04-19',11),
  (213,213,31,'p','1-04-19',11),
  (214,214,31,'p','1-04-19',11),
  (215,215,31,'p','1-04-19',11),
  (216,216,31,'p','1-04-19',11),
  (217,217,31,'p','1-04-19',11),
  (218,218,31,'p','1-04-19',11),
  (219,219,31,'p','1-04-19',11),
  (220,220,31,'p','1-04-19',11);
INSERT INTO [Attendance] (att_id,student_id,subject_id,status,date,section_id)
VALUES
  (221,221,34,'p','1-04-19',12),
  (222,222,34,'p','1-04-19',12),
  (223,223,34,'p','1-04-19',12),
  (224,224,34,'p','1-04-19',12),
  (225,225,34,'p','1-04-19',12),
  (226,226,34,'p','1-04-19',12),
  (227,227,34,'p','1-04-19',12),
  (228,228,34,'p','1-04-19',12),
  (229,229,34,'p','1-04-19',12),
  (230,230,34,'p','1-04-19',12);
INSERT INTO [Attendance] (att_id,student_id,subject_id,status,date,section_id)
VALUES
  (231,231,34,'p','1-04-19',12),
  (232,232,34,'p','1-04-19',12),
  (233,233,34,'p','1-04-19',12),
  (234,234,34,'p','1-04-19',12),
  (235,235,34,'p','1-04-19',12),
  (236,236,34,'p','1-04-19',12),
  (237,237,34,'p','1-04-19',12),
  (238,238,34,'p','1-04-19',12),
  (239,239,34,'p','1-04-19',12),
  (240,240,34,'p','1-04-19',12);
INSERT INTO [Attendance] (att_id,student_id,subject_id,status,date,section_id)
VALUES
  (241,241,37,'p','1-04-19',13),
  (242,242,37,'p','1-04-19',13),
  (243,243,37,'p','1-04-19',13),
  (244,244,37,'p','1-04-19',13),
  (245,245,37,'p','1-04-19',13),
  (246,246,37,'p','1-04-19',13),
  (247,247,37,'p','1-04-19',13),
  (248,248,37,'p','1-04-19',13),
  (249,249,37,'p','1-04-19',13),
  (250,250,37,'p','1-04-19',13);
INSERT INTO [Attendance] (att_id,student_id,subject_id,status,date,section_id)
VALUES
  (251,251,37,'p','1-04-19',13),
  (252,252,37,'p','1-04-19',13),
  (253,253,37,'p','1-04-19',13),
  (254,254,37,'p','1-04-19',13),
  (255,255,37,'p','1-04-19',13),
  (256,256,37,'p','1-04-19',13),
  (257,257,37,'p','1-04-19',13),
  (258,258,37,'p','1-04-19',13),
  (259,259,37,'p','1-04-19',13),
  (260,260,37,'p','1-04-19',13);
INSERT INTO [Attendance] (att_id,student_id,subject_id,status,date,section_id)
VALUES
  (261,261,40,'p','1-04-19',14),
  (262,262,40,'p','1-04-19',14),
  (263,263,40,'p','1-04-19',14),
  (264,264,40,'p','1-04-19',14),
  (265,265,40,'p','1-04-19',14),
  (266,266,40,'p','1-04-19',14),
  (267,267,40,'p','1-04-19',14),
  (268,268,40,'p','1-04-19',14),
  (269,269,40,'p','1-04-19',14),
  (270,270,40,'p','1-04-19',14);
INSERT INTO [Attendance] (att_id,student_id,subject_id,status,date,section_id)
VALUES
  (271,271,40,'p','1-04-19',14),
  (272,272,40,'p','1-04-19',14),
  (273,273,40,'p','1-04-19',14),
  (274,274,40,'p','1-04-19',14),
  (275,275,40,'p','1-04-19',14),
  (276,276,40,'p','1-04-19',14),
  (277,277,40,'p','1-04-19',14),
  (278,278,40,'p','1-04-19',14),
  (279,279,40,'p','1-04-19',14),
  (280,280,40,'p','1-04-19',14);
INSERT INTO [Attendance] (att_id,student_id,subject_id,status,date,section_id)
VALUES
  (281,281,43,'p','1-04-19',15),
  (282,282,43,'p','1-04-19',15),
  (283,283,43,'p','1-04-19',15),
  (284,284,43,'p','1-04-19',15),
  (285,285,43,'p','1-04-19',15),
  (286,286,43,'p','1-04-19',15),
  (287,287,43,'p','1-04-19',15),
  (288,288,43,'p','1-04-19',15),
  (289,289,43,'p','1-04-19',15),
  (290,290,43,'p','1-04-19',15);
INSERT INTO [Attendance] (att_id,student_id,subject_id,status,date,section_id)
VALUES
  (291,291,43,'p','1-04-19',15),
  (292,292,43,'p','1-04-19',15),
  (293,293,43,'p','1-04-19',15),
  (294,294,43,'p','1-04-19',15),
  (295,295,43,'p','1-04-19',15),
  (296,296,43,'p','1-04-19',15),
  (297,297,43,'p','1-04-19',15),
  (298,298,43,'p','1-04-19',15),
  (299,299,43,'p','1-04-19',15),
  (300,300,43,'p','1-04-19',15);
INSERT INTO [Attendance] (att_id,student_id,subject_id,status,date,section_id)
VALUES
  (301,301,46,'p','1-04-19',16),
  (302,302,46,'p','1-04-19',16),
  (303,303,46,'p','1-04-19',16),
  (304,304,46,'p','1-04-19',16),
  (305,305,46,'p','1-04-19',16),
  (306,306,46,'p','1-04-19',16),
  (307,307,46,'p','1-04-19',16),
  (308,308,46,'p','1-04-19',16),
  (309,309,46,'p','1-04-19',16),
  (310,310,46,'p','1-04-19',16);
INSERT INTO [Attendance] (att_id,student_id,subject_id,status,date,section_id)
VALUES
  (311,311,46,'p','1-04-19',16),
  (312,312,46,'p','1-04-19',16),
  (313,313,46,'p','1-04-19',16),
  (314,314,46,'p','1-04-19',16),
  (315,315,46,'p','1-04-19',16),
  (316,316,46,'p','1-04-19',16),
  (317,317,46,'p','1-04-19',16),
  (318,318,46,'p','1-04-19',16),
  (319,319,46,'p','1-04-19',16),
  (320,320,46,'p','1-04-19',16);
INSERT INTO [Attendance] (att_id,student_id,subject_id,status,date,section_id)
VALUES
  (321,321,49,'A','1-04-19',17),
  (322,322,49,'A','1-04-19',17),
  (323,323,49,'A','1-04-19',17),
  (324,324,49,'A','1-04-19',17),
  (325,325,49,'A','1-04-19',17),
  (326,326,49,'A','1-04-19',17),
  (327,327,49,'A','1-04-19',17),
  (328,328,49,'A','1-04-19',17),
  (329,329,49,'A','1-04-19',17),
  (330,330,49,'A','1-04-19',17);
INSERT INTO [Attendance] (att_id,student_id,subject_id,status,date,section_id)
VALUES
  (331,331,49,'A','1-04-19',17),
  (332,332,49,'A','1-04-19',17),
  (333,333,49,'A','1-04-19',17),
  (334,334,49,'A','1-04-19',17),
  (335,335,49,'A','1-04-19',17),
  (336,336,49,'A','1-04-19',17),
  (337,337,49,'A','1-04-19',17),
  (338,338,49,'A','1-04-19',17),
  (339,339,49,'A','1-04-19',17),
  (340,340,49,'A','1-04-19',17);
INSERT INTO [Attendance] (att_id,student_id,subject_id,status,date,section_id)
VALUES
  (341,341,52,'A','1-04-19',18),
  (342,342,52,'A','1-04-19',18),
  (343,343,52,'A','1-04-19',18),
  (344,344,52,'A','1-04-19',18),
  (345,345,52,'A','1-04-19',18),
  (346,346,52,'A','1-04-19',18),
  (347,347,52,'A','1-04-19',18),
  (348,348,52,'A','1-04-19',18),
  (349,349,52,'A','1-04-19',18),
  (350,350,52,'A','1-04-19',18);
INSERT INTO [Attendance] (att_id,student_id,subject_id,status,date,section_id)
VALUES
  (351,351,52,'A','1-04-19',18),
  (352,352,52,'A','1-04-19',18),
  (353,353,52,'A','1-04-19',18),
  (354,354,52,'A','1-04-19',18),
  (355,355,52,'A','1-04-19',18),
  (356,356,52,'A','1-04-19',18),
  (357,357,52,'A','1-04-19',18),
  (358,358,52,'A','1-04-19',18),
  (359,359,52,'A','1-04-19',18),
  (360,360,52,'A','1-04-19',18);
  INSERT INTO [Attendance] (att_id,student_id,subject_id,status,date,section_id)
VALUES
  (361,361,55,'A','1-04-19',19),
  (362,362,55,'A','1-04-19',19),
  (363,363,55,'A','1-04-19',19),
  (364,364,55,'A','1-04-19',19),
  (365,365,55,'A','1-04-19',19),
  (366,366,55,'A','1-04-19',19),
  (367,367,55,'A','1-04-19',19),
  (368,368,55,'A','1-04-19',19),
  (369,369,55,'A','1-04-19',19),
  (370,370,55,'A','1-04-19',19);
INSERT INTO [Attendance] (att_id,student_id,subject_id,status,date,section_id)
VALUES
  (371,371,55,'A','1-04-19',19),
  (372,372,55,'A','1-04-19',19),
  (373,373,55,'A','1-04-19',19),
  (374,374,55,'A','1-04-19',19),
  (375,375,55,'A','1-04-19',19),
  (376,376,55,'A','1-04-19',19),
  (377,377,55,'A','1-04-19',19),
  (378,378,55,'A','1-04-19',19),
  (379,379,55,'A','1-04-19',19),
  (380,380,55,'A','1-04-19',19);

  --Examination
  INSERT INTO [Examinations] (ex_id,type,date,subject_id,class_id,section_id,department_id)
VALUES
  (1,'Mid Term','1-20-19',1,1,1,5),
  (2,'Mid Term','1-20-19',2,1,1,5),
  (3,'Mid Term','1-20-19',3,1,1,5),
  (4,'Mid Term','1-20-19',4,2,2,5),
  (5,'Mid Term','1-20-19',5,2,2,5),
  (6,'Mid Term','1-20-19',6,2,2,5),
  (7,'Mid Term','1-20-19',7,3,3,5),
  (8,'Mid Term','1-20-19',8,3,3,5),
  (9,'Mid Term','1-20-19',9,3,3,5),
  (10,'Mid Term','1-20-19',10,4,4,5);
INSERT INTO [Examinations] (ex_id,type,date,subject_id,class_id,section_id,department_id)
VALUES
  (11,'Mid Term','1-20-19',11,4,4,5),
  (12,'Mid Term','1-20-19',12,4,4,5),
  (13,'Mid Term','1-20-19',13,5,5,5),
  (14,'Mid Term','1-20-19',14,5,5,5),
  (15,'Mid Term','1-20-19',15,5,5,5),
  (16,'Mid Term','1-20-19',16,6,6,5),
  (17,'Mid Term','1-20-19',17,6,6,5),
  (18,'Mid Term','1-20-19',18,6,6,5),
  (19,'Mid Term','1-20-19',19,7,7,5),
  (20,'Mid Term','1-20-19',20,7,7,5);
INSERT INTO [Examinations] (ex_id,type,date,subject_id,class_id,section_id,department_id)
VALUES
  (21,'Mid Term','1-20-19',21,7,7,5),
  (22,'Mid Term','1-20-19',22,8,8,5),
  (23,'Mid Term','1-20-19',23,8,8,5),
  (24,'Mid Term','1-20-19',24,8,8,5),
  (25,'Mid Term','1-20-19',25,9,9,5),
  (26,'Mid Term','1-20-19',26,9,9,5),
  (27,'Mid Term','1-20-19',27,9,9,5),
  (28,'Mid Term','1-20-19',28,10,10,5),
  (29,'Mid Term','1-20-19',29,10,10,5),
  (30,'Mid Term','1-20-19',30,10,10,5);
INSERT INTO [Examinations] (ex_id,type,date,subject_id,class_id,section_id,department_id)
VALUES
  (31,'Mid Term','1-20-19',31,11,11,5),
  (32,'Mid Term','1-20-19',32,11,11,5),
  (33,'Mid Term','1-20-19',33,11,11,5),
  (34,'Mid Term','1-20-19',34,12,12,4),
  (35,'Mid Term','1-20-19',35,12,12,4),
  (36,'Mid Term','1-20-19',36,12,12,4),
  (37,'Mid Term','1-20-19',37,13,13,4),
  (38,'Mid Term','1-20-19',38,13,13,4),
  (39,'Mid Term','1-20-19',39,13,13,4),
  (40,'Mid Term','1-20-19',40,14,14,3);
INSERT INTO [Examinations] (ex_id,type,date,subject_id,class_id,section_id,department_id)
VALUES
  (41,'Mid Term','1-20-19',41,14,14,3),
  (42,'Mid Term','1-20-19',42,14,14,3),
  (43,'Mid Term','1-20-19',43,15,15,3),
  (44,'Mid Term','1-20-19',44,15,15,3),
  (45,'Mid Term','1-20-19',45,15,15,3),
  (46,'Mid Term','1-20-19',46,16,16,2),
  (47,'Mid Term','1-20-19',47,16,16,2),
  (48,'Mid Term','1-20-19',48,16,16,2),
  (49,'Mid Term','1-20-19',49,17,17,2),
  (50,'Mid Term','1-20-19',50,17,17,2);
INSERT INTO [Examinations] (ex_id,type,date,subject_id,class_id,section_id,department_id)
VALUES
  (51,'Mid Term','1-20-19',51,17,17,2),
  (52,'Mid Term','1-20-19',52,18,18,1),
  (53,'Mid Term','1-20-19',53,18,18,1),
  (54,'Mid Term','1-20-19',54,18,18,1),
  (55,'Mid Term','1-20-19',55,19,19,1),
  (56,'Mid Term','1-20-19',56,19,19,1),
  (57,'Mid Term','1-20-19',57,19,19,1);

--Marks
INSERT INTO [Marks] (marks_id,total_marks,obtained_marks,subject_id,student_id,ex_id)
VALUES
  (1,100,66,1,1,1),
  (2,100,66,1,2,1),
  (3,100,66,1,3,1),
  (4,100,68,1,4,1),
  (5,100,68,1,5,1),
  (6,100,68,1,6,1),
  (7,100,75,1,7,1),
  (8,100,75,1,8,1),
  (9,100,75,1,9,1),
  (10,100,79,1,10,1);
INSERT INTO [Marks] (marks_id,total_marks,obtained_marks,subject_id,student_id,ex_id)
VALUES
  (11,100,79,1,11,1),
  (12,100,79,1,12,1),
  (13,100,85,1,13,1),
  (14,100,85,1,14,1),
  (15,100,85,1,15,1),
  (16,100,90,1,16,1),
  (17,100,90,1,17,1),
  (18,100,90,1,18,1),
  (19,100,92,1,19,1),
  (20,100,92,1,20,1);
INSERT INTO [Marks] (marks_id,total_marks,obtained_marks,subject_id,student_id,ex_id)
VALUES
  (21,100,92,4,21,4),
  (22,100,83,4,22,4),
  (23,100,83,4,23,4),
  (24,100,83,4,24,4),
  (25,100,88,4,25,4),
  (26,100,88,4,26,4),
  (27,100,88,4,27,4),
  (28,100,66,4,28,4),
  (29,100,66,4,29,4),
  (30,100,66,4,30,4);
INSERT INTO [Marks] (marks_id,total_marks,obtained_marks,subject_id,student_id,ex_id)
VALUES
  (31,100,68,4,31,4),
  (32,100,68,4,32,4),
  (33,100,68,4,33,4),
  (34,100,75,4,34,4),
  (35,100,75,4,35,4),
  (36,100,75,4,36,4),
  (37,100,79,4,37,4),
  (38,100,79,4,38,4),
  (39,100,79,4,39,4),
  (40,100,85,4,40,4);
INSERT INTO [Marks] (marks_id,total_marks,obtained_marks,subject_id,student_id,ex_id)
VALUES
  (41,100,85,7,41,7),
  (42,100,85,7,42,7),
  (43,100,90,7,43,7),
  (44,100,90,7,44,7),
  (45,100,90,7,45,7),
  (46,100,92,7,46,7),
  (47,100,92,7,47,7),
  (48,100,92,7,48,7),
  (49,100,83,7,49,7),
  (50,100,83,7,50,7);
INSERT INTO [Marks] (marks_id,total_marks,obtained_marks,subject_id,student_id,ex_id)
VALUES
  (51,100,83,7,51,7),
  (52,100,88,7,52,7),
  (53,100,88,7,53,7),
  (54,100,88,7,54,7),
  (55,100,66,7,55,7),
  (56,100,66,7,56,7),
  (57,100,66,7,57,7),
  (58,100,68,7,58,7),
  (59,100,68,7,59,7),
  (60,100,68,7,60,7);
INSERT INTO [Marks] (marks_id,total_marks,obtained_marks,subject_id,student_id,ex_id)
VALUES
  (61,100,75,10,61,10),
  (62,100,75,10,62,10),
  (63,100,75,10,63,10),
  (64,100,79,10,64,10),
  (65,100,79,10,65,10),
  (66,100,79,10,66,10),
  (67,100,85,10,67,10),
  (68,100,85,10,68,10),
  (69,100,85,10,69,10),
  (70,100,90,10,70,10);
INSERT INTO [Marks] (marks_id,total_marks,obtained_marks,subject_id,student_id,ex_id)
VALUES
  (71,100,90,10,71,10),
  (72,100,90,10,72,10),
  (73,100,92,10,73,10),
  (74,100,92,10,74,10),
  (75,100,92,10,75,10),
  (76,100,83,10,76,10),
  (77,100,83,10,77,10),
  (78,100,83,10,78,10),
  (79,100,88,10,79,10),
  (80,100,88,10,80,10);
INSERT INTO [Marks] (marks_id,total_marks,obtained_marks,subject_id,student_id,ex_id)
VALUES
  (81,100,88,13,81,13),
  (82,100,66,13,82,13),
  (83,100,66,13,83,13),
  (84,100,66,13,84,13),
  (85,100,68,13,85,13),
  (86,100,68,13,86,13),
  (87,100,68,13,87,13),
  (88,100,75,13,88,13),
  (89,100,75,13,89,13),
  (90,100,75,13,90,13);
INSERT INTO [Marks] (marks_id,total_marks,obtained_marks,subject_id,student_id,ex_id)
VALUES
  (91,100,79,13,91,13),
  (92,100,79,13,92,13),
  (93,100,79,13,93,13),
  (94,100,85,13,94,13),
  (95,100,85,13,95,13),
  (96,100,85,13,96,13),
  (97,100,90,13,97,13),
  (98,100,90,13,98,13),
  (99,100,90,13,99,13),
  (100,100,92,13,100,13);
INSERT INTO [Marks] (marks_id,total_marks,obtained_marks,subject_id,student_id,ex_id)
VALUES
  (101,100,92,16,101,16),
  (102,100,92,16,102,16),
  (103,100,83,16,103,16),
  (104,100,83,16,104,16),
  (105,100,83,16,105,16),
  (106,100,88,16,106,16),
  (107,100,88,16,107,16),
  (108,100,88,16,108,16),
  (109,100,66,16,109,16),
  (110,100,66,16,110,16);
INSERT INTO [Marks] (marks_id,total_marks,obtained_marks,subject_id,student_id,ex_id)
VALUES
  (111,100,66,16,111,16),
  (112,100,68,16,112,16),
  (113,100,68,16,113,16),
  (114,100,68,16,114,16),
  (115,100,75,16,115,16),
  (116,100,75,16,116,16),
  (117,100,75,16,117,16),
  (118,100,79,16,118,16),
  (119,100,79,16,119,16),
  (120,100,79,16,120,16);
INSERT INTO [Marks] (marks_id,total_marks,obtained_marks,subject_id,student_id,ex_id)
VALUES
  (121,100,85,19,121,19),
  (122,100,85,19,122,19),
  (123,100,85,19,123,19),
  (124,100,90,19,124,19),
  (125,100,90,19,125,19),
  (126,100,90,19,126,19),
  (127,100,92,19,127,19),
  (128,100,92,19,128,19),
  (129,100,92,19,129,19),
  (130,100,83,19,130,19);
INSERT INTO [Marks] (marks_id,total_marks,obtained_marks,subject_id,student_id,ex_id)
VALUES
  (131,100,83,19,131,19),
  (132,100,83,19,132,19),
  (133,100,88,19,133,19),
  (134,100,88,19,134,19),
  (135,100,88,19,135,19),
  (136,100,66,19,136,19),
  (137,100,66,19,137,19),
  (138,100,66,19,138,19),
  (139,100,68,19,139,19),
  (140,100,68,19,140,19);
INSERT INTO [Marks] (marks_id,total_marks,obtained_marks,subject_id,student_id,ex_id)
VALUES
  (141,100,68,22,141,22),
  (142,100,75,22,142,22),
  (143,100,75,22,143,22),
  (144,100,75,22,144,22),
  (145,100,79,22,145,22),
  (146,100,79,22,146,22),
  (147,100,79,22,147,22),
  (148,100,85,22,148,22),
  (149,100,85,22,149,22),
  (150,100,85,22,150,22);
INSERT INTO [Marks] (marks_id,total_marks,obtained_marks,subject_id,student_id,ex_id)
VALUES
  (151,100,90,22,151,22),
  (152,100,90,22,152,22),
  (153,100,90,22,153,22),
  (154,100,92,22,154,22),
  (155,100,92,22,155,22),
  (156,100,92,22,156,22),
  (157,100,83,22,157,22),
  (158,100,83,22,158,22),
  (159,100,83,22,159,22),
  (160,100,88,22,160,22);
INSERT INTO [Marks] (marks_id,total_marks,obtained_marks,subject_id,student_id,ex_id)
VALUES
  (161,100,88,25,161,25),
  (162,100,88,25,162,25),
  (163,100,66,25,163,25),
  (164,100,66,25,164,25),
  (165,100,66,25,165,25),
  (166,100,68,25,166,25),
  (167,100,68,25,167,25),
  (168,100,68,25,168,25),
  (169,100,75,25,169,25),
  (170,100,75,25,170,25);
INSERT INTO [Marks] (marks_id,total_marks,obtained_marks,subject_id,student_id,ex_id)
VALUES
  (171,100,75,25,171,25),
  (172,100,79,25,172,25),
  (173,100,79,25,173,25),
  (174,100,79,25,174,25),
  (175,100,85,25,175,25),
  (176,100,85,25,176,25),
  (177,100,85,25,177,25),
  (178,100,90,25,178,25),
  (179,100,90,25,179,25),
  (180,100,90,25,180,25);
INSERT INTO [Marks] (marks_id,total_marks,obtained_marks,subject_id,student_id,ex_id)
VALUES
  (181,100,92,28,181,28),
  (182,100,92,28,182,28),
  (183,100,92,28,183,28),
  (184,100,83,28,184,28),
  (185,100,83,28,185,28),
  (186,100,83,28,186,28),
  (187,100,88,28,187,28),
  (188,100,88,28,188,28),
  (189,100,88,28,189,28),
  (190,100,66,28,190,28);
INSERT INTO [Marks] (marks_id,total_marks,obtained_marks,subject_id,student_id,ex_id)
VALUES
  (191,100,66,28,191,28),
  (192,100,66,28,192,28),
  (193,100,68,28,193,28),
  (194,100,68,28,194,28),
  (195,100,68,28,195,28),
  (196,100,75,28,196,28),
  (197,100,75,28,197,28),
  (198,100,75,28,198,28),
  (199,100,79,28,199,28),
  (200,100,79,28,200,28);
INSERT INTO [Marks] (marks_id,total_marks,obtained_marks,subject_id,student_id,ex_id)
VALUES
  (201,100,79,31,201,31),
  (202,100,85,31,202,31),
  (203,100,85,31,203,31),
  (204,100,85,31,204,31),
  (205,100,90,31,205,31),
  (206,100,90,31,206,31),
  (207,100,90,31,207,31),
  (208,100,92,31,208,31),
  (209,100,92,31,209,31),
  (210,100,92,31,210,31);
INSERT INTO [Marks] (marks_id,total_marks,obtained_marks,subject_id,student_id,ex_id)
VALUES
  (211,100,83,31,211,31),
  (212,100,83,31,212,31),
  (213,100,83,31,213,31),
  (214,100,88,31,214,31),
  (215,100,88,31,215,31),
  (216,100,88,31,216,31),
  (217,100,66,31,217,31),
  (218,100,66,31,218,31),
  (219,100,66,31,219,31),
  (220,100,68,31,220,31);
INSERT INTO [Marks] (marks_id,total_marks,obtained_marks,subject_id,student_id,ex_id)
VALUES
  (221,100,68,34,221,34),
  (222,100,68,34,222,34),
  (223,100,75,34,223,34),
  (224,100,75,34,224,34),
  (225,100,75,34,225,34),
  (226,100,79,34,226,34),
  (227,100,79,34,227,34),
  (228,100,79,34,228,34),
  (229,100,85,34,229,34),
  (230,100,85,34,230,34);
INSERT INTO [Marks] (marks_id,total_marks,obtained_marks,subject_id,student_id,ex_id)
VALUES
  (231,100,85,34,231,34),
  (232,100,90,34,232,34),
  (233,100,90,34,233,34),
  (234,100,90,34,234,34),
  (235,100,92,34,235,34),
  (236,100,92,34,236,34),
  (237,100,92,34,237,34),
  (238,100,83,34,238,34),
  (239,100,83,34,239,34),
  (240,100,83,34,240,34);
INSERT INTO [Marks] (marks_id,total_marks,obtained_marks,subject_id,student_id,ex_id)
VALUES
  (241,100,88,37,241,37),
  (242,100,88,37,242,37),
  (243,100,88,37,243,37),
  (244,100,66,37,244,37),
  (245,100,66,37,245,37),
  (246,100,66,37,246,37),
  (247,100,68,37,247,37),
  (248,100,68,37,248,37),
  (249,100,68,37,249,37),
  (250,100,75,37,250,37);
INSERT INTO [Marks] (marks_id,total_marks,obtained_marks,subject_id,student_id,ex_id)
VALUES
  (251,100,75,37,251,37),
  (252,100,75,37,252,37),
  (253,100,79,37,253,37),
  (254,100,79,37,254,37),
  (255,100,79,37,255,37),
  (256,100,85,37,256,37),
  (257,100,85,37,257,37),
  (258,100,85,37,258,37),
  (259,100,90,37,259,37),
  (260,100,90,37,260,37);
INSERT INTO [Marks] (marks_id,total_marks,obtained_marks,subject_id,student_id,ex_id)
VALUES
  (261,100,90,40,261,40),
  (262,100,92,40,262,40),
  (263,100,92,40,263,40),
  (264,100,92,40,264,40),
  (265,100,83,40,265,40),
  (266,100,83,40,266,40),
  (267,100,83,40,267,40),
  (268,100,88,40,268,40),
  (269,100,88,40,269,40),
  (270,100,88,40,270,40);
INSERT INTO [Marks] (marks_id,total_marks,obtained_marks,subject_id,student_id,ex_id)
VALUES
  (271,100,66,40,271,40),
  (272,100,66,40,272,40),
  (273,100,66,40,273,40),
  (274,100,68,40,274,40),
  (275,100,68,40,275,40),
  (276,100,68,40,276,40),
  (277,100,75,40,277,40),
  (278,100,75,40,278,40),
  (279,100,75,40,279,40),
  (280,100,79,40,280,40);
INSERT INTO [Marks] (marks_id,total_marks,obtained_marks,subject_id,student_id,ex_id)
VALUES
  (281,100,79,43,281,43),
  (282,100,79,43,282,43),
  (283,100,85,43,283,43),
  (284,100,85,43,284,43),
  (285,100,85,43,285,43),
  (286,100,90,43,286,43),
  (287,100,90,43,287,43),
  (288,100,90,43,288,43),
  (289,100,92,43,289,43),
  (290,100,92,43,290,43);
INSERT INTO [Marks] (marks_id,total_marks,obtained_marks,subject_id,student_id,ex_id)
VALUES
  (291,100,92,43,291,43),
  (292,100,83,43,292,43),
  (293,100,83,43,293,43),
  (294,100,83,43,294,43),
  (295,100,88,43,295,43),
  (296,100,88,43,296,43),
  (297,100,88,43,297,43),
  (298,100,66,43,298,43),
  (299,100,66,43,299,43),
  (300,100,66,43,300,43);
INSERT INTO [Marks] (marks_id,total_marks,obtained_marks,subject_id,student_id,ex_id)
VALUES
  (301,100,68,46,301,46),
  (302,100,68,46,302,46),
  (303,100,68,46,303,46),
  (304,100,75,46,304,46),
  (305,100,75,46,305,46),
  (306,100,75,46,306,46),
  (307,100,79,46,307,46),
  (308,100,79,46,308,46),
  (309,100,79,46,309,46),
  (310,100,85,46,310,46);
INSERT INTO [Marks] (marks_id,total_marks,obtained_marks,subject_id,student_id,ex_id)
VALUES
  (311,100,85,46,311,46),
  (312,100,85,46,312,46),
  (313,100,90,46,313,46),
  (314,100,90,46,314,46),
  (315,100,90,46,315,46),
  (316,100,92,46,316,46),
  (317,100,92,46,317,46),
  (318,100,92,46,318,46),
  (319,100,83,46,319,46),
  (320,100,83,46,320,46);
INSERT INTO [Marks] (marks_id,total_marks,obtained_marks,subject_id,student_id,ex_id)
VALUES
  (321,100,83,49,321,49),
  (322,100,88,49,322,49),
  (323,100,88,49,323,49),
  (324,100,88,49,324,49),
  (325,100,66,49,325,49),
  (326,100,66,49,326,49),
  (327,100,66,49,327,49),
  (328,100,68,49,328,49),
  (329,100,68,49,329,49),
  (330,100,68,49,330,49);
INSERT INTO [Marks] (marks_id,total_marks,obtained_marks,subject_id,student_id,ex_id)
VALUES
  (331,100,75,49,331,49),
  (332,100,75,49,332,49),
  (333,100,75,49,333,49),
  (334,100,79,49,334,49),
  (335,100,79,49,335,49),
  (336,100,79,49,336,49),
  (337,100,85,49,337,49),
  (338,100,85,49,338,49),
  (339,100,85,49,339,49),
  (340,100,90,49,340,49);
INSERT INTO [Marks] (marks_id,total_marks,obtained_marks,subject_id,student_id,ex_id)
VALUES
  (341,100,90,52,341,52),
  (342,100,90,52,342,52),
  (343,100,92,52,343,52),
  (344,100,92,52,344,52),
  (345,100,92,52,345,52),
  (346,100,83,52,346,52),
  (347,100,83,52,347,52),
  (348,100,83,52,348,52),
  (349,100,88,52,349,52),
  (350,100,88,52,350,52);
INSERT INTO [Marks] (marks_id,total_marks,obtained_marks,subject_id,student_id,ex_id)
VALUES
  (351,100,88,52,351,52),
  (352,100,66,52,352,52),
  (353,100,66,52,353,52),
  (354,100,66,52,354,52),
  (355,100,68,52,355,52),
  (356,100,68,52,356,52),
  (357,100,68,52,357,52),
  (358,100,75,52,358,52),
  (359,100,75,52,359,52),
  (360,100,75,52,360,52);
INSERT INTO [Marks] (marks_id,total_marks,obtained_marks,subject_id,student_id,ex_id)
VALUES
  (361,100,79,55,361,55),
  (362,100,79,55,362,55),
  (363,100,79,55,363,55),
  (364,100,85,55,364,55),
  (365,100,85,55,365,55),
  (366,100,85,55,366,55),
  (367,100,90,55,367,55),
  (368,100,90,55,368,55),
  (369,100,90,55,369,55),
  (370,100,92,55,370,55);
INSERT INTO [Marks] (marks_id,total_marks,obtained_marks,subject_id,student_id,ex_id)
VALUES
  (371,100,92,55,371,55),
  (372,100,92,55,372,55),
  (373,100,83,55,373,55),
  (374,100,83,55,374,55),
  (375,100,83,55,375,55),
  (376,100,88,55,376,55),
  (377,100,88,55,377,55),
  (378,100,88,55,378,55),
  (379,100,66,55,379,55),
  (380,100,66,55,380,55);


  --Accounts
  INSERT INTO [Accounts] (acc_id,voucher_no,total_fee,issue_date,due_date,status,student_id)
VALUES
  (1,1,10000,'1-05-19','1-06-19','Paid',1),
  (2,2,10000,'1-05-19','1-06-19','Paid',2),
  (3,3,10000,'1-05-19','1-06-19','Paid',3),
  (4,4,10000,'1-05-19','1-06-19','Paid',4),
  (5,5,10000,'1-05-19','1-06-19','Paid',5),
  (6,6,10000,'1-05-19','1-06-19','Paid',6),
  (7,7,10000,'1-05-19','1-06-19','Paid',7),
  (8,8,10000,'1-05-19','1-06-19','Paid',8),
  (9,9,10000,'1-05-19','1-06-19','Paid',9),
  (10,10,10000,'1-05-19','1-06-19','Paid',10);
INSERT INTO [Accounts] (acc_id,voucher_no,total_fee,issue_date,due_date,status,student_id)
VALUES
  (11,11,10000,'1-05-19','1-06-19','Paid',11),
  (12,12,10000,'1-05-19','1-06-19','Paid',12),
  (13,13,10000,'1-05-19','1-06-19','Paid',13),
  (14,14,10000,'1-05-19','1-06-19','Paid',14),
  (15,15,10000,'1-05-19','1-06-19','Paid',15),
  (16,16,10000,'1-05-19','1-06-19','Paid',16),
  (17,17,10000,'1-05-19','1-06-19','Paid',17),
  (18,18,10000,'1-05-19','1-06-19','Paid',18),
  (19,19,10000,'1-05-19','1-06-19','Paid',19),
  (20,20,10000,'1-05-19','1-06-19','Paid',20);
INSERT INTO [Accounts] (acc_id,voucher_no,total_fee,issue_date,due_date,status,student_id)
VALUES
  (21,21,10000,'1-05-19','1-06-19','Paid',21),
  (22,22,10000,'1-05-19','1-06-19','Paid',22),
  (23,23,10000,'1-05-19','1-06-19','Paid',23),
  (24,24,10000,'1-05-19','1-06-19','Paid',24),
  (25,25,10000,'1-05-19','1-06-19','Paid',25),
  (26,26,10000,'1-05-19','1-06-19','Paid',26),
  (27,27,10000,'1-05-19','1-06-19','Paid',27),
  (28,28,10000,'1-05-19','1-06-19','Paid',28),
  (29,29,10000,'1-05-19','1-06-19','Paid',29),
  (30,30,10000,'1-05-19','1-06-19','Paid',30);
INSERT INTO [Accounts] (acc_id,voucher_no,total_fee,issue_date,due_date,status,student_id)
VALUES
  (31,31,10000,'1-05-19','1-06-19','Paid',31),
  (32,32,10000,'1-05-19','1-06-19','Paid',32),
  (33,33,10000,'1-05-19','1-06-19','Paid',33),
  (34,34,10000,'1-05-19','1-06-19','Paid',34),
  (35,35,10000,'1-05-19','1-06-19','Paid',35),
  (36,36,10000,'1-05-19','1-06-19','Paid',36),
  (37,37,10000,'1-05-19','1-06-19','Paid',37),
  (38,38,10000,'1-05-19','1-06-19','Paid',38),
  (39,39,10000,'1-05-19','1-06-19','Paid',39),
  (40,40,10000,'1-05-19','1-06-19','Paid',40);
INSERT INTO [Accounts] (acc_id,voucher_no,total_fee,issue_date,due_date,status,student_id)
VALUES
  (41,41,10000,'1-05-19','1-06-19','Paid',41),
  (42,42,10000,'1-05-19','1-06-19','Paid',42),
  (43,43,10000,'1-05-19','1-06-19','Paid',43),
  (44,44,10000,'1-05-19','1-06-19','Paid',44),
  (45,45,10000,'1-05-19','1-06-19','Paid',45),
  (46,46,10000,'1-05-19','1-06-19','Paid',46),
  (47,47,10000,'1-05-19','1-06-19','Paid',47),
  (48,48,10000,'1-05-19','1-06-19','Paid',48),
  (49,49,10000,'1-05-19','1-06-19','Paid',49),
  (50,50,10000,'1-05-19','1-06-19','Paid',50);
INSERT INTO [Accounts] (acc_id,voucher_no,total_fee,issue_date,due_date,status,student_id)
VALUES
  (51,51,10000,'1-05-19','1-06-19','Paid',51),
  (52,52,10000,'1-05-19','1-06-19','Paid',52),
  (53,53,10000,'1-05-19','1-06-19','Paid',53),
  (54,54,10000,'1-05-19','1-06-19','Paid',54),
  (55,55,10000,'1-05-19','1-06-19','Paid',55),
  (56,56,10000,'1-05-19','1-06-19','Paid',56),
  (57,57,10000,'1-05-19','1-06-19','Paid',57),
  (58,58,10000,'1-05-19','1-06-19','Paid',58),
  (59,59,10000,'1-05-19','1-06-19','Paid',59),
  (60,60,10000,'1-05-19','1-06-19','Paid',60);
INSERT INTO [Accounts] (acc_id,voucher_no,total_fee,issue_date,due_date,status,student_id)
VALUES
  (61,61,10000,'1-05-19','1-06-19','Paid',61),
  (62,62,10000,'1-05-19','1-06-19','Paid',62),
  (63,63,10000,'1-05-19','1-06-19','Paid',63),
  (64,64,10000,'1-05-19','1-06-19','Paid',64),
  (65,65,10000,'1-05-19','1-06-19','Paid',65),
  (66,66,10000,'1-05-19','1-06-19','Paid',66),
  (67,67,10000,'1-05-19','1-06-19','Paid',67),
  (68,68,10000,'1-05-19','1-06-19','Paid',68),
  (69,69,10000,'1-05-19','1-06-19','Paid',69),
  (70,70,10000,'1-05-19','1-06-19','Paid',70);
INSERT INTO [Accounts] (acc_id,voucher_no,total_fee,issue_date,due_date,status,student_id)
VALUES
  (71,71,10000,'1-05-19','1-06-19','Paid',71),
  (72,72,10000,'1-05-19','1-06-19','Paid',72),
  (73,73,10000,'1-05-19','1-06-19','Paid',73),
  (74,74,10000,'1-05-19','1-06-19','Paid',74),
  (75,75,10000,'1-05-19','1-06-19','Paid',75),
  (76,76,10000,'1-05-19','1-06-19','Paid',76),
  (77,77,10000,'1-05-19','1-06-19','Paid',77),
  (78,78,10000,'1-05-19','1-06-19','Paid',78),
  (79,79,10000,'1-05-19','1-06-19','Paid',79),
  (80,80,10000,'1-05-19','1-06-19','Paid',80);
INSERT INTO [Accounts] (acc_id,voucher_no,total_fee,issue_date,due_date,status,student_id)
VALUES
  (81,81,10000,'1-05-19','1-06-19','Paid',81),
  (82,82,10000,'1-05-19','1-06-19','Paid',82),
  (83,83,10000,'1-05-19','1-06-19','Paid',83),
  (84,84,10000,'1-05-19','1-06-19','Paid',84),
  (85,85,10000,'1-05-19','1-06-19','Paid',85),
  (86,86,10000,'1-05-19','1-06-19','Paid',86),
  (87,87,10000,'1-05-19','1-06-19','Paid',87),
  (88,88,10000,'1-05-19','1-06-19','Paid',88),
  (89,89,10000,'1-05-19','1-06-19','Paid',89),
  (90,90,10000,'1-05-19','1-06-19','Paid',90);
INSERT INTO [Accounts] (acc_id,voucher_no,total_fee,issue_date,due_date,status,student_id)
VALUES
  (91,91,10000,'1-05-19','1-06-19','Paid',91),
  (92,92,10000,'1-05-19','1-06-19','Paid',92),
  (93,93,10000,'1-05-19','1-06-19','Paid',93),
  (94,94,10000,'1-05-19','1-06-19','Paid',94),
  (95,95,10000,'1-05-19','1-06-19','Paid',95),
  (96,96,10000,'1-05-19','1-06-19','Paid',96),
  (97,97,10000,'1-05-19','1-06-19','Paid',97),
  (98,98,10000,'1-05-19','1-06-19','Paid',98),
  (99,99,10000,'1-05-19','1-06-19','Paid',99),
  (100,100,10000,'1-05-19','1-06-19','Paid',100);
  INSERT INTO [Accounts] (acc_id,voucher_no,total_fee,issue_date,due_date,status,student_id)
VALUES
  (101,101,10000,'1-05-19','1-06-19','Not paid',101),
  (102,102,10000,'1-05-19','1-06-19','Not paid',102),
  (103,103,10000,'1-05-19','1-06-19','Not paid',103),
  (104,104,10000,'1-05-19','1-06-19','Not paid',104),
  (105,105,10000,'1-05-19','1-06-19','Not paid',105),
  (106,106,10000,'1-05-19','1-06-19','Not paid',106),
  (107,107,10000,'1-05-19','1-06-19','Not paid',107),
  (108,108,10000,'1-05-19','1-06-19','Not paid',108),
  (109,109,10000,'1-05-19','1-06-19','Not paid',109),
  (110,110,10000,'1-05-19','1-06-19','Not paid',110);
INSERT INTO [Accounts] (acc_id,voucher_no,total_fee,issue_date,due_date,status,student_id)
VALUES
  (111,111,10000,'1-05-19','1-06-19','Not paid',111),
  (112,112,10000,'1-05-19','1-06-19','Not paid',112),
  (113,113,10000,'1-05-19','1-06-19','Not paid',113),
  (114,114,10000,'1-05-19','1-06-19','Not paid',114),
  (115,115,10000,'1-05-19','1-06-19','Not paid',115),
  (116,116,10000,'1-05-19','1-06-19','Not paid',116),
  (117,117,10000,'1-05-19','1-06-19','Not paid',117),
  (118,118,10000,'1-05-19','1-06-19','Not paid',118),
  (119,119,10000,'1-05-19','1-06-19','Not paid',119),
  (120,120,10000,'1-05-19','1-06-19','Not paid',120);
INSERT INTO [Accounts] (acc_id,voucher_no,total_fee,issue_date,due_date,status,student_id)
VALUES
  (121,121,10000,'1-05-19','1-06-19','Not paid',121),
  (122,122,10000,'1-05-19','1-06-19','Not paid',122),
  (123,123,10000,'1-05-19','1-06-19','Not paid',123),
  (124,124,10000,'1-05-19','1-06-19','Not paid',124),
  (125,125,10000,'1-05-19','1-06-19','Not paid',125),
  (126,126,10000,'1-05-19','1-06-19','Not paid',126),
  (127,127,10000,'1-05-19','1-06-19','Not paid',127),
  (128,128,10000,'1-05-19','1-06-19','Not paid',128),
  (129,129,10000,'1-05-19','1-06-19','Not paid',129),
  (130,130,10000,'1-05-19','1-06-19','Not paid',130);
INSERT INTO [Accounts] (acc_id,voucher_no,total_fee,issue_date,due_date,status,student_id)
VALUES
  (131,131,10000,'1-05-19','1-06-19','Not paid',131),
  (132,132,10000,'1-05-19','1-06-19','Not paid',132),
  (133,133,10000,'1-05-19','1-06-19','Not paid',133),
  (134,134,10000,'1-05-19','1-06-19','Not paid',134),
  (135,135,10000,'1-05-19','1-06-19','Not paid',135),
  (136,136,10000,'1-05-19','1-06-19','Not paid',136),
  (137,137,10000,'1-05-19','1-06-19','Not paid',137),
  (138,138,10000,'1-05-19','1-06-19','Not paid',138),
  (139,139,10000,'1-05-19','1-06-19','Not paid',139),
  (140,140,10000,'1-05-19','1-06-19','Not paid',140);
INSERT INTO [Accounts] (acc_id,voucher_no,total_fee,issue_date,due_date,status,student_id)
VALUES
  (141,141,10000,'1-05-19','1-06-19','Not paid',141),
  (142,142,10000,'1-05-19','1-06-19','Not paid',142),
  (143,143,10000,'1-05-19','1-06-19','Not paid',143),
  (144,144,10000,'1-05-19','1-06-19','Not paid',144),
  (145,145,10000,'1-05-19','1-06-19','Not paid',145),
  (146,146,10000,'1-05-19','1-06-19','Not paid',146),
  (147,147,10000,'1-05-19','1-06-19','Not paid',147),
  (148,148,10000,'1-05-19','1-06-19','Not paid',148),
  (149,149,10000,'1-05-19','1-06-19','Not paid',149),
  (150,150,10000,'1-05-19','1-06-19','Not paid',150);
INSERT INTO [Accounts] (acc_id,voucher_no,total_fee,issue_date,due_date,status,student_id)
VALUES
  (151,151,10000,'1-05-19','1-06-19','Not paid',151),
  (152,152,10000,'1-05-19','1-06-19','Not paid',152),
  (153,153,10000,'1-05-19','1-06-19','Not paid',153),
  (154,154,10000,'1-05-19','1-06-19','Not paid',154),
  (155,155,10000,'1-05-19','1-06-19','Not paid',155),
  (156,156,10000,'1-05-19','1-06-19','Not paid',156),
  (157,157,10000,'1-05-19','1-06-19','Not paid',157),
  (158,158,10000,'1-05-19','1-06-19','Not paid',158),
  (159,159,10000,'1-05-19','1-06-19','Not paid',159),
  (160,160,10000,'1-05-19','1-06-19','Not paid',160);
INSERT INTO [Accounts] (acc_id,voucher_no,total_fee,issue_date,due_date,status,student_id)
VALUES
  (161,161,10000,'1-05-19','1-06-19','Not paid',161),
  (162,162,10000,'1-05-19','1-06-19','Not paid',162),
  (163,163,10000,'1-05-19','1-06-19','Not paid',163),
  (164,164,10000,'1-05-19','1-06-19','Not paid',164),
  (165,165,10000,'1-05-19','1-06-19','Not paid',165),
  (166,166,10000,'1-05-19','1-06-19','Not paid',166),
  (167,167,10000,'1-05-19','1-06-19','Not paid',167),
  (168,168,10000,'1-05-19','1-06-19','Not paid',168),
  (169,169,10000,'1-05-19','1-06-19','Not paid',169),
  (170,170,10000,'1-05-19','1-06-19','Not paid',170);
INSERT INTO [Accounts] (acc_id,voucher_no,total_fee,issue_date,due_date,status,student_id)
VALUES
  (171,171,10000,'1-05-19','1-06-19','Not paid',171),
  (172,172,10000,'1-05-19','1-06-19','Not paid',172),
  (173,173,10000,'1-05-19','1-06-19','Not paid',173),
  (174,174,10000,'1-05-19','1-06-19','Not paid',174),
  (175,175,10000,'1-05-19','1-06-19','Not paid',175),
  (176,176,10000,'1-05-19','1-06-19','Not paid',176),
  (177,177,10000,'1-05-19','1-06-19','Not paid',177),
  (178,178,10000,'1-05-19','1-06-19','Not paid',178),
  (179,179,10000,'1-05-19','1-06-19','Not paid',179),
  (180,180,10000,'1-05-19','1-06-19','Not paid',180);
INSERT INTO [Accounts] (acc_id,voucher_no,total_fee,issue_date,due_date,status,student_id)
VALUES
  (181,181,10000,'1-05-19','1-06-19','Not paid',181),
  (182,182,10000,'1-05-19','1-06-19','Not paid',182),
  (183,183,10000,'1-05-19','1-06-19','Not paid',183),
  (184,184,10000,'1-05-19','1-06-19','Not paid',184),
  (185,185,10000,'1-05-19','1-06-19','Not paid',185),
  (186,186,10000,'1-05-19','1-06-19','Not paid',186),
  (187,187,10000,'1-05-19','1-06-19','Not paid',187),
  (188,188,10000,'1-05-19','1-06-19','Not paid',188),
  (189,189,10000,'1-05-19','1-06-19','Not paid',189),
  (190,190,10000,'1-05-19','1-06-19','Not paid',190);
INSERT INTO [Accounts] (acc_id,voucher_no,total_fee,issue_date,due_date,status,student_id)
VALUES
  (191,191,10000,'1-05-19','1-06-19','Not paid',191),
  (192,192,10000,'1-05-19','1-06-19','Not paid',192),
  (193,193,10000,'1-05-19','1-06-19','Not paid',193),
  (194,194,10000,'1-05-19','1-06-19','Not paid',194),
  (195,195,10000,'1-05-19','1-06-19','Not paid',195),
  (196,196,10000,'1-05-19','1-06-19','Not paid',196),
  (197,197,10000,'1-05-19','1-06-19','Not paid',197),
  (198,198,10000,'1-05-19','1-06-19','Not paid',198),
  (199,199,10000,'1-05-19','1-06-19','Not paid',199),
  (200,200,10000,'1-05-19','1-06-19','Not paid',200);
INSERT INTO [Accounts] (acc_id,voucher_no,total_fee,issue_date,due_date,status,student_id)
VALUES
  (201,201,10000,'1-05-19','1-06-19','Not paid',201),
  (202,202,10000,'1-05-19','1-06-19','Not paid',202),
  (203,203,10000,'1-05-19','1-06-19','Not paid',203),
  (204,204,10000,'1-05-19','1-06-19','Not paid',204),
  (205,205,10000,'1-05-19','1-06-19','Not paid',205),
  (206,206,10000,'1-05-19','1-06-19','Not paid',206),
  (207,207,10000,'1-05-19','1-06-19','Not paid',207),
  (208,208,10000,'1-05-19','1-06-19','Not paid',208),
  (209,209,10000,'1-05-19','1-06-19','Not paid',209),
  (210,210,10000,'1-05-19','1-06-19','Not paid',210);
INSERT INTO [Accounts] (acc_id,voucher_no,total_fee,issue_date,due_date,status,student_id)
VALUES
  (211,211,10000,'1-05-19','1-06-19','Not paid',211),
  (212,212,10000,'1-05-19','1-06-19','Not paid',212),
  (213,213,10000,'1-05-19','1-06-19','Not paid',213),
  (214,214,10000,'1-05-19','1-06-19','Not paid',214),
  (215,215,10000,'1-05-19','1-06-19','Not paid',215),
  (216,216,10000,'1-05-19','1-06-19','Not paid',216),
  (217,217,10000,'1-05-19','1-06-19','Not paid',217),
  (218,218,10000,'1-05-19','1-06-19','Not paid',218),
  (219,219,10000,'1-05-19','1-06-19','Not paid',219),
  (220,220,10000,'1-05-19','1-06-19','Not paid',220);
INSERT INTO [Accounts] (acc_id,voucher_no,total_fee,issue_date,due_date,status,student_id)
VALUES
  (221,221,10000,'1-05-19','1-06-19','Not paid',221),
  (222,222,10000,'1-05-19','1-06-19','Not paid',222),
  (223,223,10000,'1-05-19','1-06-19','Not paid',223),
  (224,224,10000,'1-05-19','1-06-19','Not paid',224),
  (225,225,10000,'1-05-19','1-06-19','Not paid',225),
  (226,226,10000,'1-05-19','1-06-19','Not paid',226),
  (227,227,10000,'1-05-19','1-06-19','Not paid',227),
  (228,228,10000,'1-05-19','1-06-19','Not paid',228),
  (229,229,10000,'1-05-19','1-06-19','Not paid',229),
  (230,230,10000,'1-05-19','1-06-19','Not paid',230);
INSERT INTO [Accounts] (acc_id,voucher_no,total_fee,issue_date,due_date,status,student_id)
VALUES
  (231,231,10000,'1-05-19','1-06-19','Not paid',231),
  (232,232,10000,'1-05-19','1-06-19','Not paid',232),
  (233,233,10000,'1-05-19','1-06-19','Not paid',233),
  (234,234,10000,'1-05-19','1-06-19','Not paid',234),
  (235,235,10000,'1-05-19','1-06-19','Not paid',235),
  (236,236,10000,'1-05-19','1-06-19','Not paid',236),
  (237,237,10000,'1-05-19','1-06-19','Not paid',237),
  (238,238,10000,'1-05-19','1-06-19','Not paid',238),
  (239,239,10000,'1-05-19','1-06-19','Not paid',239),
  (240,240,10000,'1-05-19','1-06-19','Not paid',240);
INSERT INTO [Accounts] (acc_id,voucher_no,total_fee,issue_date,due_date,status,student_id)
VALUES
  (241,241,10000,'1-05-19','1-06-19','Not paid',241),
  (242,242,10000,'1-05-19','1-06-19','Not paid',242),
  (243,243,10000,'1-05-19','1-06-19','Not paid',243),
  (244,244,10000,'1-05-19','1-06-19','Not paid',244),
  (245,245,10000,'1-05-19','1-06-19','Not paid',245),
  (246,246,10000,'1-05-19','1-06-19','Not paid',246),
  (247,247,10000,'1-05-19','1-06-19','Not paid',247),
  (248,248,10000,'1-05-19','1-06-19','Not paid',248),
  (249,249,10000,'1-05-19','1-06-19','Not paid',249),
  (250,250,10000,'1-05-19','1-06-19','Not paid',250);
INSERT INTO [Accounts] (acc_id,voucher_no,total_fee,issue_date,due_date,status,student_id)
VALUES
  (251,251,10000,'1-05-19','1-06-19','Not paid',251),
  (252,252,10000,'1-05-19','1-06-19','Not paid',252),
  (253,253,10000,'1-05-19','1-06-19','Not paid',253),
  (254,254,10000,'1-05-19','1-06-19','Not paid',254),
  (255,255,10000,'1-05-19','1-06-19','Not paid',255),
  (256,256,10000,'1-05-19','1-06-19','Not paid',256),
  (257,257,10000,'1-05-19','1-06-19','Not paid',257),
  (258,258,10000,'1-05-19','1-06-19','Not paid',258),
  (259,259,10000,'1-05-19','1-06-19','Not paid',259),
  (260,260,10000,'1-05-19','1-06-19','Not paid',260);
INSERT INTO [Accounts] (acc_id,voucher_no,total_fee,issue_date,due_date,status,student_id)
VALUES
  (261,261,10000,'1-05-19','1-06-19','Not paid',261),
  (262,262,10000,'1-05-19','1-06-19','Not paid',262),
  (263,263,10000,'1-05-19','1-06-19','Not paid',263),
  (264,264,10000,'1-05-19','1-06-19','Not paid',264),
  (265,265,10000,'1-05-19','1-06-19','Not paid',265),
  (266,266,10000,'1-05-19','1-06-19','Not paid',266),
  (267,267,10000,'1-05-19','1-06-19','Not paid',267),
  (268,268,10000,'1-05-19','1-06-19','Not paid',268),
  (269,269,10000,'1-05-19','1-06-19','Not paid',269),
  (270,270,10000,'1-05-19','1-06-19','Not paid',270);
INSERT INTO [Accounts] (acc_id,voucher_no,total_fee,issue_date,due_date,status,student_id)
VALUES
  (271,271,10000,'1-05-19','1-06-19','Not paid',271),
  (272,272,10000,'1-05-19','1-06-19','Not paid',272),
  (273,273,10000,'1-05-19','1-06-19','Not paid',273),
  (274,274,10000,'1-05-19','1-06-19','Not paid',274),
  (275,275,10000,'1-05-19','1-06-19','Not paid',275),
  (276,276,10000,'1-05-19','1-06-19','Not paid',276),
  (277,277,10000,'1-05-19','1-06-19','Not paid',277),
  (278,278,10000,'1-05-19','1-06-19','Not paid',278),
  (279,279,10000,'1-05-19','1-06-19','Not paid',279),
  (280,280,10000,'1-05-19','1-06-19','Not paid',280);
INSERT INTO [Accounts] (acc_id,voucher_no,total_fee,issue_date,due_date,status,student_id)
VALUES
  (281,281,10000,'1-05-19','1-06-19','Not paid',281),
  (282,282,10000,'1-05-19','1-06-19','Not paid',282),
  (283,283,10000,'1-05-19','1-06-19','Not paid',283),
  (284,284,10000,'1-05-19','1-06-19','Not paid',284),
  (285,285,10000,'1-05-19','1-06-19','Not paid',285),
  (286,286,10000,'1-05-19','1-06-19','Not paid',286),
  (287,287,10000,'1-05-19','1-06-19','Not paid',287),
  (288,288,10000,'1-05-19','1-06-19','Not paid',288),
  (289,289,10000,'1-05-19','1-06-19','Not paid',289),
  (290,290,10000,'1-05-19','1-06-19','Not paid',290);
INSERT INTO [Accounts] (acc_id,voucher_no,total_fee,issue_date,due_date,status,student_id)
VALUES
  (291,291,10000,'1-05-19','1-06-19','Not paid',291),
  (292,292,10000,'1-05-19','1-06-19','Not paid',292),
  (293,293,10000,'1-05-19','1-06-19','Not paid',293),
  (294,294,10000,'1-05-19','1-06-19','Not paid',294),
  (295,295,10000,'1-05-19','1-06-19','Not paid',295),
  (296,296,10000,'1-05-19','1-06-19','Not paid',296),
  (297,297,10000,'1-05-19','1-06-19','Not paid',297),
  (298,298,10000,'1-05-19','1-06-19','Not paid',298),
  (299,299,10000,'1-05-19','1-06-19','Not paid',299),
  (300,300,10000,'1-05-19','1-06-19','Not paid',300);
INSERT INTO [Accounts] (acc_id,voucher_no,total_fee,issue_date,due_date,status,student_id)
VALUES
  (301,301,10000,'1-05-19','1-06-19','Paid',301),
  (302,302,10000,'1-05-19','1-06-19','Paid',302),
  (303,303,10000,'1-05-19','1-06-19','Paid',303),
  (304,304,10000,'1-05-19','1-06-19','Paid',304),
  (305,305,10000,'1-05-19','1-06-19','Paid',305),
  (306,306,10000,'1-05-19','1-06-19','Paid',306),
  (307,307,10000,'1-05-19','1-06-19','Paid',307),
  (308,308,10000,'1-05-19','1-06-19','Paid',308),
  (309,309,10000,'1-05-19','1-06-19','Paid',309),
  (310,310,10000,'1-05-19','1-06-19','Paid',310);
INSERT INTO [Accounts] (acc_id,voucher_no,total_fee,issue_date,due_date,status,student_id)
VALUES
  (311,311,10000,'1-05-19','1-06-19','Paid',311),
  (312,312,10000,'1-05-19','1-06-19','Paid',312),
  (313,313,10000,'1-05-19','1-06-19','Paid',313),
  (314,314,10000,'1-05-19','1-06-19','Paid',314),
  (315,315,10000,'1-05-19','1-06-19','Paid',315),
  (316,316,10000,'1-05-19','1-06-19','Paid',316),
  (317,317,10000,'1-05-19','1-06-19','Paid',317),
  (318,318,10000,'1-05-19','1-06-19','Paid',318),
  (319,319,10000,'1-05-19','1-06-19','Paid',319),
  (320,320,10000,'1-05-19','1-06-19','Paid',320);
INSERT INTO [Accounts] (acc_id,voucher_no,total_fee,issue_date,due_date,status,student_id)
VALUES
  (321,321,10000,'1-05-19','1-06-19','Paid',321),
  (322,322,10000,'1-05-19','1-06-19','Paid',322),
  (323,323,10000,'1-05-19','1-06-19','Paid',323),
  (324,324,10000,'1-05-19','1-06-19','Paid',324),
  (325,325,10000,'1-05-19','1-06-19','Paid',325),
  (326,326,10000,'1-05-19','1-06-19','Paid',326),
  (327,327,10000,'1-05-19','1-06-19','Paid',327),
  (328,328,10000,'1-05-19','1-06-19','Paid',328),
  (329,329,10000,'1-05-19','1-06-19','Paid',329),
  (330,330,10000,'1-05-19','1-06-19','Paid',330);
INSERT INTO [Accounts] (acc_id,voucher_no,total_fee,issue_date,due_date,status,student_id)
VALUES
  (331,331,10000,'1-05-19','1-06-19','Paid',331),
  (332,332,10000,'1-05-19','1-06-19','Paid',332),
  (333,333,10000,'1-05-19','1-06-19','Paid',333),
  (334,334,10000,'1-05-19','1-06-19','Paid',334),
  (335,335,10000,'1-05-19','1-06-19','Paid',335),
  (336,336,10000,'1-05-19','1-06-19','Paid',336),
  (337,337,10000,'1-05-19','1-06-19','Paid',337),
  (338,338,10000,'1-05-19','1-06-19','Paid',338),
  (339,339,10000,'1-05-19','1-06-19','Paid',339),
  (340,340,10000,'1-05-19','1-06-19','Paid',340);
INSERT INTO [Accounts] (acc_id,voucher_no,total_fee,issue_date,due_date,status,student_id)
VALUES
  (341,341,10000,'1-05-19','1-06-19','Paid',341),
  (342,342,10000,'1-05-19','1-06-19','Paid',342),
  (343,343,10000,'1-05-19','1-06-19','Paid',343),
  (344,344,10000,'1-05-19','1-06-19','Paid',344),
  (345,345,10000,'1-05-19','1-06-19','Paid',345),
  (346,346,10000,'1-05-19','1-06-19','Paid',346),
  (347,347,10000,'1-05-19','1-06-19','Paid',347),
  (348,348,10000,'1-05-19','1-06-19','Paid',348),
  (349,349,10000,'1-05-19','1-06-19','Paid',349),
  (350,350,10000,'1-05-19','1-06-19','Paid',350);
INSERT INTO [Accounts] (acc_id,voucher_no,total_fee,issue_date,due_date,status,student_id)
VALUES
  (351,351,10000,'1-05-19','1-06-19','Paid',351),
  (352,352,10000,'1-05-19','1-06-19','Paid',352),
  (353,353,10000,'1-05-19','1-06-19','Paid',353),
  (354,354,10000,'1-05-19','1-06-19','Paid',354),
  (355,355,10000,'1-05-19','1-06-19','Paid',355),
  (356,356,10000,'1-05-19','1-06-19','Paid',356),
  (357,357,10000,'1-05-19','1-06-19','Paid',357),
  (358,358,10000,'1-05-19','1-06-19','Paid',358),
  (359,359,10000,'1-05-19','1-06-19','Paid',359),
  (360,360,10000,'1-05-19','1-06-19','Paid',360);
INSERT INTO [Accounts] (acc_id,voucher_no,total_fee,issue_date,due_date,status,student_id)
VALUES
  (361,361,10000,'1-05-19','1-06-19','Paid',361),
  (362,362,10000,'1-05-19','1-06-19','Paid',362),
  (363,363,10000,'1-05-19','1-06-19','Paid',363),
  (364,364,10000,'1-05-19','1-06-19','Paid',364),
  (365,365,10000,'1-05-19','1-06-19','Paid',365),
  (366,366,10000,'1-05-19','1-06-19','Paid',366),
  (367,367,10000,'1-05-19','1-06-19','Paid',367),
  (368,368,10000,'1-05-19','1-06-19','Paid',368),
  (369,369,10000,'1-05-19','1-06-19','Paid',369),
  (370,370,10000,'1-05-19','1-06-19','Paid',370);
INSERT INTO [Accounts] (acc_id,voucher_no,total_fee,issue_date,due_date,status,student_id)
VALUES
  (371,371,10000,'1-05-19','1-06-19','Paid',371),
  (372,372,10000,'1-05-19','1-06-19','Paid',372),
  (373,373,10000,'1-05-19','1-06-19','Paid',373),
  (374,374,10000,'1-05-19','1-06-19','Paid',374),
  (375,375,10000,'1-05-19','1-06-19','Paid',375),
  (376,376,10000,'1-05-19','1-06-19','Paid',376),
  (377,377,10000,'1-05-19','1-06-19','Paid',377),
  (378,378,10000,'1-05-19','1-06-19','Paid',378),
  (379,379,10000,'1-05-19','1-06-19','Paid',379),
  (380,380,10000,'1-05-19','1-06-19','Paid',380);

 --Computer Lab


 insert into [computerlab] (lab_id,lab_name,lab_attendant,total_pc)
 values
(1,'PC-Lab-A','Ali Ahmad',20),
(2,'PC-Lab-B','M.Usama',24),
(3,'PC-Lab-C','Jawad',25)

--Library
 insert into Library (lib_id,admin,lab_attendant)
 values
(1,'Akram','Raza')



--selecting all tables
select * from Department
select * from Class
select * from Section
select * from Students
select * from Faculty
select * from Subjects
select * from Attendance
select * from Examinations
select * from Marks
select * from Accounts
select * from ComputerLab
select * from Library
select * from StudentAdress
select * from FacultyAddress
select * from HOD

--Report that shows students with due fee
CREATE VIEW [StudentsWithTheDueFee]
AS
     SELECT students.std_id as ID, 
            Students.fname as Student_Name ,
			Students.mobile_no as Contact,
			StudentAdress.address as Address,
			Accounts.status as Fee_status
     FROM students
          INNER JOIN StudentAdress ON StudentAdress.std_id = Students.std_id
		  INNER JOIN Accounts ON Accounts.status='Not paid' and Accounts.student_id=Students.std_id
GO
-------------------------------


--Procedures for reports
--Report that shows students with due fee
CREATE VIEW [StudentsWithTheDueFee]
AS
     SELECT students.std_id as ID, 
            Students.fname as Student_Name ,
			Students.mobile_no as Contact,
			StudentAdress.address as Address,
			Accounts.status as Fee_status
     FROM students
          INNER JOIN StudentAdress ON StudentAdress.std_id = Students.std_id
		  INNER JOIN Accounts ON Accounts.status='Not paid' and Accounts.student_id=Students.std_id
GO

CREATE PROCEDURE StudentsWithTheDueFeeProcedure
AS
SELECT * FROM StudentsWithTheDueFee
GO;

exec StudentsWithTheDueFeeProcedure

--Report that shows Students who got higher than 70 Marks and have paid the fee
CREATE VIEW [StudentsWhichAreEligibleForNextClassPromotions]
AS
     SELECT students.std_id as ID, 
            Students.fname as Student_Name ,
			Students.mobile_no as Contact,
			marks.obtained_marks,
			Accounts.status as Fee_Status
     FROM students
          INNER JOIN Marks ON Marks.student_id = Students.std_id and marks.obtained_marks>=70
		  INNER JOIN Accounts ON Accounts.status='Paid' and Accounts.student_id=Students.std_id
GO

CREATE PROCEDURE [StudentsWhichAreEligibleForNextClassPromotionProcedure]
AS
SELECT * FROM [StudentsWhichAreEligibleForNextClassPromotion]
GO;

exec [StudentsWhichAreEligibleForNextClassPromotionProcedure]


--Report that shows All Faculty and thier address
CREATE VIEW [FacultyAndAddress]
AS
     SELECT faculty.fac_id as ID, 
            Faculty.fac_name as Faculty_Name ,
			Faculty.phone_no as Contact,
			Faculty.email as Email,
			Faculty.age as Age,
			Faculty.department_id as Dep_ID,
			Faculty.subject_id as subject_id,
			Faculty.section_id as section_id,
			FacultyAddress.address_id as Address_id,
			FacultyAddress.address as Address,
			FacultyAddress.city as City,
			FacultyAddress.zipcode as ZIPCODE
			
     FROM Faculty
          INNER JOIN FacultyAddress ON FacultyAddress.fac_id = faculty.fac_id
GO

CREATE PROCEDURE [FacultyAndAddressProcedure]
AS
SELECT * FROM [FacultyAndAddress]
GO;

exec [FacultyAndAddressProcedure]

--Report that shows All departments and the subjects they offer

CREATE VIEW [DepartmentsAndSubjects]
AS
     SELECT department.dep_id as Dep_ID, 
            department.dep_name as Department_Name ,
			subjects.sub_id as sub_id,
			subjects.name as sub_name,
			subjects.class_id as class_id,
			subjects.section_id as section_id		
     FROM department
          INNER JOIN subjects ON subjects.department_id = department.dep_id
GO

CREATE PROCEDURE [DepartmentsAndSubjectsProcedure]
AS
SELECT * FROM [DepartmentsAndSubjects]
GO;

exec [DepartmentsAndSubjectsProcedure]


--Report that shows All attendance records of students
select*from students
select*from attendance
CREATE VIEW [StudentsAttendance]
AS
     SELECT students.std_id as ID, 
            Students.fname as Student_Name ,
			Students.class_id as Class_ID,
			Students.section_id as Section_ID,
			Students.dep_id as Dep_ID,
			attendance.subject_id as Subject_id,
			attendance.status as status,
			attendance.date as Date
     FROM students
          INNER JOIN attendance ON attendance.student_id = students.std_id
GO

CREATE PROCEDURE [StudentsAttendanceProcedure]
AS
SELECT * FROM [StudentsAttendance]
GO;

exec [StudentsAttendanceProcedure]


--Report that shows All students who belong to science department and have obtained equal to or more than 90 marks
CREATE VIEW [ScienceStudentsWhoGotAA]
AS
     SELECT students.std_id as ID, 
            Students.fname as Student_Name ,
			Students.class_id as Class_ID,
			Students.section_id as Section_ID,
			Students.dep_id as Dep_ID,
			marks.obtained_marks,
			marks.subject_id,
			marks.ex_id as Exam_ID
     FROM students
          INNER JOIN marks ON marks.student_id = students.std_id and marks.obtained_marks>90 and students.dep_id=1


GO

CREATE PROCEDURE [ScienceStudentsWhoGotAAProcedure]
AS
SELECT * FROM [ScienceStudentsWhoGotAA]
GO;

exec [ScienceStudentsWhoGotAAProcedure]


--Triggers
--Trigger that will set datetime automatically according to book status
CREATE TRIGGER update_library_trigger ON Book AFTER UPDATE
AS
BEGIN
SET NOCOUNT ON;
UPDATE book set borrowed_at = GETDATE()
FROM Book b
INNER JOIN inserted i on b.book_id=i.book_id
AND i.status = 'Borrowed'
UPDATE Book set returned_at = GETDATE()
FROM Book b
INNER JOIN inserted i on b.book_id=i.book_id
AND i.status = 'Returned'
END
GO

--Testing trigger
insert into book(book_id,book_name,borrowed_at,returned_at,status,std_id,lib_id)
values (1,'Java',null,null,null,1,1)

update book
set status = 'returned'
where book_id=1
select*from book



--Trigger to add default dep name if its value is null
DROP TRIGGER IF EXISTS t_dep_insert;
GO
CREATE TRIGGER t_dep_insert ON department INSTEAD OF INSERT
AS BEGIN
    DECLARE @dep_id int;
    DECLARE @dep_name varchar(20);
    SELECT @dep_id = dep_id, @dep_name = dep_name FROM INSERTED;
    IF @dep_name IS NULL SET @dep_name = 'Default';
    INSERT INTO department (dep_id, dep_name) VALUES (@dep_id, @dep_name);
END;


--Trigger to make sure department id is not referenced in other table before deleting it
DROP TRIGGER IF EXISTS t_dep_delete;
GO
CREATE TRIGGER t_dep_delete ON department INSTEAD OF DELETE
AS BEGIN
    DECLARE @dep_id int;
    DECLARE @dep_name varchar(20);
	DECLARE @count int;
    SELECT @dep_id = dep_id FROM DELETED;
    SELECT @count = COUNT(*) FROM department WHERE dep_id = @dep_id;
    IF @count = 0
        DELETE FROM country WHERE dep_id = @dep_id;
    ELSE
        THROW 51000, 'can not delete - department is referenced in other tables', 1;
END;
