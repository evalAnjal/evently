# Evently Demo

Evently is a small JSP and Servlet-based web application for managing campus events. It supports user registration, login, role-based dashboards, and logout, backed by a PostgreSQL database. App Screenshots are at the bottom of this file

## Features

- User registration and login
- Session-based authentication
- Role-based routing for `ADMIN` and regular members
- Admin dashboard and member dashboard pages
- Event search on the member dashboard
- PostgreSQL persistence for user accounts

## Tech Stack

- Java 11
- Maven WAR project
- Jakarta Servlet 6.1
- JSP
- PostgreSQL
- Tailwind CSS via CDN for page styling

## Project Structure

- `src/main/java/com/eventmgmt/demo/controller` - servlet controllers for login, registration, and logout
- `src/main/java/com/eventmgmt/demo/DAO` - database access logic
- `src/main/java/com/eventmgmt/demo/model` - application models
- `src/main/java/com/eventmgmt/demo/util` - database connection helper
- `src/main/webapp` - JSP pages and static web assets

## Requirements

- Java 11 or newer
- Maven 3.8+
- PostgreSQL database
- A Servlet 6.0 compatible container or the bundled Jetty Maven plugin

## Database Setup

The application reads its PostgreSQL connection from `src/main/java/com/eventmgmt/demo/util/DBconnection.java`.

Before running the app, make sure your database has a `users` table with at least these columns:

- `id`
- `username`
- `email`
- `password`
- `role`

Example schema:

```sql
CREATE TABLE users (
	id SERIAL PRIMARY KEY,
	username VARCHAR(100) NOT NULL,
	email VARCHAR(150) NOT NULL UNIQUE,
	password VARCHAR(255) NOT NULL,
	role VARCHAR(20) NOT NULL DEFAULT 'MEMBER'
);
```

If you are using a different database, update the JDBC URL, username, and password in `DBconnection.java`.

## Run the Application

### Option 1: Use the helper script

```bash
./start-server.sh
```

This script frees port 8080 if needed and then starts the app with the Jetty Maven plugin.

### Option 2: Run with Maven directly

```bash
./mvnw -DskipTests org.eclipse.jetty.ee10:jetty-ee10-maven-plugin:12.0.15:run
```

## Access the App

After the server starts, open:

- Login page: `http://localhost:8080/index.jsp`
- Registration page: `http://localhost:8080/register.jsp`

## Login Flow

- Users register from the registration page.
- Login submits to `/loginProcess`.
- If the user role is `ADMIN`, the app redirects to `admin-dashboard.jsp`.
- Other users are redirected to `member-dashboard.jsp`.
- Logout is handled at `/logout`.

## Notes

- The current dashboards are mostly static UI examples, with session checks and basic navigation.
- The member dashboard includes a client-side search filter for the event list.
- Registration currently stores plain-text passwords in the database. For production use, add password hashing before storing credentials.

## Build

```bash
./mvnw clean package
```

The packaged WAR is generated under `target/`.
