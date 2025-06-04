

--Create a New Database
CREATE DATABASE AirportTicketingSystemDB;
GO
USE AirportTicketingSystemDB;
GO



--Step 2: Creating the Employees Table

CREATE TABLE Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Role VARCHAR(50) CHECK (Role IN ('Ticketing Staff', 'Ticketing Supervisor'))
);

/*EmployeeID → Primary Key, auto-incremented (IDENTITY(1,1)).

Name → Employee's name (Required, cannot be NULL).

Email → Ensures unique emails for employees.

Role → Restricted to 'Ticketing Staff' or 'Ticketing Supervisor' using a CHECK constraint.  */

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Step 3: Creating the Passengers Table
------ let's create the Passengers table, which stores passenger details such as their PNR, name, email, and meal preference.

CREATE TABLE Passengers (
    PassengerID INT IDENTITY(1,1) PRIMARY KEY,
    PNR VARCHAR(10) UNIQUE NOT NULL,
    Email VARCHAR(100) NOT NULL,
    MealPreference VARCHAR(20) CHECK (MealPreference IN ('Vegetarian', 'Non-Vegetarian')),
    DOB DATE NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL
);
/*PassengerID → Primary Key, auto-incremented (IDENTITY(1,1)).
PNR → Unique identifier for passengers, ensuring no duplicate bookings.
Email → Stores passenger's email address (Required).
MealPreference → Allows only 'Vegetarian' or 'Non-Vegetarian' using a CHECK constraint.
DOB → Stores the passenger's Date of Birth.
FirstName & LastName → Passenger's full name (Required fields).  */
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Step 4: Creating the Flights Table
--Now, let's create the Flights table, which stores details about flights, including flight number, origin, destination, and timings.

CREATE TABLE Flights (
    FlightID INT IDENTITY(1,1) PRIMARY KEY,
    FlightNumber VARCHAR(10) UNIQUE NOT NULL,
    Origin VARCHAR(50) NOT NULL,
    Destination VARCHAR(50) NOT NULL,
    DepartureTime DATETIME NOT NULL,
    ArrivalTime DATETIME NOT NULL
);
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Step 5: Creating the Reservations Table
--Now, let's create the Reservations table, which stores passenger booking details, flight ID, and reservation status.
CREATE TABLE Reservations (
    ReservationID INT IDENTITY(1,1) PRIMARY KEY,
    PNR VARCHAR(10) NOT NULL REFERENCES Passengers(PNR),
    FlightID INT NOT NULL REFERENCES Flights(FlightID),
    Status VARCHAR(20) CHECK (Status IN ('Confirmed', 'Pending', 'Cancelled')),
    ReservationDate DATE NOT NULL CHECK (ReservationDate >= GETDATE())
);

/*ReservationID → Primary Key, auto-incremented (IDENTITY(1,1)).
PNR → Links to the Passengers table, ensuring only valid passengers can have reservations.
FlightID → Links to the Flights table, ensuring only valid flights are booked.
Status → Only allows 'Confirmed', 'Pending', or 'Cancelled'.
ReservationDate → Ensures the reservation is not in the past using CHECK (ReservationDate >= GETDATE()).*/

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Step 6: Creating the Tickets Table
--Now, let's create the Tickets table, which stores ticket details, including reservation ID, flight ID, fare, and ticket class.
CREATE TABLE Tickets (
    TicketID INT IDENTITY(1,1) PRIMARY KEY,
    ReservationID INT NOT NULL REFERENCES Reservations(ReservationID),
    FlightID INT NOT NULL REFERENCES Flights(FlightID),
    IssueDate DATE DEFAULT GETDATE(),
    IssueTime TIME DEFAULT GETDATE(),
    Fare DECIMAL(10,2) NOT NULL,
    SeatNumber VARCHAR(10) NULL,
    Class VARCHAR(20) CHECK (Class IN ('Business', 'FirstClass', 'Economy')),
    IssuedByEmployeeID INT REFERENCES Employees(EmployeeID)
);

/*TicketID → Primary Key, auto-incremented (IDENTITY(1,1)).
ReservationID → Links to the Reservations table, ensuring a ticket is issued only for valid reservations.
FlightID → Links to the Flights table for tracking flight details.
IssueDate & IssueTime → Defaults to the current date and time when a ticket is issued.
Fare → Stores the ticket price.
SeatNumber → Can be NULL if a preferred seat is not available.
Class → Allows only 'Business', 'FirstClass', or 'Economy'.
IssuedByEmployeeID → Links to Employees table, tracking who issued the ticket.*/

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Step 7: Creating the Baggage Table
--Now, let's create the Baggage table, which stores baggage details associated with each ticket.

CREATE TABLE Baggage (
    BaggageID INT IDENTITY(1,1) PRIMARY KEY,
    TicketID INT NOT NULL REFERENCES Tickets(TicketID) ON DELETE CASCADE,
    Weight DECIMAL(5,2) NOT NULL,
    Status VARCHAR(20) CHECK (Status IN ('Checked-in', 'Loaded'))
);
/*
BaggageID → Primary Key, auto-incremented (IDENTITY(1,1)).
TicketID → Links to the Tickets table, ensuring baggage is associated with a valid ticket.
ON DELETE CASCADE → Deletes baggage records if the corresponding ticket is deleted.
Weight → Stores the baggage weight (measured in kg).
Status → Only allows 'Checked-in' or 'Loaded'. */

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Step 8: Verifying That All Tables Were Created Successfully

EXEC sp_tables;


SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_TYPE = 'BASE TABLE';

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--Step 9: Insert Sample Data into the Employees Table
INSERT INTO Employees (Name, Email, Role) VALUES
('Amit Sharma', 'amit.sharma@example.com', 'Ticketing Staff'),
('Priya Verma', 'priya.verma@example.com', 'Ticketing Supervisor'),
('Rahul Nair', 'rahul.nair@example.com', 'Ticketing Staff'),
('Neha Iyer', 'neha.iyer@example.com', 'Ticketing Supervisor'),
('Sandeep Patel', 'sandeep.patel@example.com', 'Ticketing Staff'),
('David Brown', 'david.brown@example.com', 'Ticketing Staff'),
('Emma Wilson', 'emma.wilson@example.com', 'Ticketing Supervisor'),
('Liam Johnson', 'liam.johnson@example.com', 'Ticketing Staff'),
('Olivia White', 'olivia.white@example.com', 'Ticketing Staff'),
('Ethan Green', 'ethan.green@example.com', 'Ticketing Supervisor'),
('Sophia Thomas', 'sophia.thomas@example.com', 'Ticketing Staff'),
('Michael Scott', 'michael.scott@example.com', 'Ticketing Staff'),
('Jessica Adams', 'jessica.adams@example.com', 'Ticketing Supervisor'),
('Daniel Clark', 'daniel.clark@example.com', 'Ticketing Staff'),
('Emily Watson', 'emily.watson@example.com', 'Ticketing Supervisor');

SELECT * FROM Employees;


--Step 10: Inserting Sample Data into the Passengers Table

INSERT INTO Passengers (PNR, Email, MealPreference, DOB, FirstName, LastName) VALUES
('PNR101', 'raj.kapoor@example.com', 'Vegetarian', '1985-06-15', 'Raj', 'Kapoor'),
('PNR102', 'ananya.sharma@example.com', 'Non-Vegetarian', '1992-08-20', 'Ananya', 'Sharma'),
('PNR103', 'vivek.mishra@example.com', 'Vegetarian', '2000-05-10', 'Vivek', 'Mishra'),
('PNR104', 'sneha.bose@example.com', 'Non-Vegetarian', '1995-12-01', 'Sneha', 'Bose'),
('PNR105', 'karthik.iyer@example.com', 'Vegetarian', '1990-03-05', 'Karthik', 'Iyer'),
('PNR106', 'sarah.lee@example.com', 'Vegetarian', '1980-11-22', 'Sarah', 'Lee'),
('PNR107', 'chris.martin@example.com', 'Non-Vegetarian', '1995-04-10', 'Chris', 'Martin'),
('PNR108', 'olivia.adams@example.com', 'Vegetarian', '1987-06-15', 'Olivia', 'Adams'),
('PNR109', 'john.doe@example.com', 'Non-Vegetarian', '1998-09-25', 'John', 'Doe'),
('PNR110', 'emma.brown@example.com', 'Vegetarian', '1984-07-30', 'Emma', 'Brown');

SELECT * FROM  Passengers;


--Step 11: Insert Sample Data into the Flights Table
INSERT INTO Flights (FlightNumber, Origin, Destination, DepartureTime, ArrivalTime) VALUES
('AI101', 'New York', 'London', '2025-06-10 08:00:00', '2025-06-10 18:00:00'),
('BA202', 'London', 'Dubai', '2025-06-12 10:00:00', '2025-06-12 20:00:00'),
('EK303', 'Dubai', 'Sydney', '2025-06-15 06:00:00', '2025-06-15 22:00:00'),
('LH404', 'Frankfurt', 'New York', '2025-06-18 09:00:00', '2025-06-18 15:00:00'),
('QR505', 'Doha', 'Toronto', '2025-06-20 01:00:00', '2025-06-20 10:00:00'),
('AI707', 'Delhi', 'Singapore', '2025-06-22 14:00:00', '2025-06-22 22:00:00'),
('SQ808', 'Singapore', 'San Francisco', '2025-06-25 23:00:00', '2025-06-26 14:00:00'),
('CX909', 'Hong Kong', 'Tokyo', '2025-06-27 07:00:00', '2025-06-27 12:00:00'),
('AF111', 'Paris', 'Los Angeles', '2025-06-29 11:00:00', '2025-06-29 20:00:00'),
('DL212', 'Atlanta', 'Chicago', '2025-07-01 18:00:00', '2025-07-01 20:00:00');

SELECT * FROM Flights;


--Step 12: Insert Sample Data into the Reservations Table

INSERT INTO Reservations (PNR, FlightID, Status, ReservationDate) VALUES
('PNR101', 1, 'Confirmed', '2025-06-05'),
('PNR102', 2, 'Pending', '2025-06-07'),
('PNR103', 3, 'Confirmed', '2025-06-10'),
('PNR104', 4, 'Cancelled', '2025-06-12'),
('PNR105', 5, 'Confirmed', '2025-06-15'),
('PNR106', 6, 'Pending', '2025-06-17'),
('PNR107', 7, 'Confirmed', '2025-06-20'),
('PNR108', 8, 'Confirmed', '2025-06-22'),
('PNR109', 9, 'Pending', '2025-06-25'),
('PNR110', 10, 'Confirmed', '2025-06-28');

SELECT * FROM Reservations;

--Step 13: Insert Sample Data into the Tickets Table

INSERT INTO Tickets (ReservationID, FlightID, Fare, SeatNumber, Class, IssuedByEmployeeID) VALUES
(1, 1, 3500.00, '22B', 'Economy', 1),
(2, 2, 4800.00, '10A', 'Business', 2),
(3, 3, 5200.00, '5C', 'FirstClass', 3),
(4, 4, 2800.00, '14E', 'Economy', 4),
(5, 5, 4600.00, '7D', 'Business', 5),
(6, 6, 3100.00, '19F', 'Economy', 6),
(7, 7, 5300.00, '3A', 'FirstClass', 7),
(8, 8, 2900.00, '21C', 'Economy', 8),
(9, 9, 4700.00, '9B', 'Business', 9),
(10, 10, 3300.00, '18D', 'Economy', 10);

SELECT * FROM Tickets;

--Step 14: Insert Sample Data into the Baggage Table

INSERT INTO Baggage (TicketID, Weight, Status) VALUES
(1, 18.00, 'Checked-in'),
(2, 25.00, 'Loaded'),
(3, 22.50, 'Checked-in'),
(4, 15.00, 'Checked-in'),
(5, 28.00, 'Loaded'),
(6, 20.00, 'Checked-in'),
(7, 30.00, 'Loaded'),
(8, 17.50, 'Checked-in'),
(9, 19.00, 'Checked-in'),
(10, 24.00, 'Loaded');

SELECT * FROM Baggage;

--Step 15: Verify Data in All Tables
SELECT 'Employees' AS TableName, COUNT(*) AS TotalRows FROM Employees
UNION ALL
SELECT 'Passengers', COUNT(*) FROM Passengers
UNION ALL
SELECT 'Flights', COUNT(*) FROM Flights
UNION ALL
SELECT 'Reservations', COUNT(*) FROM Reservations
UNION ALL
SELECT 'Tickets', COUNT(*) FROM Tickets
UNION ALL
SELECT 'Baggage', COUNT(*) FROM Baggage;




select * from Passengers;
select * from Reservations;
--Step 16: Query to Find Passengers with Pending Reservations

SELECT p.PassengerID, p.FirstName, p.LastName, r.ReservationID, r.Status 
FROM Passengers p
JOIN Reservations r ON p.PNR = r.PNR
WHERE r.Status = 'Pending';
/* Why Are We Running This Query?
In Task 1 of the assignment, we were asked to identify passengers with pending reservations.
 This query helps the airport ticketing system know which passengers haven't confirmed their 
 bookings yet, so employees can follow up with them.  */


--Step 17: Query to Find Passengers Aged 40 and Above

SELECT PassengerID, FirstName, LastName, DOB,
    DATEDIFF(YEAR, DOB, GETDATE()) AS Age
FROM Passengers
WHERE DATEDIFF(YEAR, DOB, GETDATE()) >= 40;

/*DATEDIFF(YEAR, DOB, GETDATE()) → Calculates the passenger’s age.
WHERE DATEDIFF(YEAR, DOB, GETDATE()) >= 40 → Filters only passengers who are 40 or older. */

--Step 18: Createing a Stored Procedure to Search Passengers by Last Name
----This will let's create a Stored Procedure that will allows us to search for passengers by their last name.
CREATE PROCEDURE SearchPassengerByLastName
    @LastName NVARCHAR(50)
AS
BEGIN
    SELECT * FROM Passengers
    WHERE LastName LIKE '%' + @LastName + '%'
    ORDER BY FirstName;
END
GO
--we can find passengers by their last name without writing a full SQL query every time.
--Execute a Stored Procedure 
EXEC SearchPassengerByLastName @LastName = 'Kapoor';



----Step 19,Task 1.4 (b): Create Stored Procedure for Business Class Reservations Made Today
--This procedure returns a list of passengers who have a reservation for today in Business class.
CREATE PROCEDURE GetBusinessClassPassengersToday
AS
BEGIN
    SELECT 
        p.PassengerID,
        p.FirstName,
        p.LastName,
        r.ReservationID,
        r.ReservationDate,
        t.Class
    FROM Passengers p
    JOIN Reservations r ON p.PNR = r.PNR
    JOIN Tickets t ON r.ReservationID = t.ReservationID
    WHERE t.Class = 'Business' 
      AND CAST(r.ReservationDate AS DATE) = CAST(GETDATE() AS DATE);
END;
GO
--Execute the procedure to test (make sure at least one record matches today's date)
EXEC GetBusinessClassPassengersToday;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Step 20: Task 1.4(c) – Stored Procedure to Insert a New Employee
CREATE PROCEDURE InsertNewEmployee
    @Name NVARCHAR(100),
    @Email NVARCHAR(100),
    @Role NVARCHAR(50)
AS
BEGIN
    INSERT INTO Employees (Name, Email, Role)
    VALUES (@Name, @Email, @Role);
END;
GO

--Example: Executing the procedure
EXEC InsertNewEmployee 
    @Name = 'Ravi Patel',
    @Email = 'ravi.patel@example.com',
    @Role = 'Ticketing Staff';

SELECT * FROM Employees
WHERE Email = 'ravi.patel@example.com';

----Step 21:Task 1.4(d) Stored Procedure – Update Passenger Details If Booked Before
--This procedure updates passenger information only if the passenger has an existing reservation.
CREATE PROCEDURE UpdatePassengerDetails
    @PassengerID INT,
    @Email NVARCHAR(100),
    @MealPreference VARCHAR(20),
    @LastName NVARCHAR(50)
AS
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM Reservations r
        JOIN Passengers p ON p.PNR = r.PNR
        WHERE p.PassengerID = @PassengerID
    )
    BEGIN
        UPDATE Passengers
        SET Email = @Email,
            MealPreference = @MealPreference,
            LastName = @LastName
        WHERE PassengerID = @PassengerID;
    END
    ELSE
    BEGIN
        PRINT 'Passenger has not booked a flight yet. No update performed.';
    END
END;
GO

-- Replace 1 with a valid PassengerID who has a reservation
EXEC UpdatePassengerDetails 
    @PassengerID = 1,
    @Email = 'updated.email@example.com',
    @MealPreference = 'Vegetarian',
    @LastName = 'Singh';

SELECT * FROM Passengers
WHERE PassengerID = 1;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 22 Task 1.5: Enhanced View – Tickets Issued + Total Revenue Including Extras
--This view shows all tickets issued by employees along with fare and estimated extras.
CREATE OR ALTER VIEW EmployeeIssuedRevenueView AS
SELECT 
    e.EmployeeID,
    e.Name AS IssuedBy,
    t.TicketID,
    t.Class,
    t.Fare,
    ISNULL(b.Weight * 100, 0) AS BaggageFee,
    20 AS MealFee,      -- Simulated fixed meal upgrade
    30 AS SeatFee,      -- Simulated preferred seat charge
    (t.Fare + ISNULL(b.Weight * 100, 0) + 20 + 30) AS TotalRevenue
FROM Employees e
JOIN Tickets t ON e.EmployeeID = t.IssuedByEmployeeID
LEFT JOIN Baggage b ON t.TicketID = b.TicketID;

SELECT * FROM EmployeeIssuedRevenueView;
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--Step 23, Task 1.6: Create a Trigger to Automatically Update Seat Status when a ticket is issued.
CREATE TRIGGER AutoUpdateSeatStatus
ON Tickets
AFTER INSERT
AS
BEGIN
    UPDATE Tickets
    SET SeatNumber = 'Reserved'
    WHERE TicketID IN (SELECT TicketID FROM inserted);
END;

--Testing  the Trigger we will Insert a New Ticket and Check if the Seat is Automatically Reserved:
INSERT INTO Tickets (ReservationID, FlightID, Fare, Class)
VALUES (7, 2, 5000.00, 'Business');

--check if the ticket is successfully added:
SELECT * FROM Tickets WHERE ReservationID = 7;

select * from Reservations;
select * from Tickets;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 24: Scalar Function – Get Total Checked-in Baggage by Flight and Date
--This function returns the total number of checked-in baggages for a given flight on a specific date.

CREATE FUNCTION GetCheckedInBaggageCount
(
    @FlightID INT,
    @Date DATE
)
RETURNS INT
AS
BEGIN
    DECLARE @Count INT;

    SELECT @Count = COUNT(*)
    FROM Baggage b
    JOIN Tickets t ON b.TicketID = t.TicketID
    WHERE b.Status = 'Checked-in'
      AND t.FlightID = @FlightID
      AND CAST(t.IssueDate AS DATE) = @Date;

    RETURN @Count;
END;
GO
-- Get checked-in baggage count for flight ID 1 on '2025-06-07'
SELECT dbo.GetCheckedInBaggageCount(1, '2025-06-07') AS CheckedInBaggage;
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Step 25: Bonus Query – Flights with the Most Total Baggage Weight

SELECT 
    f.FlightNumber,
    SUM(b.Weight) AS TotalBaggageWeight
FROM Flights f
JOIN Tickets t ON f.FlightID = t.FlightID
JOIN Baggage b ON t.TicketID = b.TicketID
GROUP BY f.FlightNumber
ORDER BY TotalBaggageWeight DESC;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Step 26: Bonus Query – Number of Tickets Issued by Each Employee

SELECT 
    e.Name AS EmployeeName,
    COUNT(t.TicketID) AS TicketsIssued
FROM Employees e
JOIN Tickets t ON e.EmployeeID = t.IssuedByEmployeeID
GROUP BY e.Name
ORDER BY TicketsIssued DESC;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step : Creating a Read-Only User for Security
CREATE LOGIN ReadOnlyUser WITH PASSWORD = 'Airport@Aindree123';
CREATE USER ReadOnlyUser FOR LOGIN ReadOnlyUser;
ALTER ROLE db_datareader ADD MEMBER ReadOnlyUser;





BACKUP DATABASE AirportTicketingSystemDB
TO DISK = 'C:\Users\Public\Backup\AirportTicketingSystemDB.bak'
WITH FORMAT, MEDIANAME = 'SQLServerBackup', NAME = 'Full Backup of AirportTicketingSystemDB';