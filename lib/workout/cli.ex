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

  def process_args({[distance: dist, time: time, gear: gear], ["add"], _}) do
    date = get_date
    append_entry date, time, dist, gear
    IO.puts "Adding: date: #{date} dist: #{dist}, time: #{time}, gear: #{gear}"
  end

  def process_args({[distance: dist, time: time], ["add"], _}) do
    gear = 3
    date = get_date
    append_entry date, time, dist, gear
    IO.puts "Adding: date: #{date} dist: #{dist}, time: #{time}, gear: #{gear}"
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

  defp append_entry(date, time, distance, gear) do
    output_line = Enum.join [date, time, distance, gear], ";"
    File.write! Application.get_env(:workout, :log_file), output_line, [:append]
  end

  defp get_date do
    {{year, month, day}, {hour, minute, _}} = :calendar.local_time
    "#{year}-#{month}-#{day} #{hour}:#{minute}"
  end
end
