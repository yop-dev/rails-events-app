# Entity Relationship Diagram (ERD)
## Rails Event Management System

### Visual ERD

```
┌─────────────────────────────┐         ┌─────────────────────────────┐         ┌─────────────────────────────┐
│           USERS             │         │           EVENTS            │         │       REGISTRATIONS         │
├─────────────────────────────┤         ├─────────────────────────────┤         ├─────────────────────────────┤
│ 🔑 id (PK)                  │◄────────│ 🔑 id (PK)                  │◄────────│ 🔑 id (PK)                  │
│ 📧 email (UNIQUE)           │   1:N   │ 🔗 user_id (FK)             │   1:N   │ 🔗 event_id (FK)            │
│ 🔐 encrypted_password       │         │ 📝 name                     │         │ 👤 attendee_name            │
│ 🔄 reset_password_token     │         │ 📅 date                     │         │ 📧 attendee_email           │
│ ⏰ reset_password_sent_at   │         │ 📍 location                 │         │ ⏰ created_at               │
│ 💭 remember_created_at      │         │ 📄 description (TEXT)       │         │ 🔄 updated_at               │
│ 👑 role (INTEGER)           │         │ ⏰ created_at               │         └─────────────────────────────┘
│ ⏰ created_at               │         │ 🔄 updated_at               │
│ 🔄 updated_at               │         └─────────────────────────────┘
└─────────────────────────────┘
```

### Detailed Entity Breakdown

#### 🧑‍💻 USERS Table
| Field | Type | Constraints | Description |
|-------|------|-------------|-------------|
| **id** | BIGINT | PRIMARY KEY, AUTO_INCREMENT | Unique user identifier |
| **email** | VARCHAR(255) | NOT NULL, UNIQUE | User's login email |
| **encrypted_password** | VARCHAR(255) | NOT NULL | Devise encrypted password |
| **reset_password_token** | VARCHAR(255) | UNIQUE | Password reset token |
| **reset_password_sent_at** | DATETIME | NULL | Reset token timestamp |
| **remember_created_at** | DATETIME | NULL | Remember me timestamp |
| **role** | INTEGER | DEFAULT 0 | User role (0=user, 1=admin) |
| **created_at** | DATETIME | NOT NULL | Record creation timestamp |
| **updated_at** | DATETIME | NOT NULL | Record update timestamp |

**Indexes:**
- `index_users_on_email` (UNIQUE)
- `index_users_on_reset_password_token` (UNIQUE)

#### 🎪 EVENTS Table
| Field | Type | Constraints | Description |
|-------|------|-------------|-------------|
| **id** | BIGINT | PRIMARY KEY, AUTO_INCREMENT | Unique event identifier |
| **user_id** | INTEGER | NOT NULL, FOREIGN KEY → users(id) | Event organizer |
| **name** | VARCHAR(255) | NOT NULL | Event name/title |
| **date** | DATETIME | NOT NULL | Event date and time |
| **location** | VARCHAR(255) | NOT NULL | Event venue/location |
| **description** | TEXT | NULL | Event description (optional) |
| **created_at** | DATETIME | NOT NULL | Record creation timestamp |
| **updated_at** | DATETIME | NOT NULL | Record update timestamp |

**Indexes:**
- `index_events_on_user_id`

**Foreign Keys:**
- `user_id` → `users(id)` ON DELETE RESTRICT

#### 🎟️ REGISTRATIONS Table
| Field | Type | Constraints | Description |
|-------|------|-------------|-------------|
| **id** | BIGINT | PRIMARY KEY, AUTO_INCREMENT | Unique registration identifier |
| **event_id** | INTEGER | NOT NULL, FOREIGN KEY → events(id) | Associated event |
| **attendee_name** | VARCHAR(255) | NOT NULL | Attendee's full name |
| **attendee_email** | VARCHAR(255) | NOT NULL | Attendee's email address |
| **created_at** | DATETIME | NOT NULL | Record creation timestamp |
| **updated_at** | DATETIME | NOT NULL | Record update timestamp |

**Indexes:**
- `index_registrations_on_event_id`

**Foreign Keys:**
- `event_id` → `events(id)` ON DELETE CASCADE

### 🔗 Relationships

#### User ↔ Event (One-to-Many)
- **Relationship**: One user can create many events
- **Cardinality**: 1:N
- **Foreign Key**: `events.user_id` → `users.id`
- **Cascade**: `dependent: :destroy` (deleting user deletes their events)

#### Event ↔ Registration (One-to-Many)  
- **Relationship**: One event can have many registrations
- **Cardinality**: 1:N
- **Foreign Key**: `registrations.event_id` → `events.id`
- **Cascade**: `dependent: :destroy` (deleting event deletes registrations)

### 📊 Business Rules & Constraints

#### User Rules
1. **Email Uniqueness**: Each user must have a unique email address
2. **Role System**: Users have roles (0=regular user, 1=admin)
3. **Authentication**: Uses Devise for secure authentication
4. **Default Role**: New users default to role 0 (regular user)

#### Event Rules
1. **Required Fields**: name, date, location are mandatory
2. **Optional Description**: Events can have detailed descriptions
3. **User Association**: Every event must have an organizer (user)
4. **Admin Access**: Admins can view/manage all events

#### Registration Rules
1. **Required Fields**: attendee_name and attendee_email are mandatory
2. **Email Format**: attendee_email must be valid email format
3. **Event Association**: Every registration must be linked to an event
4. **Cascade Delete**: Registrations are deleted when parent event is deleted

### 🔐 Security & Access Control

#### Authorization Matrix
| Role | Create Events | Edit Own Events | Delete Own Events | View All Events | Admin Dashboard |
|------|---------------|-----------------|-------------------|-----------------|-----------------|
| **User (0)** | ✅ | ✅ | ✅ | ❌ | ❌ |
| **Admin (1)** | ✅ | ✅ (All) | ✅ (All) | ✅ | ✅ |

#### Data Access Patterns
- **Users**: Can only manage their own events and registrations
- **Admins**: Can manage all events and registrations across the system
- **Public**: Can view event details and register for events (no authentication required)

### 📈 Performance Considerations

#### Database Indexes
- `users.email` (UNIQUE) - Fast login lookups
- `users.reset_password_token` (UNIQUE) - Password reset functionality  
- `events.user_id` - Efficient user → events queries
- `registrations.event_id` - Fast event → registrations lookups

#### Query Optimization
- Use `includes()` for N+1 query prevention
- Scope queries based on user role for security
- Implement pagination for large datasets

### 🚀 Scalability Notes

#### Current Architecture
- **SQLite** for development/testing
- **PostgreSQL** for production deployment
- **Rails 8** with modern conventions
- **Devise** for authentication

#### Future Enhancements
- Add composite indexes for complex queries
- Implement soft deletes for audit trails
- Add event capacity limits
- Include user profiles and additional metadata
- Add event categories/tags relationship

### 💾 Sample Data Relationships

```
User (id: 1, email: 'user@test.com', role: 0)
  └── Event (id: 1, name: 'Tech Conference', user_id: 1)
      ├── Registration (id: 1, attendee_name: 'John Doe', event_id: 1)
      ├── Registration (id: 2, attendee_name: 'Jane Smith', event_id: 1)
      └── Registration (id: 3, attendee_name: 'Mike Johnson', event_id: 1)

Admin (id: 2, email: 'admin@test.com', role: 1)
  └── Event (id: 2, name: 'Workshop Series', user_id: 2)
      ├── Registration (id: 4, attendee_name: 'Sarah Wilson', event_id: 2)
      └── Registration (id: 5, attendee_name: 'Tom Brown', event_id: 2)
```

---

*This ERD represents the core data model for the Rails Event Management System, designed for scalability, security, and maintainability.*
