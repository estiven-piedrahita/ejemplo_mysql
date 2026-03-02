create database crudzaso_academy;

use crudzaso_academy;

create table users(
id int auto_increment primary key,
full_name varchar(200) not null,
email varchar(120) not null unique,
created_at datetime default current_timestamp
);

create table roles (
id int auto_increment primary key,
code varchar(100) not null unique,
name varchar(100) not null,
description text,
created_at datetime default current_timestamp

);


CREATE TABLE user_roles (
	user_id INT NOT NULL,
    role_id INT NOT NULL,
    assigned_at DATETIME DEFAULT current_timestamp,
    
    PRIMARY KEY (user_id, role_id),
    
    CONSTRAINT fk_user_roles_user
		FOREIGN KEY (user_id)
        REFERENCES users(id) ON DELETE CASCADE,
        
	FOREIGN KEY (role_id)
    REFERENCES roles(id) ON DELETE CASCADE
    
);

CREATE TABLE courses (
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    level ENUM('BEGINNER', 'INTERMEDIATE', 'EXPERT') NOT NULL DEFAULT 'BEGINNER'
    created_at DATATIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE enrollments (
	ID INT AUTO_INCREMENT PRIMARY KEY,
    
    user_id INT NOT NULL,
    
    course_id INT NOT NULL,
    
    enrolled_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    
	FOREIGN KEY (user_id)
    REFERENCES users(id) ON DELETE CASCADE,
    
	FOREIGN KEY (course_id)
    REFERENCES courses(id) ON DELETE CASCADE
    
    UNIQUE KEY uq_user_course (user_id, course_id)
);

