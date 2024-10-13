# BR Survey Score Calculator

This Ruby script processes survey responses from a JSON file

- calculates a score based on predefined criteria, and outputs the results.

It is designed to evaluate responses to specific questions and determine a percentage score representing the overall positive feedback.

## Usage

### Running the Script

1. **Prepare the JSON File**:

   Create a JSON file (e.g., `survey_response.json`) with the survey responses in the correct format.

2. **Run the Script**:

   Execute the script from the command line, providing the path to the JSON file:

   ```bash
   ruby main.rb path/to/survey_response.json
   ```

   Replace `survey_response.rb` with the actual json filename if different (`answer.json` is included in repo).

**Expected Output:**

```
Score is 3/5 - 60.0
```

This output indicates that the respondent scored 3 out of 5 valid points, resulting in a 60% positive score.

## Error Handling

- **Missing File Argument**:

  If no file path is provided, the script will prompt for correct usage and exit.

- **File Not Found**:

  If the specified file does not exist, the script will notify the user and exit.

- **Invalid JSON Format**:

  If the JSON file cannot be parsed, the script will display an error message and exit.

- **Incomplete Data**:

  Responses that are `nil` or `"unsure"` are skipped in scoring and do not count towards the total valid points.
