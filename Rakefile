require 'rake'
require 'rake/testtask'

def exec(cmd)
  success = system(cmd)
  raise "System command execution failed!" unless success
end

import File.expand_path(File.dirname(__FILE__) + "/lib/tasks/git.rake")

task :default => [:spec, :calc]

task :spec do
  exec "spec spec/"
end

task :calc do
  expression = "108 * 95 + 84"
  expected_result = 10344
  result = `./calc "/* test calculator */ #{expression}"`
  raise "calculator error: #{expression} should == #{expected_result}" unless result.to_i == expected_result
end