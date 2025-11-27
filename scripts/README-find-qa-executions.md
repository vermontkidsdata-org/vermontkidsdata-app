# Find QA State Machine Executions Script

This TypeScript script searches through AWS Step Functions state machine executions to find those with a specific ID in their input JSON.

## Usage

### Using npm script (recommended)
```bash
npm run find-qa-executions -- --id "your-id-here"
```

### Direct execution
```bash
ts-node scripts/find-qa-state-machine-executions.ts --id "your-id-here"
```

## Options

| Option | Alias | Type | Required | Description |
|--------|-------|------|----------|-------------|
| `--id` | `-i` | string | ✓ | ID to search for in state machine execution inputs |
| `--region` | `-r` | string | | AWS region (defaults to AWS CLI default) |
| `--profile` | `-p` | string | | AWS profile to use (defaults to AWS CLI default) |
| `--state-machine` | `-s` | string | | Filter state machines by name pattern (defaults to QA-related machines) |
| `--status` | | string | | Filter executions by status (RUNNING, SUCCEEDED, FAILED, TIMED_OUT, ABORTED) |
| `--max-results` | `-m` | number | | Maximum number of executions to check per state machine (default: 100) |
| `--verbose` | `-v` | boolean | | Enable verbose output |
| `--help` | `-h` | | | Show help |

## Examples

### Basic usage
```bash
npm run find-qa-executions -- --id "12345"
```

### With specific region and verbose output
```bash
npm run find-qa-executions -- --id "abc-123" --region us-east-1 --verbose
```

### Filter by state machine name and status
```bash
npm run find-qa-executions -- --id "test-id" --state-machine "MyQAStateMachine" --status SUCCEEDED
```

### Using AWS profile
```bash
npm run find-qa-executions -- --id "example-id" --profile my-aws-profile
```

## How it works

1. **State Machine Discovery**: The script first lists all Step Functions state machines in your AWS account
2. **QA Filtering**: By default, it filters for state machines with names containing "qa", "quality", or "test" (case-insensitive)
3. **Execution Listing**: For each relevant state machine, it lists recent executions
4. **Input Parsing**: For each execution, it retrieves the execution details and parses the input JSON
5. **ID Matching**: It looks for common ID field names (`id`, `Id`, `ID`, `identifier`, `executionId`, `requestId`) and matches against the provided ID
6. **First Match Exit**: The script stops immediately after finding the first matching execution
7. **Results Display**: Shows the first matching execution with its details

## Prerequisites

- AWS CLI installed and configured
- Appropriate AWS permissions for Step Functions:
  - `states:ListStateMachines`
  - `states:ListExecutions`
  - `states:DescribeExecution`
- Node.js and TypeScript dependencies installed

## Output

The script provides:
- Progress information during execution
- Summary of found executions
- Detailed information for each matching execution including:
  - Execution name and status
  - Start date
  - Execution ARN
  - State Machine ARN
  - Input JSON (in verbose mode)

## Error Handling

The script includes comprehensive error handling for:
- AWS CLI command failures
- Invalid JSON parsing
- Missing or inaccessible state machines
- Network connectivity issues

Use the `--verbose` flag to see detailed error information and execution progress.