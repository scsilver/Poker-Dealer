require 'pry'
class Player
  attr_accessor :name, :hand

  @position = 0
    class << self
      attr_accessor :position
    end

  def initialize(player_name)
    @name = player_name
    @hand = []
    self.class.position += 1
  end

end

class Deck
  attr_accessor :contents

  def initialize(deck_count)
    @contents = []
    generate_deck
    multiply_decks(deck_count)
    shuffle
  end

  def shuffle
    @contents.shuffle!
  end

  def deal_hands(players, num_cards)
    players.each do |player|
      num_cards.times do |i|
        player.hand << @contents.pop
      end
    end
  end

  def deal_community(game)
    game.community_cards << @contents.pop
  end

  private

  def generate_deck
    suits = ['Spades','Clubs','Hearts','Diamonds']
    ranks = ['A', 'K', 'Q', 'J', '10', '9', '8', '7', '6', '5', '4', '3', '2']
    suits.each do |suit|
      ranks.each do |rank|
        @contents << Card.new(suit, rank)
      end
    end
  end

  def multiply_decks(deck_count)
    (deck_count-1).times do |i|
      @contents.concat(@contents)
    end
  end

end

class Card
  attr_accessor :suit, :rank, :name, :color

  def initialize(suit,rank)
    @suit = suit
    @rank = rank
    @name = "#{rank} of #{suit}"
    set_color
  end

  private

  def set_color
    case @suit
    when "Spades", "Clubs"
      @color = "Black"
    when "Diamonds", "Hearts"
      @color = "Red"
    end
  end

end

class Game
  attr_accessor :game, :players, :community_cards

  def initialize(game, players)
    @game = game
    @players = players
    set_up(@game)
    @num_pocket_cards = 0
    @num_communitiy_cards = 0
    @community_cards = []
  end

  private

  def set_up(game)
    case game
    when "hold em"
      @num_pocket_cards = 2
      @num_communitiy_cards = 5
      @deck = Deck.new(1)
      @deck.deal(@players, @num_pocket_cards)
      @community_draw_pattern = [3, 1, 1]
      Bet.set_up(game,10,5)
    when "standard"
      @num_pocket_cards = 5
      @num_communitiy_cards = 0
      @deck = Deck.new(1)
      @deck.deal(@players, @num_pocket_cards)
      @community_draw_pattern = nil
    end
  end

  def next_round
    @round = Round.new(@round+1)
  end

end
class Round
  def initialize(number)
    @number = number
    @bets = []
  end

  def bet
     game.players.each do |player|
       @bets << Bet.new(player, amount).ante
     end
  end

end

class Bet
  def self.game_type(game)
    @@game
  end
  def self.big_blind(amount)
    @@big_blind
  end

  def self.small_blind(amount)
    @@small_blind
  end

  def self.setup(game, big_amount, small_amount)
    self.game_type(game)
    self.big_blind(big_amount)
    self.small_blind(small_amount)
  end

  def initialize(player, amount)
    @player = player
    @amount = amount
  end

  def ante
    case @@game
    when "hold em"
      case @player.postion
      when 1
        @amount < @big_blind ? @big_blind : @amount #sets minimum of big blind
      when 2
        @amount < @small_blind ? @small_blind : @amount #sets minimum of small blind
      end
    when "standard"
    end
  end
end


def run
  print "Enter # of Players: "
  num_players = gets.to_i
  print "Enter # of Cards per Hand: "
  num_cards = gets.to_i
  players = []
  num_players.times do |i|
    print "Enter Player #{i+1}'s Name: "
    name = gets
    players << Player.new(name)
  end

  deck = Deck.new(1)
  deck.deal(players, num_cards)

  players.each do |player|
    print "Name: #{player.name}"
    puts "Hand.............. "
    player.hand.each do |card|
      puts "#{card.name} "
    end
  end
end
run
