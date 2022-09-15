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


  def generate_random_tripplet(fake?) do
    options = [(&(&1 + &2)), (&(&1 - &2))]
    option = :rand.uniform(2) - 1
    a = Enum.random(40..100)
    b = Enum.random(0..50)
    case fake? do
      true ->
        op_random = :rand.uniform(2) - 1
        [a + :rand.uniform(10), b, Enum.at(options, option).(a, b), Enum.at(options, op_random)]
      false ->
        [a, b, Enum.at(options, option).(a, b), Enum.at(options, option)]
    end

  end
  def generate_quad_options() do
    a = generate_random_tripplet(false)
    b = generate_random_tripplet(true)
    c = generate_random_tripplet(true)
    d = generate_random_tripplet(true)
    Enum.shuffle([a, b, c, d])
  end
end
