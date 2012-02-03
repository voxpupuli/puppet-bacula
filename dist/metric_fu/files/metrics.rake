begin
    require 'metric_fu'
    require 'zaml'

    class MetricFu::Report
      def to_yaml ## monkeypatch to use ZAML instead of YAML, which is hideously slow
       ZAML.dump(report_hash)
      end
    end

    MetricFu::Configuration.run do |config|
        config.rcov[:rcov_opts] << "-Ispec" # Needed to find spec_helper
        config.flay = { :dirs_to_flay => ['lib'] } # Does nothing otherwise
    end
# rescue LoadError ## commented because it is better to fail if this happens
    # Metric-fu not installed
    # http://metric-fu.rubyforge.org/
end
