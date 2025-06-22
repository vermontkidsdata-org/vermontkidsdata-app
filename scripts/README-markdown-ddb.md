# Markdown to DynamoDB Insertion Script

This script scans the `data` directory for markdown files and inserts them into a DynamoDB table based on the `VKD_ENVIRONMENT` environment variable.

## List of Markdown Files

The following markdown files from the `data` directory will be processed:

1. 2020_Early_Childhood_Systems_Needs_Assessment_Building_Bright_Futures_October_2020.md
2. 2020_How_Are_Vermonts_Young_Children_and_Families_Building_Bright_Futures_January_2021.md
3. 2020_Vermont_Maternal_Infant_Early_Childhood_Home_Visiting_Program_Needs_Assessment_September_2020.md
4. 2023_Vermont_Head_Start_and_Early_Head_Start_Needs_Assessment_Report_Vermont_Head_Start_Collaboration_Office_Spring_2023.md
5. COVID-19_Vermont_Family_Impact_Survey_Voices_for_Vermonts_Children_Lets_Grow_Kids_Building_Bright_Futures_Hunger_Free_Vermont_Vermont_Early_Childhood_Advocacy_Alliance_October_2020.md
6. Identifying and Understanding the Vermont SNAP-Ed Focus Population.md
7. Integration_in_Vermonts_Early_Childhood_System_Issue_Brief_Vermont_Early_Childhood_Data_Policy_Center_Mar_2022.md
8. Maternal_and_Child_Health_Division_Title_V_Five-Year_Needs_Assessment_Vermont_Department_of_Health_September_2020.md
9. The_State_of_Vermonts_Children_2021_Year_in_Review_Building_Bright_Futures_January_2022.md
10. The_Vermont_Early_Childhood_Action_Plan_-_November_2020.md
11. Vermont_Child_Care_and_Early_Childhood_Education_Systems_Analysis.md
12. Vermont_Early_Care_and_Education_Financing_Study.md
13. Vermont_System_of_Care_Report_2023_-_State_Interagency_Team_SIT.md

## DynamoDB Tables

The script will insert items into one of the following DynamoDB tables based on the `VKD_ENVIRONMENT` environment variable:

- `qa`: qa-LocalDevBranch-SingleServiceTableABC698C2-3Z52F7FCI8WH
- `master`: master-LocalDevBranch-SingleServiceTableABC698C2-FNHLW4FT8XVJ

## Usage

### Prerequisites

- AWS CLI configured with appropriate credentials
- Node.js installed
- Required npm packages installed (`uuid`)

### Running the Script

1. Set the environment variable `VKD_ENVIRONMENT` to either `qa` or `master`:

   ```bash
   # For Windows CMD
   set VKD_ENVIRONMENT=qa
   
   # For Windows PowerShell
   $env:VKD_ENVIRONMENT="qa"
   
   # For Linux/Mac
   export VKD_ENVIRONMENT=qa
   ```

2. Run the script:

   ```bash
   node scripts/insert-markdown-to-ddb.js
   ```

   Or directly if the script is executable:

   ```bash
   scripts/insert-markdown-to-ddb.js
   ```

### What the Script Does

1. Determines which DynamoDB table to use based on the `VKD_ENVIRONMENT` variable
2. Scans the `data` directory for markdown files
3. For each markdown file:
   - Reads the file content
   - Generates a unique ID
   - Creates a DynamoDB item with the following attributes:
     - PK: `CONV#{itemId}` (where itemId is the filename without .md extension)
     - SK: `SORT#0`
     - id: The filename without .md extension
     - fileName: The name of the markdown file
     - envName: The environment name (qa or master)
     - query: `Do a needs assessment for {itemId}`
     - sortKey: 0
     - status: "success"
     - type: "needs-assessment"
     - _ct: Timestamp of insertion
     - _md: Timestamp of insertion
     - _et: "Completion"
     - content: The content of the markdown file
   - Inserts the item into the selected DynamoDB table
4. Outputs a summary of the operation

### Example Output

```
Using environment: qa
Using DynamoDB table: qa-LocalDevBranch-SingleServiceTableABC698C2-3Z52F7FCI8WH
Found 13 markdown files in the data directory:
- 2020_Early_Childhood_Systems_Needs_Assessment_Building_Bright_Futures_October_2020.md
- 2020_How_Are_Vermonts_Young_Children_and_Families_Building_Bright_Futures_January_2021.md
...

Inserting files into DynamoDB...
Successfully inserted item for file: 2020_Early_Childhood_Systems_Needs_Assessment_Building_Bright_Futures_October_2020.md
...

Summary: Inserted 13 out of 13 files into DynamoDB table qa-LocalDevBranch-SingleServiceTableABC698C2-3Z52F7FCI8WH