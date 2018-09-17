defmodule Practice.Calc do
  def parse_float(text) do
    {num, _} = Float.parse(text)
    num
  end

  def calc(expr) do
    # This should handle +,-,*,/ with order of operations,
    # but doesn't need to handle parens.
    expr
    |> String.split(" ")
    |> tag_tokens
    |> convert_to_postfix
    |> evaluate([])
    |> elem(1)
  end

  defp tag_tokens(split_expr) do
    # Tags each token based on which type it is and returns that tagged list
    tagged = for token <- split_expr do
      cond do
        token === "+" ->
          {:op, 1, "+"}
        token === "-" ->
          {:op, 1, "-"}
        token === "*" ->
          {:op, 2, "*"}
        token === "/" ->
          {:op, 2, "/"}
        true ->
          {:num, token}
      end
    end
    tagged
  end

  defp convert_to_postfix(tokens), do: convert_to_postfix(tokens, [])

  defp convert_to_postfix(tokens, stack) do
    case {tokens, stack} do
      {[], stack} -> stack
      {[{:num, _} | rest_num], stack} -> [hd tokens] ++ convert_to_postfix(rest_num, stack)
      {[{:op, precedence, _} | rest_op], stack} ->
        cond do
          stack == [] ->
            convert_to_postfix(rest_op, [hd tokens] ++ stack)
          precedence >= hd stack ->
            convert_to_postfix(rest_op, [hd tokens] ++ stack)
          true ->
            popped = hd stack
            stack = tl stack
            [popped] ++ convert_to_postfix(tokens, stack)
        end
    end
  end

  defp evaluate(tokens, stack) do
    case {tokens, stack} do
      {[], stack} -> hd stack
      {[{:num, _} | rest_num], stack} -> evaluate(rest_num, [hd tokens] ++ stack)
      {[{:op, _, op} | rest_op], stack} ->
        first_pop = hd stack
        stack = tl stack
        second_pop = hd stack
        stack = tl stack
        num1 = elem(second_pop, 1)
        num2 = elem(first_pop, 1)
        evaluate(rest_op, [{:num, Integer.to_string(do_math(op, String.to_integer(num1), String.to_integer(num2)))}] ++ stack)
    end
  end

  defp do_math(op, a, b) do
    case op do
      "+" -> a + b
      "-" -> a - b
      "*" -> a * b
      "/" -> Kernel.trunc(a / b)
    end
  end
end
