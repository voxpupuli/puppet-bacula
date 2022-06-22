# frozen_string_literal: true

require 'spec_helper'

describe 'bacula::escape' do
  it { is_expected.to run.with_params.and_raise_error(ArgumentError) }
  it { is_expected.to run.with_params(42).and_raise_error(ArgumentError) }
  it { is_expected.to run.with_params(%(ab)).and_return(%("ab")) }
  it { is_expected.to run.with_params(%(a'b)).and_return(%("a'b")) }
  it { is_expected.to run.with_params(%(a"b)).and_return(%("a\\"b")) }
end
