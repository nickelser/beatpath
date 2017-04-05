require "beatpath/version"
require "beatpath/vote_matrix"

module Beatpath
  class Vote
    attr_reader :pairwise_matrix, :strongest_paths, :winners

    def initialize(ballots, candidates = nil)
      @pairwise_matrix = VoteMatrix.pairwise_from_ballots(ballots, candidates)
      @strongest_paths = @pairwise_matrix.floyd_warshall
      @winners = @strongest_paths.winners
    end
  end
end
