CREATE DATABASE InClass

USE InClass

--Problem 1. One-To-One Relationship

CREATE TABLE Passports (
PassportID INT PRIMARY KEY NOT NULL,
PassportNumber VARCHAR(50)
)

CREATE TABLE Persons (
PersonID INT PRIMARY KEY IDENTITY NOT NULL,
FirstName VARCHAR(50) NOT NULL,
Salary NUMERIC(15,2),
PassportID INT FOREIGN KEY REFERENCES Passports(PassportID)
)

INSERT INTO Passports VALUES
(101, 'N34FG21B'),
(102, 'K65LO4R7'),
(103, 'ZE657QP2')

INSERT INTO Persons VALUES
('Roberto', 43300, 102),
('Tom', 56100, 103),
('Yana', 60200, 101)

--Problem 2. One-To-Many Relationship

CREATE TABLE Manufacturers (
ManufacturerID INT PRIMARY KEY IDENTITY NOT NULL,
[Name] VARCHAR(50) NOT NULL,
EstablishedOn DATE
)

CREATE TABLE Models (
ModelID INT PRIMARY KEY NOT NULL,
[Name] VARCHAR(50) NOT NULL,
ManufacturerID INT FOREIGN KEY REFERENCES Manufacturers(ManufacturerID)
)

INSERT INTO Manufacturers VALUES
('BMW', '07/03/1916'),
('Tesla', '01/01/2003'),
('Lada', '01/05/1966')

INSERT INTO Models VALUES
(101, 'X1', 1),
(102, 'i6', 1),
(103, 'Model S', 2),
(104, 'Model X', 2),
(105, 'Model 3', 2),
(106, 'Nova', 3)

--Problem 3. Many-To-Many Relationship

CREATE TABLE Students (
StudentID INT PRIMARY KEY IDENTITY NOT NULL,
[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE Exams (
ExamID INT PRIMARY KEY NOT NULL,
[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE StudentsExams (
StudentID INT,
ExamID INT,
CONSTRAINT PK_StudentsExams
PRIMARY KEY (StudentID, ExamID),
CONSTRAINT FK_StudentsExams_Students
FOREIGN KEY (StudentID)
REFERENCES Students(StudentID),
CONSTRAINT FK_StudentsExams_Exams
FOREIGN KEY (ExamID)
REFERENCES Exams(ExamID)
)

INSERT INTO Students VALUES
('Mila'),
('Toni'),
('Ron')

INSERT INTO Exams VALUES
(101, 'SpringMVC'),
(102, 'Neo4j'),
(103, 'Oracle 11g')

INSERT INTO StudentsExams VALUES
(1, 101),
(1, 102),
(2, 101),
(3, 103),
(2, 102),
(2, 103)

--Problem 4. Self-Referencing

CREATE TABLE Teachers (
TeacherID INT PRIMARY KEY NOT NULL,
[Name] VARCHAR(50) NOT NULL,
ManagerID INT FOREIGN KEY REFERENCES Teachers(TeacherID)
)

INSERT INTO Teachers VALUES
(101, 'John', NULL),
(102, 'Maya', 106),
(103, 'Silvia', 106),
(104, 'Ted', 105),
(105, 'Mark', 101),
(106, 'Greta', 101)

--05. Online Store Database
--CREATE DATABASE OnlineStore
--USE OnlineStore

CREATE TABLE ItemTypes (
ItemTypeID INT PRIMARY KEY IDENTITY NOT NULL,
[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE Items (
ItemID INT PRIMARY KEY IDENTITY NOT NULL,
[Name] VARCHAR(50) NOT NULL,
ItemTypeID INT FOREIGN KEY REFERENCES ItemTypes(ItemTypeID)
)

CREATE TABLE Cities (
CityID INT PRIMARY KEY IDENTITY NOT NULL,
[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE Customers (
CustomerID INT PRIMARY KEY IDENTITY NOT NULL,
[Name] VARCHAR(50) NOT NULL,
Birthdate DATE,
CityID INT FOREIGN KEY REFERENCES Cities(CityID)
)

CREATE TABLE Orders (
OrderID INT PRIMARY KEY IDENTITY NOT NULL,
CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID) NOT NULL
)

CREATE TABLE OrderItems (
OrderID INT,
ItemID INT,
CONSTRAINT PK_OrderItems
PRIMARY KEY (OrderID, ItemID),
CONSTRAINT FK_OrderItems_Order
FOREIGN KEY (OrderID)
REFERENCES Orders(OrderID),
CONSTRAINT FK_OrderItems_Items
FOREIGN KEY (ItemID)
REFERENCES Items(ItemID)
)

--06. University Database
--CREATE DATABASE University
--USE University

CREATE TABLE Subjects (
SubjectID INT PRIMARY KEY IDENTITY,
SubjectName VARCHAR(50)
)

CREATE TABLE Majors (
MajorID INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(50)
)

CREATE TABLE Students (
StudentID INT PRIMARY KEY IDENTITY,
StudentNumber INT,
StudentName VARCHAR(50),
MajorID INT FOREIGN KEY REFERENCES Majors(MajorID)
)

CREATE TABLE Payments (
PaymentID INT PRIMARY KEY IDENTITY NOT NULL,
PaymentDate DATE,
PaymentAmount NUMERIC(15,2) NOT NULL,
StudentID INT FOREIGN KEY REFERENCES Students(StudentID)
)

CREATE TABLE Agenda (
StudentID INT NOT NULL,
SubjectID INT NOT NULL,
CONSTRAINT PK_Agenda
PRIMARY KEY (StudentID, SubjectID),
CONSTRAINT FK_Agenda_Order
FOREIGN KEY (StudentID)
REFERENCES Students(StudentID),
CONSTRAINT FK_Agenda_Subjects
FOREIGN KEY (SubjectID)
REFERENCES Subjects(SubjectID)
)

--Problem 7.	SoftUni Design
--USE master
--DROP InClass
--CREATE DATABASE InClass
--USE InClass


--Problem 8.	Geography Design
--USE master
--DROP InClass
--CREATE DATABASE InClass
--USE InClass

USE [Geography]
--09. *Peaks in Rila
SELECT m.MountainRange, p.PeakName, p.Elevation
FROM Mountains AS m
JOIN Peaks AS p ON p.MountainID = m.Id
WHERE m.MountainRange = 'Rila'
ORDER BY p.Elevation DESC