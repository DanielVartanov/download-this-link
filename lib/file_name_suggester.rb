class FileNameSuggester
  def self.suggest_file_name!(url)
    suggested_file_name = File.basename(URI::parse(url).path)
    suggested_file_name.strip!
    suggested_file_name.empty? ? generate_file_name : suggested_file_name
  end

  def generate_file_name
    "file-#{rand(1000000000)}"
  end
end