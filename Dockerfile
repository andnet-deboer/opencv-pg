# Use Python 3.11 slim
FROM python:3.11-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
WORKDIR /app

# Install system dependencies for OpenCV, PySide6, and Qt GUI
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    # OpenGL
    libgl1 \
    libegl1 \
    # X11 core
    libxrender1 \
    libxext6 \
    libx11-6 \
    libx11-xcb1 \
    # XCB libraries
    libxcb1 \
    libxcb-cursor0 \
    libxcb-xinerama0 \
    libxcb-icccm4 \
    libxcb-image0 \
    libxcb-keysyms1 \
    libxcb-randr0 \
    libxcb-render-util0 \
    libxcb-shape0 \
    libxcb-shm0 \
    libxcb-sync1 \
    libxcb-xfixes0 \
    libxcb-xkb1 \
    # X extensions
    libxkbfile1 \
    libxkbcommon0 \
    libxkbcommon-x11-0 \
    libxi6 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    libxfixes3 \
    libxrender-dev \
    libxtst6 \
    # Core libraries for Qt
    libglib2.0-0 \
    libfontconfig1 \
    libfreetype6 \
    libdbus-1-3 \
    libnss3 \
    libasound2 \
    # WebEngine dependencies
    libnss3 \
    libnspr4 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libatspi2.0-0 \
    libxshmfence1 \
    # Fonts
    fonts-liberation \
    fonts-dejavu-core \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip and install flit
RUN pip install --upgrade pip setuptools wheel flit

# Copy project files
COPY . /app/

# Allow Flit root install
ENV FLIT_ROOT_INSTALL=1

# Install dependencies explicitly first, then the package
RUN pip install "numpy<2" && \
    pip install pyside6==6.5.2 qtpy==2.3.1 opencv-contrib-python-headless==4.8.0.76 jinja2==3.1.2 && \
    flit install --deps production

# GUI support
ENV DISPLAY=:0
ENV QT_QPA_PLATFORM=xcb

# Default command
CMD ["/bin/bash"]