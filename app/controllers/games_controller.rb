class GamesController < ApplicationController
    def index
        session[:answers] = []
        if params[:infinite_mode]
            session[:rails_method] = random_rails_method.sample
        else
            session[:rails_method] = random_rails_method.sample(1, random: Random.new((Date.current - Date.new(2018,04,23)).days.to_i)).first
        end
        session[:game_won] = false
        @rails_method = session[:rails_method]
        @colors = Array.new(6) { Array.new(@rails_method.size) { nil } }
        @alphabet = init_alphabet
        @same_length_methods_list = nil
        @all_methods_list = nil
        @methods_list = same_length_methods_list
    end

    def infinite
        redirect_to controller: 'games', action: :index, infinite_mode: true
    end

    def give_up
        send_stream(gave_up: true)
    end

    def answer
        answer = params[:game][:answer].upcase
        if is_a_valid_answer?(answer)
            session[:answers] << answer
            session[:game_won] = answer == session[:rails_method]
        end
        send_stream(is_a_valid_answer: is_a_valid_answer?(answer))
    end

    private

    def send_stream(args)
        colors, alphabet = compute_colors(session[:rails_method], session[:answers]) 
        respond_to do |format|
            format.turbo_stream {
                render turbo_stream:
                    turbo_stream.replace(
                        'game_turbo_frame',
                        partial: 'games/game',
                        locals: {
                            rails_method: session[:rails_method],
                            answers: session[:answers],
                            game_won: session[:game_won],
                            is_valid_answer: args[:is_a_valid_answer],
                            gave_up: args[:gave_up],
                            rails_method_doc: MethodsHelper.get_doc(session[:rails_method].downcase),
                            colors: colors,
                            alphabet: alphabet,
                            methods_list: same_length_methods_list
                        }
                    )
            }
        end
    end

    def compute_colors(rails_method, answers)
        colors = Array.new(6) { Array.new(rails_method.size) { nil } }
        alphabet = init_alphabet
        answers.each_with_index do |answer, answer_index|
            remaining_chars = []
            answer.chars.each_with_index do |char, char_index|
                if char == rails_method[char_index]
                    colors[answer_index][char_index] = 'green'
                    alphabet[char] = 'green-400'
                else
                    remaining_chars << rails_method[char_index]
                end
            end
            answer.chars.each_with_index do |char, char_index|
                if colors[answer_index][char_index].nil? && remaining_chars.include?(char)
                    colors[answer_index][char_index] = 'orange' 
                    alphabet[char] = 'orange-400'
                    remaining_chars.delete_at(remaining_chars.index(char) || remaining_chars.length)
                elsif alphabet[char] == 'slate-100'
                    alphabet[char] = 'slate-400'
                end
            end

        end
        [colors, alphabet]
    end

    def is_a_valid_answer?(answer)
        answer.size == session[:rails_method].size && is_existing_method?(answer)
    end

    def is_existing_method?(answer)
        random_rails_method.include?(answer)
    end

    def same_length_methods_list
        @same_length_methods_list ||= random_rails_method.uniq.filter {|method_name| method_name.size == session[:rails_method].size}
    end

    def random_rails_method
        @all_methods_list ||= MethodsHelper.filtered_methods
                                  .map { |method_name| method_name.to_s.upcase }
                                  .sort_by {|method_name| [method_name.size, method_name] }
    end

    def init_alphabet
        (('A'..'Z').to_a + ['?', '_', '!']).map { |char| [char, 'slate-100'] }.to_h
    end
end