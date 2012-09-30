require 'pry'

def test(amount)
	if amount.is_a?(Rational)
		amount.to_d
	elsif amount.respond_to?(:to_d)
		amount.to_d
	else
		BigDecimal.new(amount.to_s)
	end
end

binding.pry