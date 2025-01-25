# Task Manager

This project is a Task Manager application built with Flutter. The application allows users to create, edit, delete, and manage tasks. Tasks can have titles, descriptions, estimated hours to complete, and due dates. The application uses the `Provider` package for state management and `SharedPreferences` for local storage.

## Features

- Add new tasks with title, description, estimated hours, and due date.
- Edit existing tasks.
- Delete tasks.
- Mark tasks as completed.
- Filter tasks by status (All, Pending, Completed).
- Persist tasks locally using `SharedPreferences`.

## Setup Instructions

### Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install) (version 2.5.0 or higher)
- [Dart](https://dart.dev/get-dart) (version 2.14.0 or higher)

### Installation

1. **Clone the repository:**
    ```sh
    git clone https://github.com/Raychy/task_manager.git
    cd task_manager
    ```

2. **Install dependencies:**
    ```sh
    flutter pub get
    ```

3. **Run the application:**
    ```sh
    flutter run
    ```

## Project Structure

- **lib/models/`**
    - `task.dart`: Defines the `Task` model.
- **lib/providers/`**
    - `task_provider.dart`: Manages the state of tasks using the `Provider` package.
- **lib/screens/`**
    - `home_screen.dart`: The main screen of the application to display all tasks.
    - `add_task_screen.dart`: Screen to add a new task.
- **lib/widgets/`**
    - `custom_textform_field.dart`: A reusable custom text form field widget.
    - `task_list.dart`: A widget for all tasks.
    - `task_card.dart`: A widget that represents a single task in the list.
    - `task_item.dart`: A widget for individual task item.
- **lib/utils/`**
    - `format_date.dart`: Utility function for formatting dates.

## Assumptions

- The application assumes that tasks are stored locally and does not include backend integration.
- The application assumes a simple user interface suitable for managing tasks on a single device.
- The application uses `SharedPreferences` for local storage, which may not be suitable for large-scale or multi-user environments.


