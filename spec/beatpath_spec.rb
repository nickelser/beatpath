require "spec_helper"

describe Beatpath do
  it "has a version number" do
    expect(Beatpath::VERSION).not_to be nil
  end

  describe "wikipedia sample ballot" do
    # from wikipedia (https://en.wikipedia.org/wiki/Schulze_method)
    # all the matrixes and the final ranking are directly from the Wikipedia page as of 2017-04-05
    let(:ballotA) do
      [[1, 3, 2, 5, 4]] * 5 +
        [[1, 4, 5, 3, 2]] * 5 +
        [[2, 5, 4, 1, 3]] * 8 +
        [[3, 1, 2, 5, 4]] * 3 +
        [[3, 1, 5, 2, 4]] * 7 +
        [[3, 2, 1, 4, 5]] * 2 +
        [[4, 3, 5, 2, 1]] * 7 +
        [[5, 2, 1, 4, 3]] * 8
    end

    it "computes pairwise preferences" do
      expect(Beatpath::VoteMatrix.pairwise_from_ballots(ballotA)).to eq(
        Matrix[[0, 20, 26, 30, 22],
               [25, 0, 16, 33, 18],
               [19, 29, 0, 17, 24],
               [15, 12, 28, 0, 14],
               [23, 27, 21, 31, 0]]
      )
    end

    it "computes the strongest paths" do
      expect(Beatpath::VoteMatrix.pairwise_from_ballots(ballotA).floyd_warshall).to eq(
        Matrix[[0, 28, 28, 30, 24],
               [25, 0, 28, 33, 24],
               [25, 29, 0, 29, 24],
               [25, 28, 28, 0, 24],
               [25, 28, 28, 31, 0]]
      )
    end

    it "calculates the winners" do
      expect(Beatpath::VoteMatrix.pairwise_from_ballots(ballotA).floyd_warshall.winners).to eq(
        [5, 1, 3, 2, 4] # E > A > C > B > D
      )
    end
  end
end
