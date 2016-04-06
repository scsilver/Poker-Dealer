require 'pry'
class Player
  attr_accessor :name, :hand

  def initialize(player_name)
    @name = player_name
    @hand = []
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

  def deal(players, num_cards)
    players.each do |player|
      num_cards.times do |i|
        player.hand << @contents.pop
      end
    end
  end


  private

  def generate_deck
    suits = ['Spades','Clubs','Hearts','Diamonds']
    ranks = ['A', 'K', 'Q', 'J', '10', '9', '8', '7', '6', '5', '4', '3', '2']
    suits.each do |suit|
      ranks.each do |rank|
        @contents << Card.new(suit,rank)
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
