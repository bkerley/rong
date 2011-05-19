require 'rong/elements/ball'
require 'rong/elements/paddle'
require 'rong/elements/window_constants'

module Rong
  module Elements
    class Game
      include WindowConstants
      WINNING_SCORE = 12

      attr_accessor :paddles, :ball, :winner,
        :left_score, :right_score,
        :score_callbacks,  :hit_callbacks,
        :bounce_callbacks, :win_callbacks

      def initialize
        self.left_score = self.right_score = 0

        self.score_callbacks  = []
        self.hit_callbacks    = []
        self.bounce_callbacks = []
        self.win_callbacks    = []

        self.ball    = Ball.new(WINDOW_CENTER_X, WINDOW_CENTER_Y, 0)
        self.paddles = [Paddle.new("Right Player", LEFT_PADDLE_X,  PADDLE_Y),
          Paddle.new("Left Player", RIGHT_PADDLE_X, PADDLE_Y)]
      end

      def update
        return if winner
        ball.move
        paddles.each {|p| check_bounds(p) }
        check_ball_bounds
        check_win_condition
        paddles.each do |paddle|
          if paddle.intersects?(ball)
            paddle.hit(ball)
            hit
          end
        end
      end

      def reset
        self.winner     = nil
        self.left_score = self.right_score = 0
        reset_paddles
        ball.serve_from(SERVE_FROM_X, SERVE_FROM_Y)
      end

      def on_score(&block)
        score_callbacks << block if block_given?
      end

      def score
        score_callbacks.each {|cb| cb.call(left_score, right_score) }
      end

      def on_hit(&block)
        hit_callbacks << block if block_given?
      end

      def hit
        hit_callbacks.each {|cb| cb.call }
      end

      def on_bounce(&block)
        bounce_callbacks << block if block_given?
      end

      def bounce
        bounce_callbacks.each {|cb| cb.call }
      end

      def on_win(&block)
        win_callbacks << block if block_given?
      end

      def reset_paddles
        paddles.first.move_to(LEFT_PADDLE_X,  PADDLE_Y)
        paddles.last.move_to(RIGHT_PADDLE_X,  PADDLE_Y)
      end

      def declare_winner(who)
        ball.move_to(WINDOW_CENTER_X, WINDOW_CENTER_Y)
        ball.stop
        self.winner = who
        win_callbacks.each {|cb| cb.call(who) }
      end

      def check_bounds(entity)
        if entity.top < 0
          entity.move_to(entity.x, 0 + entity.height / 2)
        end
        if entity.bottom > WINDOW_HEIGHT
          entity.move_to(entity.x, WINDOW_HEIGHT - entity.height / 2)
        end
      end

      def check_ball_bounds
        if ball.top < 0 || ball.bottom > WINDOW_HEIGHT
          bounce
          ball.reflect_y
        end

        if ball.left < 0 || ball.right > WINDOW_WIDTH
          if ball.left < 0
            self.left_score += 1
            ball.serve_right_from(SERVE_FROM_X, SERVE_FROM_Y)
          else
            self.right_score += 1
            ball.serve_left_from(SERVE_FROM_X, SERVE_FROM_Y)
          end
          score
          reset_paddles
        end
      end

      def check_win_condition
        if left_score >= WINNING_SCORE
          declare_winner(paddles.first)
        elsif right_score >= WINNING_SCORE
          declare_winner(paddles.last)
        end
      end
    end
  end
end
