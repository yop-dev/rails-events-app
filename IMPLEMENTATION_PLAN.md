# Rails Events App - Implementation Plan

## Project Overview
A Rails application for managing events and registrations with role-based authentication (regular users and admins).

## Current Status ✅
- [x] Rails application setup with Devise authentication
- [x] User model with role-based access (regular users vs admins)
- [x] Admin authentication system fixed
- [x] Separate login/registration flows for users and admins
- [x] Basic admin dashboard structure

---

## 🎯 Implementation Plan

### Phase 1: Database Models

#### Event Model
```ruby
# Attributes:
- name (string, required)
- date (datetime, required) 
- location (string, required)
- description (text, optional)
```

#### Registration Model
```ruby
# Attributes:
- event_id (foreign key, required)
- attendee_name (string, required)
- attendee_email (string, required, email format)
```

#### Model Relationships
- Event `has_many :registrations, dependent: :destroy`
- Registration `belongs_to :event`

**Tasks:**
- [ ] Generate Event model and migration
- [ ] Generate Registration model and migration
- [ ] Add validations to both models
- [ ] Set up model associations

---

### Phase 2: User Pages

#### 1. Events Index Page (`/events`)
**Requirements:**
- Lists events: name, date, location
- Actions: Show, Edit, Delete
- Button: "Create Event"

**Tasks:**
- [ ] Create EventsController with index action
- [ ] Create events/index.html.erb view
- [ ] Add table with event data
- [ ] Add action buttons (Show, Edit, Delete)
- [ ] Add "Create Event" button

#### 2. New Event Page (`/events/new`)
**Requirements:**
- Form: name, date, location, description (textarea)
- Save/Cancel buttons
- Shows validation errors

**Tasks:**
- [ ] Add new and create actions to EventsController
- [ ] Create events/new.html.erb with form
- [ ] Create events/_form.html.erb partial
- [ ] Add validation error display
- [ ] Implement strong parameters

#### 3. Edit Event Page (`/events/:id/edit`)
**Requirements:**
- Same as New Event, but pre-filled
- Shows validation errors

**Tasks:**
- [ ] Add edit and update actions to EventsController
- [ ] Create events/edit.html.erb
- [ ] Reuse _form.html.erb partial
- [ ] Add validation error display

#### 4. Event Show Page (`/events/:id`)
**Requirements:**
- Displays event details: name, date, location, description
- Actions: Edit, Delete, Back to List
- Section: Registrations List (attendee name, email, Edit, Delete)
- Add Registration Form: attendee name, email
- Shows validation errors for registrations

**Tasks:**
- [ ] Add show action to EventsController
- [ ] Create events/show.html.erb
- [ ] Display event details
- [ ] Add Edit, Delete, Back buttons
- [ ] Create registrations list section
- [ ] Add inline registration form
- [ ] Add registration actions (Edit, Delete)

#### 5. Edit Registration Page (`/registrations/:id/edit`)
**Requirements:**
- Form: attendee_name, attendee_email
- Save/Cancel buttons
- Shows validation errors

**Tasks:**
- [ ] Create RegistrationsController
- [ ] Add edit and update actions
- [ ] Create registrations/edit.html.erb
- [ ] Create registrations/_form.html.erb partial
- [ ] Add validation error display

---

### Phase 3: Admin Pages

#### 1. Admin Dashboard (`/admin`)
**Requirements:**
- Event and registration stats (total events, total attendees)

**Tasks:**
- [ ] Update Admin::DashboardController
- [ ] Add statistics methods to models
- [ ] Update admin/dashboard/index.html.erb
- [ ] Display total events and total attendees

#### 2. Admin Event Management (`/admin/events`)
**Requirements:**
- List/search events
- Bulk delete or close events
- Manage all registrations (view/edit/delete)

**Tasks:**
- [ ] Create Admin::EventsController
- [ ] Create admin/events/index.html.erb
- [ ] Add events list with search
- [ ] Add bulk delete functionality
- [ ] Add registration management per event

#### 3. Admin Registration Management (`/admin/registrations`)
**Requirements:**
- List/search registrations (by event/attendee)
- Bulk delete/export attendee lists

**Tasks:**
- [ ] Create Admin::RegistrationsController
- [ ] Create admin/registrations/index.html.erb
- [ ] Add registrations list with search
- [ ] Add search by event/attendee
- [ ] Add bulk delete functionality
- [ ] Add basic CSV export

---

## 🗂 File Structure

```
app/
├── controllers/
│   ├── events_controller.rb
│   ├── registrations_controller.rb
│   └── admin/
│       ├── events_controller.rb
│       └── registrations_controller.rb
├── models/
│   ├── event.rb
│   └── registration.rb
└── views/
    ├── events/
    │   ├── index.html.erb
    │   ├── show.html.erb
    │   ├── new.html.erb
    │   ├── edit.html.erb
    │   └── _form.html.erb
    ├── registrations/
    │   ├── edit.html.erb
    │   └── _form.html.erb
    └── admin/
        ├── events/
        │   └── index.html.erb
        └── registrations/
            └── index.html.erb
```

---

## 🚀 Implementation Order

### Step 1: Models and Database
1. [ ] Create Event model
2. [ ] Create Registration model
3. [ ] Add validations and associations

### Step 2: Basic Event Management
4. [ ] Events Index Page
5. [ ] New Event Page
6. [ ] Edit Event Page
7. [ ] Event Show Page (without registrations)

### Step 3: Registration System
8. [ ] Add registrations to Event Show page
9. [ ] Registration form on Event Show page
10. [ ] Edit Registration Page

### Step 4: Admin Features
11. [ ] Admin Dashboard with stats
12. [ ] Admin Event Management
13. [ ] Admin Registration Management

---

## 📚 Basic Dependencies Needed

```ruby
# Add to Gemfile:
gem 'bootstrap', '~> 5.3'
gem 'jquery-rails'
```

---

*Last updated: September 15, 2025*
*Project: Rails Events App*
*Status: Ready for Implementation*
