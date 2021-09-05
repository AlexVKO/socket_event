# frozen_string_literal: true

require_relative "socket_event/version"
require_relative 'socket_event/utils'
require 'evt'
require 'socket'

module SocketEvent
  class Error < StandardError; end
  # Your code goes here...

  class Server
    extend Utils

    attr_reader :server

    def self.rm(socket_name)
      socket_path = build_socket_path(socket_name)
      `rm #{socket_path}`
    end

    def self.start_and_listen(socket_name)

      instance = new(socket_name)

      socket_path = build_socket_path(socket_name)

      @server = UNIXServer.new(socket_path)

      instance.instance_exec do
        log "#start_and_listen #{socket_path}"

        loop do
          begin
            socket = server.accept

            id = rand(36**8).to_s(36)

            data = eval(socket.readline)

            log("Started #{data.inspect}", id: id)

            result = yield(data)

            socket.puts(result) if result

            socket.close

            log("Finished #{result.inspect}", id: id)
          rescue => e
            puts e
          end
        end
      end
    end

    def log(msg, id: nil)
      if id
        puts "[SocketEvent] #{id} | #{msg}"
      else
        puts "[SocketEvent] | #{msg}"
      end
    end

    def initialize(socket_name)
      @socket_name = socket_name
    end
  end

  module Client
    extend Utils

    def self.send_message(socket_name, data)
      socket = UNIXSocket.new(build_socket_path(socket_name))

      socket.puts(data.to_s)

      result = socket.read

      socket.close

      result.chomp if result
    end
  end

  private

end
