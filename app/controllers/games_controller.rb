class GamesController < ApplicationController
    def index
        session[:answers] = []
        session[:rails_method] = random_rails_method.sample.to_s.upcase
        @answers = []
        @rails_method = session[:rails_method]
    end

    def answer
        answer = params[:answer].upcase
        session[:answers] << answer if is_a_valid_answer?(answer)
        respond_to do |format|
            format.turbo_stream {
                render turbo_stream:
                    turbo_stream.replace(
                        'game_turbo_frame',
                        partial: 'games/game',
                        locals: {
                            rails_method: session[:rails_method],
                            answers: session[:answers], 
                        }
                    )
            }
        end
    end

    private

    def is_a_valid_answer?(answer)
        answer.size == session[:rails_method].size && is_existing_method?(answer)
    end

    def is_existing_method?(answer)
        random_rails_method.include?(answer)
    end

    def random_rails_method
        @methods ||= Array.public_instance_methods.grep(/[a-z_?]+/).map { |method| method.to_s.upcase }
    end
end
