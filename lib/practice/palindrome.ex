defmodule Practice.Palindrome do
  def palindrome(x) do
    x == String.reverse(x)
  end
end