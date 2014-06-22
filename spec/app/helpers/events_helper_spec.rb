require 'spec_helper'

describe "AmazingEvents::App::EventsHelper" do
  let(:helpers){ Class.new }
  before { helpers.extend AmazingEvents::App::EventsHelper }
  subject { helpers }

  it "should return nil" do
    expect(subject.foo).to be_nil
  end
end
