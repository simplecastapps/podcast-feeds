defmodule PodcastFeeds do

  defmodule Image do
    defstruct title: nil,
              url: nil,
              link: nil,
              width: nil,
              height: nil,
              description: nil
  end

  defmodule Enclosure do
    defstruct url: nil,
              length: nil,
              type: nil
  end

  defmodule Meta do
    defstruct title: nil,
              link: nil,
              description: nil,
              author: nil,
              language: nil,
              copyright: nil,
              publication_date: nil,
              last_build_date: nil,
              generator: nil,
              categories: [],
              cloud: nil,
              ttl: nil,
              managing_editor: nil,
              web_master: nil,
              skip_hours: [],
              skip_days: [],
              image: nil,
              itunes: nil,
              atom_links: []
  end

  defmodule Entry do
    defstruct title: nil,
              link: nil,
              description: nil,
              author: nil,
              categories: [],
              comments: nil,
              enclosure: nil,
              guid: nil,
              publication_date: nil,
              source: nil,
              itunes: nil,
              psc: [],
              atom_links: []
  end

  defmodule Feed do
    defstruct meta: nil, 
              entries: [],
              namespaces: []
  end

  defmodule Itunes do
    defstruct author: nil,
              block: nil,
              category: nil,
              image: nil,
              duration: nil,
              explicit: false,
              is_closed_captioned: false,
              order: nil,
              complete: false,
              new_feed_url: nil,
              owner: nil,              
              subtitle: nil,
              summary: nil
  end

  defmodule Psc do
    defstruct start: nil,
              title: nil,
              href: nil,
              image: nil
  end

  defmodule AtomLink do
    defstruct rel: nil,
              type: nil,
              href: nil,
              title: nil
  end

  defmodule SkipDays do
    defstruct days: []
  end

  defmodule SkipHours do
    defstruct hours: []
  end



  @chunk_size 4096

  def parse_file(filename) do
    File.stream!(filename, [], @chunk_size)
    |> parse_stream
  end

  def parse_stream(stream) do
    stream
    |> PodcastFeeds.Parsers.RSS2.parse
    |> (fn({:ok, state, rest})-> 
      {:ok, state.feed, state.namespaces, rest} 
    end).()
  end

  # defp parse_document({:ok, parser, document}) do
  #   {:ok, parser.parse(document)}
  # end

  # defp parse_document(other), do: other

  # defp detect_parser({:ok, document}) do
  #   cond do
  #     RSS2.valid?(document) -> {:ok, RSS2, document}
  #     Atom.valid?(document) -> {:ok, Atom, document}
  #     true -> {:error, "Feed format not valid"}
  #   end
  # end

  defp detect_parser(other), do: other

end
