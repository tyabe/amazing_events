require 'spec_helper'

describe "AmazingEvents::App::SessionsHelper" do
  let(:helpers){ Class.new }
  before { helpers.extend AmazingEvents::App::SessionsHelper }
  subject { helpers }

  it "should return nil" do
    expect(subject.foo).to be_nil
  end
end
