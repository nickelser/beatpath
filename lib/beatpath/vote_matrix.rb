require "matrix"
require "set"

module Beatpath
  class VoteMatrix < ::Matrix
    public :"[]=", :set_element, :set_component
    attr_accessor :vote_candidates

    def self.zero_with_candidates(candidates = [])
      zeroed = zero(candidates.size)
      zeroed.vote_candidates = candidates
      zeroed
    end

    def self.pairwise_from_ballots(ballots, candidates = nil)
      if candidates.nil?
        candidates = SortedSet.new

        # compute distinct candidates
        ballots.each do |b|
          candidates += b
        end

        candidates = candidates.to_a
      end

      d = zero_with_candidates(candidates)

      # compute pairwise rankings from all ballots
      ballots.each do |b|
        # for each ballot, compute which candidates were not voted on
        unvoted_candidates = candidates - b

        # for each candidate on the given ballot
        b.each_with_index do |c1, idx|
          # compute our internal mapping of the candidate
          c1_idx = candidates.find_index(c1)

          # for each candidate, c2, that follows this candidate in order of preference,
          # mark c1 as pairwise better than c2
          b[(idx + 1)..-1].each do |c2|
            d[c1_idx, candidates.find_index(c2)] += 1
          end

          # candidates not mentioned on this ballot are always strictly worse
          # than the candidates on the ballot (c1)
          unvoted_candidates.each do |c2|
            d[c1_idx, candidates.find_index(c2)] += 1
          end
        end
      end

      d
    end

    # https://en.wikipedia.org/wiki/Schulze_method
    # Input: self[i,j], the number of voters who prefer candidate i to candidate j.
    # Output: p[i,j], the strength of the strongest path from candidate i to candidate j.
    def floyd_warshall
      p = VoteMatrix.zero_with_candidates(vote_candidates)

      # for i from 1 to C
      #    for j from 1 to C
      #       if (i ≠ j) then
      #          if (d[i,j] > d[j,i]) then
      #             p[i,j] := d[i,j]
      #          else
      #             p[i,j] := 0
      row_count.times do |i|
        row_count.times do |j|
          next if i == j

          if self[i, j] > self[j, i]
            p[i, j] = self[i, j]
          else
            p[i, j] = 0
          end
        end
      end

      # for i from 1 to C
      #    for j from 1 to C
      #       if (i ≠ j) then
      #          for k from 1 to C
      #             if (i ≠ k and j ≠ k) then
      #                p[j,k] := max ( p[j,k], min ( p[j,i], p[i,k] )
      row_count.times do |i|
        row_count.times do |j|
          next if i == j

          row_count.times do |k|
            next if i == k || j == k

            p[j, k] = [p[j, k], [p[j, i], p[i, k]].min].max
          end
        end
      end

      p
    end

    def winners
      results = VoteMatrix.zero_with_candidates(vote_candidates)

      # compute which candidate has the strongest path
      row_count.times do |i|
        row_count.times do |j|
          next if i == j

          # candidate i is strictly better than j if the strongest path goes through i
          results[i, j] += 1 if self[i, j] > self[j, i]
        end
      end

      # and finally compute the final ordering of the candidates
      results = Hash[results.row_vectors.each_with_index.map do |r, i|
        [vote_candidates[i], r.inject(:+)]
      end]

      results.sort_by { |_, v| v }.map(&:first).reverse
    end
  end
end
