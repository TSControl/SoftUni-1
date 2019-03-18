--Problem 1.	Create Database
CREATE DATABASE Minions
COLLATE Cyrillic_General_100_CI_AI
USE Minions

--Problem 2.	Create Tables
CREATE TABLE Minions (
Id INT PRIMARY KEY IDENTITY NOT NULL,
[Name] NVARCHAR(50) NOT NULL,
Age INT
);

CREATE TABLE Towns (
Id INT PRIMARY KEY IDENTITY NOT NULL,
[Name] NVARCHAR(50) NOT NULL
);

--Problem 3.	Alter Minions Table
ALTER TABLE Minions
ADD TownId INT FOREIGN KEY REFERENCES Towns(Id)

--04. Insert Records in Both Tables
INSERT INTO Towns (Id, [Name]) VALUES
(1, 'Sofia'),
(2, 'Plovdiv'),
(3, 'Varna');

INSERT INTO Minions (Id, [Name], Age, TownID) VALUES 
(1, 'Kevin', 22, 1),
(2, 'Bob', 15, 3),
(3, 'Steward', NULL, 2);

--Problem 5.	Truncate Table Minions
TRUNCATE TABLE Minions

--Problem 6.	Drop All Tables
DROP TABLE Minions
DROP TABLE Towns

--07. Create Table People
CREATE TABLE People (
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(200) NOT NULL,
Picture VARBINARY(MAX),
Height FLOAT(2),
[Weight] FLOAT(2),
Gender CHAR CHECK (Gender  IN ('m','f')),
Birthdate DATE NOT NULL,
Biography NVARCHAR(MAX)
);

INSERT INTO People
VALUES
('Sabi', NULL, 168, 100, 'm', '02-01-1992', NULL),
('Sabi', NULL, 168, 100, 'f', '02-01-1992', NULL),
('Sabi', NULL, 168, 100, 'm', '02-01-1992', NULL),
('Sabi', NULL, 168, 100, 'f', '02-01-1992', NULL),
('Sabi', NULL, 168, 100, 'm', '02-01-1992', NULL);

--08. Create Table Users
CREATE TABLE Users (
Id INT IDENTITY PRIMARY KEY,
Username VARCHAR(30) NOT NULL,
[Password] VARCHAR(26) NOT NULL,
ProfilePicture VARBINARY(MAX),
LastLoginTime DATETIME,
IsDeleted INT NOT NULL CHECK (IsDeleted IN (0, 1))
);
INSERT INTO Users (Username, [Password], LastLoginTime, IsDeleted) VALUES
('Sabi', 'wtf', GETDATE(), 1),
('Wasabi', 'twf', GETDATE(), 0),
('WaSabi', 'ftw', GETDATE(), 1),
('Zabi', 'gtfo', GETDATE(), 1),
('Shombi', 'lol', GETDATE(), 0);

--Problem 9.	Change Primary Key
ALTER TABLE Users
DROP CONSTRAINT PK_Users

ALTER TABLE Users
ADD CONSTRAINT PK_Users PRIMARY KEY (Id, Username)

--Problem 10.	Add Check Constraint
ALTER TABLE Users
ADD CONSTRAINT PasswordMinLength
CHECK (LEN([Password]) > 5)

--Problem 11.	Set Default Value of a Field
ALTER TABLE Users
ADD DEFAULT GETDATE() FOR LastLoginTime

--Problem 12.	Set Unique Field
ALTER TABLE Users
DROP CONSTRAINT PK_Users

ALTER TABLE Users
ADD CONSTRAINT PK_Users PRIMARY KEY (Id)

ALTER TABLE Users
ADD CONSTRAINT uc_Username UNIQUE (Username)

ALTER TABLE Users
ADD CONSTRAINT uc_UsernameLength CHECK (LEN(Username) >= 3)

--13. Movies Database
--CREATE DATABASE Movies 
--USE Movies
CREATE TABLE Directors (
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	DirectorName NVARCHAR(100) NOT NULL,
	Notes NVARCHAR(MAX)
)

CREATE TABLE Genres (
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	GenreName NVARCHAR(30) NOT NULL,
	Notes NVARCHAR(MAX)
)

CREATE TABLE Categories (
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	CategoryName NVARCHAR(50) NOT NULL,
	Notes NVARCHAR(MAX)
)

CREATE TABLE Movies (
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	Title NVARCHAR(50) NOT NULL,
	DirectorId INT FOREIGN KEY REFERENCES Directors(Id),
	CopyrightYear DATE,
	[Length] BIGINT,
	GenreId INT FOREIGN KEY REFERENCES Genres(Id),
	Rating INT,
	Notes NVARCHAR(MAX)
)

INSERT INTO Directors (DirectorName, Notes) VALUES
('Uwe Boll', 'Total Idiot'),
('Guy Ritchie', 'It''s been emotional'),
('Martin Scorseze', 'Let''s depart'),
('Steven Soderbergh', 'Ocean''s 11, 12, 13, 15?'),
('Wachovski Sisters', 'Take the red pill, take the blue pill')

INSERT INTO Genres(GenreName, Notes) VALUES
('Horror', 'scary shait'),
('Thriller', 'from Michael Jackson'),
('Comedy', 'a genre back in the days'),
('Drama', 'when you wanna take the girls out on a movie'),
('Action', 'kaBOOM')

INSERT INTO Categories(CategoryName, Notes) VALUES
('First Cat', ''),
('Second Cat', 'string.Empty'),
('Third Cat, Lotta CATS', '[zero]'),
('Fifth Cat', 'null'),
('Seventh Cat Cat Cat', '')

INSERT INTO Movies (Title, DirectorId, CopyrightYear, [Length], GenreId, Rating, Notes) VALUES
('Snatch', 2, '1999', '103', 3, 10, 'drop the gun, fat boy')

INSERT INTO Movies (Title, DirectorId, CopyrightYear, [Length], GenreId, Rating, Notes) VALUES
('The Matrix', 5, '1997', '130', 5, 10, 'I know kung-fu!')

INSERT INTO Movies (Title, DirectorId, CopyrightYear, [Length], GenreId, Rating, Notes) VALUES
('Bob sus zele', 1, '2000', '120', 3, 1, 'make a mess!')

INSERT INTO Movies (Title, DirectorId, CopyrightYear, [Length], GenreId, Rating, Notes) VALUES
('The Girlfriend', 4, '2007', '90', 4, 3, 'Sasha Grey ~')

INSERT INTO Movies (Title, DirectorId, CopyrightYear, [Length], GenreId, Rating, Notes) VALUES
('Wolf from Wall Street', 3, '2015', '145', 1, 9, 'I know kung-fu!')

--14. Car Rental Database
--CREATE DATABASE CarRental 
--USE CarRental
CREATE TABLE Categories (
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	CategoryName NVARCHAR(50),
	DailyRate DECIMAL(5, 2) NOT NULL,
	WeeklyRate DECIMAL(5, 2) NOT NULL,
	MonthlyRate DECIMAL(5, 2) NOT NULL,
	WeekendRate DECIMAL(5, 2) NOT NULL
)
INSERT INTO Categories (CategoryName, DailyRate, WeeklyRate, MonthlyRate, WeekendRate) VALUES
('monster trucks', 5.21, 23.5, 125.5, 45.5)

INSERT INTO Categories (CategoryName, DailyRate, WeeklyRate, MonthlyRate, WeekendRate) VALUES
('tesla cars', 51.21, 123.5, 225.5, 435.5)

INSERT INTO Categories (CategoryName, DailyRate, WeeklyRate, MonthlyRate, WeekendRate) VALUES
('opel astrak', 0.21, 3.5, 5.5, 1.5)

CREATE TABLE Cars (
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	PlateNumber VARCHAR(8),
	Manufacturer VARCHAR(30),
	Model VARCHAR(30),
	CarYear DATE,
	CategoryId INT FOREIGN KEY REFERENCES Categories(Id),
	Doors REAL,
	Picture VARBINARY(MAX),
	Condition NVARCHAR(100),
	Available BIT
)

INSERT INTO Cars (PlateNumber, Manufacturer, Model, CarYear, CategoryId, Doors, Condition, Available) VALUES
('B 0525 A', 'Opel', 'Astra', '1994', 3, 4, 'BRAND NEW WITH RUST', 1)

INSERT INTO Cars (PlateNumber, Manufacturer, Model, CarYear, CategoryId, Doors, Condition, Available) VALUES
('A 2241 X', 'Opel', 'Cadet', '1990', 1, 2, 'BRAND NEW WITH RUST', 1)

INSERT INTO Cars (PlateNumber, Manufacturer, Model, CarYear, CategoryId, Doors, Condition, Available) VALUES
('X 4452 A', 'Opel', 'Vectra', '1997', 3, 4, 'BRAND NEW WITH RUST', 2)

CREATE TABLE Employees (
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	FirstName NVARCHAR(50) NOT NULL,
	LastName NVARCHAR(50) NOT NULL,
	Title NVARCHAR(30),
	Notes NVARCHAR(MAX)
)

INSERT INTO Employees (FirstName, LastName) VALUES
('Dancho', 'Lechkov'),
('Hristo', 'Stoichkov'),
('Emil', 'Kremenliev')

CREATE TABLE Customers (
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	DriverLicenceNumber NVARCHAR(15) NOT NULL,
	FullName NVARCHAR(100) NOT NULL,
	Address NVARCHAR(500),
	City NVARCHAR(50),
	ZIPCode NVARCHAR(10),
	Notes NVARCHAR(200)
)

INSERT INTO Customers (DriverLicenceNumber, FullName) VALUES
('Bql', 'Georgi Ivanov'),
('Zelen', 'Petur Hubchev'),
('Cherven', 'Dimitur Penev')

CREATE TABLE RentalOrders (
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	EmployeeId INT FOREIGN KEY REFERENCES Employees(Id),
	CustomerId INT FOREIGN KEY REFERENCES Customers(Id),
	CarId INT,
	TankLevel INT,
	KilometrageStart INT,
	KilometrageEnd INT,
	TotalKilometrage INT,
	StartDate DATE,
	EndDate DATE,
	TotalDays AS DATEDIFF(DAY, StartDate, EndDate),
	RateApplied INT,
	TaxRate DECIMAL(5, 2),
	OrderStatus NVARCHAR(50),
	Notes NVARCHAR(MAX)
)

INSERT INTO RentalOrders (EmployeeId, CustomerId, StartDate, EndDate) VALUES
(1, 1, '05/05/1995', '05/10/1995'),
(2, 1, '10/10/2010', '10/12/2010'),
(3, 3, '06/07/2017', '09/07/2017')


--15. Hotel Database
--CREATE DATABASE Hotel
--USE Hotel
CREATE TABLE Employees (
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	FirstName NVARCHAR(50) NOT NULL,
	LastName NVARCHAR(50) NOT NULL,
	Title NVARCHAR(100),
	Notes NVARCHAR(MAX)
)

INSERT INTO Employees (FirstName, LastName) VALUES
('Michael', 'Jackson'),
('Michael', 'Jordan'),
('Michael', 'Keaton')

CREATE TABLE Customers (
	AccountNumber INT UNIQUE IDENTITY NOT NULL,
	FirstName NVARCHAR(50) NOT NULL,
	LastName NVARCHAR(50) NOT NULL,
	PhoneNumber INT,
	EmergencyName NVARCHAR(100),
	EmergencyNumber INT,
	Notes NVARCHAR(MAX)
)

INSERT INTO Customers (FirstName, LastName) VALUES
('Josh', 'Brolin'),
('Jon', 'Snow'),
('Jake', 'Gylenhaal')

CREATE TABLE RoomStatus (
	RoomStatus NVARCHAR(50) PRIMARY KEY NOT NULL,
	Notes NVARCHAR(MAX)
)

INSERT INTO RoomStatus (RoomStatus) VALUES
('Occupied'),
('Available'),
('Cleaning')

CREATE TABLE RoomTypes (
	RoomType NVARCHAR(50) PRIMARY KEY NOT NULL,
	Notes NVARCHAR(MAX)
)

INSERT INTO RoomTypes (RoomType) VALUES
('4 person'),
('2 person'),
('Boksonierka, brat')

CREATE TABLE BedTypes (
	BedType NVARCHAR(50) PRIMARY KEY NOT NULL,
	Notes NVARCHAR(MAX)
)

INSERT INTO BedTypes (BedType) VALUES
('King'),
('Queen'),
('Midget')

CREATE TABLE Rooms (
	RoomNumber INT PRIMARY KEY IDENTITY NOT NULL,
	RoomType NVARCHAR(50) FOREIGN KEY REFERENCES RoomTypes(RoomType),
	BedType NVARCHAR(50) FOREIGN KEY REFERENCES BedTypes(BedType),
	Rate DECIMAL(6,2),
	RoomStatus NVARCHAR(50),
	Notes NVARCHAR(MAX)
)

INSERT INTO Rooms (Rate) VALUES
(12.55),
(43.99),
(60.33)

CREATE TABLE Payments (
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	EmployeeId INT,
	PaymentDate DATE,
	AccountNumber INT,
	FirstDateOccipied DATE,
	LastDateOccupied DATE,
	TotalDays AS DATEDIFF(DAY, FirstDateOccipied, LastDateOccupied),
	AmountCharged DECIMAL(10, 2),
	TaxRate DECIMAL(6, 2),
	TaxAmount DECIMAL(6, 2),
	PaymentTotal DECIMAL(12, 2),
	Notes NVARCHAR(MAX)
)

INSERT INTO Payments (EmployeeId, PaymentDate, AmountCharged) VALUES
(1, GETDATE(), 60.25),
(2, GETDATE(), 160.25),
(3, GETDATE(), 460.25)

CREATE TABLE Occupancies (
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	EmployeeId INT,
	DateOccipied DATE,
	AccountNumber INT,
	RoomNumber INT,
	RateApplied DECIMAL(6, 2),
	PhoneCharge DECIMAL(10, 2),
	Notes NVARCHAR(MAX)
)

INSERT INTO Occupancies (EmployeeId, RateApplied, Notes) VALUES
(1, 55.55, 'enough is enough'),
(2, 15.55, 'now I know how the typewriters feel'),
(3, 35.55, 'these exercises are obsolete')

--Problem 16.	Create SoftUni Database
--CREATE DATABASE SoftUni
--USE SoftUni
CREATE TABLE Towns (
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	[Name] NVARCHAR(50)
)

CREATE TABLE Addresses (
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	AddressText NVARCHAR(100),
	TownId INT FOREIGN KEY REFERENCES Towns(Id)
)

CREATE TABLE Departments (
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	[Name] NVARCHAR(50)
)

CREATE TABLE Employees
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	FirstName NVARCHAR(50),
	MiddleName NVARCHAR(50),
	LastName NVARCHAR(50),
	JobTitle NVARCHAR(35),
	DepartmentId INT FOREIGN KEY REFERENCES Departments(Id),
	HireDate DATE,
	Salary DECIMAL(10,2),
	AddressId INT FOREIGN KEY REFERENCES Addresses(Id)
)

--Problem 17.	Backup Database
BACKUP DATABASE SoftUni
	TO DISK = 'D:\softuni-backup.bak' --location where the backup file will be saved
		WITH FORMAT,
			MEDIANAME = 'DB Back up',
			NAME = 'SoftUni DataBase 2017-09-22';
GO

RESTORE DATABASE SoftUni
FROM DISK = 'D:\softuni-backup.bak' --location of the db on your hard drive
GO

--Problem 18.	Basic Insert
--USE SoftUni
INSERT INTO Towns ([Name]) VALUES
('Sofia'),
('Plovdiv'),
('Varna'),
('Burgas')

INSERT INTO Departments (Name) VALUES
('Engineering'),
('Sales'),
('Marketing'),
('Software Development'),
('Quality Assurance')

INSERT INTO Employees (FirstName, MiddleName, LastName, JobTitle, DepartmentId, HireDate, Salary) VALUES
('Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 4, '2013/01/02', 3500.00),
('Petar', 'Petrov', 'Petrov', 'Senior Engineer', 1, '2004/02/03', 4000.00),
('Maria', 'Petrova', 'Ivanova', 'Intern', 5, '2016/28/08', 525.25),
('Georgi', 'Teziev', 'Ivanov', 'CEO', 2, '2007/09/12', 3000.00),
('Peter', 'Pan', 'Pan', 'Intern', 3, '2016/28/08', 599.88)

--19. Basic Select All Fields
SELECT * FROM Towns
SELECT * FROM Departments
SELECT * FROM Employees

--20. Basic Select All Fields and Order Them
SELECT * FROM Towns ORDER BY [Name]
SELECT * FROM Departments ORDER BY [Name]
SELECT * FROM Employees ORDER BY Salary DESC

--21. Basic Select Some Fields
SELECT [Name] FROM Towns ORDER BY [Name]
SELECT [Name] FROM Departments ORDER BY [Name]
SELECT FirstName, LastName, JobTitle, Salary FROM Employees ORDER BY Salary DESC

--22. Increase Employees Salary
UPDATE Employees
SET Salary *= 1.1  
SELECT Salary FROM Employees
--23. Decrease Tax Rate
--USE Hotel
UPDATE Payments
SET TaxRate *= 0.97
SELECT TaxRate FROM Payments

--24. Delete All Records
DELETE FROM Occupancies
SELECT * FROM Occupancies