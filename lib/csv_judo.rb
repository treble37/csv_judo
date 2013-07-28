require 'csv'

module CSVJudo
  def self.read_in_csv(file_name)
    csv_arr = Array.new
    CSV.foreach(file_name) do |row|
      csv_arr<<row
    end
    csv_arr
  end
  def self.fetch_rows_by_date(csv_arr,arg_options={})
    options = {start_date: "2013-07-26 22:51", end_date: "2013-07-27 22:51", column: 4}
    options.merge!(arg_options)
    start_dt=DateTime.parse(options[:start_date])
    end_dt=DateTime.parse(options[:end_date])
    match_arr = Array.new
    csv_arr.each do |row|
      check_dt = DateTime.parse(row[options[:column]])
      if (check_dt>=start_dt&&check_dt<=end_dt)
        match_arr<<row
      end
    end
    return match_arr
  end
  def self.fetch_rows_by_duration(csv_arr,arg_options={})
    #duration_search: 1: >= start_duration, 0: >=start_duration & <=end_duration, -1: <end_duration
    options = {start_duration: DateTime.strptime("00:00:30","%H:%M:%S"), end_duration: DateTime.strptime("00:01:00","%H:%M:%S"), column: 9, duration_search: 1}
    options.merge!(arg_options)
    match_arr = Array.new
    csv_arr.each do |row|
      check_dur = DateTime.strptime(row[options[:column]],"%H:%M:%S")
      case options[:duration_search]
      when -1
        if (check_dur<=options[:end_duration])
          match_arr << row
        end
      when 0
        if (check_dur>=options[:start_duration]&&check_dur<=options[:end_duration])
          match_arr << row
        end
      when 1
        if (check_dur>=options[:start_duration])
          match_arr<<row
        end
      end
    end
    return match_arr
  end
end