defmodule PodcastFeeds.Parsers.Helpers do
  use Timex

  def parse_email(string) do
    case string do
      "" -> nil
      nil -> nil
      _ -> String.trim string
    end
  end

  def parse_date(datestring, format \\ "{RFC1123}" )

  def parse_date(datestring, formats) when is_list(formats) do
    formats |> Enum.find_value(nil, fn format ->
      datestring |> parse_date(format)
    end)
  end

  def proper_case(str) do
    case str |> String.split_at(1) do
      {"",_} -> str
      {letter, rest} -> "#{letter |> String.upcase}#{rest}"
    end
  end

  def parse_date(datestring, format) do

    # days should be proper case, but some rss files don't comply with that
    datestring = if format == "{RFC1123}" || String.starts_with?(format, "{WDshort}, ") do
      datestring |> String.split(" ") |> Enum.map(fn x -> x |> proper_case() end) |> Enum.join(" ")
    else
      datestring
    end

    # hour in pubdates on rss.com often has no leading 0
    datestring = if format == "{RFC1123}" && Regex.match?(~r/ [0-9]:[0-9]{2}:[0-9]{2} /, datestring) do
      Regex.replace(~r/ ([0-9]):([0-9]{2}):([0-9]{2}) /, datestring, " 0\\1:\\2:\\3 ")
    else
      datestring
    end

    case datestring |> Timex.parse(format) do
      {:ok, date} -> date
      _ -> nil
    end
  end


  def parse_integer(value) do
    case Integer.parse(value) do
      {value, _} -> value
      :error -> nil
    end
  end

  def strip_nil(val) do
    case val do
      nil -> nil
      "" -> nil
      _ -> case String.trim(val) do
        "" -> nil
        ret -> ret
      end
    end
  end

  def parse_yes_no_boolean(val) do
    case val do
      nil -> false
      val when is_binary(val) ->
        case String.downcase(val) do
          "yes" -> true
          _ -> false
        end
      _ -> false
    end
  end


  # alias PodcastFeeds.Parsers.RSS2.ParserState

  # set the current character content to a struct member
  # def map_character_content(state, struct_member, struct_name) do
  #   %ParserState{element_stack: [elem | element_stack], element_acc: element_acc} = state
  #   case elem.__struct__ do
  #     ^struct_name ->
  #       elem = %{elem | struct_member => element_acc}
  #       %{state | element_stack: [elem | element_stack]}
  #     _ -> state
  #   end
  # end

  # append the current character content to a list of strings
  # def append_character_content_to_list(state, struct_member, struct_name) do
  #   %ParserState{element_stack: [elem | element_stack], element_acc: element_acc} = state
  #   case elem.__struct__ do
  #     ^struct_name ->
  #       elem = %{elem | struct_member => [element_acc | Map.fetch!(elem, struct_member)]}
  #       %{state | element_stack: [elem | element_stack]}
  #     _ -> state
  #   end
  # end

  # map attributes to a ... map. ahem.
  # def map_attributes(state, attributes, struct_member, struct_name) do
  #   %ParserState{element_stack: [elem | element_stack]} = state
  #   case elem.__struct__ do
  #     ^struct_name ->
  #       attribute_map = extract_attributes(attributes)
  #       elem = %{elem | struct_member => attribute_map}
  #       %{state | element_stack: [elem | element_stack]}
  #     _ -> state
  #   end
  # end

  # try to parse the current character map to an integer,
  # set it to nil on failure
  # pass on result via state
  # def parse_character_content_to_integer(state) do
  #   %ParserState{element_acc: element_acc} = state
  #   element_acc = case Integer.parse(element_acc) do
  #     {value, _} -> value
  #     :error -> nil
  #   end
  #   %{state | element_acc: element_acc}
  # end

  # try to parse the current character map to a boolean,
  # set it to false on failure
  # pass on result via state
  # def parse_character_content_to_boolean(state) do
  #   %ParserState{element_acc: element_acc} = state
  #   element_acc = case element_acc do
  #     "yes" -> true
  #     "YES" -> true
  #     "Yes" -> true
  #     _ -> false
  #   end
  #   %{state | element_acc: element_acc}
  # end

  # try to parse the current character acc to a timex date
  # parsing is pretty picky, at the lightest sniff of
  # problems, nil is returned.
  # def parse_character_content_to_date(state) do
  #   %ParserState{element_acc: element_acc} = state
  #   %{state | element_acc: parse_datetime(element_acc)}
  # end

  # parse the value into a date or return nil
  # def parse_datetime(text) do
  #   case text |> DateFormat.parse("{RFC1123}") do
  #     {:ok, date} -> date
  #     _ -> nil
  #   end
  # end

  # get attributes from node and put it into a map
  # def extract_attributes(attributes) do
  #   Enum.reduce attributes, %{}, fn({:attribute, key, _, _, value}, acc) ->
  #     Map.put(acc, List.to_atom(key), to_string(value))
  #   end
  # end

end
