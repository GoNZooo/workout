defmodule Workout.CLI do
  alias Workout.Log

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
                 gear: :integer,
                 verbose: :boolean],
      aliases: [h: :help,
                d: :distance,
                t: :time,
                g: :gear,
                v: :verbose]
    )
    options
  end

  def process_args({[help: true], _, _}) do
    IO.puts "workout [--help/-h] --distance/-d D.D --time/-t T.T --gear/-g G=3"
  end

  def process_args({[], [], _}) do
    IO.puts "workout [--help/-h] --distance/-d D.D --time/-t T.T --gear/-g G=3"
  end

  def process_args({[distance: dist, time: time, gear: gear], ["add"], _}) do
    date = Log.get_date
    Log.append_entry date, time, dist, gear
    IO.puts "Adding: date: #{date} dist: #{dist}, time: #{time}, gear: #{gear}"
  end

  def process_args({[distance: dist, time: time], ["add"], _}) do
    gear = 3
    date = Log.get_date
    Log.append_entry date, time, dist, gear
    IO.puts "Adding: date: #{date} dist: #{dist}, time: #{time}, gear: #{gear}"
  end

  def process_args({_, ["log"], _}) do
    Log.output_log
  end

  def process_args({_, ["sum"], _}) do
    Log.output_log
    Log.sum_fields(:all)
  end
end
