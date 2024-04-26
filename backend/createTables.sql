-- Active: 1713898692625@@127.0.0.1@3306@mhs
DROP TABLE IF EXISTS MAKES_APPOINTMENT;
DROP TABLE IF EXISTS TREATS;
DROP TABLE IF EXISTS INVOICE_DETAIL;
DROP TABLE IF EXISTS OUTPATIENT_SURGERY;
DROP TABLE IF EXISTS OFFICE_BUILDING;
DROP TABLE IF EXISTS INVOICE;
DROP TABLE IF EXISTS PATIENT;
DROP TABLE IF EXISTS DOCTOR;
DROP TABLE IF EXISTS NURSE;
DROP TABLE IF EXISTS OTHER_HCP;
DROP TABLE IF EXISTS ADMIN_STAFF;
DROP TABLE IF EXISTS EMPLOYEE;
DROP TABLE IF EXISTS FACILITY;
DROP TABLE IF EXISTS INSURANCE_COMPANY;

CREATE TABLE FACILITY (
    Facility_ID INT AUTO_INCREMENT PRIMARY KEY,
    Street VARCHAR(255) NOT NULL,
    City VARCHAR(255) NOT NULL,
    State VARCHAR(2) NOT NULL,
    Zip VARCHAR(5) NOT NULL,
    MaxSize INT,
    Facility_Type VARCHAR(50) NOT NULL,
    CHECK (Facility_Type IN ('OP Surgery', 'Office')),
    CHECK (Zip REGEXP '^[0-9]{5}$')
);

CREATE TABLE INSURANCE_COMPANY (
    InsuranceComp_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL UNIQUE,
    Street VARCHAR(255) NOT NULL,
    City VARCHAR(255) NOT NULL,
    State VARCHAR(2) NOT NULL,
    Zip VARCHAR(5) NOT NULL
);

CREATE TABLE EMPLOYEE (
    EmployeeID INT AUTO_INCREMENT PRIMARY KEY,
    SSN CHAR(9) UNIQUE NOT NULL,
    FirstName VARCHAR(255) NOT NULL,
    MiddleName VARCHAR(255),
    LastName VARCHAR(255) NOT NULL,
    Street VARCHAR(255) NOT NULL,
    City VARCHAR(255) NOT NULL,
    State VARCHAR(255) NOT NULL,
    Zip VARCHAR(5) NOT NULL,
    Salary DECIMAL(10, 2) CHECK (Salary >= 0),
    Date_Hired DATE NOT NULL,
    Job_Class VARCHAR(50) NOT NULL,
    Fac_ID INT NOT NULL,
    FOREIGN KEY (Fac_ID) REFERENCES FACILITY(Facility_ID),
    CHECK (SSN REGEXP '^[0-9]{9}$'),
    CHECK (Job_Class IN ('Doctor', 'Nurse', 'HCP', 'Admin')),
    CHECK (Zip REGEXP '^[0-9]{5}$')
);

CREATE TABLE DOCTOR (
    EmployeeID INT PRIMARY KEY,
    Speciality VARCHAR(255) NOT NULL,
    Board_Certification_Date DATE NOT NULL,
    FOREIGN KEY (EmployeeID) REFERENCES EMPLOYEE(EmployeeID)
    ON DELETE CASCADE
);

CREATE TABLE NURSE (
    EmployeeID INT PRIMARY KEY,
    Certification VARCHAR(255) NOT NULL,
    FOREIGN KEY (EmployeeID) REFERENCES EMPLOYEE(EmployeeID)
    ON DELETE CASCADE
);

CREATE TABLE OTHER_HCP (
    EmployeeID INT PRIMARY KEY,
    Practice_Area VARCHAR(255) NOT NULL,
    FOREIGN KEY (EmployeeID) REFERENCES EMPLOYEE(EmployeeID)
    ON DELETE CASCADE
);

CREATE TABLE ADMIN_STAFF (
    EmployeeID INT PRIMARY KEY,
    Job_Title VARCHAR(255) NOT NULL,
    FOREIGN KEY (EmployeeID) REFERENCES EMPLOYEE(EmployeeID)
    ON DELETE CASCADE
);

CREATE TABLE PATIENT (
    Patient_ID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(255) NOT NULL,
    MiddleName VARCHAR(255),
    LastName VARCHAR(255) NOT NULL,
    Street VARCHAR(255) NOT NULL,
    City VARCHAR(255) NOT NULL,
    State VARCHAR(2) NOT NULL,
    Zip VARCHAR(5) NOT NULL,
    First_Visit_Date DATE NOT NULL,
    Doctor_ID INT NOT NULL,
    InComp_ID INT NOT NULL,
    FOREIGN KEY (Doctor_ID) REFERENCES DOCTOR(EmployeeID),
    FOREIGN KEY (InComp_ID) REFERENCES INSURANCE_COMPANY(InsuranceComp_ID),
    CHECK (Zip REGEXP '^[0-9]{5}$')
);

CREATE TABLE OFFICE_BUILDING (
    Facility_ID INT PRIMARY KEY,
    Office_Count INT CHECK (Office_Count >= 0),
    FOREIGN KEY (Facility_ID) REFERENCES FACILITY(Facility_ID)
    ON DELETE CASCADE
);

CREATE TABLE OUTPATIENT_SURGERY (
    Facility_ID INT PRIMARY KEY,
    Room_Count INT CHECK (Room_Count >= 0),
    Procedure_Code VARCHAR(255) NOT NULL,
    Description VARCHAR(1000),
    FOREIGN KEY (Facility_ID) REFERENCES FACILITY(Facility_ID)
    ON DELETE CASCADE
);

CREATE TABLE INVOICE (
    Inv_ID INT AUTO_INCREMENT PRIMARY KEY,
    InvDate DATE,
    InComp_ID INT NOT NULL,
    FOREIGN KEY (InComp_ID) REFERENCES INSURANCE_COMPANY(InsuranceComp_ID)
);

CREATE TABLE INVOICE_DETAIL (
    InvDetailID INT AUTO_INCREMENT PRIMARY KEY,
    Cost DECIMAL(10, 2) CHECK (Cost >= 0),
    Inv_ID INT NOT NULL,
    FOREIGN KEY (Inv_ID) REFERENCES INVOICE(Inv_ID)
    ON DELETE CASCADE
);

CREATE TABLE MAKES_APPOINTMENT (
    Pat_ID INT,
    Doc_ID INT,
    Fac_ID INT,
    Date_Time TIMESTAMP,
    InD_ID INT NOT NULL,
    PRIMARY KEY (Pat_ID, Doc_ID, Fac_ID, Date_Time),
    FOREIGN KEY (Pat_ID) REFERENCES PATIENT(Patient_ID),
    FOREIGN KEY (Doc_ID) REFERENCES DOCTOR(EmployeeID),
    FOREIGN KEY (Fac_ID) REFERENCES FACILITY(Facility_ID),
    FOREIGN KEY (InD_ID) REFERENCES INVOICE_DETAIL(Inv_ID)
);

CREATE TABLE TREATS (
    Patient_ID INT,
    Doctor_ID INT,
    PRIMARY KEY (Patient_ID, Doctor_ID),
    FOREIGN KEY (Patient_ID) REFERENCES PATIENT(Patient_ID),
    FOREIGN KEY (Doctor_ID) REFERENCES DOCTOR(EmployeeID)
);