# Purpose
A script to suppress data in worksheets (one sheet at a time)

# Usage
* always run the script as a whole, don't access functions with imports
* run the script with -h to see options
* always quote file names
* first filename = input, second filename=output
* I recommend not changing the log file, but you can with the `-l` flag
* example usage: python src/suppression.py "child.xlsx" "clean_child.xlsx" -p "PRIM" -s "SEC"
    * python
    * script name
    * input file in quotes
    * output file in quotes
    * -p flag to set the string for primary suppression (default=***)
    * -s flag to set the string for secondary suppression

## Primary-Only Suppression
* To perform only primary suppression (skip secondary suppression) on a worksheet, add "primary" to the worksheet title
* The annotation is case insensitive and works with or without a dash
* Examples of valid annotations:
  * **With dash**: "Ethnicity by County - primary", "Ethnicity by County-primary", "Ethnicity by County - Primary"
  * **Without dash**: "Ethnicity by County primary", "Ethnicity by County PRIMARY", "Ethnicity by County Primary"
  * **Spacing tolerant**: "Ethnicity by County  -  primary", "Ethnicity by County   primary"
* The primary annotation will be automatically stripped from the output worksheet name
* The clean worksheet name (without the primary annotation) will be used for table definitions and output


# Credits
Author: Fitz Koch
Created: 2025-07-19
For followups or questions, email fkeenank@uvm.edu

Feel free to alter and reuse any part of this! Credit is nice if directly copying something.