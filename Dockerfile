# Step 1: Use an official Python runtime as the base image
FROM python:3.10-slim

# Step 2: Set the working directory inside the container
WORKDIR /app

# Step 3: Copy the current directory contents into the container at /app
COPY . /app

# Step 4: Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Step 5: Make port 5000 available to the outside world
EXPOSE 5000

# Step 6: Define the environment variable for Flask
ENV FLASK_APP=app.py

# Step 7: Run the Flask app when the container starts
CMD ["flask", "run", "--host=0.0.0.0", "--port=5000"]

