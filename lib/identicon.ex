defmodule Identicon do
  @moduledoc """
  Takes a name and convert it into a identicon image.

  The image would be 250px x 250px. Inside the image we have 25 squares of 50px.

  The Identicon should be unique to the string provided. In other words, if we provide carlos as many time as we want, the identicon should be the same but diferent for a diferent name.
  """

  @doc """
    Main function to pipeline functions in order to build the identicon.
  """
  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_square
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
  end

  @doc """
  Function to hash the string provided by users that eventually will become an identicon.
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

  @doc """
  Function to map the grid and get the pixel coordinates of the squares in the grid.
  """
  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map =
      Enum.map(grid, fn {_code, index} ->
        horizontal = rem(index, 5) * 50
        vertical = div(index, 5) * 50

        top_left = {horizontal, vertical}
        bottom_right = {horizontal + 50, vertical + 50}

        {top_left, bottom_right}
      end)

    %Identicon.Image{image | pixel_map: pixel_map}
  end

  @doc """
  Function to draw the image.
  """
  def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}) do
    image = :egd.create(250, 250)
    fill = :egd.color(color)

    Enum.each(pixel_map, fn {start, stop} ->
      :egd.filledRectangle(image, start, stop, fill)
    end)

    :egd.render(image)
  end

  @doc """
  Function to save image.
  """
  def save_image(image, input) do
    File.write("#{input}.png", image)
  end
end
