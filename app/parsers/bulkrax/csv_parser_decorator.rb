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

    def untar(file_to_unzip)
      super
      coerce_unpacked_files! if Account.find_by(tenant: Apartment::Tenant.current).mobius?
    end

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

      # Collect all unique headers from all CSV files
      all_headers = csv_file_paths.each_with_object([]) do |file_path, headers|
        CSV.foreach(file_path, headers: true) do |row|
          headers << row.headers
        end
      end.uniq.flatten << 'file' << 'model' # add additional headers 'file' and 'model' to be used later

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

    # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength
    def coerce_csv
      csv_path = File.join(importer_unzip_path, COMBINED_CSV_FILENAME)
      filenames = Dir[File.join(importer_unzip_path, COMBINED_FILES_DIRNAME, '*')].map { |path| File.basename(path) }
      updated_rows = []

      CSV.foreach(csv_path, headers: true, return_headers: true) do |row|
        file_entry = filenames.select { |file| file.include?(row['ss_pid'].tr(':', '_')) }.join(',')
        row['file'] = file_entry if file_entry.present?
        if (row['bs_isCommunity'] || row['bs_isCollection'])&.downcase == 'true'
          row['model'] =
            Hyrax.config.collection_model
        end

        updated_rows << row.to_hash
      end
      # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength

      # Ensure the new headers exist in final csv
      # Without this we get `row['file'] => nil` which makes the header disappear later
      updated_rows.first['file'] = 'file'
      updated_rows.first['model'] = 'model'

      CSV.open(csv_path, 'wb') do |csv|
        updated_rows.each do |row|
          csv << row.values
        end
      end
    end

    def clean_up_upacked_files
      Dir.glob(File.join(importer_unzip_path, '*')).each do |file_path|
        next if File.basename(file_path) == COMBINED_CSV_FILENAME || File.basename(file_path) == COMBINED_FILES_DIRNAME

        FileUtils.rm_rf(file_path)
      end
    end
  end
end

Bulkrax::CsvParser.prepend(Bulkrax::CsvParserDecorator)
