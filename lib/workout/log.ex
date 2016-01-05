defmodule Workout.Log do
  defp pad(x) when is_integer(x) and x < 10 do
    String.rjust Integer.to_string(x), 2, ?0
  end

  defp pad(x), do: x

  defp calculate_average_speed(distance, time, precision \\ 2) do
    Float.round(distance / (time / 60), precision)
  end

  defp calculate_score(average_speed, time, precision \\ 2) do
    score = (:math.log2(average_speed) + :math.log2(1/10)) * time
    Float.round(score, precision)
  end

  defp output_line("\n"), do: :ok

  defp output_line(line) do
    [date, time, distance, gear] = String.split(String.rstrip(line), ";")
    time = parse(:float, time)
    distance = parse(:float, distance)
    average_speed = calculate_average_speed(distance, time)
    score = calculate_score(average_speed, time)

    IO.write "#{IO.ANSI.green}#{date}#{IO.ANSI.reset}: "
    IO.write "#{distance} km in #{time} minutes on gear #{gear} "
    IO.puts "(~#{average_speed} km/h, score: #{score})"
  end

  def append_entry(date, time, distance, gear) do
    output = Enum.join([date, time, distance, gear], ";") <> "\n"
    File.write! Application.get_env(:workout, :log_file), output, [:append]
  end

  def get_date do
    {{year, month, day}, {hour, minute, _}} = :calendar.local_time
    "#{year}-#{pad(month)}-#{pad(day)} #{pad(hour)}:#{pad(minute)}"
  end

  def output_log do
    f = File.stream!(Application.get_env(:workout, :log_file))
    for line <- f, do: output_line line
  end

  defp parse(:float, t) do
    {parsed_float, ""} = Float.parse(t)
    parsed_float
  end

  def sum_file(file) do
    file
    |> Stream.map(&(String.split(&1, ";")))
    |> Stream.map(fn [_, t, d, _] -> {parse(:float, t), parse(:float, d)} end)
    |> Enum.reduce({0, 0, 0},
      fn {t, d}, {tacc, dacc, nacc} ->
        {t+tacc, d+dacc, nacc + 1}
      end)
  end

  def sum_fields(:all) do
    f = File.stream!(Application.get_env(:workout, :log_file))
    {total_time, total_distance, entries} = sum_file(f)
    average_speed = calculate_average_speed(total_distance, total_time)
    average_score = Float.round(calculate_score(average_speed, total_time) / entries, 2)

    IO.puts ""
    IO.puts("#{IO.ANSI.magenta}Total time: #{total_time} minutes")
    IO.puts("Total distance: #{total_distance} km")
    IO.puts("Average speed: #{average_speed} km/h")
    IO.puts("Average score: #{average_score}")
  end
end
