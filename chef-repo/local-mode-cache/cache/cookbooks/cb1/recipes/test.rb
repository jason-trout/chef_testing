ruby_block "do_it" do
  block do
    Chef::Config.from_file("/tmp/block.rb")
  end
  action:run
end
