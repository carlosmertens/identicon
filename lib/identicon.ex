defmodule Identicon do
  @moduledoc """
  Takes a name and convert it into a identicon image.
  """

  @doc """
    Main function to pipeline the helper functions.


  """
  def main(input) do
    input
    |> hash_input
    |> pick_color
  end

  @doc """
  Function to hash the string provided by users.
  """
  def hash_input(input) do
    hex =
      :crypto.hash(:md5, input)
      |> :binary.bin_to_list()

    %Identicon.Image{hex: hex}
  end

  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do
    %Identicon.Image{image | color: {r, g, b}}
  end
end
