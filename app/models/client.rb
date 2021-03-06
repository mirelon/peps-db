class Client < ApplicationRecord
  has_many :sessions, dependent: :destroy
  has_many :performances, through: :sessions
  belongs_to :l2
  include RodneCisloCalculations

  before_save :calculate_datum_narodenia, if: proc { will_save_change_to_rodne_cislo? }

  def calculate_datum_narodenia
    self.datum_narodenia = datum_narodenia_from_rodne_cislo
  end

  def display_name
    "\##{id} #{meno} #{priezvisko}"
  end

  # @return Integer
  def age(date = Date.current)
    birthdate = datum_narodenia_from_rodne_cislo
    diff = date.year - birthdate.year
    (birthdate + diff.years > date) ? (diff - 1) : diff
  end

  # @return Float
  def age_f(date = Date.current)
    ((date - datum_narodenia_from_rodne_cislo).days / 1.year).to_f
  end

  def age_i(date = Date.current)
    ((date - datum_narodenia_from_rodne_cislo).days / 1.year).to_i
  end
end
