require_relative 'lib/csv_judo'

class ReportGenerator
  include CSVJudo
  attr_accessor :file_name_arr, :num_calls_arr, :report_fields_arr, :date_arr, :duration_arr, :final_report
  def initialize
    @report_fields_arr = ["Name", "Num Calls"]
    @file_name_arr = Dir['*cloudsharklabs*.csv']
    @duration_arr = [TimeDuration.new({duration_obj: DateTime.strptime("00:00:00","%H:%M:%S")}),TimeDuration.new({duration_obj: DateTime.strptime("00:01:00","%H:%M:%S")})]
    @final_report = Array.new
  end
  def report_generator
    @final_report<<@report_fields_arr
    @file_name_arr.each do |f|
      report_csv_arr = read_in_csv(f)
      report_csv_arr = fetch_rows_by_date(report_csv_arr,{start_date: @date_arr[0], end_date: @date_arr[1]})
      report_csv_arr = fetch_rows_by_duration(report_csv_arr,options = {start_time_duration: @duration_arr[0], end_time_duration: @duration_arr[1], duration_column: 9})
      @final_report<<[f,report_csv_arr.length]
    end
  end
end

repg = ReportGenerator.new
repg.date_arr = ["2013-7-21","2013-7-27"]
repg.file_name_arr = Dir['*cloudsharklabs*.csv']
s_dur = TimeDuration.new({duration_obj: DateTime.strptime("00:00:00","%H:%M:%S")})
e_dur = TimeDuration.new({duration_obj: DateTime.strptime("00:10:00","%H:%M:%S")})
repg.duration_arr = [s_dur,e_dur]
repg.report_generator

p repg.final_report

