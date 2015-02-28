#####################################################
# Class to generate unique consecutive names based on 
# popular surf spots (most of them located in 
# California).
#
# NOTE: Sorry I could not find any spot starting 
# with `X`. 
#####################################################
class SurfSpotNameGenerator
  SEPARATION_TOKEN = '-'
  SPOTS_DICT = {"a"=>["avila", "avalanche"], 
                "b"=>["blackies", "bolsa_chica"], 
                "c"=>["cowells", "cortez"], 
                "d"=>["deadmans", "delmar"], 
                "e"=>["el_capitan", "el_porto"], 
                "f"=>["fort_point", "fletchers"], 
                "g"=>["garrapata", "grandview"], 
                "h"=>["hermosa", "huntington"], 
                "i"=>["imperial", "ians"], 
                "j"=>["japs_cove", "jalama"], 
                "k"=>["kellys", "klamath"], 
                "l"=>["lindamar", "lowers"], 
                "m"=>["mavericks", "malibu"], 
                "n"=>["newport", "noriega"], 
                "o"=>["ocean_beach", "oceanside"],
                "p"=>["pleasure_point", "pismo"], 
                "q"=>["quintara", "queens"], 
                "r"=>["rockaway", "rincon"], 
                "s"=>["sandspit", "scripps"], 
                "t"=>["taraval", "topanga"], 
                "u"=>["uppers", "uncle_cliffy"], 
                "v"=>["venice", "ventura"], 
                "w"=>["wedge", "wallys"], 
                "y"=>["yokohama", "yachats"], 
                "z"=>["zuma", "zeroes"]}

  def self.get_next_id(previous_id=nil)
    if previous_id.nil? or previous_id.empty?
      next_id = first_id
    elsif !valid_id? previous_id
      raise SurfSpotNameGeneratorException, 'Invalid previous id'
    else
      previous_spot, previous_n = previous_id.split SEPARATION_TOKEN
      next_id = get_next_id_after previous_spot, previous_n.to_i
    end
    next_id
  end

  private
  def self.first_id
    build_id SPOTS_DICT['a'].first, 1
  end

  def self.valid_id?(id)
    name_and_n = id.split(SEPARATION_TOKEN)
    return false if name_and_n.count != 2

    name, n = name_and_n
    (valid_spot_name? name and
     n.to_i > 0)
  end

  def self.valid_spot_name?(name)
    (SPOTS_DICT.include? name.first and
     SPOTS_DICT[name.first].include? name)
  end

  def self.build_id(spot_name, n)
    "#{spot_name}#{SEPARATION_TOKEN}#{n}"
  end

  def self.get_next_id_after(previous_spot, previous_n)
    next_letter = (previous_spot.first == 'z') ? 'a' : previous_spot.first.next
    next_letter = next_letter.next if next_letter == 'x'
    spot_index = SPOTS_DICT[previous_spot.first].find_index previous_spot
    spot_index = (spot_index + 1) % 2 if next_letter == 'a'
    next_n = (next_letter == 'a' and spot_index == 0) ? previous_n + 1 : previous_n

    next_spot = SPOTS_DICT[next_letter][spot_index]
    build_id next_spot, next_n
  end
end

class SurfSpotNameGeneratorException < Exception
end