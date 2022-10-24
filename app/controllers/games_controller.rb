class GamesController < ApplicationController
    def index
        @answers = []
        @rails_method = Array.public_instance_methods.grep(/[a-z_?]+/).sample.to_s.upcase
    end

    def answer
        Rails.logger.info(params)
        @rails_method = params[:rails_method]
        @answers = params[:answers].split
        @answers << params[:answer].upcase
        respond_to do |format|
            format.turbo_stream { render turbo_stream:
                turbo_stream.replace('answers_grid', partial: 'games/answers_grid')
            }
        end
    end
end
