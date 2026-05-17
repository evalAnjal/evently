# Evently Demo

**Evently** is a full-stack Java web application for campus-style event management. It enables users to register, log in with role-based access, discover events, join them, and provides admins with event management and analytics capabilities.

## Overview

This is a **Model-View-Controller (MVC)** application built with **Jakarta Servlets**, **JSP**, and **PostgreSQL**. It features:

- ✅ User authentication (registration, login, logout)
- ✅ Role-based access control (ADMIN and MEMBER roles)
- ✅ Event creation and management (admin-only)
- ✅ Event discovery and joining (member-only)
- ✅ Admin dashboard with analytics (KPI metrics, event overview, member details)
- ✅ Session-based security
- ✅ Responsive UI with Tailwind CSS

## Features

### Authentication & Authorization
- **User Registration:** New users can create accounts with email/username/password
- **Login:** Email and password validation with role-based redirection
- **Session Management:** Secure session handling with logout capability
- **Role-Based Access:** Admin users access admin dashboard; members access member dashboard

### Event Management
- **Event Creation (Admin):** Admins can create events with title, description, location, and date/time
- **Event Listing:** Members see all approved events in a searchable table
- **Event Joining (Member):** Members can join events and provide profile info (phone, age, preference)
- **Event Details (Admin):** Admins view all joined members for each event with contact details

### Admin Dashboard
- **KPI Cards:** Total Events, Approved Events, Members, Total Registrations
- **Event Overview:** Searchable table showing participant and registration counts per event
- **Member Details:** Drill-down view to see all members who joined a specific event

### Member Dashboard
- **Event Discovery:** Real-time search filter for events by title, location
- **Quick Join:** Modal form for event registration with validation
- **Join Status:** Visual indicator showing which events user has already joined
- **Form Validation:** Phone, age (1-120), and preference collection

## Tech Stack

| Component | Version |
|-----------|---------|
| Java | 11 |
| Build Tool | Maven 3.8+ |
| Web API | Jakarta Servlet API 6.1 |
| View Template | JSP |
| Database | PostgreSQL |
| Server | Embedded Jetty (dev) |
| UI Framework | Tailwind CSS |
| Testing | JUnit 5 |

**Key Dependencies:**
- `jakarta.servlet:jakarta.servlet-api:6.1.0` (WebServlet, HttpServlet)
- `org.postgresql:postgresql:42.7.2` (JDBC driver)
- `org.junit.jupiter:junit-jupiter-*:5.13.2` (unit testing)

## Architecture

### MVC Pattern
- **Models:** `User.java`, `Event.java` - Domain objects with getters/setters
- **Views:** JSP templates in `src/main/webapp/` - Render HTML with Tailwind CSS
- **Controllers:** Servlet endpoints in `src/main/java/com/eventmgmt/demo/controller/` - Handle HTTP requests
- **Data Layer:** DAO classes in `src/main/java/com/eventmgmt/demo/DAO/` - Database operations

### Layered Structure
```
┌─────────────────────────────────┐
│      JSP Views (UI/HTML)         │
├─────────────────────────────────┤
│    Servlet Controllers            │  (HTTP Request/Response)
├─────────────────────────────────┤
│    DAO Classes                    │  (SQL Queries)
├─────────────────────────────────┤
│    PostgreSQL Database            │  (Persisted Data)
└─────────────────────────────────┘
```

## Project Structure

```
demo/
├── pom.xml                              # Maven configuration, build settings
├── start-server.sh                      # Dev server launcher
├── README.md                            # This file
│
└── src/main/
    ├── java/com/eventmgmt/demo/
    │   ├── controller/                  # Servlet endpoints (7 classes)
    │   │   ├── LoginServlet.java        # POST /loginProcess - user authentication
    │   │   ├── RegisterServelet.java    # POST /registerProcess - user registration
    │   │   ├── LogoutServelet.java      # GET /logout - session invalidation
    │   │   ├── EventServelet.java       # GET /Member-dashboard - list approved events
    │   │   ├── joinEventServlet.java    # POST /joinEvent - register for event
    │   │   ├── addEventServlet.java     # POST /addEvent - create event (admin)
    │   │   └── AdminDashboardServlet.java # GET /admin-dashboard - admin analytics
    │   │
    │   ├── DAO/                         # Data access classes (3 classes)
    │   │   ├── UserDAO.java             # validateUser(), registerUser()
    │   │   ├── EventDAO.java            # createEvent(), getAll*(), getJoinedMembers*()
    │   │   └── registrationDAO.java     # joinEvent(), getJoinedEventIds()
    │   │
    │   ├── model/                       # Domain objects (2 classes)
    │   │   ├── User.java                # id, username, email, password, role
    │   │   └── Event.java               # id, title, description, location, eventDate, status
    │   │
    │   └── util/                        # Database utilities
    │       └── DBconnection.java        # Static PostgreSQL connection management
    │
    └── webapp/
        ├── index.jsp                    # Login page
        ├── register.jsp                 # Registration page
        ├── member-dashboard.jsp         # Member event listing and join UI
        ├── admin-dashboard.jsp          # Admin metrics, event management, member details
        ├── home-page.jsp                # [Unused]
        ├── home_page.jsp                # [Unused]
        ├── manual.jsp                   # [Unused]
        └── WEB-INF/
            ├── web.xml                  # Deployment descriptor
            └── hi.jsp                   # [Unused]
```

## Requirements

- **Java:** 11 or higher
- **Maven:** 3.8 or higher
- **PostgreSQL:** 12+ (local or cloud instance)
- **Git** (for cloning)

## Database Setup

### Connection Details
Database credentials are **currently hardcoded** in `src/main/java/com/eventmgmt/demo/util/DBconnection.java`:
```java
private static final String URL = "jdbc:postgresql://ep-small-pond-a19ayax8-pooler.ap-southeast-1.aws.neon.tech/neondb?sslmode=require";
private static final String USER = "neondb_owner";
private static final String PASS = "npg_Np6gayB4KfUJ";
```
⚠️ **Security Note:** Credentials should be moved to environment variables before production deployment.

### Schema

Execute the following SQL to set up the database:

#### Users Table
Stores registered users with roles for access control.
```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'MEMBER'  -- 'ADMIN' or 'MEMBER'
);
```

#### Events Table
Stores event information created by admins.
```sql
CREATE TABLE events (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    location VARCHAR(200),
    event_date TIMESTAMP NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'APPROVED'
);
```

#### Registrations Table
Stores member registrations for events with participation details.
```sql
CREATE TABLE registrations (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    event_id INT NOT NULL REFERENCES events(id) ON DELETE CASCADE,
    phone VARCHAR(25),
    age INT,
    preference VARCHAR(80),  -- 'Speaker', 'Attendee', 'Volunteer', or 'Networking'
    UNIQUE (user_id, event_id)  -- Prevent duplicate registrations
);
```

### Existing Database Update
If your `registrations` table doesn't have all columns, run:
```sql
ALTER TABLE registrations
ADD COLUMN IF NOT EXISTS phone VARCHAR(25),
ADD COLUMN IF NOT EXISTS age INT,
ADD COLUMN IF NOT EXISTS preference VARCHAR(80);
```

## Getting Started

### Prerequisites
1. Clone the repository
2. Ensure Java 11+ is installed: `java -version`
3. Ensure Maven 3.8+ is installed: `mvn -version`
4. Set up PostgreSQL database and run schema (see Database Setup above)
5. Update credentials in `src/main/java/com/eventmgmt/demo/util/DBconnection.java`

### Build the Project

```bash
./mvnw clean package
```

This generates `target/demo-1.0-SNAPSHOT.war`.

### Run Locally (Development)

**Option 1 - Recommended (Faster):**
```bash
./start-server.sh
```
- Automatically frees port 8080
- Starts embedded Jetty via Maven plugin
- App available at: **http://localhost:8080**

**Option 2 - Manual Maven:**
```bash
./mvnw -DskipTests org.eclipse.jetty.ee10:jetty-ee10-maven-plugin:12.0.15:run
```

**Option 3 - Deploy WAR to Server:**
- Copy `target/demo-1.0-SNAPSHOT.war` to Tomcat/Jetty webapps directory
- Rename to `demo.war` if desired
- Start server

### First Access

1. Navigate to **http://localhost:8080**
2. You will be redirected to login page (`index.jsp`)
3. Click **"here"** link to register a new account
4. Log in with your credentials
5. Based on role:
   - **Admin:** Redirected to `/admin-dashboard`
   - **Member:** Redirected to `/Member-dashboard`

**Test Credentials:**
Create admin account during registration or insert directly:
```sql
INSERT INTO users (username, email, password, role) 
VALUES ('Admin User', 'admin@example.com', 'password123', 'ADMIN');

INSERT INTO users (username, email, password, role)
VALUES ('Member User', 'member@example.com', 'password456', 'MEMBER');
```

## API Endpoints

### Authentication Routes

| Method | Endpoint | Purpose | Handler |
|--------|----------|---------|---------|
| GET | `/index.jsp` | Login page | IndexPage |
| GET | `/register.jsp` | Registration page | RegisterPage |
| POST | `/registerProcess` | Create new user account | RegisterServelet |
| POST | `/loginProcess` | Authenticate user | LoginServlet |
| GET | `/logout` | Logout and invalidate session | LogoutServelet |

### Member Routes

| Method | Endpoint | Purpose | Handler |
|--------|----------|---------|---------|
| GET | `/Member-dashboard` | View available events (approved only) | EventServelet |
| POST | `/joinEvent` | Register for an event | joinEventServlet |

**Request Example (Join Event):**
```http
POST /joinEvent
Content-Type: application/x-www-form-urlencoded

eventId=5&userId=3&phone=9876543210&age=25&preference=Attendee
```

### Admin Routes

| Method | Endpoint | Purpose | Handler |
|--------|----------|---------|---------|
| GET | `/admin-dashboard` | View admin dashboard with KPIs | AdminDashboardServlet |
| GET | `/admin-dashboard?eventId=X` | View members who joined event X | AdminDashboardServlet |
| POST | `/addEvent` | Create new event | addEventServlet |

**Request Example (Create Event):**
```http
POST /addEvent
Content-Type: application/x-www-form-urlencoded

title=Tech Conference&description=Learn new technologies&location=Hall A&eventDate=2025-06-15T14:00
```

### Session & Security

- **Session Attribute:** `user` (User object)
- **Login Check:** All protected routes validate: `User user = (User) request.getSession().getAttribute("user")`
- **Redirect on Unauthorized:** 401 → `/index.jsp`

## User Workflows

### Workflow 1: New User Registration
```
1. GET /index.jsp (Login Page)
   → Click "here" link
   ↓
2. GET /register.jsp (Registration Form)
   → Fill: username, email, password
   → Submit form
   ↓
3. POST /registerProcess (RegisterServelet)
   → UserDAO.registerUser() inserts into users table
   → Role defaults to 'MEMBER'
   ↓
4. Redirect to /index.jsp (Success message shown)
   → User can now login
```

### Workflow 2: Admin Login & Event Creation
```
1. POST /loginProcess (Email: admin@ex.com, Pass: adminpass)
   → UserDAO.validateUser() checks credentials
   → Finds role = 'ADMIN'
   ↓
2. Session created, redirect to /admin-dashboard
   ↓
3. View KPI Cards & Event Table
   → See: Total Events, Approved Events, Members, Registrations
   ↓
4. Click "Create New Event" button
   → Modal form opens (title, description, location, date-time)
   ↓
5. POST /addEvent (with event details)
   → EventDAO.createEvent() inserts into events table
   → Status set to 'APPROVED'
   ↓
6. Redirect /admin-dashboard?success=1
   → Table refreshes with new event
```

### Workflow 3: Member Login & Join Event
```
1. POST /loginProcess (Email: member@ex.com, Pass: password)
   → UserDAO.validateUser() checks credentials
   → Finds role = 'MEMBER'
   ↓
2. Session created, redirect to /Member-dashboard
   ↓
3. GET /Member-dashboard (EventServelet)
   → Fetches all APPROVED events via EventDAO.getAllApprovedEvents()
   → Fetches user's joined event IDs via registrationDAO.getJoinedEventIds()
   → Displays table with Join/Joined buttons
   ↓
4. Search events (JavaScript client-side filter)
   ↓
5. Click "Join" button on an event
   → Modal form opens (phone, age, preference)
   ↓
6. POST /joinEvent (eventId, userId, phone, age, preference)
   → registrationDAO.joinEvent() inserts into registrations table
   → On duplicate: constraint error caught, user sees error message
   ↓
7. Redirect /Member-dashboard?success=1
   → Button changes to disabled "Joined"
```

### Workflow 4: Admin View Event Details
```
1. Login as Admin (Role = 'ADMIN')
   → Landed on /admin-dashboard
   ↓
2. View Event Overview Table
   → Shows: Event Title, Date, Location, Participants, Registrations, Status
   ↓
3. Click "View Details" on an event
   ↓
4. GET /admin-dashboard?eventId=5
   → AdminDashboardServlet fetches event via EventDAO.getJoinedMembersByEvent(5)
   → Displays table of all members who joined this event
   → Shows: Member ID, Username, Email, Phone, Age, Preference
   ↓
5. Click "Clear" link to return to overview
```

## Code Quality & Notable Implementations

### ✅ Strengths
- **Prepared Statements:** All SQL queries use `?` placeholders to prevent SQL injection
- **Session Management:** Proper session creation/invalidation for auth
- **Try-Catch Error Handling:** Every DAO method has exception handling
- **Role-Based Access Control:** Clean separation between admin and member flows
- **Field Validation:** Phone, age (1-120), required field checks
- **Unique Constraints:** Email uniqueness enforced at database level
- **Responsive UI:** Tailwind CSS for mobile-friendly design
- **Client-Side Search:** JavaScript filtering for event search (no server roundtrip)

### ⚠️ Security Concerns
1. **Hardcoded Credentials:** Database URL, username, password visible in source
   - **Fix:** Use environment variables or external config files
   - Example: `System.getenv("DB_URL")`

2. **Plain-Text Passwords:** No hashing for stored passwords
   - **Fix:** Use BCrypt or PBKDF2
   - Example: `BCrypt.hashpw(password, BCrypt.gensalt())`

3. **No CSRF Tokens:** Forms lack CSRF protection
   - **Fix:** Add hidden token in forms, validate server-side

4. **No Input Sanitization:** JSP outputs could be vulnerable to XSS
   - **Fix:** Use `<c:out>` tag or `fn:escapeXml()` in EL expressions

5. **Generic Error Messages:** "EventDAO ERROR" thrown
   - **Fix:** Use logging framework (SLF4J + Logback)
   - Avoid exposing stack traces to users

6. **No Rate Limiting:** Brute force attacks possible on login
   - **Fix:** Implement rate limiting on authentication endpoints

### Naming & Code Style
- ⚠️ `registrationDAO` (lowercase) - should follow convention: `RegistrationDAO`
- ⚠️ `Servelet` typo in class names - should be `Servlet`
- Inconsistent spacing in SQL and Java code

## Future Enhancements

- [ ] Password hashing with BCrypt
- [ ] Environment-based configuration
- [ ] CSRF token protection
- [ ] XSS prevention with output encoding
- [ ] Logging framework (SLF4J)
- [ ] Rate limiting on login
- [ ] Email notifications for event registration
- [ ] Event cancellation workflow
- [ ] User profile management
- [ ] Event status workflow (Pending, Approved, Rejected, Cancelled)
- [ ] Full-text search on events
- [ ] Pagination for large tables
- [ ] REST API endpoints (JSON)
- [ ] Automated tests (JUnit)
- [ ] Docker containerization
- [ ] CI/CD pipeline (GitHub Actions)

