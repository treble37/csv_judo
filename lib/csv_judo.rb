require 'csv'

class TimeDuration
  attr_accessor :duration
  def initialize(time_options={})
    options = {:duration_obj=>DateTime.strptime("00:00:00","%H:%M:%S")}
    options.merge!(time_options)
    @duration = options[:duration_obj]
  end
  def duration_in_seconds
    @duration.hour*3600+@duration.min*60+@duration.sec
  end
end

module CSVJudo
  def read_in_csv(file_name,arg_options={})
    options={:headers=>true}
    options.merge!(arg_options)
    csv_arr = Array.new
    CSV.foreach(file_name,options) do |row|
      csv_arr<<row
    end
    csv_arr
  end
  def fetch_rows_by_date(csv_arr,arg_options={})
    options = {start_date: "2013-07-26 22:51", end_date: "2013-07-27 22:51", column: 4}
    options.merge!(arg_options)
    start_dt=DateTime.parse(options[:start_date])
    end_dt=DateTime.parse(options[:end_date])
    match_arr = csv_arr.select do |row|
      check_dt = DateTime.parse(row[options[:column]])
      row if (check_dt>=start_dt&&check_dt<=end_dt)
    end
    match_arr
  end
  def fetch_rows_by_duration(csv_arr,arg_options={})
    #duration_column: column where the date/time information in the call sheet that is being compared against the start and end time durations
    @start_time_duration = arg_options[:start_time_duration]||TimeDuration.new({:duration_obj=>DateTime.strptime("00:00:00","%H:%M:%S")})
    @end_time_duration = arg_options[:end_time_duration]||TimeDuration.new({:duration_obj=>DateTime.strptime("00:10:00","%H:%M:%S")})
    options = {start_time_duration: @start_time_duration, end_time_duration: @end_time_duration, duration_column: 9}
    options.merge!(arg_options)
    match_arr = csv_arr.select do |row|
      check_dur = TimeDuration.new({:duration_obj=>DateTime.strptime(row[options[:duration_column]],"%H:%M:%S")})
      row if check_dur.duration>=options[:start_time_duration].duration&&check_dur.duration<=options[:end_time_duration].duration
    end
    match_arr
  end
end