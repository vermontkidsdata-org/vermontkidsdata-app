# Debugging and Testing Rules for Vermont Kids Data App

## Integration Testing Rules

### Always Run Full Test Suite
- **Rule**: When implementing new features or fixing bugs, ALWAYS run the complete integration test suite, not just individual tests
- **Command**: `npx ts-node test/integration-test.ts --env=qa`
- **Reason**: Ensures changes don't break existing functionality

### Test-Driven Development
- **Rule**: Before claiming a fix is complete, verify it works with comprehensive testing
- **Process**: 
  1. Run specific test to verify fix: `npx ts-node test/integration-test.ts --env=qa --test-type=<test-name>`
  2. Run full test suite to check for regressions: `npx ts-node test/integration-test.ts --env=qa`

## AWS Debugging Rules

### Finding Lambda Functions in State Machines
- **Rule**: When debugging state machine issues, find Lambda functions through the state machine definition, not by searching
- **Process**:
  1. Get state machine definition: `aws stepfunctions describe-state-machine --state-machine-arn <arn> --query "definition"`
  2. Extract Lambda function names from the definition
  3. Use function names to find CloudWatch logs

### CloudWatch Log Investigation
- **Rule**: When Lambda functions fail, go directly to the Lambda function to find its associated log group
- **Process**:
  1. Find Lambda function name from state machine definition
  2. CloudWatch log group will be: `/aws/lambda/<function-name>`
  3. Check recent log streams for errors

### State Machine Execution Analysis
- **Rule**: When completions get stuck, check recent state machine executions for patterns
- **Commands**:
  - List recent executions: `aws stepfunctions list-executions --state-machine-arn <arn> --max-items 5`
  - Get execution details: `aws stepfunctions describe-execution --execution-arn <arn>`
  - Look for FAILED executions and examine their error messages

## Deployment Rules

### Use Proper Deployment Scripts
- **Rule**: Use the provided deployment script instead of trying to set environment variables manually
- **Command**: `bash do_not_commit/deploy.sh` (if there are AWS infrastructure changes other than just modifying lambda code) or `bash do_not_commit/hotswap.sh` (if the changes are only to TypeScript lambda function code)
- **Reason**: The script handles all necessary environment variables and configurations

### CRITICAL: Always Deploy and Test After Code Changes
- **Rule**: When making ANY code changes (SQL queries, Lambda functions, transformations, etc.), you MUST:
  1. Deploy using `do_not_commit/deploy.sh`
  2. Test the actual API endpoints with real HTTP calls
  3. Verify the changes work as expected in the deployed environment
- **Reason**: Code changes don't take effect until deployed, and local testing doesn't reflect production behavior
- **Example**: After fixing SQL queries, deploy first, then test with `curl "https://api.qa.vtkidsdata.org/..."`

### Database Updates Require Script Execution
- **Rule**: When modifying SQL scripts (like `scripts/20250924-act76.sql`), the database must be updated separately
- **Process**:
  1. Deploy code changes with `do_not_commit/deploy.sh`
  2. Execute SQL script to update database queries
  3. Test API endpoints to verify both code and database changes work together
- **Note**: Code deployment and database updates are separate steps

### Environment Setup
- **Rule**: When AWS CLI commands fail due to environment issues, use the BBF profile
- **Format**: Add `--profile BBF --region us-east-1` to AWS CLI commands
- **Example**: `aws stepfunctions list-executions --state-machine-arn <arn> --profile BBF --region us-east-1`

## Code Investigation Rules

### API Error Analysis
- **Rule**: When getting OpenAI API errors, the issue is likely in ai-utils.ts or ai-start-openai-completion.ts
- **Common Issues**:
  - Deprecated API parameters (like `file_ids` → `attachments`)
  - Null reference errors in file metadata access
  - Missing optional chaining for undefined objects

### File Upload Debugging
- **Rule**: When file upload features fail, check both the upload processing AND the OpenAI integration
- **Key Files**:
  - `src/ai-post-completion.ts` - Handles upload parameter processing
  - `src/uploadData.ts` - Processes document uploads
  - `src/ai-start-openai-completion.ts` - Integrates with OpenAI API
  - `src/ai-utils.ts` - Core OpenAI API functions

## Testing Patterns

### Debug Mode Usage
- **Rule**: Use debug mode to get detailed API request/response information
- **Command**: Add `--debug` flag to integration tests
- **Benefits**: Shows exact API calls, response structures, and timing information

### API Endpoint Testing After Changes
- **Rule**: After deploying code changes, ALWAYS test the actual API endpoints with curl or similar tools
- **Process**:
  1. Test the specific endpoint that was modified
  2. Test with different parameter combinations (filters, etc.)
  3. Verify the response structure and data correctness
  4. Test edge cases (empty results, invalid parameters)
- **Example**: `curl "https://api.qa.vtkidsdata.org/chart/bar/query_name?param1=value1&param2=value2"`

### Filter and Transformation Testing
- **Rule**: When implementing filter transformations, test both the API behavior and user experience
- **Key Points**:
  - API should accept simple values (numbers, basic strings)
  - Frontend transformations should only affect display, not API calls
  - Test that filters work with both transformed and raw values
  - Verify that empty results indicate a real issue, not just transformation problems

### Status Progression Monitoring
- **Rule**: Monitor completion status progression to identify where issues occur
- **Expected Flow**: "new" → "in_progress" → "success"
- **Stuck States**: If stuck in "new" = state machine not starting; if stuck in "queued" = OpenAI processing issues

## SQL Query and Database Rules

### Query Modification Process
- **Rule**: When modifying SQL queries in scripts, follow this exact process:
  1. Identify the correct query name (check API calls to find exact query being used)
  2. Modify the SQL script file
  3. Deploy code changes with `do_not_commit/deploy.sh`
  4. Execute the SQL script to update database
  5. Test API endpoints to verify changes work
- **Common Mistake**: Modifying the wrong query (e.g., `act76_family_pct_of_fpl:line` vs `act76_ccfap_family_pct_of_fpl:line`)

### Filter Implementation Best Practices
- **Rule**: Keep API filters simple and reliable
- **Approach**:
  - Use basic data types for API parameters (numbers for months: 1,2,3... not "January","February")
  - Apply transformations only in frontend display, not in API logic
  - Test with raw values first, then add display transformations
- **Example**: Month filter accepts `month_filter=7` (July) but displays "July" in dropdown

### Database Query Testing
- **Rule**: Test SQL queries directly in database before deploying, then test full-stack integration
- **Database Testing Process**:
  1. Use MCP MySQL tool to test query logic against actual database (dbvkd_qa)
  2. Verify data exists for test parameters and check data format/capitalization
  3. Confirm queries return expected results in correct order
  4. Check that transformations work as expected
- **Full-Stack Testing Process**:
  5. Deploy code changes
  6. Test actual API endpoints with HTTP calls (curl or browser)
  7. Verify frontend integration and check for JavaScript errors
  8. Ensure user interface displays correctly with proper labels and formatting
- **Why Both Levels Are Required**: Database testing catches SQL/data issues; browser testing catches frontend integration and user experience issues

## Error Pattern Recognition

### Common Error Patterns
1. **"Cannot read properties of undefined"** → Add optional chaining (`?.`)
2. **"Unknown parameter"** → Check for deprecated API parameters
3. **State machine FAILED** → Check Lambda function logs
4. **Stuck in "queued"** → OpenAI API rate limiting or processing issues
5. **Stuck in "new"** → State machine not starting, check POST completion logic
6. **Empty API results after changes** → Check if database was updated AND code was deployed
7. **Filter not working with transformed values** → Use simple values in API, transform only for display

## Best Practices

### Systematic Debugging Approach
1. Identify the failure point (API, state machine, Lambda function)
2. Check recent executions/logs for error patterns
3. Trace the code path from API call to completion
4. Fix the root cause, not just symptoms
5. Test both the specific fix AND full regression testing
6. Deploy and verify in target environment

### Documentation
- **Rule**: When fixing bugs, document the root cause and solution
- **Format**: Include both the technical fix and the debugging process used
- **Purpose**: Helps future debugging of similar issues

9. **CRITICAL - FIX ALL DISPLAY ISSUES**: If you find even minor display issues (incorrect text, formatting problems, "[object Object]" displays, missing data, etc.), you MUST investigate and fix them immediately. Always consider whether your code changes might have caused them. We cannot allow ANY regressions to happen, no matter how minor they seem. Do NOT wait for the user to point out display issues - proactively look for and fix them.

10. **CRITICAL - DO NOT MODIFY EXISTING WORKING CODE**: When fixing bugs, you must be very cautious about changing existing code that was working before your changes. If you introduced a bug with new code, fix the NEW code, not the existing code. Only modify existing code if you can prove it was already broken. If you think you need to change existing working code to fix an issue, you must ask the user first.

11. You must be very cautious about changing the database format. Do not change the database structure unless the user explicitly tells you to. If you think you need to change the database structure, you must ask the user if that is acceptable.

**MANDATORY WORKFLOW VERIFICATION**

Before considering any task complete, you MUST confirm:
- ☐ Lint has been run (errors fixed, not just lint:fix)
- ☐ Unit tests have been run
- ☐ All tests pass
- ☐ If tests failed, they were fixed (not skipped)

If you cannot check all boxes, the task is INCOMPLETE and you must state: "Task incomplete - tests not run/passing" and continue working until they pass.

**ERROR HANDLING IN MANDATORY STEPS**

If you encounter ANY error during mandatory workflow steps (lint, test, etc):
1. Stop proceeding to other work
2. Fix the error
3. Do not skip to deployment, browser testing, or other tasks
4. If you cannot fix it after 3 attempts, ASK the user for guidance

Never rationalize skipping a mandatory step due to errors.

**Exception:** Only skip these steps if the user explicitly tells you not to run tests or deploy (e.g., "don't deploy yet" or "skip tests for now").

When setting VKD_ENVIRONMENT, note that the VKD_ENVIRONMENT is always set to "qa" for development tasks.
