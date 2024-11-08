# Welcome to My Users App
***
## Task
The task is to create a user management application using Sinatra and JSON file storage. The challenge is to implement user authentication, session management, and CRUD operations for user data.

## Description
This application is built using Sinatra, a lightweight web framework for Ruby, and JSON file storage. The application allows users to create an account, sign in, update their password, and delete their account. It also supports session management to keep users logged in.

## Installation
To install the project, follow these steps:
1. Clone the repository:
    ```sh
    git clone <repository-url>
    ```
2. Navigate to the project directory:
    ```sh
    cd my_users_app
    ```
3. Install the required gems:
    ```sh
    bundle install
    ```

## Usage
To run the application, use the following command:
```sh

ruby app.rb

API Endpoints
GET /users
Returns all users without their passwords.

POST /users
Creates a new user and returns the user without the password.

Parameters:
firstname
lastname
age
password
email
POST /sign_in
Authenticates the user and creates a session.

Parameters:
email
password
PUT /users
Updates the current user's password. Requires login.

Parameters:
password
DELETE /sign_out
Logs out the current user. Requires login.

DELETE /users
Deletes the current user. Requires login.



### The Core Team


<span><i>Made at <a href='https://qwasar.io'>Qwasar SV -- Software Engineering School</a></i></span>
<span><img alt='Qwasar SV -- Software Engineering School's Logo' src='https://storage.googleapis.com/qwasar-public/qwasar-logo_50x50.png' width='20px' /></span>
