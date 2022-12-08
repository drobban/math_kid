defmodule MathKidWeb.MultiplesHelper do
  def generate_calc() do
    # op = Enum.random(0..1)
    op = 0

    a = Enum.random(0..5)
    b = Enum.random(0..5)

    question = %{a: a, b: b, operator: op}

    question
  end

  def calc_answer(%{a: a, b: b, operator: op}) do
    case op do
      0 ->
        a * b
      _ ->
        nil
    end
  end

  def generate_random_tripplet(fake?) do
    options = [&(&1 * &2)]
    option = 0
    a = Enum.random(0..10)
    b = Enum.random(0..10)

    case fake? do
      true ->
        [a + :rand.uniform(10), b, Enum.at(options, option).(a, b), Enum.at(options, option)]

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
