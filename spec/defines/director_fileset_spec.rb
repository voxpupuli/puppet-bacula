# frozen_string_literal: true

require 'spec_helper'

describe 'bacula::director::fileset' do
  let(:title) { 'title' }

  context 'extended options' do
    let(:params) do
      {
        files: [
          '/a',
          '/b'
        ],
        conf_dir: '/etc/bacula',
        director_name: 'director_name',
        options: {
          'a' => 'string',
          'b' => false,
          'c' => %w[an array]
        }
      }
    end

    it { is_expected.to contain_concat__fragment('bacula-fileset-title').with(content: %r{a = string}) }
    it { is_expected.to contain_concat__fragment('bacula-fileset-title').with(content: %r{b = no}) }
    it { is_expected.to contain_concat__fragment('bacula-fileset-title').with(content: %r{c = an}) }
    it { is_expected.to contain_concat__fragment('bacula-fileset-title').with(content: %r{c = array}) }
  end
end
