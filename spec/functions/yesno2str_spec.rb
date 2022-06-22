# frozen_string_literal: true

require 'spec_helper'

describe 'bacula::yesno2str' do
  it { is_expected.to run.with_params.and_raise_error(ArgumentError) }
  it { is_expected.to run.with_params(42).and_raise_error(ArgumentError) }
  it { is_expected.to run.with_params('Moin').and_raise_error(ArgumentError) }
  it { is_expected.to run.with_params(true).and_return('yes') }
  it { is_expected.to run.with_params('yes').and_return('yes') }
  it { is_expected.to run.with_params('true').and_return('yes') }
  it { is_expected.to run.with_params(false).and_return('no') }
  it { is_expected.to run.with_params('no').and_return('no') }
  it { is_expected.to run.with_params('false').and_return('no') }
end
