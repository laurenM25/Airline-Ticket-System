create table airline(
    name varchar(100) primary key);
    
create table airplane(
    airline_name varchar(100) not null,
    id int not null,
    seat_capacity int not null,
    primary key (airline_name, id),
    foreign key (airline_name)
    	references airline(name)
    	on delete cascade 
    	on update cascade);
        
create table city (
    name varchar(100) primary key);

create table airport (
    name varchar(100) primary key,
    city varchar(100) not null,
    foreign key (city)
    	references city(name)
    	on delete cascade 
    	on update cascade); 

create table flight (
    flight_num varchar(100) not null, 
    airline_name varchar(100) not null,
    departure_time DATETIME not null,
    arrival_time DATETIME not null,
    price decimal(10,2) not null,
    status varchar(20) not null
        check (status in ('upcoming', 'in-progress', 'delayed')),
    airplane_id int not null,
    departure_airport varchar(100) not null,
    arrival_airport varchar(100) not null,
    primary key (flight_num, airline_name),
    foreign key (airline_name)
         references airline(name)
         on delete cascade
         on update cascade,
     foreign key (airline_name, airplane_id)
          references airplane(airline_name, id)
          on delete restrict
          on update cascade,
      foreign key (departure_airport)
           references airport(name)
           on delete cascade
           on update cascade,
      foreign key (arrival_airport)
           references airport(name)
           on delete cascade
           on update cascade);  

create table ticket (
    ticket_id int primary key,
    flight_num varchar(100) not null,
    airline_name varchar(100) not null,
    foreign key (flight_num, airline_name)
        references flight(flight_num, airline_name)
           on delete cascade
           on update cascade);     

create table customer(
    email varchar(100) primary key,
    name varchar(100) not null,
    password text not null,
    building varchar(100),
    street varchar(100),
    city varchar(100),
    state varchar(100),
    phone_number varchar(100),
    passport_number varchar(100) unique,
    passport_expiration_date date,
    passport_country varchar(100),
    date_of_birth date);
    
create table booking_agent (
    email varchar(100) primary key,
    password text not null);
    
create table airline_staff(
    username varchar(100) primary key,
    password text not null,
    first_name varchar(100),
    last_name varchar(100),
    date_of_birth date,
    airline_name varchar(100) not null,
    foreign key (airline_name)
        references airline(name)
        on delete cascade 
        on update cascade);

create table authorized_by (
    agent_email varchar(100) not null,
    airline_name varchar(100) not null,
    primary key (agent_email, airline_name),
    foreign key (agent_email)
        references booking_agent(email)
        on delete cascade
        on update cascade,
    foreign key (airline_name)
        references airline(name)
        on delete cascade
        on update cascade);

create table purchases (
    ticket_id int not null,
    customer_email varchar(100) not null,
    booking_agent_email varchar(100),
    purchase_date date not null,
    primary key (ticket_id, customer_email),
    foreign key (ticket_id)
        references ticket(ticket_id)
        on delete cascade
        on update cascade,
    foreign key (customer_email)
        references customer(email)
        on delete cascade
        on update cascade,
     foreign key (booking_agent_email)
        references booking_agent(email)
        on delete set null
        on update cascade);

create table permission (
    permission_type varchar(100) not null
        check (permission_type in ('admin', 'operator')),
    airline_staff_username varchar(100) not null,
    primary key (airline_staff_username, permission_type),
    foreign key (airline_staff_username)
        references airline_staff(username)
        on delete cascade 
        on update cascade);

create table city_alias (
    alias_name varchar(100),
    city_name varchar(100),
    primary key (alias_name, city_name),
    foreign key (city_name)
        references city(name)
        on delete cascade
        on update cascade);

-- adding two tables for a special user type: system admin
create table system_admin(
    username varchar(100) primary key,
    password text not null,
    created_at TIMESTAMP
);

create table register_requests(
    request_id INT AUTO_INCREMENT PRIMARY KEY,
    username varchar(100) UNIQUE,
    password text NOT NULL,
    first_name varchar(100),
    last_name varchar(100),
    date_of_birth date,
    airline_name varchar(100),
    permission_type varchar(100) check (permission_type in ('admin', 'operator')),
    FOREIGN KEY (airline_name) REFERENCES airline(name) on delete cascade 
        on update cascade
);