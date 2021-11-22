defmodule MathKidWeb.SingleLive.WordList do
  defmodule Vocabulary do
    defstruct [
      words: [
        "Hej där", "Jag", "Jag heter", "Vem där?", "Vad heter du?",
        "Jag bor i Umeå", "Min farmor bor i Blekinge", "Min mormor bor i Umeå",
        "Har du en hund?", "Jag har fyra hundar", "Min bil är blå", "Kvantum",
        "Fysik", "Raket", "Bränsle", "Yxa", "Raketbränsle", "Bil", "Bilbränsle",
        "Min bil går på bensin", "Tant Agda är 80 år", "Kyrkan ligger i Kyrkhult",
        "Småland är ett landskap", "Blekinge är ett landskap", "Kvantfysik",
        "Vad gillar du?", "Jag gilllar apelsiner", "Nationalencyklopedi"
      ]
    ]
  end


  def get_word(el) do
    Enum.at(%Vocabulary{}.words, el)
  end

  def get_count() do
    Enum.count(%Vocabulary{}.words)
  end
end
