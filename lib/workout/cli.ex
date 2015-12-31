defmodule Workout.CLI do
  def main(argv) do
    argv |> parse_args |> process_args
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
    IO.puts "workout [--help/-h] --distance/-d D.D --time/-t T.T --gear/-g G"
  end

  def process_args({[], _, _}) do
    IO.puts "workout [--help/-h] --distance/-d D.D --time/-t T.T --gear/-g G"
  end
end
