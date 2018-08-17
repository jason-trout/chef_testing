require 'chefspec'

describe 'cb1::helloworld' do
  let(:chef_run) {
    ChefSpec::SoloRunner.new(
      platform: 'ubuntu', version: '18.04').converge(described_recipe)
  }
  it 'created the file' do
    expect(chef_run).to render_file('/tmp/helloworld.txt').with_content('Hello world!')
  end
end
