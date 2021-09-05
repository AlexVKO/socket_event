# frozen_string_literal: true

require "evt"
require "spec_helper"

RSpec.describe SocketEvent do
  it "has a version number" do
    expect(SocketEvent::VERSION).not_to be nil
  end

  it "spec_name" do
    event_catcher = double("event_catcher")

    Thread.new do
      SocketEvent::Server.rm("testing")

      SocketEvent::Server.start_and_listen("testing") do |line|
        event_catcher.puts(line[:msg])
        "yo"
      end
    end

    sleep 0.1

    n = 6_000

    expect(event_catcher)
      .to receive(:puts).with("yeah").exactly(n).times

    n.times do
      expect(SocketEvent::Client.send_message("testing", { msg: "yeah" }))
        .to eq("yo")
    end

    SocketEvent::Server.rm("testing")
  end
end
