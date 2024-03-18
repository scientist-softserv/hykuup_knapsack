# frozen_string_literal: true

RSpec.describe Bulkrax do
  describe '.config' do
    subject { described_class.config }

    its(:default_work_type) { is_expected.to be_a(Proc) }
  end

  describe '.default_work_type' do
    subject { described_class.default_work_type&.constantize }

    context 'when it is in a mobius tenant' do
      let(:mobius_site) { create(:site, available_works: MOBIUS_CONCERNS) }

      it do
        allow(Site).to receive(:first).and_return(mobius_site)
        is_expected.to be MobiusWork
      end
    end

    context 'when it is in a non-mobius tenant' do
      let(:other_site) { create(:site, available_works: Hyrax.config.registered_curation_concern_types - MOBIUS_CONCERNS) }

      it do
        allow(Site).to receive(:first).and_return(other_site)
        is_expected.to be GenericWork
      end
    end

    context 'when there is no tenant' do
      it do
        allow(Site).to receive(:first).and_return(nil)
        is_expected.to be_nil
      end
    end
  end
end
