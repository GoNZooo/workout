defmodule Workout.CLI do
  def main(argv) do
    argv
    |> parse_args
    |> process_args
  end

  def parse_args(argv) do
    options = OptionParser.parse(
      argv,
      switches: [help: :boolean,
                 distance: :float,
                 time: :float,
                 gear: :integer],
      aliases: [h: :help,
                d: :distance,
                t: :time,
                g: :gear]
    )
    options
  end

  def process_args({[help: true], _, _}) do
    IO.puts "workout [--help/-h] --distance/-d D.D --time/-t T.T --gear/-g G=3"
  end

  def process_args({[], [], _}) do
    IO.puts "workout [--help/-h] --distance/-d D.D --time/-t T.T --gear/-g G=3"
  end

  def process_args({[distance: d, time: t, gear: g], ["add"], _}) do
    IO.puts "Adding: distance: #{d}, time: #{t}, gear: #{g}"
  end

  def process_args({[distance: d, time: t], ["add"], _}) do
    g = 3
    IO.puts "Adding: distance: #{d}, time: #{t}, gear: #{g}"
  end

  def process_args({_, ["log"], _}) do
    IO.puts "Outputting log"
  end
end
