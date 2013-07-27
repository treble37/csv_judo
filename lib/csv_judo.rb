require 'csv'

module CSVJudo
  def read_in_csv(file_name)
    csv_arr = Array.new
    CSV.foreach(file_name) do |row|
      csv_arr<<row
    end
    csv_arr
  end
  #get rows matching a certain date or duration 
  def fetch_rows_by_date(csv_arr,options={start_date: "2013-07-26 22:51", end_date: "2013-07-27 22:51", column: 5})
    options.merge!(options)
    start_dt=DateTime.parse(options[:start_date])
    end_dt=DateTime.parse(options[:end_date])
    match_arr = Array.new
    csv_arr.each do |row|
      row.each do |r|
        check_dt = DateTime.parse(r[options[:column]])
        if (check_dt>=start_dt&&check_dt<=end_dt)
          match_arr<<row
        end
      end
    end
    return match_arr
  end
end