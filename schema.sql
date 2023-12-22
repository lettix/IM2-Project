-- table 'author'
CREATE TABLE `author` (
  `authorid` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(200) NOT NULL,
  `status` ENUM('Enable', 'Disable') NOT NULL
);

-- table `book`
CREATE TABLE `book` (
  `bookid` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `categoryid` INT UNSIGNED NOT NULL,
  `authorid` INT UNSIGNED NOT NULL,
  `rackid` INT UNSIGNED NOT NULL,
  `name` TEXT NOT NULL,
  `picture` VARCHAR(250) NOT NULL,
  `publisherid` INT UNSIGNED NOT NULL,
  `isbn` VARCHAR(30) NOT NULL,
  `no_of_copy` INT NOT NULL,
  `status` ENUM('Enable', 'Disable') NOT NULL,
  `added_on` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  `updated_on` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP()
);

-- table `category`
CREATE TABLE `category` (
  `categoryid` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(200) NOT NULL,
  `status` ENUM('Enable', 'Disable') NOT NULL
);

-- table `issued_book`
CREATE TABLE `issued_book` (
  `issuebookid` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `bookid` INT UNSIGNED NOT NULL,
  `userid` INT UNSIGNED NOT NULL,
  `issue_date_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  `expected_return_date` DATETIME NOT NULL,
  `return_date_time` DATETIME NOT NULL,
  `status` ENUM('Issued', 'Returned', 'Not Return') NOT NULL
);

-- table `publisher`
CREATE TABLE `publisher` (
  `publisherid` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(255) NOT NULL,
  `status` ENUM('Enable', 'Disable') NOT NULL
);

-- table `rack`
CREATE TABLE `rack` (
  `rackid` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(200) NOT NULL,
  `status` ENUM('Enable', 'Disable') NOT NULL DEFAULT 'Enable'
);

-- table `user`
CREATE TABLE `user` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `first_name` VARCHAR(255),
  `last_name` VARCHAR(255),
  `email` VARCHAR(255),
  `password` VARCHAR(64) NOT NULL,
  `role` ENUM('admin', 'user') DEFAULT 'admin'
);

-- SQL CRUD Operations

-- Create (INSERT) Operations
INSERT INTO user (`first_name`, `last_name`, `email`, `password`, `role`) VALUES ('John', 'Doe', 'john.doe@example.com', 'password123', 'user');

INSERT INTO book (`name`, `status`, `isbn`, `no_of_copy`, `categoryid`, `authorid`, `rackid`, `publisherid`, `picture`) VALUES ('Sample Book', 'Enable', '123456789', 10, 1, 1, 1, 1, 'default_picture.jpg');

INSERT INTO issued_book (`bookid`, `userid`, `expected_return_date`, `return_date_time`, `status`) VALUES (1, 1, '2023-01-01', '2023-01-10', 'Issued');

INSERT INTO category (`name`, `status`) VALUES ('Fiction', 'Active');

INSERT INTO author (`name`, `status`) VALUES ('Author Name', 'Active');

INSERT INTO publisher (`name`, `status`) VALUES ('Publisher Name', 'Active');

INSERT INTO rack (`name`, `status`) VALUES ('Rack Name', 'Active');


-- Read (SELECT) Operations

SELECT * FROM user WHERE email = 'john.doe@example.com' AND password = 'password123';

SELECT COUNT(*) AS total_books FROM book;
SELECT COUNT(*) AS available_books FROM book WHERE status = 'Enable';
SELECT COUNT(*) AS returned_books FROM issued_book WHERE status = 'Returned';
SELECT COUNT(*) AS issued_books FROM issued_book WHERE status = 'Issued';

SELECT * FROM user;

SELECT book.bookid, book.picture, book.name, book.status, book.isbn, book.no_of_copy, book.updated_on,
       author.name AS author_name, category.name AS category_name, rack.name AS rack_name, publisher.name AS publisher_name
FROM book
LEFT JOIN author ON author.authorid = book.authorid
LEFT JOIN category ON category.categoryid = book.categoryid
LEFT JOIN rack ON rack.rackid = book.rackid
LEFT JOIN publisher ON publisher.publisherid = book.publisherid;

SELECT issued_book.issuebookid, issued_book.issue_date_time, issued_book.expected_return_date,
       issued_book.return_date_time, issued_book.status, book.name AS book_name, book.isbn,
       user.first_name, user.last_name
FROM issued_book
LEFT JOIN book ON book.bookid = issued_book.bookid
LEFT JOIN user ON user.id = issued_book.userid;

SELECT categoryid, name, status FROM category;

SELECT authorid, name, status FROM author;

SELECT publisherid, name, status FROM publisher;

SELECT rackid, name, status FROM rack;


-- Update Operations

UPDATE user SET first_name = 'UpdatedName', last_name = 'UpdatedLastName', email = 'updated.email@example.com', role = 'admin' WHERE id = 1;

UPDATE book SET name = 'Updated Book', status = 'Disable', isbn = '987654321', no_of_copy = 5, categoryid = 2, authorid = 2, rackid = 2, publisherid = 2 WHERE bookid = 1;

UPDATE issued_book SET bookid = 2, userid = 2, expected_return_date = '2023-02-01', return_date_time = '2023-01-20', status = 'Returned' WHERE issuebookid = 1;

UPDATE category SET name = 'Updated Category', status = 'Inactive' WHERE categoryid = 1;

UPDATE author SET name = 'Updated Author', status = 'Inactive' WHERE authorid = 1;

UPDATE publisher SET name = 'Updated Publisher', status = 'Inactive' WHERE publisherid = 1;

UPDATE rack SET name = 'Updated Rack', status = 'Inactive' WHERE rackid = 1;


-- Delete Operations

DELETE FROM user WHERE id = 1;

DELETE FROM book WHERE bookid = 1;

DELETE FROM issued_book WHERE issuebookid = 1;

DELETE FROM category WHERE categoryid = 1;

DELETE FROM author WHERE authorid = 1;

DELETE FROM publisher WHERE publisherid = 1;

DELETE FROM rack WHERE rackid = 1;

-- SQL VIEWS
CREATE VIEW issued_book_view AS
SELECT issued_book.issuebookid, issued_book.issue_date_time, issued_book.expected_return_date,
       issued_book.return_date_time, issued_book.status,
       book.name AS book_name, book.isbn, user.first_name, user.last_name
FROM issued_book
LEFT JOIN book ON book.bookid = issued_book.bookid
LEFT JOIN user ON user.id = issued_book.userid;

CREATE VIEW view_total_books AS
SELECT COUNT(*) AS total_books FROM book;

CREATE VIEW view_available_books AS
SELECT COUNT(*) AS available_books FROM book WHERE status = 'Enable';

CREATE VIEW view_returned_books AS
SELECT COUNT(*) AS returned_books FROM issued_book WHERE status = 'Returned';

CREATE VIEW view_issued_books AS
SELECT COUNT(*) AS issued_books FROM issued_book WHERE status = 'Issued';



-- SQL STORED PROCEDURES
DELIMITER $$
CREATE PROCEDURE save_user(
    IN first_name VARCHAR(255),
    IN last_name VARCHAR(255),
    IN email VARCHAR(255),
    IN password VARCHAR(255),
    IN role VARCHAR(255),
    IN action VARCHAR(255),
    IN userId INT
)
BEGIN
    IF action = 'updateUser' THEN
        UPDATE user
        SET first_name = first_name,
            last_name = last_name,
            email = email,
            role = role
        WHERE id = userId;
    ELSE
        INSERT INTO user (first_name, last_name, email, password, role)
        VALUES (first_name, last_name, email, password, role);
    END IF;
END;
$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE UpdateIssuedBookStatus(IN issue_book_id INT, IN new_status VARCHAR(20))
BEGIN
    UPDATE issued_book SET status = new_status WHERE issuebookid = issue_book_id;
END $$
DELIMITER ;


-- SQL TRIGGERS
DELIMITER $$
CREATE TRIGGER after_issue_book
AFTER INSERT ON issued_book
FOR EACH ROW
BEGIN
    UPDATE book
    SET status = 'Issued'
    WHERE bookid = NEW.bookid;
END;
$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER after_return_book
AFTER UPDATE ON issued_book
FOR EACH ROW
BEGIN
    IF NEW.status = 'Returned' THEN
        UPDATE book
        SET status = 'Enable'
        WHERE bookid = NEW.bookid;
    END IF;
END;
$$
DELIMITER ;

CREATE TRIGGER before_update_book
BEFORE UPDATE ON book
FOR EACH ROW
SET NEW.updated_on = NOW();


--SQL JOINS
SELECT
    book.bookid,
    book.picture,
    book.name,
    book.status,
    book.isbn,
    book.no_of_copy,
    book.updated_on,
    author.name AS author_name,
    category.name AS category_name,
    rack.name AS rack_name,
    publisher.name AS publisher_name
FROM
    book
    LEFT JOIN author ON author.authorid = book.authorid
    LEFT JOIN category ON category.categoryid = book.categoryid
    LEFT JOIN rack ON rack.rackid = book.rackid
    LEFT JOIN publisher ON publisher.publisherid = book.publisherid;


SELECT
    issued_book.issuebookid,
    issued_book.issue_date_time,
    issued_book.expected_return_date,
    issued_book.return_date_time,
    issued_book.status,
    book.name AS book_name,
    book.isbn,
    user.first_name,
    user.last_name
FROM
    issued_book
    LEFT JOIN book ON book.bookid = issued_book.bookid
    LEFT JOIN user ON user.id = issued_book.userid;


 