defmodule Practice.Factor do
  def factor(x) do
    if x == 1 do
      []
    else
      factor = factor_divide(x, 2)
      factors = [factor]
      factors = factors ++ factor(div(x, factor))
      factors
    end
  end

  defp factor_divide(x, div_num) do
    if rem(x, div_num) == 0 do
      div_num
    else
      factor_divide(x, div_num + 1)
    end
  end
end