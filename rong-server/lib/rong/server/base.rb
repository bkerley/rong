module Rong
  module Server
    class Base
      attr_reader :ball,
                  :board_height,
                  :board_length,
                  :listeners,
                  :paddles,
                  :scores

      def initialize(length, height, state=GameState.new)
        @ball         = Ball.new(state.ball_coords[0], state.ball_coords[1])
        @board_length = length
        @board_height = height
        @paddles      = [Paddle.new(state.paddle1_y), Paddle.new(state.paddle2_y)]
        @scores       = [0, 0]
        @listeners    = []
        @game_state   = state
      end

      def add_listener(listener)
        @listeners << listener
      end

      def current_game_state
        @game_state
      end

      def update_listeners
        listeners.each do |l|
          l.update_game_state(current_game_state)
        end
      end

    end
  end
end
