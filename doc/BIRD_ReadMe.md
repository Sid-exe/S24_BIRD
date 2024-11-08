
# Biomedical Information Resource Database - BIRD

## Overview

**S24_BIRD** is a MySQL database created during the summer of 2024. This Knowledge Repository comprises a vast database with billions of data points and numerous interconnected tables containing biomedical data. The information spans proteins, diseases, genomes, drugs, and more, massively aiding researchers and scientists in drug discovery. This database serves as a foundation for building Knowledge Graphs or LLMs, facilitating efficient analysis and data collection.

## Repository Contents

This GitHub repository includes all necessary Python load files to access, parse, and extract data from various data files containing crucial biomedical information and insert the data into the MySQL database named **S24_BIRD**. These data files are downloaded or web-scraped from various biomedical websites such as UniProt, Chembl, Disgenet, ClinVar, PubMed, and JensenLab, among others. 

### Pre-Downloading Data

It is recommended to pre-download these files in advance and store them in folders within the data directory so that the load files can access them and extract the relevant data. The naming structure of these data folders can be determined by examining the file paths and filenames given in the codes where the data is accessed. A Detailed Excel Sheet showing the Datasets, Load Files and Sources along with their Links will be provided in this folder. However these links may get updated over time.

### Running Scripts

Running the codes in a powerful Linux Operating System with a MySQL server is highly recommended. Additionally, using tmux sessions to run the Python scripts ensures uninterrupted script execution.

### Additional Data Sources

The provided load files alone are not sufficient to populate all the tables in the database. Several tables were manually added from other sources by importing CSV files into a database management platform called **DBeaver**.Apart from **S24_BIRD**, We included two more Databases called **S24_chembl** and **S24_clinicaltrials**. Although these exists independantly some data from S24_chembl was added to S24_BIRD via a loader. The rest of the databases act as another pivotal source of Biomedical data that could be incorporated with **S24_BIRD** in the future.Information about the Databased, tables, ER diagram, and .sql dump files are provided in the SQL folder of the repository.

## Running Scripts in Order

To ensure that the tables in the database populate records without redundancies and key constraint violations, it is essential to run the scripts in a specific order. This order is provided in the commands file in this directory. The code uses command line arguments, so it is preferable to follow the run commands exactly as specified.

## Types of Load Files

There are three types of load files:

1. **Common:** Load files that access pre-downloaded data.
2. **Rare Case:** Load files that download and process data.
3. **API:** Load files that use APIs to directly download from website servers.



