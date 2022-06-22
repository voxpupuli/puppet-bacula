# frozen_string_literal: true

require 'spec_helper'

describe 'Bacula::Size' do
  context 'valid sizes' do
    [
      4096,
      '1m',
      '10gb',
      '4M'
    ].each do |value|
      context value.inspect do
        it { is_expected.to allow_value(value) }
      end
    end
  end

  context 'invalid sizes' do
    [
      '4096',
      'john',
      '8 hours',
      'o12GB1'
    ].each do |value|
      context value.inspect do
        it { is_expected.not_to allow_value(value) }
      end
    end
  end
end
