require 'spec_helper'

describe "AmazingEvents::App::TicketsHelper" do
  let(:helpers){ Class.new }
  before { helpers.extend AmazingEvents::App::TicketsHelper }
  subject { helpers }

  it "should return nil" do
    expect(subject.foo).to be_nil
  end
end
