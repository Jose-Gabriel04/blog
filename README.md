# Blog Project – Setup Guide

This guide explains how to set up and run the **Blog Rails Project** on a fresh system.

---

## Prerequisites

Make sure you have the following installed:

- Ubuntu/Debian-based system
- Git
- RVM (Ruby Version Manager)
- PostgreSQL

---

## Installation Steps

1. **Update your system packages:**
  sudo apt update

2. **Fix any broken packages (if necessary):**
  sudo dpkg --configure -a

3. **Install PostgreSQL and its extensions:**
  sudo apt install postgresql postgresql-contrib

4. **Clone the project repository:**
  git clone git@github.com:Jose-Gabriel04/blog.git
  cd blog

5. **Install Ruby using RVM:**
  rvm install ruby-3.4.6

6. **Install project dependencies:**
  bundle install

## Database Setup

Create and migrate the database:
  rails db:create db:migrate

**If you encounter an authentication error with PostgreSQL, set a password for the default user:**
  sudo -u postgres psql
  ALTER USER postgres WITH PASSWORD 'postgres';
  \q

## Running the Application
  rails s