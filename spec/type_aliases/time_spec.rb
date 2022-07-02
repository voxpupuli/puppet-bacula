# frozen_string_literal: true

require 'spec_helper'

describe 'Bacula::Time' do
  context 'valid times' do
    [
      '3600',
      '30 seconds',
      '10 minutes',
      '8 hours',
      '2 days',
      '4 months',
      '2 quarters',
      '5 years',
      '1 month 2 days 30 sec',
      '1 week 2 days 3 hours 10 mins'
    ].each do |value|
      context value.inspect do
        it { is_expected.to allow_value(value) }
      end
    end
  end

  context 'invalid times' do
    [
      'john',
      '8hours',
      '1 month2 hours'
    ].each do |value|
      context value.inspect do
        it { is_expected.not_to allow_value(value) }
      end
    end
  end
end
