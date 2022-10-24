class GameController < ApplicationController
    def index
        @rails_method = Array.public_instance_methods.grep(/[a-z_?]+/).sample.to_s
    end
end
