pipe_delimited_file = [] # For use in constructing file contents

def groovify (thang)
  thang = thang.gsub(/%26/, '&')
  thang = thang.gsub("_", " ")
end

files = Dir["files/*"]
# Iterate through the files, and for each, iterate through the lines.
files.each do |fl|
  File.open(fl) do |file|
    fl_represent = 0 # make sure this industry name is included, at least
    # For each, download the contents of the page into an array of lines.
    linesarr = file.readlines
    # Iterate through the lines.
    linesarr.each do |line|
      line.chomp!
      # Extract whatever fits into /\[\[(.+?)\]\]/. E.g., [[foo]]
      if /\[\[(.+?)\]\]/.match(line)
        # Push that onto an array, constructing pipe-separated lines.
        pipe_delimited_file << "#{groovify(fl).slice(6,fl.length - 1)}|#{$1}"
        fl_represent += 1
      end
    end
    pipe_delimited_file << "#{groovify(fl).slice(6,fl.length - 1)}|" if 
      fl_represent == 0
  end
end

# Output to text file.
File.open("industry-and-titles.txt", "w") do |file|
  pipe_delimited_file.each { |line| file.write("#{line}\n") }
end
