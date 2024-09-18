Here is the entire SOP correctly formatted in Markdown:

md
Copy code
# SOP: Installing and Using Python Virtual Environment (venv)

## Overview
This procedure explains how to create, activate, use, and deactivate a Python virtual environment using `venv`. This ensures that project dependencies are isolated and managed properly without affecting the global Python environment.

## Prerequisites
- Python 3.x must be installed on the system.
- Ensure that `pip` is installed by running:
  ```bash
  python3 -m ensurepip --upgrade
```

Steps
## 1. Navigate to Your Project Directory
Open a terminal and change to the root directory of your project:

```bash
cd /path/to/your/project
```

## 2. Create a Virtual Environment
Use the following command to create a new virtual environment named venv:

```bash
python3 -m venv venv
```
This will create a venv directory in your project folder containing the virtual environment files.


3. Activate the Virtual Environment
On Linux/Pop!_OS and macOS:
Run the following command to activate the virtual environment:

```bash
Copy code
source venv/bin/activate
```
On Windows:
Run this command to activate the virtual environment:

bash
Copy code
venv\Scripts\activate
Once activated, your terminal prompt will change, indicating that you are now working inside the virtual environment.

4. Install Project Dependencies
With the virtual environment activated, install the required Python packages using pip. For example, to install psycopg2, run:

```bash
pip install psycopg2
```
You can install additional dependencies as needed, and they will be installed only within the virtual environment.

## 5. Deactivate the Virtual Environment
Once you are finished working, deactivate the virtual environment by running:

```bash
deactivate
```
This will return you to the global Python environment.

Best Practices
Always activate the virtual environment before installing new packages.
Consider creating a requirements.txt file to track your dependencies:

```bash
pip freeze > requirements.txt
```
To install all dependencies from a requirements.txt file in a new environment:

```bash
pip install -r requirements.txt
```

Troubleshooting
If venv is not recognized, ensure Python 3.x is installed and check if it includes the venv module.
Use the following command to upgrade pip inside the virtual environment:

```bash
pip install --upgrade pip
```

## Conclusion
Using venv ensures that Python project dependencies are managed cleanly and isolated from the global environment. Follow this procedure to create, activate, and manage your virtual environments efficiently.






