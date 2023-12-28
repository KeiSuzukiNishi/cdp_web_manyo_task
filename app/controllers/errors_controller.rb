class ErrorsController < ApplicationController
    def internal_server_error
      raise StandardError, 'This is a simulated 500 error.'
    end
  end