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
  end

  @doc """
  Function to hash the string provided by users.
  """
  def hash_input(input) do
    :crypto.hash(:md5, input)
    |> :binary.bin_to_list()
  end
end
