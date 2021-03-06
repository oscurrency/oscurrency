# == Schema Information
#
# Table name: conversations
#
#  id            :integer          not null, primary key
#  talkable_id   :integer
#  talkable_type :string(255)
#  exchange_id   :integer
#

require File.dirname(__FILE__) + '/../spec_helper'

describe Conversation do
  
  before(:each) do
    @conversation = conversations(:one)
  end

  it "should have many messages" do
    @conversation.should respond_to(:messages)
  end
  
  it "should order messages by most recent first" do
    sorted_messages = @conversation.messages.sort_by(&:created_at)
    @conversation.messages.should == sorted_messages
  end
end
