# VKD Debugging Rules - Quick Reference

## 🚨 CRITICAL WORKFLOW RULES

### MANDATORY BEFORE COMPLETION
- ☐ Deploy changes: `bash do_not_commit/deploy.sh`
- ☐ Run integration tests: `npx ts-node test/integration-test.ts --env=qa`
- ☐ Test actual API endpoints with curl/browser
- ☐ Verify no display regressions (check for "[object Object]", formatting issues, etc.)

**If ANY step fails, STOP and fix before proceeding. Never skip mandatory steps.**

### NEVER MODIFY EXISTING WORKING CODE
- Fix NEW code that introduced bugs, not existing working code
- Only change existing code if you can prove it was already broken
- Ask user before changing working code or database structure

## 🔍 ACT76 DATA DEBUGGING PATTERNS

### Geography Filtering Bug Pattern (LEARNED 2024-12-18)
**Problem**: Line charts showing incorrect totals (e.g., 766 instead of 410)
**Root Cause**: Missing geography filtering - queries sum all counties instead of using Vermont totals
**Solution**: Add geography filtering to line chart queries:
```sql
AND ((@county_filter = "-- All --" AND geography = "Vermont") 
     OR (@county_filter != "-- All --" AND geography COLLATE utf8mb4_unicode_ci = @county_filter))
```
**Affected Queries**: `act76_child_race:line`, `act76_child_ethnicity_ccfap:line`, `act76_child_age_ccfap:line`

### Family Total Calculation Bug Pattern (LEARNED 2024-12-18)
**Problem**: Family totals incorrect due to summing counties with suppressed values
**Root Cause**: Calculated sums include suppressed (-1) values and "Out of State" records
**Solution**: Use authoritative Vermont totals instead of calculated sums
**Key Insight**: Vermont aggregate data is more reliable than county-level calculations

### Query Name Confusion Pattern
**Problem**: Modifying wrong query (e.g., `act76_family_pct_of_fpl:line` vs `act76_ccfap_family_pct_of_fpl:line`)
**Solution**: Always verify exact query name from API calls before modifying

## 🛠️ DEPLOYMENT & TESTING

### Deploy-Test-Verify Cycle
1. **Deploy**: `bash do_not_commit/deploy.sh` (or `hotswap.sh` for Lambda-only changes)
2. **Update DB**: Execute SQL scripts if queries were modified
3. **Test API**: `curl "https://api.qa.vtkidsdata.org/chart/bar/query_name?params"`
4. **Test UI**: Verify charts display correctly in browser
5. **Integration Test**: `npx ts-node test/integration-test.ts --env=qa`

### Database Testing Strategy
1. **Direct SQL Testing**: Use MCP MySQL tool against `dbvkd_qa`
2. **API Testing**: Test endpoints after deployment
3. **UI Testing**: Verify frontend integration and display

## 🐛 COMMON ERROR PATTERNS

| Error | Likely Cause | Solution |
|-------|-------------|----------|
| `"Cannot read properties of undefined"` | Missing null checks | Add optional chaining (`?.`) |
| `"Unknown parameter"` | Deprecated API params | Check OpenAI API changes |
| State machine FAILED | Lambda function error | Check `/aws/lambda/<function-name>` logs |
| Stuck in "new" | State machine not starting | Check POST completion logic |
| Stuck in "queued" | OpenAI processing issues | Check rate limits/API status |
| Empty API results after changes | DB not updated OR code not deployed | Deploy AND execute SQL scripts |
| Filter not working | Using transformed values in API | Use raw values in API, transform for display only |

## 📊 SQL QUERY DEBUGGING

### Filter Implementation Best Practices
- **API Level**: Use simple values (numbers: `month_filter=9`, not `"September"`)
- **Display Level**: Transform for user interface only
- **Geography Logic**: Always handle "-- All --" vs specific geography selection

### Query Modification Checklist
1. Identify correct query name from API calls
2. Modify SQL in script file
3. Deploy code changes
4. Execute SQL script to update database
5. Test API endpoints
6. Verify UI displays correctly

## 🔧 AWS DEBUGGING

### State Machine Issues
```bash
# List recent executions
aws stepfunctions list-executions --state-machine-arn <arn> --max-items 5 --profile BBF --region us-east-1

# Get execution details
aws stepfunctions describe-execution --execution-arn <arn> --profile BBF --region us-east-1

# Find Lambda logs
aws stepfunctions describe-state-machine --state-machine-arn <arn> --query "definition" --profile BBF --region us-east-1
```

### CloudWatch Logs
- Lambda logs: `/aws/lambda/<function-name>`
- Check recent log streams for errors
- Look for patterns in FAILED executions

## 🧪 TESTING STRATEGIES

### Integration Test Usage
- **Full Suite**: `npx ts-node test/integration-test.ts --env=qa`
- **Debug Mode**: Add `--debug` flag for detailed API info
- **Specific Test**: `--test-type=<test-name>` (if supported)

### API Testing After Changes
```bash
# Test specific endpoint
curl "https://api.qa.vtkidsdata.org/chart/bar/act76_child_race:bar?race_filter=Black%20or%20African%20American&county_filter=--%20All%20--&month_filter=9&year_filter=2025"

# Test line chart equivalent
curl "https://api.qa.vtkidsdata.org/chart/line/act76_child_race:line?race_filter=Black%20or%20African%20American&county_filter=--%20All%20--"
```

## 📁 KEY FILES FOR DEBUGGING

### OpenAI/AI Issues
- `src/ai-utils.ts` - Core OpenAI API functions
- `src/ai-start-openai-completion.ts` - OpenAI integration
- `src/ai-post-completion.ts` - Upload parameter processing

### Data/Query Issues
- `scripts/20250924-act76.sql` - Act76 query definitions
- `src/chartsApi.ts` - Chart API logic
- `src/db-utils.ts` - Database utilities

### File Upload Issues
- `src/uploadData.ts` - Document upload processing
- `src/ai-assistant-upload.ts` - Assistant file handling

## 🎯 SYSTEMATIC DEBUGGING APPROACH

1. **Identify Failure Point**: API, state machine, Lambda, or UI?
2. **Check Recent Logs**: Look for error patterns in executions/logs
3. **Trace Code Path**: Follow the request from API to completion
4. **Fix Root Cause**: Don't just treat symptoms
5. **Test Thoroughly**: Both specific fix AND regression testing
6. **Deploy & Verify**: Confirm fix works in target environment
7. **Document**: Record the issue, cause, and solution for future reference

## 🚀 ENVIRONMENT NOTES

- **VKD_ENVIRONMENT**: Always set to "qa" for development tasks
- **AWS Profile**: Use `--profile BBF --region us-east-1` for CLI commands
- **Test Environment**: https://api.qa.vtkidsdata.org
- **UI Environment**: https://ui.qa.vtkidsdata.org
