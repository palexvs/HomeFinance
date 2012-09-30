class Money
  include ActiveModel::Validations
  
  attr_reader :cents
  
  validates_numericality_of :cents

  def initialize(cents)
    @cents = cents
  end

  class << self
    
    def to_money(str_money)
      cents = (str_money.to_f * 100).to_i
      Money.new(cents)
    end

    def to_money?(str_money)
      /\A\d+(\.\d+)?\z/ == str_money.to_s
    end

  end

  def ==(value)
    @cents == self.class.to_money(value).cents
  end

  def to_i
    @cents
  end

  def to_f
    @cents.to_f
  end

  def to_s
    return nil if @cents.nil?

    unit, subunit = @cents.abs.divmod(100)

    unit_str       = ""
    subunit_str    = ""
    fraction_str   = ""

    unit_str, subunit_str = unit.to_s, subunit.to_s

    subunit_str.insert(0, '0') while subunit_str.length < 2

    absolute_str =  "#{unit_str}.#{subunit_str}#{fraction_str}"

    absolute_str.tap do |str|
      str.insert(0, "-") if @cents < 0
    end
  end

  def inspect
    "#<Money cents:#{@cents} to_s:#{self.to_s}>"
  end  
end