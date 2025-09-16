# Visual ERD - Mermaid Diagram
## Rails Event Management System

You can copy this Mermaid code and paste it into any Mermaid-compatible viewer (like GitHub, Mermaid Live Editor, or VS Code with Mermaid extension):

```mermaid
erDiagram
    USERS {
        bigint id PK "Primary Key"
        varchar email UK "Unique, NOT NULL"
        varchar encrypted_password "NOT NULL, Devise"
        varchar reset_password_token UK "Unique"
        datetime reset_password_sent_at "Nullable"
        datetime remember_created_at "Nullable" 
        integer role "Default 0, 0=user 1=admin"
        datetime created_at "NOT NULL"
        datetime updated_at "NOT NULL"
    }

    EVENTS {
        bigint id PK "Primary Key"
        integer user_id FK "NOT NULL, References users(id)"
        varchar name "NOT NULL, Event name"
        datetime date "NOT NULL, Event date/time"
        varchar location "NOT NULL, Event venue"
        text description "Nullable, Event description"
        datetime created_at "NOT NULL"
        datetime updated_at "NOT NULL"
    }

    REGISTRATIONS {
        bigint id PK "Primary Key"  
        integer event_id FK "NOT NULL, References events(id)"
        varchar attendee_name "NOT NULL, Attendee full name"
        varchar attendee_email "NOT NULL, Attendee email"
        datetime created_at "NOT NULL"
        datetime updated_at "NOT NULL"
    }

    USERS ||--o{ EVENTS : "creates/organizes"
    EVENTS ||--o{ REGISTRATIONS : "has attendees"
```

### Alternative PlantUML ERD

If you prefer PlantUML format:

```plantuml
@startuml Event_Management_ERD

!define ENTITY class
!define PK <b><color:red>
!define FK <b><color:blue>

ENTITY USERS {
    PK id : BIGINT
    --
    email : VARCHAR(255) <<unique>>
    encrypted_password : VARCHAR(255)
    reset_password_token : VARCHAR(255) <<unique>>
    reset_password_sent_at : DATETIME
    remember_created_at : DATETIME
    role : INTEGER <<default: 0>>
    created_at : DATETIME
    updated_at : DATETIME
}

ENTITY EVENTS {
    PK id : BIGINT
    --
    FK user_id : INTEGER
    name : VARCHAR(255)
    date : DATETIME
    location : VARCHAR(255) 
    description : TEXT
    created_at : DATETIME
    updated_at : DATETIME
}

ENTITY REGISTRATIONS {
    PK id : BIGINT
    --
    FK event_id : INTEGER
    attendee_name : VARCHAR(255)
    attendee_email : VARCHAR(255)
    created_at : DATETIME
    updated_at : DATETIME
}

USERS ||--o{ EVENTS : "creates/organizes"
EVENTS ||--o{ REGISTRATIONS : "has attendees"

@enduml
```

### How to View These Diagrams:

1. **Mermaid**:
   - Visit [Mermaid Live Editor](https://mermaid.live/)
   - Paste the Mermaid code above
   - View/export the generated diagram

2. **PlantUML**:
   - Visit [PlantUML Server](http://www.plantuml.com/plantuml/uml/)
   - Paste the PlantUML code above
   - Generate and download the diagram

3. **VS Code**:
   - Install "Mermaid Markdown Syntax Highlighting" extension
   - Open this file and preview it

4. **GitHub**:
   - GitHub natively supports Mermaid diagrams in markdown files
   - The diagram will render automatically when viewing this file on GitHub

### Quick Database Stats:
- **3 Tables** with clear relationships
- **2 Foreign Key relationships** ensuring data integrity  
- **4 Indexes** for optimal query performance
- **Role-based access control** built into the User model
- **Cascade deletions** for maintaining referential integrity

---

*These visual diagrams complement the detailed ERD documentation in `ERD.md`*
