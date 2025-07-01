# mymodule/lib/facter/compruebaDirectorio.rb
Facter.add(:compruebaDirectorio) do
  setcode do
    directory_path = Facter.value(:directory_path)
    Facter.debug("Checking existence of directory: #{directory_path}")

    if directory_path.nil? || directory_path.empty?
      Facter.debug("No directory path provided.")
      'false'
    else
      exists = File.directory?(directory_path)
      Facter.debug("Directory #{directory_path} exists: #{exists}")
      exists ? 'true' : 'false'
    end
  end
end
