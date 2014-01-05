module Astro

  class NameGenerator
  SYLLABLES = [ "Ad", "Al", "Alm", "Am", "An", "Ant", "Arb", "Arc", "As",
                "Bak", "Ban", "Bar", "Bel", "Bes", "Bil", "Bin", "Bon", "Bril",
                "Bur", "Cer", "Cm", "Com", "Cor", "Cron", "Dag", "Dan", "Dar",
                "Dur", "Dur", "En", "End", "Er", "Fed", "Fir", "Gal", "Gam",
                "Gan", "Gess", "Gli", "Glo", "Goh", "Gui", "Han", "Hil", "Hon",
                "Is", "Ith", "Jak", "Jon", "Jum", "Kal", "Kar", "Karn", "Kes",
                "Kom", "Kur", "Lan", "Les", "Lid", "Lor", "Lus", "Mel", "Met",
                "Mim", "Myr", "Nab", "Nag", "Nal", "Nat", "Nik", "Nub", "Om",
                "Ond", "Phin", "Pin", "Quel", "Rax", "Rer", "Rif", "Rin",
                "Ris", "Rish", "Ron", "Rur", "Rut", "Ryl", "Sav", "Sel", "Sen",
                "Sern", "Sui", "Sum", "Tlo", "Tal", "Tan", "Tel", "Tis", "Top",
                "Tros", "Um", "Val", "Var", "Wat", "Wer", "Yin", "Zel", "Zoc",
                "Zun"
  ]

  PREFIXES = ["Nar", "Ord", "Ak", "Kor"] + Array.new(18)
  SUFFIXES = ["a", "aan", "ar", "as", "ea", "eer", "i", "ia", "in", "ine",
              "ooine", "ior", "ir", "is", "oo", "as", "oth", "u", "uk", "yi",
              "yn", "lia"]
  NUMBERING = ["II", "III", "IV", "V", "VI", "VII", "VII", "IX", "X", "XI", "XII",
               "XIII", "XIV", "XV"] + Array.new(48)

  PUNCTUATION = [:apos,:dash] + Array.new(12)
  LETTERS = ('a'..'z').to_a - ['r','v','x','y','i','e','f','h','j','l','s','u']
  TEMPLATES = Array.new(35,[2]) +
              Array.new(25,[3]) +
              Array.new(25,[2,2]) +
              Array.new(10,[4]) +
              Array.new(5,[2,3]) +
              Array.new(5,[3,2]) +
              Array.new(5,[5]) +
              Array.new(1,[2,4]) +
              Array.new(1,[4,2]) +
              Array.new(2,[3,3]) +
              Array.new(1,[2,2,2]) +
              Array.new(1,[2,1,2])


  # @param [Array<Fixnum>] template
  def name(template = pick_template)
    vary_template(template).map do |c|
      word(c)
    end.join(" ")
  end

  def vary_template(template)
    prefix = pick_prefix
    number = pick_number
    out = template.dup
    if prefix && template.count == 1 && template[0] > 2
      out = [prefix,out[0] - 1]
    end
    if number
      if out.count == 1 && out[0] > 2
        out = [out[0] - 1, number]
      elsif out.count == 1
        out = [out[0],number]
      elsif out.count > 1
        out = [out[0], number]
      end
    end
    out
  end

  def pick_punctuation
    PUNCTUATION.sample
  end

  def word(count)
    return count if count.is_a?(String)
    return pick_syllable if count == 1
    parts = Array.new(count){pick_syllable}
    parts[-1] = pick_suffix if rand(5).zero?
    capitalize(punctuate(parts.compact))
  end

  # @param [Array<Fixnum>] parts
  def punctuate(parts)
    return parts if parts.count < 2
    case pick_punctuation
      when :dash
        return punctuate_with_dash(parts)
      when :apos
        return punctuate_with_apos(parts)
      else
        return parts
    end
  end

  def punctuate_with_dash(parts)
    insert_into = Random.rand(1..(parts.count - 1))
    parts.insert(insert_into, "-")
  end

  def punctuate_with_apos(parts)
    insert_into = Random.rand(0..(parts.count))
    if insert_into.zero?
      extra_c = LETTERS.sample
      parts.insert(insert_into, "#{extra_c}'")

    else
      parts.insert(insert_into, "'")

    end
  end


  # @param [Parts<String>] parts
  def capitalize(parts)
    word = parts.join("").capitalize
    if word.include?("'") && parts[0].include?("'")
      return parts[0] + capitalize(parts[1..-2])
    elsif word.include?("'")
      word.split("'").map{|fragment| capitalize([fragment])}.join("'")
    elsif word.include?("-")
      word.split("-").map{|fragment| capitalize([fragment])}.join("-")
    else
      return word
    end
  end

  def pick_suffix
    SUFFIXES.sample
  end

  def pick_prefix
    PREFIXES.sample
  end

  def pick_syllable
    SYLLABLES.sample
  end

  def pick_number
    NUMBERING.sample
  end

  def pick_template
    TEMPLATES.sample
  end
end
end