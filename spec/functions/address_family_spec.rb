require 'spec_helper'

describe 'address_family' do
  it { is_expected.to run.with_params('f001::').and_return('INET6') }
  it { is_expected.to run.with_params('10.0.0.1').and_return('INET') }
  it { is_expected.to run.with_params('foot').and_return(false) }
end
