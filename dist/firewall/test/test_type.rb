require 'helper'
require 'test/unit'

class FirewallTypeTest < Test::Unit::TestCase
  def test_name
    assert_raise( Puppet::Error ) {Puppet::Type.type(:firewall).new(:chain => "INPUT", :jump => "ACCEPT")}
    assert_nothing_raised( Puppet::Error ) {Puppet::Type.type(:firewall).new(:name => "010-test-ssh", :chain => "INPUT", :jump => "ACCEPT")}
  end

  def test_table
    assert_raise( Puppet::Error ) {Puppet::Type.type(:firewall).new(:name => "010-test-ssh", :table => "mediatemple", :jump => "ACCEPT")}
    %w(nat mangle filter raw).each do |table|
      assert_nothing_raised( Puppet::Error ) {Puppet::Type.type(:firewall).new(:name => "010-test-ssh", :table => table, :jump => "ACCEPT")}
    end
  end

  def test_chain
    assert_raise( Puppet::Error ) {Puppet::Type.type(:firewall).new(:name => "010-test-ssh", :chain => "TEST", :jump => "ACCEPT")}
    assert_nothing_raised( Puppet::Error ) {Puppet::Type.type(:firewall).new(:name => "010-test-ssh", :chain => "INPUT", :jump =>"ACCEPT")}
  end

  def test_jump
    assert_raise( Puppet::Error ) {Puppet::Type.type(:firewall).new(:name => "010-test-ssh", :chain => "INPUT", :jump => "INSERT")}
    assert_nothing_raised( Puppet::Error ) {Puppet::Type.type(:firewall).new(:name => "010-test-ssh", :chain => "INPUT", :jump => "ACCEPT")}
  end
  
  def test_ports
    [:sport, :dport].each do |param|
      assert_raise( Puppet::Error ) {Puppet::Type.type(:firewall).new(:name => "010-test-ssh", :chain => "INPUT", :jump => "ACCEPT", param => 22)}
      %w(tcp udp).each do |proto|
        assert_nothing_raised( Puppet::Error ) {Puppet::Type.type(:firewall).new(:name => "010-test-ssh", :chain => "INPUT", :jump => "ACCEPT", :proto => proto)}
      end
    end
  end

  def test_iniface
    assert_raise( Puppet::Error ) {Puppet::Type.type(:firewall).new(:name => "010-test-ssh", :chain => "OUTPUT", :jump => "ACCEPT", :iniface => "eth0")}
    %w(INPUT FORWARD PREROUTING).each do |chain|
      assert_nothing_raised( Puppet::Error ) {Puppet::Type.type(:firewall).new(:name => "010-test-ssh", :chain => chain, :jump => "ACCEPT", :iniface => "eth0")}
    end
  end

  def test_outiface
    assert_raise( Puppet::Error ) {Puppet::Type.type(:firewall).new(:name => "010-test-ssh", :chain => "INPUT", :jump => "ACCEPT", :outiface => "eth0")}
    %w(OUTPUT FORWARD PREROUTING).each do |chain|
      assert_nothing_raised( Puppet::Error ) {Puppet::Type.type(:firewall).new(:name => "010-test-ssh", :chain => chain, :jump => "ACCEPT", :outiface => "eth0")}
    end
  end

  def test_source_and_dest
    [:tosource, :todest].each do |param|
      assert_raise( Puppet::Error ) {Puppet::Type.type(:firewall).new(:name => "010-test-ssh", :chain => "INPUT", :jump => "ACCEPT", param => "199.44.23.0:24")}
      assert_nothing_raised( Puppet::Error ) {Puppet::Type.type(:firewall).new(:name => "010-test-ssh", :table => "nat", :chain => "POSTROUTING", :jump => "ACCEPT", param => "199.44.23.0:24")}
    end
  end

  def test_toports
    assert_raise( Puppet::Error ) {Puppet::Type.type(:firewall).new(:name => "010-test-ssh", :chain => "INPUT", :jump => "ACCEPT", :toports => [22, 798])}
    %w(POSTROUTING OUTPUT).each do |chain|
      assert_nothing_raised( Puppet::Error ) {Puppet::Type.type(:firewall).new(:name => "010-test-ssh", :table => "nat", :chain => chain, :jump => "ACCEPT", :toports => [22, 798])}
    end
  end
  
  def test_reject
    assert_raise( Puppet::Error ) {Puppet::Type.type(:firewall).new(:name => "010-test-ssh", :chain => "PREROUTING", :jump => "ACCEPT", :reject => "host-unreachable")}
    %w(INPUT FORWARD OUTPUT).each do |chain|
      assert_nothing_raised( Puppet::Error ) {Puppet::Type.type(:firewall).new(:name => "010-test-ssh", :chain => chain, :jump => "ACCEPT", :reject => "host-unreachable")}
    end
  end

  def test_log_prefix
    assert_raise( Puppet::Error ) {Puppet::Type.type(:firewall).new(:name => "010-test-ssh", :chain => "INPUT", :jump => "ACCEPT", :log_prefix => "*** An Insanely Long Log Prefix Made Especially for You. <3 (mt)***")}
    assert_nothing_raised( Puppet::Error ) {Puppet::Type.type(:firewall).new(:name => "010-test-ssh", :chain => "INPUT", :jump => "ACCEPT", :log_prefix => "*** mt_logs ***")}
  end
end
