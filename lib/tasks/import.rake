namespace :import do
  desc "Import Restaurants based on JSON file"
  task :restaurants_by_file, [ :file_path ] => [ :environment ] do |t, args|
    file_contents = File.read(File.join(args[:file_path]))
    json_data     = JSON.parse(file_contents, symbolize_names: true)

    logs, error = RestaurantImportService.new(json_data).call

    puts "Error: #{error.message}" if error
    puts "Menu Items logs: "
    puts logs
  end
end
