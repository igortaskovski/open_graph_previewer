# OpenGraphPreviewer

# Setup

To start the Phoenix server:

  * `git clone`
  * Run `mix setup` to install and setup dependencies
  or
  * `mix deps.get`
  * `mix ecto.setup` or `mix.ecto.create` followed by `mix ecto.migrate`
  * Start Phoenix with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Visit [`localhost:4000`](http://localhost:4000) from your browser.

## Project

In this project I build a Open Graph Previewer.

Open Graph is Facebook's Protocol which is a set of metadata tags that website developers can integrate into their HTML to provide structured information about a webpage's content. It allows developers to define how their content should appear when shared on social media platforms, particularly on Facebook. This protocol helps optimize the presentation of shared links, ensuring that they display accurately and attractively on social media, contributing to a more engaging and informative user experience.

## Implementation

The idea for the implementation is to fetch the HTML from the given URL, use Floki which is a simple HTML parser, then if the data is valid, store it in the database and display it on the same page.

### Logic

I split the main logic into two parts, a Fetcher and a Parser. The idea is to have small, testable and reusable components.

### Fetcher

The code for the Fetcher is located in `lib/open_graph_previewer/fetcher.ex` and the test is in `test/open_graph_previewer/fetcher_test.exs`.
I defined a function called `fetch_html(url)` which is responsible for fetching the HTML content of a given `URL` using the `HTTPoison` library, which is a popular HTTP client for Elixir. The result of the request is pattern-matched and if the request is successful, the function will return `{:ok, body}`, otherwise it will return either `{:error, "Failed to fetch URL. Status code: #{code}"}` or `{:error, "Failed to fetch URL. Reason: #{reason}"}`.

### Parser
The code for the Fetcher is located in `lib/open_graph_previewer/parser.ex` and the test is in `test/open_graph_previewer/parser_test.exs`.
In the Parser, I have two functions, a public facing `build_properties(document)` function and a private function `parse_open_graph_value(document, tag)`. The idea is to make a generic parsing function which I have done with `parse_open_graph_value` and call it passing different tags we need parsed. Floki parses the HTML document, then uses the `find` function to search for the specific tags by dynamically creating a CSS selector from the interpolated string. The output of find is a list of HTML elements that match the specified selector and that is piped into `Enum.map` which takes the element `(&1)` and extracts the value of the `content` attribute from that element.

### LiveView
I created a LiveView for the display layer `lib/open_graph_previewer_web/live/preview_live/index.ex` which mounts the previously built data structure as a `result`, defines a `handle_event` function which is executed on the `process` event when the form is submitted and a private function `process_request(url)` which calls the Fetcher and Parser in a `with` expression and returns a map with the data. The HTML is defined in `lib/open_graph_previewer_web/live/preview_live/index.html.heex`.

## Conclusion
This was a very interesting project and at the same time the first time I heard about the Open Graph protocol. I thoroughly enjoyed working on the project and I am enthusiastic about the possibility of contributing to the team, hopeful for the opportunity to apply my skills in a professional capacity.