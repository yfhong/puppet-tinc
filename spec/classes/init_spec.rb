require 'spec_helper'
describe 'tinc' do

  context 'with defaults for all parameters' do
    it { should contain_class('tinc') }
  end
end
