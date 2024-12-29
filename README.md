# Mumbai House Analysis Project

This project combines Python, SQL, and real estate data to analyze property trends in Mumbai. Using Python Jupyter Notebook, I connected directly to SQL Server to fetch data from the **Mumbai database** and performed a series of analysis queries. Below is a breakdown of the key steps:

- Database Connection: Established a connection between Python Jupyter Notebook and SQL Server using pypyodbc to fetch the prices and regions tables for analysis.
- Data Fetching: Retrieved data and converted it into pandas DataFrames to work with it efficiently in Python.

## SQL Queries
1. Which region has the highest average price for houses?
2. What is the total area of houses available in each region?
3. What is the price range of houses based on BHK configurations?
4. Which region has the most expensive house per square foot?
5. What is the most common house type in each region?
6. How does the status of a house (sold, available) affect its price across regions?
7. Which type of house has the largest average area in each region?

## Python Analysis

Using Python and pandas, I performed additional data analysis:

1. Created DataFrames for East and West regions**: Segregated the data based on regional information.
2. Counted the number of resale houses**: Analyzed the dataset to determine how many resale houses are available.
3. Created DataFrames for houses greater than 100 sq feet**: Filtered the dataset to focus on larger properties.
4. Found the house with the highest price**: Identified the most expensive house in the dataset.
5. Calculated the average area of houses with more than 3 BHK**: Analyzed the properties with BHK greater than 3 to find the average area.

The project showcases the ability to connect Python with SQL for data extraction, filtering, and analysis. The insights derived from the dataset helped answer important real estate queries and provided valuable perspectives on Mumbai's housing market.
