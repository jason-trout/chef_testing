ruby_block "do_it" do
  block do
    chef::Config.from_file("~/block.rb")
  end
  action:run
end
