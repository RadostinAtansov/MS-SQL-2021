----------1----------

--USE TEST

CREATE TABLE Passports
(
	PassportID INT PRIMARY KEY IDENTITY(101, 1),
	PassportNumber CHAR(8)
)

CREATE TABLE Persons
(
	 PersonId INT PRIMARY KEY IDENTITY,
	 FirstName NVARCHAR(30),
	 Salary DECIMAL(15,2),
	 PassportID INT UNIQUE FOREIGN KEY REFERENCES Passports(PassportID)
)


INSERT INTO Passports VALUES
('N34FG21B'),
('K65LO4R7'),
('ZE657QP2')


INSERT INTO Persons VALUES
('Roberto', 43300.00102, 102),
('Tom', 56100.00, 103),
('Yana', 60200.00101, 101)

SELECT * 
FROM Persons

SELECT * 
FROM Passports

----------2----------

CREATE TABLE Manufacturers
(
	ManufacturerID INT PRIMARY KEY IDENTITY,
	Name VARCHAR(90),
	EstablishedOn DATETIME
)

CREATE TABLE Models
(
	ModelID INT PRIMARY KEY IDENTITY(101, 1),
	Name VARCHAR(50),
	ManufacturerID INT FOREIGN KEY REFERENCES Manufacturers(ManufacturerID)	
)

INSERT INTO Manufacturers VALUES
('BMW',	'07/03/1916'),
('Tesla', '01/01/2003'),
('Lada', '01/05/1966')

INSERT INTO Models VALUES
('X1',	1),
('i6',	1),
('Model S',	2),
('Model X',	2),
('Model 3',	2),
('Nova',	3)

----------3---------

--USE TEST

CREATE TABLE Students
(
	StudentID INT PRIMARY KEY IDENTITY,
	Name VARCHAR(50)
)

CREATE TABLE Exams
(
	ExamID INT PRIMARY KEY IDENTITY(101, 1),
	Name VARCHAR(50)
)

CREATE TABLE StudentsExams
(
	StudentID INT,
	ExamID INT

	CONSTRAINT PK_Students_Exams PRIMARY KEY(StudentID, ExamId),
	CONSTRAINT FK_Students FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
	CONSTRAINT FK_Exams FOREIGN KEY (ExamID) REFERENCES Exams(ExamID)
)

INSERT INTO Students VALUES
('Mila'),
('Toni'),
('Ron')

INSERT INTO Exams VALUES
('SpringMVC'),
('Neo4j'),
('Oracle 11g')

INSERT INTO StudentsExams VALUES
(1, 101),
(1, 102),
(2, 101),
(3, 103),
(2, 102),
(2, 103)

----------4----------

CREATE TABLE Teachers
(
	TeacherID INT PRIMARY KEY IDENTITY(101, 1),
	[Name] VARCHAR(90),
	ManagerID INT FOREIGN KEY REFERENCES Teachers(TeacherID)
)

INSERT INTO Teachers VALUES

('John',	NULL),
('Maya', 106),
('Silvia', 106),
('Ted', 105),
('Mark', 101),
('Greta', 101)

----------5----------

CREATE TABLE Cities
(
	CityID INT PRIMARY KEY IDENTITY,
	Name VARCHAR(90)
)

CREATE TABLE Customers
(
	CustomerID INT PRIMARY KEY IDENTITY,
	Name VARCHAR(90) NOT NULL,
	BirthDay DATE,
	CityID INT FOREIGN KEY REFERENCES Cities(CityId)
)

CREATE TABLE Orders
(
	OrderID INT PRIMARY KEY IDENTITY,
	CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID)
)

CREATE TABLE ItemTypes
(
	ItemTypesID INT PRIMARY KEY IDENTITY,
	Name VARCHAR(50),

)

CREATE TABLE Items
(
	ItemID INT PRIMARY KEY IDENTITY,
	Name VARCHAR(90) NOT NULL,
	ItemTypeID INT FOREIGN KEY REFERENCES ItemTypes(ItemTypesID)
)

CREATE TABLE OrderItems
(
	OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
	ItemID INT FOREIGN KEY REFERENCES Items(ItemID)

	CONSTRAINT PK_Order_Item PRIMARY KEY (OrderID, ItemID)
)

----------6----------

--CREATE DATABASE TEST

--USE TEST

CREATE TABLE Subjects
(
	SubjectID INT PRIMARY KEY IDENTITY,
	SubjectName NVARCHAR(90)
)

CREATE TABLE Majors
(
	MajorID INT PRIMARY KEY IDENTITY,
	Name NVARCHAR(90)
)

CREATE TABLE Students
(
	StudentID INT PRIMARY KEY IDENTITY,
	StudentNumber INT,
	StudentName NVARCHAR(90),
	MajorID	INT FOREIGN KEY REFERENCES Majors(MajorID)
)

CREATE TABLE Agenda
(
	StudentID INT FOREIGN KEY REFERENCES Students(StudentID),
	SubjectID INT FOREIGN KEY REFERENCES Subjects(SubjectID)

	CONSTRAINT PK_Student_Subject PRIMARY KEY (StudentID, SubjectID)
)

CREATE TABLE Payments
(
	PaymentID INT PRIMARY KEY IDENTITY,
	PaymentDate DATETIME,
	PaymentAmount DECIMAL(15,2),
	StudentID INT FOREIGN KEY REFERENCES Students(StudentID)
)
