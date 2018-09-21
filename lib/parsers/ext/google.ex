defmodule PodcastFeeds.Parsers.Ext.Google do
  import SweetXml

  @namespace "googleplay"

  defmodule Google do
    defstruct owner: nil,
      description: nil,
      category: nil
  end

  # google owner
  defmodule Owner do
    defstruct email: nil
  end

  def do_parse_meta_node(meta, node) do
    email = node
      |> xpath(~x"./#{@namespace}:email/text()")
      |> stringify()

    owner = %Owner{email: email}

    google = %Google{
      owner: owner,
      category: best_match([
        node
          |> xpath(~x"./#{@namespace}:category/text()")
          |> stringify(),
        node
          |> xpath(~x"./#{@namespace}:category[@text]")
          |> elem(7)
          |> hd()
          |> elem(8)
          |> stringify()
      ]),

      description: node
        |> xpath(~x"./#{@namespace}:description/text()")
        |> stringify(),
    }

    Map.put(meta, :google, google)
  end

  defp stringify(nil), do: nil
  defp stringify(list) when is_list(list), do: List.to_string(list)
  defp stringify(string) when is_binary(string), do: string

  defp best_match([]), do: nil
  defp best_match([h | t]) do
    case h do
      nil -> best_match(t)
      val -> val
    end
  end
end