defmodule MathKidWeb.MathHelper do
  def generate_calc(exclude) do
    op = Enum.random(0..1)

    question =
      if op == 1 do
        answer = Enum.random(0..15)
        a = Enum.random(0..answer)
        b = answer - a
        %{a: a, b: b, operator: op}
      else
        answer = Enum.random(0..15)
        a = Enum.random(answer..15)
        b = a - answer
        %{a: a, b: b, operator: op}
      end

    # if calc_answer(question) < 0 or question in exclude do
    if question in exclude do
      generate_calc(exclude)
    else
      question
    end
  end

  def calc_answer(%{a: a, b: b, operator: op}) do
    case op do
      1 ->
        a + b

      0 ->
        a - b

      _ ->
        nil
    end
  end
end
