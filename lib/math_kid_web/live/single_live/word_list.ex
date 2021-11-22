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
        "Vad gillar du?", "Jag gilllar apelsiner", "Nationalencyklopedi",
        "Min piraya heter Maya, vad heter din?", "En svart katt, i en svart hatt, ute en mörk natt",
        "Min schäfer är två år gammal och heter Wicke. Det är en snäll hund och han är mycket vacker",
        "Jag gillar att lyssna på musik", "Jag gillar att rida", "Jag gillar att läsa", "Jag gillar att rita",
        "Jag gillar att skriva", "- Vad gillar du? sa flickan till sin kompis Eleonora.",
        "- Vilken bok ska jag ta text ifrån? frågade pappan sin dotter"
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
