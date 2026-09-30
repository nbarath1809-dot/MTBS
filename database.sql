CREATE DATABASE IF NOT EXISTS movie_ticket_db;
USE movie_ticket_db;

CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    phone VARCHAR(15),
    role ENUM('CUSTOMER','MANAGER','ADMIN') DEFAULT 'CUSTOMER'
);

CREATE TABLE movies (
    movie_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(150) NOT NULL,
    genre VARCHAR(50),
    language VARCHAR(50),
    duration INT,
    description VARCHAR(500)
);

CREATE TABLE screens (
    screen_id INT PRIMARY KEY AUTO_INCREMENT,
    screen_name VARCHAR(50),
    total_seats INT
);

CREATE TABLE shows (
    show_id INT PRIMARY KEY AUTO_INCREMENT,
    movie_id INT,
    screen_id INT,
    show_date DATE,
    show_time TIME,
    price DECIMAL(10,2),
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id),
    FOREIGN KEY (screen_id) REFERENCES screens(screen_id)
);

CREATE TABLE seats (
    seat_id INT PRIMARY KEY AUTO_INCREMENT,
    screen_id INT,
    seat_number VARCHAR(10),
    status ENUM('AVAILABLE','BOOKED') DEFAULT 'AVAILABLE',
    FOREIGN KEY (screen_id) REFERENCES screens(screen_id)
);

CREATE TABLE bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    show_id INT,
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2),
    status ENUM('CONFIRMED','CANCELLED') DEFAULT 'CONFIRMED',
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (show_id) REFERENCES shows(show_id)
);

CREATE TABLE booking_seats (
    booking_id INT,
    seat_id INT,
    PRIMARY KEY (booking_id, seat_id),
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
    FOREIGN KEY (seat_id) REFERENCES seats(seat_id)
);

CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT,
    amount DECIMAL(10,2),
    payment_method VARCHAR(50),
    payment_status VARCHAR(30),
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
);

INSERT INTO users(name,email,password,phone,role)
VALUES ('Admin','admin@gmail.com','admin123','9876543210','ADMIN');

INSERT INTO users(name,email,password,phone,role)
VALUES ('Manager','manager@gmail.com','manager123','9876543211','MANAGER');

INSERT INTO screens(screen_name,total_seats) VALUES ('Screen 1',8);

INSERT INTO seats(screen_id,seat_number) VALUES
(1,'A1'),(1,'A2'),(1,'A3'),(1,'A4'),
(1,'B1'),(1,'B2'),(1,'B3'),(1,'B4');

INSERT INTO movies(movie_id,title,genre,language,duration,description) VALUES
(1, 'Kantara', 'Action / Drama', 'Tamil', 150, 'A fiery village rebel faces off with an upright forest officer while defending his ancestors sacred land.');

INSERT INTO shows(show_id, movie_id, screen_id, show_date, show_time, price) VALUES
(1, 1, 1, CURDATE(), '18:00:00', 150.00);

