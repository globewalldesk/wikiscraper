iandt = []
# Grab and split the contents of industry-and-titles.txt.
File.open("industry-and-titles.txt") do |file|
  lines_array = file.readlines
  lines_array.each do |title|
    title.chomp!
    iandt << title.split("|")
  end
end
