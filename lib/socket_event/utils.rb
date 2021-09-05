# frozen_string_literal: true

module SocketEvent
  VERSION = "0.1.0"

  module Utils

    def self.build_socket_path(socket_name)
      "/tmp/bgsocket-#{socket_name}.socket"
    end

    def build_socket_path(socket_name)
      "/tmp/bgsocket-#{socket_name}.socket"
    end
  end
end
