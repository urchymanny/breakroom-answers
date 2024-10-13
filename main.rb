require 'json'

# The Answer class encapsulates the survey responses and scoring logic.
class Answer
  # MAX_OVERTIME = 8
  # MIN_WAGE = 6.0

  attr_accessor :enjoys_job, :respected_by_managers, :good_for_carers,
                :contracted_hours, :hours_actually_worked, :unpaid_extra_work,
                :hourly_rate, :score

  def initialize(enjoys_job:, respected_by_managers:, good_for_carers:,
                 contracted_hours:, hours_actually_worked:, unpaid_extra_work:,
                 hourly_rate:, max_overtime: 8, min_wage: 6.0, **_extras)

    # Survey Responses
    @enjoys_job = enjoys_job
    @respected_by_managers = respected_by_managers
    @good_for_carers = good_for_carers
    @contracted_hours = contracted_hours
    @hours_actually_worked = hours_actually_worked
    @unpaid_extra_work = unpaid_extra_work
    @hourly_rate = parse_hourly_rate(hourly_rate) # Serialize the input

    # Initialize scoring counters.
    @score = 0
    @valid_points = 0

    # Constants for scoring criteria.
    @max_overtime = max_overtime    # Maximum allowed overtime hours
    @min_wage = min_wage            # Minimum wage for staff/country/city/user maybe by age
  end

  # Calculates the score based on the user's responses.
  # Returns an array containing the score, valid points, and percentage.
  def calculate_score
    check_boolean_response(@enjoys_job)
    check_boolean_response(@respected_by_managers)
    check_boolean_response(@good_for_carers)
    check_boolean_response(@unpaid_extra_work, positive_response: 'no')
    check_hours
    check_rate

    # Calculate the percentage score
    percentage = (@score.to_f / @valid_points) * 100
    [@score, @valid_points, percentage] # Return the scores
  end

  private

  def parse_hourly_rate(rate)
    return rate if rate.is_a?(Numeric)

    # Remove '£' symbol and convert to float
    rate.gsub('£', '').to_f
  end

  def check_boolean_response(value, positive_response: 'yes')
    # Skip if value is nil or 'unsure'
    return if [nil, 'unsure'].include?(value)

    @valid_points += 1
    @score += 1 if value == positive_response # Increment score if positive response
  end

  def check_hours
    # Skip if any of the comparable hours are nil or 'unsure'
    return if [nil, 'unsure'].include?(@hours_actually_worked) || [nil, 'unsure'].include?(@contracted_hours)

    @valid_points += 1
    overtime = @hours_actually_worked - @contracted_hours
    @score += 1 if overtime <= @max_overtime                # Increment score if within max overtime
  end

  def check_rate
    return if [nil, 'unsure'].include?(@hourly_rate)        # Skip if rate is nil or 'unsure'

    @valid_points += 1
    @score += 1 if @hourly_rate >= @min_wage                # Increment score if rate meets minimum wage
  end
end

def process_answer(answer)
  ans = Answer.new(**answer)
  score, valid_points, percentage = ans.calculate_score
  print("Score is #{score}/#{valid_points} - #{percentage.round(2)}")   # Display the score
end

# sample = {
#   "enjoys_job": "yes",
#   "respected_by_managers": "no",
#   "good_for_carers": "yes",
#   "contracted_hours": 20,
#   "hours_actually_worked": 34,
#   "unpaid_extra_work": "unsure",
#   "age": 26,
#   "hourly_rate": "£8.22",
#   "submitted_date": 1608211454000
# }

# runner(sample) # outputs "Score is 3/5 - 60.0%"


# Main execution block
if __FILE__ == $0
  if ARGV.empty?
    puts "This implementation requires a JSON file path as an argument"
    puts "Usage: ruby #{__FILE__} path/to/file.json"
    exit 1
  end

  filename = ARGV[0]

  # Verify that the specified file exists.
  unless File.exist?(filename)
    puts "File '#{filename}' does not exist."
    exit 1
  end

  begin
    file_content = File.read(filename)                               # Read the JSON file
    answer_data = JSON.parse(file_content, symbolize_names: true)    # Parse the content
  rescue JSON::ParserError => e
    puts "Failed to parse JSON file: #{e.message}"
    exit 1
  end

  # Process the answer data
  process_answer(answer_data)
end
