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
    # Hint:
    # expr
    # |> split
    # |> tag_tokens  (e.g. [+, 1] => [{:op, "+"}, {:num, 1.0}]
    # |> convert to postfix
    # |> reverse to prefix
    # |> evaluate as a stack calculator using pattern matching
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
            convert_to_postfix(rest_op, hd tokens ++ stack)
          precedence >= hd stack ->
            convert_to_postfix(rest_op, hd tokens ++ stack)
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
      {[{:op, _, op} | rest_op], [f, s, rest_stack]} ->
        math = do_math(op, String.to_integer(s), String.to_integer(f))
        evaluate(rest_op, [math] ++ stack)
    end
  end

  defp do_math(op, a, b) do
    case op do
      "+" -> a + b
      "-" -> a - b
      "*" -> a * b
      "/" -> a / b
    end
  end
end
