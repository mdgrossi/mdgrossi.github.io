# PYTHON CONTAINER WITH QUARTO
#
# Install Quarto into a base Python image according to instructions from 
# https://www.r-bloggers.com/2022/07/how-to-set-up-quarto-with-docker-part-1-static-content/.
# 
# Installing pandoc-citeproc fails with "Package 'pandoc-citeproc' has no
# installation candidate", which is addressed in a Stack Overflow question:
# https://stackoverflow.com/questions/64392026/error-running-filter-pandoc-citeproc-could-not-find-executable-pandoc-citeproc
#
# =============================================================================

# Download and install base Python image
FROM python:3.12

# Download and install Quarto
RUN apt-get update && apt-get install -y --no-install-recommends \
    pandoc \
    curl \
    gdebi-core \
    && rm -rf /var/lib/apt/lists/*
RUN curl -LO https://quarto.org/download/latest/quarto-linux-amd64.deb
RUN gdebi --non-interactive quarto-linux-amd64.deb
RUN quarto install extension schochastics/academicons --no-prompt

# Copy requirements into container
COPY requirements.txt .

# Update pip and install Python package dependencies
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt