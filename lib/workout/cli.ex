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
    f = File.stream!(Application.get_env(:workout, :log_file))
    for line <- f, do: output_line line
  end

  defp output_line("\n"), do: :ok

  defp output_line(line) do
    [date, time, distance, gear] = String.split line, ";"
    IO.puts "#{IO.ANSI.green}#{date}#{IO.ANSI.reset}"
    IO.puts "#{distance} km in #{time} minutes on gear #{gear}"
  end

end
