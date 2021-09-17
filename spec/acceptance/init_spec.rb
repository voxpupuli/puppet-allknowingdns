require 'spec_helper_acceptance'

describe 'allknowingdns class' do
  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'works with no errors' do
      pp = 'include allknowingdns'

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe service('all-knowing-dns') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end

    describe service('all-knowing-dns') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end
  end
end
