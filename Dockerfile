# ----------------------
# Base Python Image
# ----------------------
FROM python:3.10-slim

# ----------------------
# System packages for Java (needed for PySpark)
# ----------------------
RUN apt-get update && apt-get install -y \
    openjdk-11-jdk \
    curl \
    && apt-get clean

# ----------------------
# Environment variables for Java & PySpark
# ----------------------
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV PATH="$JAVA_HOME/bin:${PATH}"

WORKDIR /app

# ----------------------
# Install Python dependencies
# ----------------------
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# ----------------------
# Copy all project files
# ----------------------
COPY . .

# ----------------------
# Download NLTK data (Vader lexicon)
# ----------------------
RUN python -m nltk.downloader vader_lexicon

# ----------------------
# Expose Streamlit port
# ----------------------
EXPOSE 8501

# ----------------------
# Run the app
# ----------------------
CMD ["streamlit", "run", "app.py", "--server.port=8501", "--server.address=0.0.0.0"]
