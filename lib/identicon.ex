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
    |> build_grid
    |> filter_odd_square
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

  @doc """
  Function to pick the first 3 values of the hex list and create the RGB color for the identicon.
  """
  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do
    %Identicon.Image{image | color: {r, g, b}}
  end

  @doc """
  Function to build grid for the identicon. Uses another helper function `mirrow_row`
  """
  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid =
      hex
      |> Enum.chunk_every(3, 3, :discard)
      |> Enum.map(&mirrow_row/1)
      |> List.flatten()
      |> Enum.with_index()

    %Identicon.Image{image | grid: grid}
  end

  @doc """
  Helper Function to mirrow the first and the second values of the row and transport them to the end inversed.
  """
  def mirrow_row(row) do
    [first, second | _tail] = row
    row ++ [second, first]
  end

  @doc """
  Function to filter the odd values on the grid to be coloured in order to give shape to the identicon.
  """
  def filter_odd_square(%Identicon.Image{grid: grid} = image) do
    grid = Enum.filter(grid, fn {code, _index} -> rem(code, 2) == 0 end)

    %Identicon.Image{image | grid: grid}
  end
end
