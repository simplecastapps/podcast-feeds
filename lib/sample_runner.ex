defmodule SampleRunner do
  import ExProf.Macro

  @doc "analyze with profile macro"
  def do_analyze do
    profile do
      PodcastFeeds.parse(File.read!("test/fixtures/rss2/cre.xml"))
      IO.puts "message\n"
    end
  end

  @doc "get analysis records and sum them up"
  def run do
    records = do_analyze
    total_percent = Enum.reduce(records, 0.0, &(&1.percent + &2))
    IO.inspect "total = #{total_percent}"
  end
end