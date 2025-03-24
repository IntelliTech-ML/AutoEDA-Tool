# Auto EDA Tool - README

## 📊 **Auto EDA Tool - An Interactive Exploratory Data Analysis (EDA) Application in R**

### 🚀 **Overview**
The **Auto EDA Tool** is an interactive web application built using **R Shiny** and **ggplot2**, designed to automate and simplify Exploratory Data Analysis (EDA) tasks. The application allows users to upload CSV files, select desired EDA operations, and visualize or summarize the results in an easy-to-use interface. The tool covers essential EDA functionalities such as:
- Data Visualization (Histogram, Scatter Plot, Box Plot, Density Plot)
- Summarizing Data
- Outlier Detection
- Data Types Inspection
- Correlation Analysis
- Distribution Visualization

---

## ⚙️ **Tech Stack Used**
- **R**: Programming language used for data manipulation and visualization.
- **Shiny**: R package for building interactive web applications.
- **ggplot2**: For generating high-quality visualizations.
- **HTML & CSS**: Used for styling and enhancing the UI.

---

## 🛠️ **Project Structure**

- `ui`: Defines the user interface layout and components.
- `server`: Contains the backend logic to process and display data.
- `functions`: Includes reusable functions for EDA operations.
- `App`: The main Shiny application combining UI and server components.

---

## 📂 **Features and Functionalities**

### 1️⃣ **File Upload**
- The user can upload a CSV file through the `fileInput()` component.
- The uploaded data is used for all subsequent EDA operations.

### 2️⃣ **Plotting (Necessary)**
- This is the core visualization functionality of the app.
- The user selects the **Plotting** checkbox and picks features to visualize.

#### 🛠️ **Functionalities:**
- **Histogram**: Displays the distribution of a selected numeric feature.
- **Scatter Plot**: Plots the relationship between two selected features.
- **Customization:** Users can select features for both plots using dropdown menus.

#### 📊 **Example Plots:**
- Histogram of a single feature.
- Scatter plot comparing two features.

---

### 3️⃣ **Summarizing Data**
- The app generates a summary table containing basic statistics for selected features.
- Statistics include:
  - **Min**, **Median**, **Mean**, **Max**
  - **Standard Deviation**, **Variance**
  - **Missing Values**

#### 📊 **Example Summary Table:**
| Feature    | Min   | Median | Mean  | Max   | StdDev | Variance | Missing Values |
|------------|-------|--------|-------|-------|--------|----------|-----------------|
| Age        | 18    | 35     | 36.4  | 85    | 12.3   | 151.29   | 0               |
| Salary     | 20000 | 50000  | 55000 | 100000| 12000  | 144000000| 5               |

---

### 4️⃣ **Outlier Detection**
- Detects outliers using the **Interquartile Range (IQR)** method.
- Displays the total number of outliers in the selected feature.
- Visualizes outliers using a **Box Plot**.

#### 📊 **Outlier Detection Steps:**
1. **IQR Calculation:**
   - Q1 = 25th percentile, Q3 = 75th percentile
   - IQR = Q3 - Q1
2. **Outlier Boundaries:**
   - Lower Bound: Q1 - 1.5 * IQR
   - Upper Bound: Q3 + 1.5 * IQR
3. **Outlier Count:**
   - Displays the total number of outliers.
4. **Box Plot:**
   - Red points indicate outliers.

---

### 5️⃣ **Data Types Inspection**
- Displays a table showing the **data types** of each feature.
- Helps identify if a feature is numeric, factor, or character.

#### 📊 **Example Data Type Table:**
| Feature    | Data Type   |
|------------|-------------|
| Age        | Numeric     |
| Gender     | Factor      |
| Income     | Numeric     |

---

### 6️⃣ **Correlation Analysis**
- Calculates and displays the **correlation** between two selected numeric features.
- Uses the `cor()` function with `complete.obs` to ignore missing values.
- Displays the correlation value in a table format.

#### 📊 **Example Correlation Table:**
| Feature1   | Feature2   | Correlation |
|------------|------------|-------------|
| Age        | Salary     | 0.85        |
| Experience | Income     | 0.72        |

---

### 7️⃣ **Data Distributions**
- Visualizes the distribution of a selected numeric feature using a **Density Plot**.
- Includes a sample image display of a distribution graph.

#### 📊 **Visualization Steps:**
- **Density Plot:**
  - X-axis: Feature values.
  - Y-axis: Density.
  - Color: Blue with black border.

---

## 🎨 **UI Styling and Design**
The application features a modern and responsive UI with CSS styling for:
- **Buttons:** Styled with hover and active effects.
- **Panels:** Customizable backgrounds, padding, and shadows.
- **Text and Labels:** Styled with consistent fonts and colors for readability.
- **Images:** Properly formatted and displayed with borders.

---

## ✅ **How to Run the Application**

1. **Install Required Packages:**
```r
install.packages("shiny")
install.packages("ggplot2")
```

2. **Run the App:**
```r
shinyApp(ui, server)
```

3. **Access the Application:**
- Open the link displayed in the R console in your browser.
- Upload your CSV file.
- Select the desired EDA tasks.
- Visualize and analyze the data interactively.

---

## 🛠️ **Future Enhancements**
- Exporting analysis results as downloadable reports (CSV or PDF).
- Adding more visualization types (e.g., bar plots, line charts).
- Enhancing the UI with more advanced styling and themes.
- Adding data cleaning and preprocessing functionalities.

---

## 📚 **Credits and Acknowledgment**
- **Project Author:** Ajay
- **Language:** R
- **Framework:** Shiny
- **Libraries Used:** ggplot2, shiny

---

## 📝 **License**
This project is licensed under the MIT License.

