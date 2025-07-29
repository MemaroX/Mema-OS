# Image Processing: Enhancement Techniques and Analysis

This repository contains a collection of Python scripts and associated media files demonstrating fundamental **image processing techniques**, with a primary focus on **image enhancement and analysis**. It showcases practical applications of libraries like OpenCV and Matplotlib for manipulating and understanding digital images.

## Overview

This project explores various methods to improve image quality and extract meaningful information. It includes implementations for adjusting contrast and brightness, applying filters, and visualizing image characteristics through histograms. The accompanying images and video serve as visual evidence of the applied techniques and their effects.

## Features

-   **Contrast Enhancement:** Algorithms to improve the distinction between image elements.
-   **Brightness Adjustment:** Methods to modify the overall lightness or darkness of an image.
-   **Histogram Equalization:** A technique to enhance image contrast by spreading out the most frequent pixel intensity values.
-   **Image Filtering:** (Implied by `Mean Filter` image) Application of spatial filters for smoothing or sharpening.
-   **Histogram Analysis:** Visualization of pixel intensity distributions for different image channels.
-   **Visual Demonstrations:** Includes processed images and a video recording to illustrate the effects of the algorithms.

## Technologies Used

-   **Python:** The primary programming language.
-   **OpenCV (`cv2`):** For core image processing operations.
-   **NumPy:** For numerical operations and efficient array manipulation of image data.
-   **Matplotlib:** For plotting image histograms and visualizations.

## Project Contents

```
Image proccessing/
├── asdas.py                # Script for contrast enhancement, brightness reduction, and histogram plotting.
├── code.py                 # Script for histogram equalization, brightness reduction, and histogram plotting.
├── hell.py                 # (Unrelated) A Python script for system control/automation (Linux-specific).
├── test.jpg                # Original input image used for processing.
├── Erosion of test.jpg     # Output image after applying an erosion morphological operation.
├── Mean Filter of test.png # Output image after applying a mean filter.
├── Figure_1.png            # Likely a plot or result from an image processing operation.
├── Figure_2.png            # Likely another plot or result from an image processing operation.
├── Region Split and Merge.png # Image illustrating a region split and merge algorithm.
└── Recording 2024-05-03 163403.mp4 # Video demonstration of image processing techniques.
```

## Getting Started

Follow these instructions to get a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

-   **Python 3.x**
-   **pip** (Python package installer)

### Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/MemaroX/FEE_NOTES.git # Assuming this is part of FEE_NOTES
    cd FEE_NOTES/Image proccessing
    ```
    *(Note: If this is a standalone project, adjust the clone command accordingly.)*

2.  **Install dependencies:**
    It is highly recommended to use a virtual environment.
    ```bash
    # Create a virtual environment
    python -m venv venv
    # Activate the virtual environment
    # On Windows:
    .\venv\Scripts\activate
    # On macOS/Linux:
    source venv/bin/activate

    # Install required packages
    pip install opencv-python numpy matplotlib
    ```

### Running the Scripts

Navigate to the `Image proccessing` directory and run the Python scripts:

-   To run the contrast and brightness adjustment script:
    ```bash
    python asdas.py
    ```
-   To run the histogram equalization and brightness reduction script:
    ```bash
    python code.py
    ```

## Contributing

Contributions are welcome! If you have suggestions for improvements, bug fixes, or new features, please feel free to:

1.  Fork the repository.
2.  Create a new branch (`git checkout -b feature/YourFeatureName`).
3.  Make your changes.
4.  Commit your changes (`git commit -m 'Feat: Add YourFeature'`).
5.  Push to the branch (`git push origin feature/YourFeatureName`).
6.  Open a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

MemaroX - [Your GitHub Profile Link](https://github.com/MemaroX)
