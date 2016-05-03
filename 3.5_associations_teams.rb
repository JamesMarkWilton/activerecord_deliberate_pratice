# Diagram: https://gist.github.com/JoshCheek/e60015c983bbe842cffeb02b75452937
require_relative 'setup'
ActiveRecord::Schema.define do
  self.verbose = false

  # MIGRATIONS
  # <-- your work goes here
end


# MODELS
# <-- your work goes here


# TESTS
class TeamsTest < Minitest::Test
  def test_teams_have_a_name
    assert_equal 'Cubs', Team.new(name: 'Cubs').name
  end

  def test_players_have_a_name
    assert_equal 'Billy Batsalot', Player.new(name: 'Billy Batsalot').name
  end

  def test_players_have_a_batting_average
    assert_equal 60.13, Player.new(batting_average: 60.13).batting_average
  end

  def test_batting_averages_default_to_0
    assert_equal 0, Player.new.batting_average
  end

  def test_fans_have_a_name
    assert_equal 'Lilly', Fan.new(name: 'Lilly').name
  end

  def test_players_belong_to_a_team
    white_socks = Team.new name: 'White Socks'
    cubs        = Team.new name: 'Cubs'
    matt        = Player.new name: 'Matt Albers', team: white_socks
    pedro       = Player.new name: 'Pedro Stromp', team: cubs
    assert_equal white_socks, matt.team
    assert_equal cubs,        pedro.team
  end

  def test_teams_have_many_players
    white_socks = Team.create! name: 'White Socks' do |team|
      team.players.build name: 'Matt Albers'
    end
    cubs = Team.create! name: 'Cubs' do |team|
      team.players.build name: 'Pedro Stromp'
      team.players.build name: 'John Lackey'
    end
    assert_equal ['Matt Albers'],                 white_socks.players.pluck(:name)
    assert_equal ['Pedro Stromp', 'John Lackey'], cubs.players.pluck(:name)
  end


  def test_fans_have_many_teams
    carla = Fan.create! name: 'Carla' do |fan|
      fan.teams.build name: 'Red Socks'
      fan.teams.build name: 'Packers'
    end

    kyle = Fan.create! name: 'Kyle' do |fan|
      fan.teams.build name: 'Blue Socks'
      fan.teams.build name: '49ers'
    end

    assert_equal ['Red Socks', 'Packers'], carla.teams.pluck(:name)
    assert_equal ['Blue Socks', '49ers'],  kyle.teams.pluck(:name)
  end


  def test_teams_have_many_fans
    green = Team.create! name: 'Green Socks' do |team|
      team.fans.build name: 'Albert'
      team.fans.build name: 'Bertrand'
    end
    purple = Team.create! name: 'Purple Socks' do |team|
      team.fans.build name: 'Clarence'
      team.fans.build name: 'Daniel'
    end

    assert_equal ['Albert', 'Bertrand'], green.fans.pluck(:name)
    assert_equal ['Clarence', 'Daniel'], purple.fans.pluck(:name)
  end


  def test_fans_have_many_players
    carla = Fan.create! name: 'Carla' do |fan|
      fan.players.build name: 'Zed'
      fan.players.build name: 'Yanni'
    end

    kyle = Fan.create! name: 'Kyle' do |fan|
      fan.players.build name: 'XXX'
      fan.players.build name: 'Wayne'
    end

    assert_equal ['Zed', 'Yanni'], carla.players.pluck(:name)
    assert_equal ['XXX', 'Wayne'], kyle.players.pluck(:name)
  end


  def test_players_have_many_fans
    harry = Player.create! name: 'Harry "Homerun" Hill' do |team|
      team.fans.build name: 'Anthony'
      team.fans.build name: 'Belle'
    end
    sammy = Player.create! name: 'Sammy Secondbase' do |team|
      team.fans.build name: 'Clyde'
      team.fans.build name: 'Derren'
    end

    assert_equal ['Anthony', 'Belle'], harry.fans.pluck(:name)
    assert_equal ['Clyde', 'Derren'], sammy.fans.pluck(:name)
  end
end
