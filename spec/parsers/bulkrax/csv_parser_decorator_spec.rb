# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
RSpec.describe Bulkrax::CsvParserDecorator, type: :decorator do
  let(:csv_parser) { Bulkrax::CsvParser.new('double') }
  let(:account) { create(:account, name: Account::MOBIUS_TENANTS.first) }
  let(:file_to_unzip) { HykuKnapsack::Engine.root.join(File.join('spec', 'fixtures', 'test.tar.gz')).to_s }
  let(:importer_unzip_path) { HykuKnapsack::Engine.root.join('spec', 'fixtures', 'importer_unzip_path').to_s }

  before do
    clean_up
    allow(csv_parser).to receive(:importer_unzip_path).and_return(importer_unzip_path)
  end

  after { clean_up }

  describe '#unzip' do
    context 'when on a MOBIUS tenant' do
      let(:account) { create(:account, name: Account::MOBIUS_TENANTS.first) }

      before do
        allow(Account).to receive(:find_by).and_return(account)
        csv_parser.unzip(file_to_unzip)
      end

      it 'unpacks a tar.gz file' do
        expect(Dir.exist?(importer_unzip_path)).to be true
      end

      it 'creates the correct number of directories' do
        expect(Dir.glob(File.join(importer_unzip_path, '*')).count).to eq(2)
      end

      it 'creates the correct number of files' do
        expect(Dir.glob(File.join(importer_unzip_path, 'files', '*')).count).to eq(6)
      end
    end

    context 'when not on a MOBIUS tenant' do
      let(:account) { create(:account, name: 'no-mob') }

      before do
        allow(Account).to receive(:find_by).and_return(account)
        allow(csv_parser).to receive(:coerce_unpacked_files!)
      end

      it 'does not call coerce_unpacked_files!' do
        csv_parser.unzip(file_to_unzip)
        expect(csv_parser).not_to have_received(:coerce_unpacked_files!)
      end
    end
  end

  def clean_up
    FileUtils.rm_rf(importer_unzip_path) if Dir.exist?(importer_unzip_path)
  end
end
# rubocop:enable Metrics/BlockLength
