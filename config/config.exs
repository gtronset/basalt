use Mix.Config

if Mix.env() == :test do
  config :junit_formatter,
    report_dir: "/tmp/basalt-test-results/exunit"
end
