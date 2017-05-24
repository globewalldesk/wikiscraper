iandt = []
general_jobs = []
# Grab and split the contents of industry-and-titles.txt.
File.open("industry-and-titles.txt") do |file|
  lines_array = file.readlines
  lines_array.each do |title|
    title.chomp!
    i, t = title.split("|")
    iandt << [i, t]
    general_jobs << t.capitalize if t
  end
end

# Grab and split the contents of a2z.txt (but put general titles first).
atoz = {};
File.open("files/a2z.txt") do |file|
  lines_array = file.readlines
  lines_array.each do |title|
    title.chomp!
    value, key = title.split(", see: ")
    # Iterate the atoz array, constructing a hash with general titles as keys
    # pointing to arrays of specialized job titles.
    if key # will be nil if splitting doesn't happen
      atoz[key] ||= [] # Initialize key if first time seen.
      atoz[key] << value
    else
      atoz[key] = nil # There might be general job types with no sub-types.
    end
  end
end

# Every general job title in the big list needs to be in the small list, or
# else it won't be included, since we're iterating through the small list.
# For each general job in the big list,
atoz.each do |gjob, sjob|
  # Search general jobs list, make sure it's on the list.
  puts gjob unless general_jobs.find(gjob)
end

puts "All general jobs in the big list are on the small list."

big_list = []
# Iterate the iandt array, construct the big job list
iandt.each do |industry, gjob|
  gjobcap = gjob.capitalize if gjob
  if atoz[gjobcap]
    atoz[gjobcap].each do |sjob|
      big_list << "#{industry}|#{gjob}|#{sjob}\r\n" # Windows newlines.
    end
  else
    big_list << "#{industry}|#{gjob}|\r\n"
  end
end
puts big_list.length

File.open("master_list.txt", "w") do |file|
  file.puts(big_list.sort)
end
