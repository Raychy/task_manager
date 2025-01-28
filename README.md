# Task Manager

The Task Manager App is a simple mobile application built with Flutter. It allows users to manage their tasks efficiently by providing functionalities such as adding, updating, deleting, and viewing tasks. The app also allows users to filter tasks by status (e.g., Pending or Completed).


## Features

- Add new tasks with title, description(optional), estimated hours, and due date.
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
    - `task_item.dart`: A widget that represents a single task in the list.
- **lib/utils/`**
    - `format_date.dart`: Utility function for formatting dates.

## Assumptions

- Each task has a field indicating how many hours are expected to be spent on completing it. This is useful for users to track their time and allocate effort towards tasks.
- Each task has an associated due date that determines when the task is expected to be completed. The due date can be set by the user while adding or updating a task.
- The app uses SharedPreferences for data persistence, saving tasks locally. When the app is restarted, it loads tasks from SharedPreferences and saves any updates or deletions.


