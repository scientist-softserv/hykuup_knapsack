# frozen_string_literal: true

module Bulkrax
  # OVERRIDE Bulkax v7.0.0:
  #   to add model to collections so CsvCollectionEntry objects are properly created
  #   to handle tar.gz files, MOBIUS has their data in tarballs intead of zips
  module CsvParserDecorator
    COMBINED_CSV_FILENAME = 'combined.csv'
    COMBINED_FILES_DIRNAME = 'files'

    def records(_opts = {})
      return super unless Account.find_by(tenant: Apartment::Tenant.current).mobius?

      records = super
      records.each do |record|
        if (record[:bs_isCommunity] || record[:bs_isCollection])&.downcase == 'true'
          record[:model] =
            Hyrax.config.collection_model
        end
      end
    end

    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    def untar(file_to_unzip)
      super

      # MOBIUS tarballs can be nested, as when you first extract,
      # it contains a single directory that then contains all the files
      # TODO: might be nice to contribute this back to Bulkrax
      directories = Dir.entries(importer_unzip_path).select do |entry|
        File.directory? File.join(importer_unzip_path, entry) and !['.', '..'].include?(entry)
      end

      # If there's only one directory, move its contents to the importer_unzip_path
      if directories.length == 1
        subdirectory_path = File.join(importer_unzip_path, directories.first)
        Dir.glob("#{subdirectory_path}/*").each do |file|
          FileUtils.mv(file, importer_unzip_path)
        end
      end

      coerce_unpacked_files! if Account.find_by(tenant: Apartment::Tenant.current).mobius?
    end
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

    private

    def coerce_unpacked_files!
      combine_csvs
      combine_files
      coerce_csv
      clean_up_upacked_files
    end

    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    def combine_csvs
      combined_csv_path = File.join(importer_unzip_path, COMBINED_CSV_FILENAME)
      csv_file_paths = Dir.glob(File.join(importer_unzip_path, '*.csv'))

      # Collect all unique headers from all CSV files, starting with file and model since they do not originally exist
      all_headers = csv_file_paths.each_with_object(%w[file model]) do |file_path, headers|
        CSV.foreach(file_path, headers: true) do |row|
          headers << row.headers
        end
      end.uniq.flatten

      # Open the combined CSV file for writing
      CSV.open(combined_csv_path, 'wb') do |combined_csv|
        combined_csv << all_headers

        csv_file_paths.each do |file_path|
          CSV.foreach(file_path, headers: true) do |row|
            combined_row = all_headers.index_with { |_header| nil }
            row.to_h.each { |key, value| combined_row[key] = value if combined_row.key?(key) }
            combined_csv << combined_row.values
          end
        end
      end
    end
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

    # rubocop:disable Metrics/MethodLength
    def combine_files
      file_paths = Dir.glob(File.join(importer_unzip_path, '*'))
      file_paths.select! { |file_path| Dir.exist?(file_path) }
      files = []
      file_paths.each do |file_path|
        files += Dir.glob(File.join(file_path, '*'))
      end

      combined_files_dir = File.join(importer_unzip_path, COMBINED_FILES_DIRNAME)
      Dir.mkdir(combined_files_dir) unless File.directory?(combined_files_dir)

      files.each do |file|
        FileUtils.mv(file, combined_files_dir)
      end
    end
    # rubocop:enable Metrics/MethodLength

    # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
    def coerce_csv
      csv_path = File.join(importer_unzip_path, COMBINED_CSV_FILENAME)
      files = Dir.glob(File.join(importer_unzip_path, COMBINED_FILES_DIRNAME, '*'))
                 .map { |path| File.basename(path) }
                 .reject { |file| file.downcase.include?('thumbnail') }

      new_rows = CSV.foreach(csv_path, headers: true, return_headers: true).each_with_object([]) do |row, rows|
        file_entry = files.select { |file| file.include?(row['ss_pid'].tr(':', '_')) }.join(',')
        row['file'] = file_entry if file_entry.present?
        if (row['bs_isCommunity'] || row['bs_isCollection'])&.downcase == 'true'
          row['model'] = Hyrax.config.collection_model
        end

        rows << row.to_hash
      end

      CSV.open(csv_path, 'wb') do |csv|
        new_rows.each do |row|
          csv << row.values
        end
      end
    end
    # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity

    def clean_up_upacked_files
      Dir.glob(File.join(importer_unzip_path, '*')).each do |file_path|
        next if File.basename(file_path) == COMBINED_CSV_FILENAME || File.basename(file_path) == COMBINED_FILES_DIRNAME

        FileUtils.rm_rf(file_path)
      end
    end
  end
end

Bulkrax::CsvParser.prepend(Bulkrax::CsvParserDecorator)
