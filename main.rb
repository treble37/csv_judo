require_relative 'lib/csv_judo'

class ReportGenerator
  include CSVJudo
  attr_accessor :file_name_arr, :num_calls_arr, :report_fields_arr, :date_arr, :duration_arr, :final_report
  def initialize
    @report_fields_arr = ["Name", "Num Calls"]
    @file_name_arr = Dir['*cloudsharklabs*.csv']
    @duration_arr = [DateTime.strptime("00:00:00","%H:%M:%S"),DateTime.strptime("00:01:00","%H:%M:%S"),0]
    @final_report = Array.new
  end
  def report_generator
    @final_report<<@report_fields_arr
    @file_name_arr.each do |f|
      report_csv_arr = read_in_csv(f)
      report_csv_arr = report_csv_arr[1..report_csv_arr.length-1]
      report_csv_arr = fetch_rows_by_date(report_csv_arr,{start_date: @date_arr[0], end_date: @date_arr[1]})
      report_csv_arr = fetch_rows_by_duration(report_csv_arr,options = {start_duration: @duration_arr[0], end_duration: @duration_arr[1], column: 9, duration_search: @duration_arr[2]})
      @final_report<<[f,report_csv_arr.length]
    end
  end
end

repg = ReportGenerator.new
repg.date_arr = ["2013-7-29","2013-7-30"]
repg.file_name_arr = Dir['*cloudsharklabs*.csv']
repg.duration_arr = [DateTime.strptime("00:00:00","%H:%M:%S"),DateTime.strptime("00:03:00","%H:%M:%S"),0]
repg.report_generator

p repg.final_report

